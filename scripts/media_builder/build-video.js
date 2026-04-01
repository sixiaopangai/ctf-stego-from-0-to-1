const fs = require("fs");
const path = require("path");
const puppeteer = require("puppeteer-core");

const outPath = process.argv[2];
if (!outPath) {
  console.error("Usage: node build-video.js <output.webm>");
  process.exit(1);
}

const candidates = [
  "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe",
  "C:\\Program Files\\Microsoft\\Edge\\Application\\msedge.exe",
  "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
  "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe"
];

const executablePath = candidates.find((item) => fs.existsSync(item));
if (!executablePath) {
  console.error("No supported browser executable found.");
  process.exit(1);
}

async function main() {
  fs.mkdirSync(path.dirname(outPath), { recursive: true });

  const browser = await puppeteer.launch({
    executablePath,
    headless: true,
    args: [
      "--autoplay-policy=no-user-gesture-required",
      "--mute-audio",
      "--disable-gpu"
    ]
  });

  try {
    const page = await browser.newPage();
    await page.setViewport({ width: 640, height: 360, deviceScaleFactor: 1 });
    await page.goto("about:blank");

    const bytes = await page.evaluate(async () => {
      const width = 640;
      const height = 360;
      const canvas = document.createElement("canvas");
      canvas.width = width;
      canvas.height = height;
      document.body.style.margin = "0";
      document.body.appendChild(canvas);
      const ctx = canvas.getContext("2d");

      const frames = [
        "",
        "flag{",
        "",
        "",
        "sample_",
        "",
        "",
        "video_",
        "",
        "",
        "frames}",
        ""
      ];

      function wait(ms) {
        return new Promise((resolve) => setTimeout(resolve, ms));
      }

      function drawFrame(text, index) {
        const bg = ctx.createLinearGradient(0, 0, 0, height);
        bg.addColorStop(0, "#0f284a");
        bg.addColorStop(1, "#1d547f");
        ctx.fillStyle = bg;
        ctx.fillRect(0, 0, width, height);

        ctx.fillStyle = "#eef4f8";
        ctx.fillRect(36, 30, width - 72, height - 60);

        ctx.fillStyle = "#17314d";
        ctx.font = "bold 30px 'Segoe UI', sans-serif";
        ctx.fillText("Station Feed", 62, 78);
        ctx.font = "16px 'Segoe UI', sans-serif";
        ctx.fillText("Most sampled frames repeat. A few do not.", 64, 108);

        ctx.fillStyle = "#315472";
        ctx.font = "14px 'Consolas', monospace";
        ctx.fillText(`frame ${String(index + 1).padStart(2, "0")}`, 64, 320);

        ctx.fillStyle = text ? "#c4e956" : "#244865";
        ctx.font = "bold 34px 'Consolas', monospace";
        ctx.fillText(text || "all clear", 84, 190);
      }

      const stream = canvas.captureStream(4);
      const recorder = new MediaRecorder(stream, {
        mimeType: "video/webm;codecs=vp8"
      });
      const chunks = [];
      recorder.ondataavailable = (event) => {
        if (event.data && event.data.size > 0) {
          chunks.push(event.data);
        }
      };

      const stopped = new Promise((resolve) => {
        recorder.onstop = resolve;
      });

      recorder.start();
      for (let i = 0; i < frames.length; i += 1) {
        drawFrame(frames[i], i);
        await wait(320);
      }
      recorder.stop();
      await stopped;

      const blob = new Blob(chunks, { type: "video/webm" });
      const buffer = await blob.arrayBuffer();
      return Array.from(new Uint8Array(buffer));
    });

    fs.writeFileSync(outPath, Buffer.from(bytes));
    console.log(`Wrote ${outPath}`);
  } finally {
    await browser.close();
  }
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
