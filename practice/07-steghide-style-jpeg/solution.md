# Solution

## 正确方向

这题不是尾部追加，而是把载荷放在 JPEG 注释段里，再用口令做二次加密。

## 解题步骤

1. 从 `metro-pass.jpg` 的可见线索中拿到 password
2. 检查 JPEG 的 `COM` 注释段，提取其中的 `Salted__` Base64 密文
3. 用 password 跑解密脚本

## 说明

这道题是 steghide 做题路径的模拟题：

- 先找 password
- 再从 JPG 中提隐藏内容
- 最后解密

## 参考答案

```text
flag{comment_payload_opened}
```
