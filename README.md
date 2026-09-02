# frontend-ai-coding-rules

一套给 AI 编码助手（ZCode、Claude Code、Trae 等）使用的前端编码规则合集：核心是 [AGENTS.md](AGENTS.md) 编码规范，外加三个按需加载的场景化 skill 与 Git 提交规范。

## 功能

| 组件 | 作用 |
| --- | --- |
| [AGENTS.md](AGENTS.md) | 核心编码规范：修改授权与范围控制、工作流、技术栈约束（Vue 2 / Vue 3 不混用）、反过度工程化、数据字段与契约一致性、输出风格 |
| [CLAUDE.md](CLAUDE.md) | Claude Code 入口，内容为 `@AGENTS.md` 引用 |
| [api-integration-checklist](.agents/skills/api-integration-checklist/SKILL.md) | 接口联调契约校验：字段与响应壳以真实契约为准，缺口阻断并生成《接口联调清单.md》确认单，跑通即删 |
| [vue-component-style](.agents/skills/vue-component-style/SKILL.md) | Vue / uni-app 组件细则：短逻辑内联、Tailwind / Windi 类名规范、空标签自闭合 |
| [simplify](.agents/skills/simplify/SKILL.md) | 代码化简与无损重构：行为不变前提下消除多余复杂度，`/simplify` 触发 |
| [.trae/rules/git-commit-message.md](.trae/rules/git-commit-message.md) | Trae 规则：Git 提交信息用中文 |

## 目录结构

```
.
├── AGENTS.md                            # 核心编码规范（跨工具通用）
├── CLAUDE.md                            # Claude Code 入口，内容为 @AGENTS.md 引用
├── .agents/
│   └── skills/
│       ├── api-integration-checklist/   # skill：接口联调契约校验
│       │   └── SKILL.md
│       ├── simplify/                    # skill：代码化简与无损重构
│       │   └── SKILL.md
│       └── vue-component-style/         # skill：组件内联细则与 Tailwind/Windi 规范
│           └── SKILL.md
└── .trae/
    └── rules/
        └── git-commit-message.md        # Trae 规则：Git 提交信息用中文
```

## 使用方式

将 `AGENTS.md` 与 `CLAUDE.md` 复制到目标项目根目录——ZCode、Codex 等原生读取，Claude Code 经 `CLAUDE.md` 引用同一份规则；`.agents/skills/` 整目录复制过去即可被 Agent 发现，在联调、组件开发、化简代码等场景按需触发。也可把本仓库整体作为新项目的前端 AI 配置模板，按需删减。
