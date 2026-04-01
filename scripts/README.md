# Scripts 辅助脚本说明

这里收录的是教程与练习区配套使用的脚本。它们的职责是帮助你提取载荷、验证解密流程，或者重新生成部分练习样本。

## 脚本概览

| 路径 | 作用 |
| --- | --- |
| [`Extract-AppendedZip.ps1`](./Extract-AppendedZip.ps1) | 从 JPEG / PNG / GIF 等文件中提取尾部拼接的 ZIP |
| [`Decrypt-OpenSslSalted.ps1`](./Decrypt-OpenSslSalted.ps1) | 解 OpenSSL `Salted__` 格式的 AES-CBC Base64 密文 |
| [`Generate-PracticeSamples.ps1`](./Generate-PracticeSamples.ps1) | 重新生成练习区中的一批基础样本 |
| [`media_builder/`](./media_builder/) | 为高级媒体题生成 WAV / PNG / PCAP / WebM 等样本 |

## 依赖说明

### PowerShell 脚本

以下脚本默认在 Windows PowerShell 环境下使用：

- `Extract-AppendedZip.ps1`
- `Decrypt-OpenSslSalted.ps1`
- `Generate-PracticeSamples.ps1`

### Node 脚本

`media_builder/` 目录依赖：

- Node.js
- `npm install`
- 本地可用的 Edge 或 Chrome（`build-video.js` 会自动查找浏览器可执行文件）

安装依赖命令：

```powershell
cd .\scripts\media_builder
npm install
```

## 命令示例

### 1. 提取文件尾部 ZIP

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Extract-AppendedZip.ps1 `
  -InputFile .\practice\01-jpeg-tail-zip\files\park-note.jpg `
  -OutputFile .\park-note.zip
```

### 2. 解 OpenSSL Salted__ 密文

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Decrypt-OpenSslSalted.ps1 `
  -CipherBase64 "<Base64密文>" `
  -Password "<密码>"
```

### 3. 重新生成基础样本

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Generate-PracticeSamples.ps1
```

### 4. 生成二维码 PNG

```powershell
cd .\scripts\media_builder
node .\build-qr-png.js ..\..\practice\16-gif-qr-base64\files\qr.png "flag{demo}"
```

### 5. 生成频谱音频

```powershell
cd .\scripts\media_builder
node .\build-spectrogram-audio.js ..\..\practice\13-audio-spectrum-text\files\spectrum.wav "FLAG{DEMO}"
```

## 使用边界

- 这些脚本是配套工具，不替代题目的手工分析过程
- 部分脚本会在当前目录或指定路径生成文件，执行前先确认输出位置
- 练习附件已经包含在仓库中，只有在你需要重建样本时才需要运行生成脚本

## 相关入口

- 返回仓库首页：[`../README.md`](../README.md)
- 查看练习区说明：[`../practice/README.md`](../practice/README.md)
