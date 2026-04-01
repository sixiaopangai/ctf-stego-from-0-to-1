# Solution

## 正确方向

这题是典型的双层结构：

- 第一层：metadata 给 password
- 第二层：JPEG 里另一个段给密文

## 解题步骤

1. 从 `harbor-ticket.jpg` 的 XMP metadata 中拿到 password
2. 从 JPG 注释中提取 `Salted__` Base64 密文
3. 用 password 解密

## 参考答案

```text
flag{metadata_unlocks_cipher}
```
