# Solution

## 正确方向

这题是三层组合题：

- 尾部 ZIP 里有假 flag
- XMP metadata 里有 password
- JPEG 注释段里有真正的 `Salted__` 密文

## 解题步骤

1. 检查尾部 ZIP，确认假 flag 只是诱饵
2. 提取 XMP metadata，拿到 password
3. 从 JPG 注释中提取 `cipher=...`
4. 用 password 解密

## 参考答案

```text
flag{triple_layers_pay_off}
```
