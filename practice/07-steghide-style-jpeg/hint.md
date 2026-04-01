# Hint

这题的 intended path 很像 steghide：

1. 先拿到 password
2. 再提取 JPG 里的隐藏内容
3. 最后解密得到明文

如果文件尾没有异常，记得检查 JPEG 的注释段或可打印字符串。
