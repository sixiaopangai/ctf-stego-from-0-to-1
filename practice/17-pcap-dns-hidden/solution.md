# Solution

## 正确方向

这题把信息拆在了多次 DNS 查询的子域名里。

## 解题步骤

1. 提取所有 DNS 查询名
2. 过滤出可疑的子域片段
3. 按顺序拼接
4. 继续做 Base64 解码

## 参考答案

```text
flag{dns_queries_whisper}
```
