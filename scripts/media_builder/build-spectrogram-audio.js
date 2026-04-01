const fs = require("fs");
const path = require("path");

const outPath = process.argv[2];
const message = (process.argv[3] || "FLAG{SPECTRUM_13}").toUpperCase();

if (!outPath) {
  console.error("Usage: node build-spectrogram-audio.js <output.wav> [TEXT]");
  process.exit(1);
}

const font = {
  "A": ["01110","10001","10001","11111","10001","10001","10001"],
  "C": ["01111","10000","10000","10000","10000","10000","01111"],
  "E": ["11111","10000","10000","11110","10000","10000","11111"],
  "F": ["11111","10000","10000","11110","10000","10000","10000"],
  "G": ["01111","10000","10000","10111","10001","10001","01111"],
  "L": ["10000","10000","10000","10000","10000","10000","11111"],
  "M": ["10001","11011","10101","10001","10001","10001","10001"],
  "P": ["11110","10001","10001","11110","10000","10000","10000"],
  "R": ["11110","10001","10001","11110","10100","10010","10001"],
  "S": ["01111","10000","10000","01110","00001","00001","11110"],
  "T": ["11111","00100","00100","00100","00100","00100","00100"],
  "U": ["10001","10001","10001","10001","10001","10001","01110"],
  "{": ["00110","00100","00100","01000","00100","00100","00110"],
  "}": ["01100","00100","00100","00010","00100","00100","01100"],
  "_": ["00000","00000","00000","00000","00000","00000","11111"],
  "1": ["00100","01100","00100","00100","00100","00100","01110"],
  "3": ["11110","00001","00001","01110","00001","00001","11110"]
};

function glyph(ch) {
  if (!font[ch]) {
    throw new Error(`Unsupported glyph: ${ch}`);
  }
  return font[ch];
}

function buildBitmap(text) {
  const rows = 7;
  const cols = [];
  const margin = 4;
  for (let i = 0; i < margin; i += 1) {
    cols.push("0".repeat(rows));
  }
  for (const ch of text) {
    const g = glyph(ch);
    for (let x = 0; x < g[0].length; x += 1) {
      let col = "";
      for (let y = 0; y < rows; y += 1) {
        col += g[y][x];
      }
      cols.push(col);
    }
    cols.push("0".repeat(rows));
  }
  for (let i = 0; i < margin; i += 1) {
    cols.push("0".repeat(rows));
  }
  return cols;
}

function writeWav(filePath, samples, sampleRate) {
  const pcm = Buffer.alloc(samples.length * 2);
  for (let i = 0; i < samples.length; i += 1) {
    let v = Math.max(-1, Math.min(1, samples[i]));
    v = Math.round(v * 32767);
    pcm.writeInt16LE(v, i * 2);
  }

  const header = Buffer.alloc(44);
  header.write("RIFF", 0);
  header.writeUInt32LE(36 + pcm.length, 4);
  header.write("WAVE", 8);
  header.write("fmt ", 12);
  header.writeUInt32LE(16, 16);
  header.writeUInt16LE(1, 20);
  header.writeUInt16LE(1, 22);
  header.writeUInt32LE(sampleRate, 24);
  header.writeUInt32LE(sampleRate * 2, 28);
  header.writeUInt16LE(2, 32);
  header.writeUInt16LE(16, 34);
  header.write("data", 36);
  header.writeUInt32LE(pcm.length, 40);

  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, Buffer.concat([header, pcm]));
}

function main() {
  const cols = buildBitmap(message);
  const sampleRate = 22050;
  const colDuration = 0.065;
  const columnSamples = Math.floor(sampleRate * colDuration);
  const verticalScale = 3;
  const baseFreq = 520;
  const step = 170;
  const totalRows = 7 * verticalScale;
  const totalSamples = cols.length * columnSamples;
  const samples = new Float64Array(totalSamples);

  for (let c = 0; c < cols.length; c += 1) {
    const start = c * columnSamples;
    const activeFreqs = [];
    for (let row = 0; row < 7; row += 1) {
      if (cols[c][row] === "1") {
        for (let k = 0; k < verticalScale; k += 1) {
          const freqIndex = (6 - row) * verticalScale + k;
          activeFreqs.push(baseFreq + freqIndex * step);
        }
      }
    }

    for (let i = 0; i < columnSamples; i += 1) {
      const t = i / sampleRate;
      const env = Math.sin(Math.PI * i / columnSamples) ** 2;
      let value = 0;
      for (const freq of activeFreqs) {
        value += Math.sin(2 * Math.PI * freq * t);
      }
      if (activeFreqs.length > 0) {
        value = (value / activeFreqs.length) * 0.72 * env;
      }
      samples[start + i] += value;
    }
  }

  writeWav(outPath, samples, sampleRate);
  console.log(`Wrote ${outPath}`);
}

main();
