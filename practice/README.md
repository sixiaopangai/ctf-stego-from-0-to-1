# Practice 实操练习包

这里是一组可以直接动手做的练习题，不是单纯的文档附录。练习区的目标是让你把教程中学到的排查流程真正跑一遍。

如果你还没看过教程正文，建议先回到 [`../README.md`](../README.md) 或从 [`../01-基础认知.md`](../01-基础认知.md) 开始。

## 目录定位

- 按题型和难度组织练习题
- 每题都提供题面、提示、解法和附件
- 用统一命名规则保持可扩展性

## 使用方式

每个题目目录都包含以下文件：

- `challenge.md`：题目说明
- `hint.md`：提示
- `solution.md`：参考解法
- `files/`：题目附件

推荐做题顺序：

1. 先看 `challenge.md`
2. 卡住时再看 `hint.md`
3. 最后对照 `solution.md`

## 题目批次

### 基础批次

1. [`01-jpeg-tail-zip/`](./01-jpeg-tail-zip/)：JPEG 尾部拼接 ZIP，练“查文件尾 + 提取压缩包”
2. [`02-fake-flag-openssl/`](./02-fake-flag-openssl/)：假 flag + OpenSSL `Salted__`，练“两层拆解”
3. [`03-png-alpha-hidden/`](./03-png-alpha-hidden/)：PNG alpha 通道藏字，练“看透明层”
4. [`04-low-contrast-png/`](./04-low-contrast-png/)：低对比度隐藏文字，练“拉对比度”
5. [`05-base64-gzip-chain/`](./05-base64-gzip-chain/)：编码链练习，练“Base64 + Gzip”
6. [`06-audio-morse-basic/`](./06-audio-morse-basic/)：音频基础练习，练“听感 + 波形 / 频谱”

### 进阶批次

7. [`07-steghide-style-jpeg/`](./07-steghide-style-jpeg/)：模拟 steghide 做题路径的 JPG 口令题
8. [`08-png-palette-order/`](./08-png-palette-order/)：PNG 调色板顺序题，练“看 PLTE 而不是只看像素”
9. [`09-gif-frame-flash/`](./09-gif-frame-flash/)：GIF 拆帧题，练“逐帧查看闪现信息”
10. [`10-video-frame-sampling/`](./10-video-frame-sampling/)：视频抽帧题，练“按时间采样抓关键帧”
11. [`11-png-lsb-zsteg/`](./11-png-lsb-zsteg/)：PNG LSB 题，练“位平面 / 最低位 / 自定义提取”
12. [`12-jpeg-xmp-clue/`](./12-jpeg-xmp-clue/)：JPEG XMP 元数据题，练“先查 metadata 再谈解密”
13. [`13-audio-spectrum-text/`](./13-audio-spectrum-text/)：音频频谱写字题，练“看 spectrogram 而不是只听”
14. [`14-layered-metadata-cipher/`](./14-layered-metadata-cipher/)：元数据密码 + 密文载荷双层题

### 综合批次

15. [`15-image-metadata-cipher-3layer/`](./15-image-metadata-cipher-3layer/)：图片 + 元数据 + 密文 + 假 flag 三层综合题
16. [`16-gif-qr-base64/`](./16-gif-qr-base64/)：GIF 中闪现二维码，二维码里是 Base64
17. [`17-pcap-dns-hidden/`](./17-pcap-dns-hidden/)：流量包入门题，练“看 DNS 查询名”

## 注意事项

- [`writeups-index.md`](./writeups-index.md) 是统一答案索引，含完整剧透，建议最后再看
- 样本附件已随仓库提供，不必先自行生成
- 若你想重建部分样本，可回到 [`../scripts/README.md`](../scripts/README.md) 查看脚本说明
- 这套练习重点是练流程，不追求冷门和刁钻
