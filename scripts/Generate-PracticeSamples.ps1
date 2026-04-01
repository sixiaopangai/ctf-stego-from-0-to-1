param(
    [string]$Root = (Split-Path -Parent $PSScriptRoot)
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -ReferencedAssemblies 'System.Drawing.dll' -TypeDefinition @'
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
using System.Runtime.Serialization;

public static class PracticeGraphics {
    private static void DrawCard(Graphics g, int width, int height, string title, string subtitle) {
        using (LinearGradientBrush bg = new LinearGradientBrush(
            new Rectangle(0, 0, width, height),
            Color.FromArgb(145, 204, 255),
            Color.FromArgb(255, 244, 204),
            90f))
        using (Font titleFont = new Font("Segoe UI", 34, FontStyle.Bold))
        using (Font subFont = new Font("Segoe UI", 16, FontStyle.Regular))
        using (SolidBrush dark = new SolidBrush(Color.FromArgb(30, 48, 80)))
        using (Pen linePen = new Pen(Color.FromArgb(255, 255, 255), 4f))
        using (SolidBrush paper = new SolidBrush(Color.FromArgb(240, 248, 255)))
        using (Pen borderPen = new Pen(Color.FromArgb(120, 147, 184), 3f)) {
            g.SmoothingMode = SmoothingMode.HighQuality;
            g.FillRectangle(bg, 0, 0, width, height);
            using (SolidBrush cloud = new SolidBrush(Color.FromArgb(255, 255, 255))) {
                g.FillEllipse(cloud, 700, 50, 160, 160);
            }
            using (SolidBrush hill1 = new SolidBrush(Color.FromArgb(126, 206, 109)))
            using (SolidBrush hill2 = new SolidBrush(Color.FromArgb(99, 188, 86)))
            using (SolidBrush hill3 = new SolidBrush(Color.FromArgb(72, 154, 67))) {
                g.FillEllipse(hill1, -80, 300, 420, 320);
                g.FillEllipse(hill2, 240, 340, 520, 260);
                g.FillEllipse(hill3, 560, 320, 460, 280);
            }
            g.DrawString(title, titleFont, dark, 70, 90);
            g.DrawString(subtitle, subFont, dark, 74, 150);
            g.DrawLine(linePen, 70, 210, 300, 210);
            g.FillRectangle(paper, 70, 250, 320, 130);
            g.DrawRectangle(borderPen, 70, 250, 320, 130);
            g.DrawString("Daily Park Notes", subFont, dark, 100, 285);
            g.DrawString("Nothing unusual here.", subFont, dark, 100, 320);
        }
    }

    public static void CreateCarrierJpeg(string path, string title, string subtitle) {
        using (Bitmap bmp = new Bitmap(960, 540))
        using (Graphics g = Graphics.FromImage(bmp)) {
            DrawCard(g, bmp.Width, bmp.Height, title, subtitle);
            bmp.Save(path, ImageFormat.Jpeg);
        }
    }

    public static void CreateAlphaPng(string path, string hiddenText) {
        using (Bitmap bmp = new Bitmap(960, 540, PixelFormat.Format32bppArgb))
        using (Graphics g = Graphics.FromImage(bmp))
        using (LinearGradientBrush bg = new LinearGradientBrush(
            new Rectangle(0, 0, bmp.Width, bmp.Height),
            Color.FromArgb(242, 246, 250),
            Color.FromArgb(230, 236, 245),
            90f))
        using (Font titleFont = new Font("Segoe UI", 26, FontStyle.Bold))
        using (Font hiddenFont = new Font("Segoe UI", 34, FontStyle.Bold))
        using (Font hintFont = new Font("Segoe UI", 16, FontStyle.Regular))
        using (SolidBrush dark = new SolidBrush(Color.FromArgb(94, 110, 140)))
        using (SolidBrush hint = new SolidBrush(Color.FromArgb(120, 148, 170)))
        using (SolidBrush hidden = new SolidBrush(Color.FromArgb(18, 245, 246, 250)))
        using (SolidBrush paper = new SolidBrush(Color.FromArgb(255, 255, 255, 255))) {
            g.SmoothingMode = SmoothingMode.HighQuality;
            g.Clear(Color.Transparent);
            g.FillRectangle(bg, 0, 0, bmp.Width, bmp.Height);
            g.DrawString("Museum Ticket Overlay", titleFont, dark, 60, 70);
            g.DrawString("Try changing the background or inspecting alpha.", hintFont, hint, 64, 118);
            g.FillRectangle(paper, 70, 190, 820, 200);
            g.DrawString(hiddenText, hiddenFont, hidden, 105, 265);
            bmp.Save(path, ImageFormat.Png);
        }
    }

    public static void CreateLowContrastPng(string path, string hiddenText) {
        using (Bitmap bmp = new Bitmap(960, 540, PixelFormat.Format32bppArgb))
        using (Graphics g = Graphics.FromImage(bmp))
        using (Font titleFont = new Font("Segoe UI", 28, FontStyle.Bold))
        using (Font hiddenFont = new Font("Segoe UI", 36, FontStyle.Bold))
        using (Font hintFont = new Font("Segoe UI", 15, FontStyle.Regular))
        using (SolidBrush bg = new SolidBrush(Color.FromArgb(226, 236, 229)))
        using (SolidBrush dark = new SolidBrush(Color.FromArgb(90, 112, 96)))
        using (SolidBrush hidden = new SolidBrush(Color.FromArgb(223, 232, 226))) {
            g.SmoothingMode = SmoothingMode.HighQuality;
            g.FillRectangle(bg, 0, 0, bmp.Width, bmp.Height);
            g.DrawString("Status Summary", titleFont, dark, 70, 70);
            g.DrawString("Visibility is intentionally low.", hintFont, dark, 75, 120);
            g.DrawString(hiddenText, hiddenFont, hidden, 120, 250);
            bmp.Save(path, ImageFormat.Png);
        }
    }

    public static void CreatePalettePng(string path, string hiddenText) {
        int width = 512;
        int height = 128;
        using (Bitmap bmp = new Bitmap(width, height, PixelFormat.Format8bppIndexed)) {
            ColorPalette palette = bmp.Palette;
            byte[] hiddenBytes = System.Text.Encoding.ASCII.GetBytes(hiddenText);
            int idx = 0;
            for (; idx < hiddenBytes.Length && idx < 255; idx++) {
                palette.Entries[idx] = Color.FromArgb(hiddenBytes[idx], 48, 156);
            }
            if (idx < 256) {
                palette.Entries[idx] = Color.FromArgb(0, 48, 156);
                idx++;
            }
            for (int i = idx; i < 256; i++) {
                palette.Entries[i] = Color.FromArgb((i * 7) % 256, (120 + i * 5) % 256, (40 + i * 3) % 256);
            }
            bmp.Palette = palette;

            Rectangle rect = new Rectangle(0, 0, width, height);
            BitmapData data = bmp.LockBits(rect, ImageLockMode.WriteOnly, PixelFormat.Format8bppIndexed);
            try {
                int stride = data.Stride;
                byte[] raw = new byte[stride * height];
                for (int y = 0; y < height; y++) {
                    for (int x = 0; x < width; x++) {
                        raw[y * stride + x] = (byte)(x % 256);
                    }
                }
                Marshal.Copy(raw, 0, data.Scan0, raw.Length);
            }
            finally {
                bmp.UnlockBits(data);
            }
            bmp.Save(path, ImageFormat.Png);
        }
    }

    public static void CreateLsbPng(string path, string hiddenText) {
        using (Bitmap bmp = new Bitmap(640, 360, PixelFormat.Format32bppArgb))
        using (Graphics g = Graphics.FromImage(bmp))
        using (LinearGradientBrush bg = new LinearGradientBrush(
            new Rectangle(0, 0, bmp.Width, bmp.Height),
            Color.FromArgb(239, 244, 248),
            Color.FromArgb(202, 225, 242),
            90f))
        using (Font titleFont = new Font("Segoe UI", 24, FontStyle.Bold))
        using (Font bodyFont = new Font("Segoe UI", 15, FontStyle.Regular))
        using (SolidBrush dark = new SolidBrush(Color.FromArgb(44, 71, 98)))
        using (SolidBrush panel = new SolidBrush(Color.FromArgb(250, 252, 255)))
        using (Pen border = new Pen(Color.FromArgb(150, 182, 209), 2f)) {
            g.SmoothingMode = SmoothingMode.HighQuality;
            g.FillRectangle(bg, 0, 0, bmp.Width, bmp.Height);
            g.FillEllipse(new SolidBrush(Color.FromArgb(255, 255, 255)), 440, 40, 120, 120);
            g.FillRectangle(panel, 42, 120, 556, 170);
            g.DrawRectangle(border, 42, 120, 556, 170);
            g.DrawString("Quiet Grid", titleFont, dark, 48, 56);
            g.DrawString("The visible pixels are normal. The useful bits are not.", bodyFont, dark, 52, 92);
            for (int i = 0; i < 10; i++) {
                g.DrawLine(new Pen(Color.FromArgb(220, 232, 242)), 60, 145 + i * 13, 580, 145 + i * 13);
            }
            for (int i = 0; i < 8; i++) {
                g.DrawLine(new Pen(Color.FromArgb(228, 238, 247)), 82 + i * 65, 136, 82 + i * 65, 272);
            }

            Rectangle rect = new Rectangle(0, 0, bmp.Width, bmp.Height);
            BitmapData data = bmp.LockBits(rect, ImageLockMode.ReadWrite, PixelFormat.Format32bppArgb);
            try {
                int stride = data.Stride;
                int bytesLen = Math.Abs(stride) * bmp.Height;
                byte[] raw = new byte[bytesLen];
                Marshal.Copy(data.Scan0, raw, 0, bytesLen);

                byte[] textBytes = System.Text.Encoding.UTF8.GetBytes(hiddenText);
                byte[] payload = new byte[textBytes.Length + 2];
                payload[0] = (byte)((textBytes.Length >> 8) & 0xFF);
                payload[1] = (byte)(textBytes.Length & 0xFF);
                Array.Copy(textBytes, 0, payload, 2, textBytes.Length);

                List<int> bits = new List<int>();
                for (int i = 0; i < payload.Length; i++) {
                    for (int bit = 7; bit >= 0; bit--) {
                        bits.Add((payload[i] >> bit) & 1);
                    }
                }

                int bitIndex = 0;
                int[] channelOffsets = new int[] { 2, 1, 0 };
                for (int y = 0; y < bmp.Height && bitIndex < bits.Count; y++) {
                    int row = y * stride;
                    for (int x = 0; x < bmp.Width && bitIndex < bits.Count; x++) {
                        int idx = row + x * 4;
                        for (int channel = 0; channel < 3 && bitIndex < bits.Count; channel++) {
                            int offset = channelOffsets[channel];
                            raw[idx + offset] = (byte)((raw[idx + offset] & 0xFE) | bits[bitIndex]);
                            bitIndex++;
                        }
                    }
                }

                Marshal.Copy(raw, 0, data.Scan0, bytesLen);
            }
            finally {
                bmp.UnlockBits(data);
            }
            bmp.Save(path, ImageFormat.Png);
        }
    }

    private static ImageCodecInfo GetEncoder(ImageFormat format) {
        ImageCodecInfo[] codecs = ImageCodecInfo.GetImageEncoders();
        for (int i = 0; i < codecs.Length; i++) {
            if (codecs[i].FormatID == format.Guid) {
                return codecs[i];
            }
        }
        return null;
    }

    private static PropertyItem CreatePropertyItem(int id, short type, byte[] value) {
        PropertyItem item = (PropertyItem)FormatterServices.GetUninitializedObject(typeof(PropertyItem));
        item.Id = id;
        item.Type = type;
        item.Len = value.Length;
        item.Value = value;
        return item;
    }

    private static Bitmap CreateGifFrame(int width, int height, string hiddenText, bool highlight) {
        Bitmap bmp = new Bitmap(width, height);
        using (Graphics g = Graphics.FromImage(bmp))
        using (LinearGradientBrush bg = new LinearGradientBrush(
            new Rectangle(0, 0, width, height),
            Color.FromArgb(17, 32, 63),
            Color.FromArgb(37, 89, 136),
            90f))
        using (SolidBrush board = new SolidBrush(Color.FromArgb(235, 241, 248)))
        using (Font titleFont = new Font("Segoe UI", 24, FontStyle.Bold))
        using (Font textFont = new Font("Consolas", 20, FontStyle.Bold))
        using (Font footerFont = new Font("Segoe UI", 12, FontStyle.Regular))
        using (SolidBrush dark = new SolidBrush(Color.FromArgb(24, 45, 67)))
        using (SolidBrush accent = new SolidBrush(Color.FromArgb(201, 238, 120)))
        using (SolidBrush footer = new SolidBrush(Color.FromArgb(230, 238, 245))) {
            g.SmoothingMode = SmoothingMode.HighQuality;
            g.FillRectangle(bg, 0, 0, width, height);
            g.FillRectangle(board, 38, 36, width - 76, height - 72);
            g.DrawString("Transit Notice Board", titleFont, dark, 60, 56);
            g.DrawString("Most frames repeat. A few do not.", footerFont, dark, 62, 98);
            g.DrawString("platform updates", footerFont, dark, 64, height - 54);
            g.DrawString("route maintenance", footerFont, dark, 210, height - 54);
            g.DrawString("queue normal", footerFont, dark, 360, height - 54);
            if (highlight && hiddenText.Length > 0) {
                g.DrawString(hiddenText, textFont, accent, 90, 142);
            } else {
                g.DrawString("all clear", textFont, dark, 90, 142);
            }
        }
        return bmp;
    }

    public static void CreateAnimatedGif(string path, string[] frameTexts) {
        List<Bitmap> frames = new List<Bitmap>();
        try {
            for (int i = 0; i < frameTexts.Length; i++) {
                bool highlight = frameTexts[i] != null && frameTexts[i].Length > 0;
                frames.Add(CreateGifFrame(520, 240, frameTexts[i] ?? String.Empty, highlight));
            }

            ImageCodecInfo codec = GetEncoder(ImageFormat.Gif);
            if (codec == null) {
                throw new InvalidOperationException("GIF encoder not available.");
            }

            int frameCount = frames.Count;
            byte[] delays = new byte[4 * frameCount];
            for (int i = 0; i < frameCount; i++) {
                int delay = (i == 2 || i == 5 || i == 8) ? 12 : 8;
                byte[] bytes = BitConverter.GetBytes(delay);
                Array.Copy(bytes, 0, delays, i * 4, 4);
            }

            byte[] loop = new byte[] { 0, 0 };
            frames[0].SetPropertyItem(CreatePropertyItem(0x5100, 4, delays));
            frames[0].SetPropertyItem(CreatePropertyItem(0x5101, 3, loop));

            Encoder encoder = Encoder.SaveFlag;
            EncoderParameters ep = new EncoderParameters(1);
            ep.Param[0] = new EncoderParameter(encoder, (long)EncoderValue.MultiFrame);
            frames[0].Save(path, codec, ep);

            for (int i = 1; i < frames.Count; i++) {
                ep.Param[0] = new EncoderParameter(encoder, (long)EncoderValue.FrameDimensionTime);
                frames[0].SaveAdd(frames[i], ep);
            }

            ep.Param[0] = new EncoderParameter(encoder, (long)EncoderValue.Flush);
            frames[0].SaveAdd(ep);
            ep.Dispose();
        }
        finally {
            for (int i = 0; i < frames.Count; i++) {
                frames[i].Dispose();
            }
        }
    }

    public static void CreateAnimatedGifWithImage(string path, string imagePath) {
        List<Bitmap> frames = new List<Bitmap>();
        try {
            for (int i = 0; i < 8; i++) {
                Bitmap frame = CreateGifFrame(520, 240, String.Empty, false);
                if (i == 2 || i == 5) {
                    using (Graphics g = Graphics.FromImage(frame))
                    using (Bitmap qr = new Bitmap(imagePath)) {
                        g.DrawImage(qr, 168, 34, 184, 184);
                    }
                }
                frames.Add(frame);
            }

            ImageCodecInfo codec = GetEncoder(ImageFormat.Gif);
            if (codec == null) {
                throw new InvalidOperationException("GIF encoder not available.");
            }

            int frameCount = frames.Count;
            byte[] delays = new byte[4 * frameCount];
            for (int i = 0; i < frameCount; i++) {
                int delay = (i == 2 || i == 5) ? 16 : 8;
                byte[] bytes = BitConverter.GetBytes(delay);
                Array.Copy(bytes, 0, delays, i * 4, 4);
            }

            byte[] loop = new byte[] { 0, 0 };
            frames[0].SetPropertyItem(CreatePropertyItem(0x5100, 4, delays));
            frames[0].SetPropertyItem(CreatePropertyItem(0x5101, 3, loop));

            Encoder encoder = Encoder.SaveFlag;
            EncoderParameters ep = new EncoderParameters(1);
            ep.Param[0] = new EncoderParameter(encoder, (long)EncoderValue.MultiFrame);
            frames[0].Save(path, codec, ep);

            for (int i = 1; i < frames.Count; i++) {
                ep.Param[0] = new EncoderParameter(encoder, (long)EncoderValue.FrameDimensionTime);
                frames[0].SaveAdd(frames[i], ep);
            }

            ep.Param[0] = new EncoderParameter(encoder, (long)EncoderValue.Flush);
            frames[0].SaveAdd(ep);
            ep.Dispose();
        }
        finally {
            for (int i = 0; i < frames.Count; i++) {
                frames[i].Dispose();
            }
        }
    }
}
'@

function Ensure-Dir {
    param([string]$Path)
    New-Item -ItemType Directory -Force -Path $Path | Out-Null
}

function Join-Bytes {
    param(
        [byte[]]$A,
        [byte[]]$B,
        [byte[]]$C
    )
    $out = New-Object byte[] ($A.Length + $B.Length + $C.Length)
    [Array]::Copy($A, 0, $out, 0, $A.Length)
    [Array]::Copy($B, 0, $out, $A.Length, $B.Length)
    [Array]::Copy($C, 0, $out, $A.Length + $B.Length, $C.Length)
    return $out
}

function Get-EvpBytesToKey {
    param(
        [string]$Pass,
        [byte[]]$Salt,
        [int]$KeyLength,
        [int]$IvLength
    )
    $md5 = [System.Security.Cryptography.MD5]::Create()
    $passBytes = [System.Text.Encoding]::UTF8.GetBytes($Pass)
    $result = New-Object System.Collections.Generic.List[byte]
    [byte[]]$prev = @()
    while ($result.Count -lt ($KeyLength + $IvLength)) {
        $input = Join-Bytes -A $prev -B $passBytes -C $Salt
        $prev = $md5.ComputeHash($input)
        $result.AddRange($prev)
    }
    $all = $result.ToArray()
    return @{
        Key = $all[0..($KeyLength - 1)]
        IV  = $all[$KeyLength..($KeyLength + $IvLength - 1)]
    }
}

function New-OpenSslSaltedBase64 {
    param(
        [string]$Plaintext,
        [string]$Password,
        [byte[]]$Salt
    )

    $material = Get-EvpBytesToKey -Pass $Password -Salt $Salt -KeyLength 32 -IvLength 16
    $aes = [System.Security.Cryptography.Aes]::Create()
    $aes.Mode = [System.Security.Cryptography.CipherMode]::CBC
    $aes.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
    $aes.KeySize = 256
    $aes.BlockSize = 128
    $aes.Key = $material.Key
    $aes.IV = $material.IV

    $plainBytes = [System.Text.Encoding]::UTF8.GetBytes($Plaintext)
    $cipher = $aes.CreateEncryptor().TransformFinalBlock($plainBytes, 0, $plainBytes.Length)

    $prefix = [System.Text.Encoding]::ASCII.GetBytes('Salted__')
    $payload = New-Object byte[] ($prefix.Length + $Salt.Length + $cipher.Length)
    [Array]::Copy($prefix, 0, $payload, 0, $prefix.Length)
    [Array]::Copy($Salt, 0, $payload, $prefix.Length, $Salt.Length)
    [Array]::Copy($cipher, 0, $payload, $prefix.Length + $Salt.Length, $cipher.Length)
    return [Convert]::ToBase64String($payload)
}

function Write-AppendedZipJpeg {
    param(
        [string]$OutputJpeg,
        [string]$InnerText,
        [string]$Title,
        [string]$Subtitle
    )

    $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString('N'))
    Ensure-Dir -Path $tempDir

    try {
        $carrier = Join-Path $tempDir 'carrier.jpg'
        [PracticeGraphics]::CreateCarrierJpeg($carrier, $Title, $Subtitle)

        $flagPath = Join-Path $tempDir 'flag.txt'
        Set-Content -LiteralPath $flagPath -Value $InnerText -Encoding UTF8

        $zipPath = Join-Path $tempDir 'payload.zip'
        Compress-Archive -LiteralPath $flagPath -DestinationPath $zipPath -Force

        $jpgBytes = [System.IO.File]::ReadAllBytes($carrier)
        $zipBytes = [System.IO.File]::ReadAllBytes($zipPath)
        $all = New-Object byte[] ($jpgBytes.Length + $zipBytes.Length)
        [Array]::Copy($jpgBytes, 0, $all, 0, $jpgBytes.Length)
        [Array]::Copy($zipBytes, 0, $all, $jpgBytes.Length, $zipBytes.Length)
        [System.IO.File]::WriteAllBytes($OutputJpeg, $all)
    }
    finally {
        if (Test-Path -LiteralPath $tempDir) {
            Remove-Item -LiteralPath $tempDir -Recurse -Force
        }
    }
}

