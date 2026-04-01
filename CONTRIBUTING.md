# Contributing Guide

感谢你愿意为这个仓库补充内容。

这个项目的目标不是单纯堆积工具或题目，而是沉淀一套适合 CTF 初学者的隐写学习路径。因此，任何贡献都应优先服务于以下三点：

- 让新手更容易找到入口
- 让内容结构更清晰、更可维护
- 让练习与正文之间的对应关系更稳定

## 适合提交的内容

欢迎以下类型的贡献：

- 修正文档中的错误、错字、坏链或表达不清的部分
- 补充新的教程章节或现有章节的说明
- 新增练习题、提示、题解或练习索引
- 增加或改进配套脚本
- 改善仓库导航、README 或维护文档

不建议提交与当前主题无关的大范围重构，除非先在 Issue 中说明目的和范围。

## 提交前先了解的结构

仓库当前分层如下：

- 根目录 `01-08`：教程主内容
- `practice/`：练习题目录与答案索引
- `scripts/`：配套脚本与媒体样本生成脚本
- `docs/`：项目级规范文档

相关规范建议先阅读：

- [`README.md`](./README.md)
- [`docs/文档规划.md`](./docs/文档规划.md)
- [`docs/README写作规范.md`](./docs/README写作规范.md)

## 内容组织规则

### 教程章节

- 章节文件命名保持 `NN-主题名.md`
- 一篇文档只讲一个主要主题
- 首页 `README.md` 只做仓库导航，不承载整本教程正文

### 练习题

新增练习题时，目录命名保持：

```text
practice/NN-topic-keywords/
```

每道题目录下应至少包含：

- `challenge.md`
- `hint.md`
- `solution.md`
- `files/`

要求：

- `challenge.md` 只写题面
- `hint.md` 只写提示
- `solution.md` 只写参考解法
- 不要把题解直接写进顶层 README
- 如果新增题目，请同步更新 [`practice/README.md`](./practice/README.md)
- 如果新增题目，请同步更新 [`practice/writeups-index.md`](./practice/writeups-index.md)

### 脚本

如果你修改或新增脚本：

- 优先保持 PowerShell / Node 两类现有技术栈一致
- 命令示例应可直接复制执行
- 如有依赖变化，请同步更新 [`scripts/README.md`](./scripts/README.md)
- 不要引入与任务无关的网络调用、统计或遥测逻辑

## 文档写作规则

本仓库默认使用中文说明。

写 README 或说明文档时，请遵守以下原则：

- 先说明“这是什么”，再说明“怎么用”
- 优先使用相对路径链接
- 标题层级清晰，通常不要超过三级标题
- 导航类内容优先用列表或表格
- 避免把大段正文重复复制到多个地方

更细的写法约定见 [`docs/README写作规范.md`](./docs/README写作规范.md)。

## 提交流程

建议流程：

1. Fork 或新建分支进行修改
2. 保持改动范围聚焦，避免把无关修改混进同一个提交
3. 自查链接、文件命名、目录位置是否正确
4. 提交 Pull Request，说明改动目的和影响范围

## Commit 规范

提交信息请使用 Conventional Commits，例如：

```text
docs: improve practice README
feat: add audio stego practice
fix: correct broken links in docs
chore: update script usage examples
```

如果你的改动只涉及文档，优先使用 `docs:`。

## Pull Request 建议说明

PR 描述里建议写清楚：

- 改了什么
- 为什么要改
- 影响哪些文件或目录
- 是否需要维护者额外检查链接、附件或脚本

## 提交前检查清单

提交前请至少确认：

- 链接没有写错
- 文件名与目录位置符合现有规则
- README 没有泄露练习答案
- 练习题补充时，索引文档已同步更新
- 脚本改动时，说明文档已同步更新

## 交流方式

如果你准备做较大改动，建议先提 Issue 或在 PR 中说明设计思路，避免重复劳动或方向偏移。
