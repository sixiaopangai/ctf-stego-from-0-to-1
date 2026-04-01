# Solution

## 正确方向

这题不是直接在 GIF 里放明文，而是放了一个二维码，再在二维码里放 Base64。

## 解题步骤

1. 拆出 `qr-flash.gif` 的关键帧
2. 扫描二维码
3. 得到 Base64 字符串
4. Base64 解码得到最终明文

## 参考答案

```text
flag{qr_frames_base64}
```