function Write-JpegWithCommentCipher {
    param(
        [string]$OutputJpeg,
        [string]$Title,
        [string]$Subtitle,
        [string]$Password,
        [string]$Plaintext
    )

    $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString('N'))
    Ensure-Dir -Path $tempDir

    try {
        $carrier = Join-Path $tempDir 'carrier.jpg'
        [PracticeGraphics]::CreateCarrierJpeg($carrier, $Title, $Subtitle)
        $salt = [byte[]](0x21, 0x33, 0x45, 0x57, 0x69, 0x7B, 0x8D, 0x9F)
        $cipher = New-OpenSslSaltedBase64 -Plaintext $Plaintext -Password $Password -Salt $salt
        $commentText = 'cipher=' + $cipher
        $commentBytes = [System.Text.Encoding]::UTF8.GetBytes($commentText)
        $base = [System.IO.File]::ReadAllBytes($carrier)
        $len = $commentBytes.Length + 2
        $out = New-Object byte[] ($base.Length + $commentBytes.Length + 4)
        $out[0] = $base[0]
        $out[1] = $base[1]
        $out[2] = 0xFF
        $out[3] = 0xFE
        $out[4] = [byte](($len -shr 8) -band 0xFF)
        $out[5] = [byte]($len -band 0xFF)
        [Array]::Copy($commentBytes, 0, $out, 6, $commentBytes.Length)
        [Array]::Copy($base, 2, $out, 6 + $commentBytes.Length, $base.Length - 2)
        [System.IO.File]::WriteAllBytes($OutputJpeg, $out)
    }
    finally {
        if (Test-Path -LiteralPath $tempDir) {
            Remove-Item -LiteralPath $tempDir -Recurse -Force
        }
    }
}

