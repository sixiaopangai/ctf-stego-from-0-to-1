# Solution

## 正确方向

这题不是像素隐写，而是文件尾追加。

## 解题步骤

1. 确认 `park-note.jpg` 是 JPEG
2. 找到 JPEG 结束标记 `FFD9`
3. 发现 `FFD9` 后还有额外数据
4. 尾部数据开头是 `PK 03 04`
5. 提取尾部 ZIP，解压得到明文

## 参考答案

```text
flag{tail_zip_found}
```
