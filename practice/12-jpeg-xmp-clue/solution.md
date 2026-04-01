# Solution

## 正确方向

这题的明文直接藏在 JPEG 的 XMP metadata 中。

## 解题步骤

1. 检查 JPG 中是否存在 `http://ns.adobe.com/xap/1.0/`
2. 提取 XMP XML
3. 从字段里读出隐藏内容

## 参考答案

```text
flag{xmp_reveals_truth}
```
