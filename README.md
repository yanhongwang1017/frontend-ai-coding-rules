# frontend-ai-coding-rules

一套给 AI 编码助手（Claude Code、Cursor、Codex、Trae、ZCode、CodeBuddy 等）使用的前端 AI 编码规则合集：核心是开箱即用的 [AGENTS.md](AGENTS.md) 编码规范，外加三个按需加载的场景化 skill（接口联调契约校验、Vue 组件规范、代码化简）与 Git 提交规范。适用于 Vue 2 / Vue 3 + TypeScript 项目，目标是让 AI 写出的代码守契约、不猜字段、不过度工程化。

> 关键词：AI 编码规则、AI coding rules、前端编码规范、AGENTS.md、CLAUDE.md、Cursor rules、Claude Code 规则、Codex 规则、Trae 规则、Vue3 最佳实践、前端 AI 提示词

## 功能

| 组件 | 作用 |
| --- | --- |
| [AGENTS.md](AGENTS.md) | 核心编码规范：修改授权与范围控制、工作流、技术栈约束（Vue 2 / Vue 3 不混用）、反过度工程化、数据字段与契约一致性、输出风格 |
| [CLAUDE.md](CLAUDE.md) | Claude Code 入口，内容为 `@AGENTS.md` 引用 |
| [api-integration-checklist](.agents/skills/api-integration-checklist/SKILL.md) | 接口联调契约校验：字段与响应壳以真实契约为准，缺口阻断并生成《接口联调清单.md》确认单，跑通即删 |
| [vue-component-style](.agents/skills/vue-component-style/SKILL.md) | Vue / uni-app 组件细则：短逻辑内联、组件职责归属（谁消费谁请求、弹窗 / 抽屉显隐自持）、Tailwind / Windi 类名规范、空标签自闭合 |
| [simplify](.agents/skills/simplify/SKILL.md) | 代码化简与无损重构：行为不变前提下消除多余复杂度，`/simplify` 触发 |
| [.trae/rules/git-commit-message.md](.trae/rules/git-commit-message.md) | Trae 规则：Git 提交信息用中文 |
| [sync-rules.command](sync-rules.command) | macOS 同步脚本：把 `.agents/` 与 `AGENTS.md` 覆盖复制到一个或多个目标项目 |
| [sync-rules.bat](sync-rules.bat) | Windows 版同步脚本，逻辑与上者一致 |

## 目录结构

```
.
├── AGENTS.md                            # 核心编码规范（跨工具通用）
├── CLAUDE.md                            # Claude Code 入口，内容为 @AGENTS.md 引用
├── sync-rules.command                   # 同步脚本：macOS
├── sync-rules.bat                       # 同步脚本：Windows
├── targets.txt                          # 运行脚本后生成：上次的目标路径清单
├── .agents/
│   └── skills/
│       ├── api-integration-checklist/   # skill：接口联调契约校验
│       │   └── SKILL.md
│       ├── simplify/                    # skill：代码化简与无损重构
│       │   └── SKILL.md
│       └── vue-component-style/         # skill：组件职责归属、内联细则与 Tailwind/Windi 规范
│           └── SKILL.md
└── .trae/
    └── rules/
        └── git-commit-message.md        # Trae 规则：Git 提交信息用中文
```

## 使用方式

### 手动复制

将 `AGENTS.md` 与 `CLAUDE.md` 复制到目标项目根目录——ZCode、Codex 等原生读取，Claude Code 经 `CLAUDE.md` 引用同一份规则；`.agents/skills/` 整目录复制过去即可被 Agent 发现，在联调、组件开发、化简代码等场景按需触发。也可把本仓库整体作为新项目的前端 AI 配置模板，按需删减。

### 脚本同步

仓库根目录提供两个脚本，用于把 `.agents/` 与 `AGENTS.md` 覆盖复制到一个或多个目标项目：

| 脚本 | 平台 | 运行方式 |
| --- | --- | --- |
| `sync-rules.command` | macOS | 双击运行，或在终端执行 `./sync-rules.command` |
| `sync-rules.bat` | Windows | 双击运行 |

使用前把脚本与 `.agents/`、`AGENTS.md` 放在同一目录（源目录取脚本自身位置）。执行流程：

1. **首次运行**：按提示输入目标项目路径，多个用 `;` 分隔（如 `/a/b;/c/d`）
2. 输入的路径自动保存到同目录 `targets.txt`
3. **之后运行**：直接回车即用已保存的路径；输入新路径则覆盖保存
4. 每个目标若已有 `.agents/`，先整体删除再复制，保证不留残留文件；`AGENTS.md` 直接覆盖

`targets.txt` 每行一个路径，`#` 开头为注释，可手动编辑。目标目录不存在时提示跳过，不影响其余目标继续执行。