function Write-JpegWithXmp {
    param(
        [string]$OutputJpeg,
        [string]$Title,
        [string]$Subtitle,
        [string]$XmpXml
    )

    $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString('N'))
    Ensure-Dir -Path $tempDir

    try {
        $carrier = Join-Path $tempDir 'carrier.jpg'
        [PracticeGraphics]::CreateCarrierJpeg($carrier, $Title, $Subtitle)
        $base = [System.IO.File]::ReadAllBytes($carrier)
        $header = [System.Text.Encoding]::ASCII.GetBytes("http://ns.adobe.com/xap/1.0/" + [char]0)
        $xmlBytes = [System.Text.Encoding]::UTF8.GetBytes($XmpXml)
        $segmentData = New-Object byte[] ($header.Length + $xmlBytes.Length)
        [Array]::Copy($header, 0, $segmentData, 0, $header.Length)
        [Array]::Copy($xmlBytes, 0, $segmentData, $header.Length, $xmlBytes.Length)
        $len = $segmentData.Length + 2

        $out = New-Object byte[] ($base.Length + $segmentData.Length + 4)
        $out[0] = $base[0]
        $out[1] = $base[1]
        $out[2] = 0xFF
        $out[3] = 0xE1
        $out[4] = [byte](($len -shr 8) -band 0xFF)
        $out[5] = [byte]($len -band 0xFF)
        [Array]::Copy($segmentData, 0, $out, 6, $segmentData.Length)
        [Array]::Copy($base, 2, $out, 6 + $segmentData.Length, $base.Length - 2)
        [System.IO.File]::WriteAllBytes($OutputJpeg, $out)
    }
    finally {
        if (Test-Path -LiteralPath $tempDir) {
            Remove-Item -LiteralPath $tempDir -Recurse -Force
        }
    }
}

