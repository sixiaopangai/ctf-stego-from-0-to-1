# Solution

## 正确方向

这题的关键信息编码在 PNG 调色板顺序里。

## 解题步骤

1. 确认 `palette-bars.png` 是索引色 PNG
2. 提取 `PLTE` chunk
3. 读取前几项调色板条目
4. 按预设规则把颜色字节还原成 ASCII

## 参考答案

```text
flag{palette_order_matters}
```
