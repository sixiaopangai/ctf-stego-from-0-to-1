const fs = require("fs");
const path = require("path");

const outPath = process.argv[2];
if (!outPath) {
  console.error("Usage: node build-dns-pcap.js <output.pcap>");
  process.exit(1);
}

function checksum(buffer) {
  let sum = 0;
  for (let i = 0; i < buffer.length; i += 2) {
    const word = buffer.readUInt16BE(i);
    sum += word;
    while (sum > 0xffff) {
      sum = (sum & 0xffff) + (sum >>> 16);
    }
  }
  return (~sum) & 0xffff;
}

function encodeDnsName(name) {
  const parts = name.split(".");
  const chunks = [];
  for (const part of parts) {
    const label = Buffer.from(part, "ascii");
    chunks.push(Buffer.from([label.length]));
    chunks.push(label);
  }
  chunks.push(Buffer.from([0]));
  return Buffer.concat(chunks);
}

function buildDnsQuery(id, name) {
  const qname = encodeDnsName(name);
  const header = Buffer.alloc(12);
  header.writeUInt16BE(id & 0xffff, 0);
  header.writeUInt16BE(0x0100, 2);
  header.writeUInt16BE(1, 4);
  header.writeUInt16BE(0, 6);
  header.writeUInt16BE(0, 8);
  header.writeUInt16BE(0, 10);

  const question = Buffer.alloc(4);
  question.writeUInt16BE(1, 0);
  question.writeUInt16BE(1, 2);
  return Buffer.concat([header, qname, question]);
}

function buildPacket(frameNo, name) {
  const dns = buildDnsQuery(0x1200 + frameNo, name);
  const udpLen = 8 + dns.length;
  const udp = Buffer.alloc(8);
  udp.writeUInt16BE(49000 + frameNo, 0);
  udp.writeUInt16BE(53, 2);
  udp.writeUInt16BE(udpLen, 4);
  udp.writeUInt16BE(0, 6);

  const ip = Buffer.alloc(20);
  ip[0] = 0x45;
  ip[1] = 0;
  ip.writeUInt16BE(20 + udpLen, 2);
  ip.writeUInt16BE(0x4100 + frameNo, 4);
  ip.writeUInt16BE(0x0000, 6);
  ip[8] = 64;
  ip[9] = 17;
  ip.writeUInt32BE(0x0a00020f + frameNo, 12);
  ip.writeUInt32BE(0x08080808, 16);
  ip.writeUInt16BE(0, 10);
  ip.writeUInt16BE(checksum(ip), 10);

  const eth = Buffer.from([
    0x52, 0x54, 0x00, 0x12, 0x34, 0x56,
    0x02, 0x42, 0xac, 0x11, 0x00, frameNo,
    0x08, 0x00
  ]);

  return Buffer.concat([eth, ip, udp, dns]);
}

function main() {
  const parts = [
    "01-ZmxhZ3tkbnNf.ctf.local",
    "02-cXVlcmllc193.ctf.local",
    "03-aGlzcGVyfQ==.ctf.local"
  ];

  const globalHeader = Buffer.alloc(24);
  globalHeader.writeUInt32LE(0xa1b2c3d4, 0);
  globalHeader.writeUInt16LE(2, 4);
  globalHeader.writeUInt16LE(4, 6);
  globalHeader.writeInt32LE(0, 8);
  globalHeader.writeUInt32LE(0, 12);
  globalHeader.writeUInt32LE(65535, 16);
  globalHeader.writeUInt32LE(1, 20);

  const chunks = [globalHeader];
  for (let i = 0; i < parts.length; i += 1) {
    const packet = buildPacket(i + 1, parts[i]);
    const header = Buffer.alloc(16);
    header.writeUInt32LE(1711958400 + i, 0);
    header.writeUInt32LE(0, 4);
    header.writeUInt32LE(packet.length, 8);
    header.writeUInt32LE(packet.length, 12);
    chunks.push(header, packet);
  }

  fs.mkdirSync(path.dirname(outPath), { recursive: true });
  fs.writeFileSync(outPath, Buffer.concat(chunks));
  console.log(`Wrote ${outPath}`);
}

main();
