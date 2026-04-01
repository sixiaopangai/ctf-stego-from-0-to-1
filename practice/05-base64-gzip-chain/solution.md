# Solution

## 正确方向

这题的核心不是图像，而是编码链。

## 解题步骤

1. 从 `system.log` 中提取那段长 Base64
2. 先做 Base64 解码
3. 解码结果是 Gzip 压缩流
4. 再做解压，得到明文

## 参考答案

```text
flag{decode_then_decompress}
```
