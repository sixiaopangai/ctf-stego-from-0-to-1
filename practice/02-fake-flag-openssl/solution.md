# Solution

## 正确方向

这题是“文件尾追加 + 二次加密”的组合题。

## 解题步骤

1. 检查 `sunny-clue.jpg` 的文件尾
2. 提取追加的 ZIP
3. 解压得到 `flag.txt`
4. 发现第一行是假 flag，第二行是 `Salted__` 密文
5. 用第一行作为 password，按 OpenSSL `AES-256-CBC + MD5 EVP_BytesToKey` 解密

## 参考答案

```text
flag{openssl_layer_clear}
```