function Write-JpegWithXmpAndCommentCipher {
    param(
        [string]$OutputJpeg,
        [string]$Title,
        [string]$Subtitle,
        [string]$Password,
        [string]$Plaintext
    )

    $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString('N'))
    Ensure-Dir -Path $tempDir

    try {
        $tempJpeg = Join-Path $tempDir 'stage.jpg'
        $xmp = @"
<x:xmpmeta xmlns:x="adobe:ns:meta/">
 <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description xmlns:stego="https://example.local/stego/1.0/">
   <stego:passphrase>$Password</stego:passphrase>
  </rdf:Description>
 </rdf:RDF>
</x:xmpmeta>
"@
        Write-JpegWithXmp -OutputJpeg $tempJpeg -Title $Title -Subtitle $Subtitle -XmpXml $xmp

        $salt = [byte[]](0x52, 0x61, 0x70, 0x81, 0x92, 0xA3, 0xB4, 0xC5)
        $cipher = New-OpenSslSaltedBase64 -Plaintext $Plaintext -Password $Password -Salt $salt
        $commentText = 'cipher=' + $cipher
        $commentBytes = [System.Text.Encoding]::UTF8.GetBytes($commentText)
        $base = [System.IO.File]::ReadAllBytes($tempJpeg)
        $len = $commentBytes.Length + 2

        $out = New-Object byte[] ($base.Length + $commentBytes.Length + 4)
        $out[0] = $base[0]
        $out[1] = $base[1]
        $out[2] = 0xFF
        $out[3] = 0xFE
        $out[4] = [byte](($len -shr 8) -band 0xFF)
        $out[5] = [byte]($len -band 0xFF)
        [Array]::Copy($commentBytes, 0, $out, 6, $commentBytes.Length)
        [Array]::Copy($base, 2, $out, 6 + $commentBytes.Length, $base.Length - 2)
        [System.IO.File]::WriteAllBytes($OutputJpeg, $out)
    }
    finally {
        if (Test-Path -LiteralPath $tempDir) {
            Remove-Item -LiteralPath $tempDir -Recurse -Force
        }
    }
}

