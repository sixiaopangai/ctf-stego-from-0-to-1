const fs = require("fs");
const path = require("path");
const QRCode = require("qrcode");

const outPath = process.argv[2];
const text = process.argv[3];

if (!outPath || !text) {
  console.error("Usage: node build-qr-png.js <output.png> <text>");
  process.exit(1);
}

async function main() {
  fs.mkdirSync(path.dirname(outPath), { recursive: true });
  await QRCode.toFile(outPath, text, {
    margin: 2,
    width: 320,
    color: {
      dark: "#17314d",
      light: "#ffffff"
    }
  });
  console.log(`Wrote ${outPath}`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