function Append-TextZipToFile {
    param(
        [string]$TargetFile,
        [string]$InnerText
    )

    $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().ToString('N'))
    Ensure-Dir -Path $tempDir
    try {
        $txt = Join-Path $tempDir 'flag.txt'
        Set-Content -LiteralPath $txt -Value $InnerText -Encoding UTF8
        $zip = Join-Path $tempDir 'payload.zip'
        Compress-Archive -LiteralPath $txt -DestinationPath $zip -Force
        $fileBytes = [System.IO.File]::ReadAllBytes($TargetFile)
        $zipBytes = [System.IO.File]::ReadAllBytes($zip)
        $out = New-Object byte[] ($fileBytes.Length + $zipBytes.Length)
        [Array]::Copy($fileBytes, 0, $out, 0, $fileBytes.Length)
        [Array]::Copy($zipBytes, 0, $out, $fileBytes.Length, $zipBytes.Length)
        [System.IO.File]::WriteAllBytes($TargetFile, $out)
    }
    finally {
        if (Test-Path -LiteralPath $tempDir) {
            Remove-Item -LiteralPath $tempDir -Recurse -Force
        }
    }
}

function New-GzipBase64 {
    param([string]$Text)

    $textBytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
    $ms = New-Object System.IO.MemoryStream
    try {
        $gzip = New-Object System.IO.Compression.GZipStream($ms, [System.IO.Compression.CompressionMode]::Compress, $true)
        $gzip.Write($textBytes, 0, $textBytes.Length)
        $gzip.Dispose()
        return [Convert]::ToBase64String($ms.ToArray())
    }
    finally {
        $ms.Dispose()
    }
}

function New-MorseWav {
    param(
        [string]$Path,
        [string]$Message
    )

    $morse = @{
        'A'='.-';   'B'='-...'; 'C'='-.-.'; 'D'='-..';  'E'='.'
        'F'='..-.'; 'G'='--.';  'H'='....'; 'I'='..';   'J'='.---'
        'K'='-.-';  'L'='.-..'; 'M'='--';   'N'='-.';   'O'='---'
        'P'='.--.'; 'Q'='--.-'; 'R'='.-.';  'S'='...';  'T'='-'
        'U'='..-';  'V'='...-'; 'W'='.--';  'X'='-..-'; 'Y'='-.--'
        'Z'='--..'; '0'='-----';'1'='.----';'2'='..---';'3'='...--'
        '4'='....-';'5'='.....';'6'='-....';'7'='--...';'8'='---..'
        '9'='----.';'_'='..--.-'
    }

    $sampleRate = 22050
    $dot = 0.12
    $dash = $dot * 3
    $gapElement = $dot
    $gapLetter = $dot * 3
    $gapWord = $dot * 7
    $freq = 700.0
    $amplitude = 0.35

    $samples = New-Object System.Collections.Generic.List[double]

    function Add-Tone {
        param([double]$Seconds)
        $count = [int]($sampleRate * $Seconds)
        for ($i = 0; $i -lt $count; $i++) {
            $value = [Math]::Sin(2.0 * [Math]::PI * $freq * $i / $sampleRate) * $amplitude
            [void]$samples.Add($value)
        }
    }

    function Add-Silence {
        param([double]$Seconds)
        $count = [int]($sampleRate * $Seconds)
        for ($i = 0; $i -lt $count; $i++) {
            [void]$samples.Add(0.0)
        }
    }

    $chars = $Message.ToCharArray()
    for ($c = 0; $c -lt $chars.Length; $c++) {
        $ch = [string]$chars[$c]
        if ($ch -eq ' ') {
            Add-Silence -Seconds $gapWord
            continue
        }
        if (-not $morse.ContainsKey($ch)) {
            throw "Unsupported morse character: $ch"
        }

        $pattern = $morse[$ch].ToCharArray()
        for ($p = 0; $p -lt $pattern.Length; $p++) {
            if ($pattern[$p] -eq '.') {
                Add-Tone -Seconds $dot
            }
            else {
                Add-Tone -Seconds $dash
            }

            if ($p -lt $pattern.Length - 1) {
                Add-Silence -Seconds $gapElement
            }
        }

        if ($c -lt $chars.Length - 1 -and $chars[$c + 1] -ne ' ') {
            Add-Silence -Seconds $gapLetter
        }
    }

    $pcm = New-Object byte[] ($samples.Count * 2)
    for ($i = 0; $i -lt $samples.Count; $i++) {
        $val = [int16]([Math]::Round($samples[$i] * [int16]::MaxValue))
        $bytes = [BitConverter]::GetBytes($val)
        $pcm[$i * 2] = $bytes[0]
        $pcm[$i * 2 + 1] = $bytes[1]
    }

    $stream = [System.IO.File]::Open($Path, [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write)
    $writer = New-Object System.IO.BinaryWriter($stream)
    try {
        $writer.Write([System.Text.Encoding]::ASCII.GetBytes('RIFF'))
        $writer.Write([int]($pcm.Length + 36))
        $writer.Write([System.Text.Encoding]::ASCII.GetBytes('WAVE'))
        $writer.Write([System.Text.Encoding]::ASCII.GetBytes('fmt '))
        $writer.Write([int]16)
        $writer.Write([int16]1)
        $writer.Write([int16]1)
        $writer.Write([int]$sampleRate)
        $writer.Write([int]($sampleRate * 2))
        $writer.Write([int16]2)
        $writer.Write([int16]16)
        $writer.Write([System.Text.Encoding]::ASCII.GetBytes('data'))
        $writer.Write([int]$pcm.Length)
        $writer.Write($pcm)
    }
    finally {
        $writer.Dispose()
        $stream.Dispose()
    }
}

$practiceRoot = Join-Path $Root 'practice'
$files01 = Join-Path $practiceRoot '01-jpeg-tail-zip\files'
$files02 = Join-Path $practiceRoot '02-fake-flag-openssl\files'
$files03 = Join-Path $practiceRoot '03-png-alpha-hidden\files'
$files04 = Join-Path $practiceRoot '04-low-contrast-png\files'
$files05 = Join-Path $practiceRoot '05-base64-gzip-chain\files'
$files06 = Join-Path $practiceRoot '06-audio-morse-basic\files'
$files07 = Join-Path $practiceRoot '07-steghide-style-jpeg\files'
$files08 = Join-Path $practiceRoot '08-png-palette-order\files'
$files09 = Join-Path $practiceRoot '09-gif-frame-flash\files'
$files10 = Join-Path $practiceRoot '10-video-frame-sampling\files'
$files11 = Join-Path $practiceRoot '11-png-lsb-zsteg\files'
$files12 = Join-Path $practiceRoot '12-jpeg-xmp-clue\files'
$files13 = Join-Path $practiceRoot '13-audio-spectrum-text\files'
$files14 = Join-Path $practiceRoot '14-layered-metadata-cipher\files'
$files15 = Join-Path $practiceRoot '15-image-metadata-cipher-3layer\files'
$files16 = Join-Path $practiceRoot '16-gif-qr-base64\files'
$files17 = Join-Path $practiceRoot '17-pcap-dns-hidden\files'

@($files01, $files02, $files03, $files04, $files05, $files06, $files07, $files08, $files09, $files10, $files11, $files12, $files13, $files14, $files15, $files16, $files17) | ForEach-Object {
    Ensure-Dir -Path $_
}

Write-AppendedZipJpeg -OutputJpeg (Join-Path $files01 'park-note.jpg') `
    -InnerText 'flag{tail_zip_found}' `
    -Title 'Sunny Park' `
    -Subtitle 'A calm afternoon in the city.'

$fakeFlag = 'flag{this_flag_is_fake}'
$salt = [byte[]](0x11, 0x29, 0x37, 0x48, 0x56, 0x68, 0x72, 0x84)
$cipher = New-OpenSslSaltedBase64 -Plaintext 'flag{openssl_layer_clear}' -Password $fakeFlag -Salt $salt
$inner02 = $fakeFlag + [Environment]::NewLine + $cipher
Write-AppendedZipJpeg -OutputJpeg (Join-Path $files02 'sunny-clue.jpg') `
    -InnerText $inner02 `
    -Title 'Weekend Sketch' `
    -Subtitle 'Everything useful is below the surface.'

[PracticeGraphics]::CreateAlphaPng((Join-Path $files03 'alpha-note.png'), 'flag{alpha_layer_reveal}')
[PracticeGraphics]::CreateLowContrastPng((Join-Path $files04 'washed-note.png'), 'flag{contrast_is_key}')

$b64 = New-GzipBase64 -Text 'flag{decode_then_decompress}'
$log = @(
    '[INFO] 2026-04-01 10:12:11 sync start'
    '[INFO] loading profile: stego-practice'
    '[DEBUG] blob=' + $b64
    '[INFO] backup complete'
)
Set-Content -LiteralPath (Join-Path $files05 'system.log') -Value $log -Encoding ASCII

New-MorseWav -Path (Join-Path $files06 'morse.wav') -Message 'AUDIO_MORSE_06'

Write-JpegWithCommentCipher -OutputJpeg (Join-Path $files07 'metro-pass.jpg') `
    -Title 'Metro Pass' `
    -Subtitle 'Locker 73 reopens at dawn.' `
    -Password 'locker73' `
    -Plaintext 'flag{comment_payload_opened}'

[PracticeGraphics]::CreatePalettePng((Join-Path $files08 'palette-bars.png'), 'flag{palette_order_matters}')
[PracticeGraphics]::CreateAnimatedGif((Join-Path $files09 'notice.gif'), [string[]]('', '', 'flag{gif_', '', '', 'frames_', '', '', 'tell_all}', ''))
[PracticeGraphics]::CreateLsbPng((Join-Path $files11 'quiet-grid.png'), 'flag{lsb_bits_signal}')

$xmp12 = @"
<x:xmpmeta xmlns:x="adobe:ns:meta/">
 <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:stego="https://example.local/stego/1.0/">
   <dc:description>archive item</dc:description>
   <stego:note>flag{xmp_reveals_truth}</stego:note>
  </rdf:Description>
 </rdf:RDF>
</x:xmpmeta>
"@
Write-JpegWithXmp -OutputJpeg (Join-Path $files12 'archive-card.jpg') `
    -Title 'Archive Card' `
    -Subtitle 'Metadata often speaks louder than pixels.' `
    -XmpXml $xmp12

Write-JpegWithXmpAndCommentCipher -OutputJpeg (Join-Path $files14 'harbor-ticket.jpg') `
    -Title 'Harbor Ticket' `
    -Subtitle 'Manifest checked. Metadata filed.' `
    -Password 'harbor42' `
    -Plaintext 'flag{metadata_unlocks_cipher}'

$img15 = Join-Path $files15 'terminal-pass.jpg'
Write-JpegWithXmpAndCommentCipher -OutputJpeg $img15 `
    -Title 'Terminal Pass' `
    -Subtitle 'Dock 17 manifest revised at 19:40.' `
    -Password 'tram88' `
    -Plaintext 'flag{triple_layers_pay_off}'
Append-TextZipToFile -TargetFile $img15 -InnerText 'flag{this_decoy_is_fake}'

$mediaBuilder = Join-Path $PSScriptRoot 'media_builder'
$videoScript = Join-Path $mediaBuilder 'build-video.js'
$videoOutput = Join-Path $files10 'station-feed.webm'
if ((Get-Command node -ErrorAction SilentlyContinue) -and (Test-Path -LiteralPath (Join-Path $mediaBuilder 'build-qr-png.js'))) {
    $qrTemp = Join-Path $files16 'qr_tmp.png'
    node (Join-Path $mediaBuilder 'build-qr-png.js') $qrTemp 'ZmxhZ3txcl9mcmFtZXNfYmFzZTY0fQ=='
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $qrTemp)) {
        throw 'QR builder failed.'
    }
    [PracticeGraphics]::CreateAnimatedGifWithImage((Join-Path $files16 'qr-flash.gif'), $qrTemp)
    Remove-Item -LiteralPath $qrTemp -Force
}
else {
    throw 'QR builder is missing.'
}

if ((Get-Command node -ErrorAction SilentlyContinue) -and (Test-Path -LiteralPath (Join-Path $mediaBuilder 'build-dns-pcap.js'))) {
    node (Join-Path $mediaBuilder 'build-dns-pcap.js') (Join-Path $files17 'dns-bursts.pcap')
    if ($LASTEXITCODE -ne 0) {
        throw 'DNS pcap builder failed.'
    }
}
else {
    throw 'DNS pcap builder is missing.'
}

if ((Get-Command node -ErrorAction SilentlyContinue) -and (Test-Path -LiteralPath (Join-Path $mediaBuilder 'build-spectrogram-audio.js'))) {
    node (Join-Path $mediaBuilder 'build-spectrogram-audio.js') (Join-Path $files13 'spectrum.wav') 'FLAG{SPECTRUM_13}'
    if ($LASTEXITCODE -ne 0) {
        throw 'Audio spectrum builder failed.'
    }
}
else {
    throw 'Audio spectrum builder is missing.'
}
if (Test-Path -LiteralPath $videoOutput) {
    Write-Warning 'Keeping existing station-feed.webm. Delete it manually if you want to force a fresh rebuild under an environment that can launch the browser.'
}
elseif ((Get-Command node -ErrorAction SilentlyContinue) -and (Test-Path -LiteralPath (Join-Path $mediaBuilder 'node_modules\puppeteer-core')) -and (Test-Path -LiteralPath $videoScript)) {
    node $videoScript $videoOutput
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $videoOutput)) {
        throw 'Video builder failed and no existing station-feed.webm is available.'
    }
}
else {
    Write-Warning 'Video builder dependencies are missing and no existing station-feed.webm is available.'
}

Write-Output 'Practice samples generated successfully.'
