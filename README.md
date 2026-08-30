# frontend-ai-coding-rules

前端 AI 编码规则仓库：一套给 AI 编码助手（ZCode、Claude Code、Trae 等）用的规则与配置合集，核心是 [AGENTS.md](AGENTS.md) 编码规范，外加接口联调 skill 和 Git 提交规范。

## 目录结构

```
.
├── AGENTS.md                            # 核心：AI 编码规则（跨工具通用）
├── CLAUDE.md                            # Claude Code 入口，内容为 @AGENTS.md 引用
├── .agents/
│   └── skills/
│       └── api-integration-checklist/   # ZCode skill：接口联调契约校验
│           └── SKILL.md
└── .trae/
    └── rules/
        └── git-commit-message.md        # Trae 规则：Git 提交信息用中文
```

## 内容说明

### AGENTS.md —— AI 编码规则

面向前端开发的完整行为规范，按「授权 → 实现 → 底线」三层展开，主要包含：

- **修改规则**：未经授权不修改任何文件；`review` / `answer` / `monitor` 只读，`change` 只做被要求的工作；严禁凭猜测修改需求文档。
- **工作流规则**：先理解再动手、优先复用现有代码、接口字段以真实契约为准、不随意新增依赖等。
- **技术栈约束**：Vue 2（Element UI）与 Vue 3（TypeScript、Element Plus、Ant Design Vue、Layui Vue、Windi CSS / Tailwind CSS）两套栈严禁混用；统一使用 yarn。
- **反过度工程化**：内联优先，短于 8 行的逻辑不抽方法；「六级懒人梯」决策顺序（YAGNI → 复用现有 → 标准库 → 已装依赖 → 一行 → 最少代码）；修 Bug 修根因不修症状。
- **前端契约规则**：状态判断严禁汉字参与逻辑、严禁臆造别名做多重兼容、多状态判断用 `Set` / 字典集中收敛；下拉枚举数据直通，禁止无意义的 `.map()` 转换和猜测性 `.filter()`。
- **输出风格**：中文注释、克制的 try-catch、Tailwind / Windi 类名规范、空标签自闭合。

### api-integration-checklist —— 接口联调 skill

前端与后端接口联调的契约校验规范，三条底线：

1. 禁止私自脑补——契约里没有的字段，严禁捏造字段名或写死 Mock 数据；
2. 检测到接口缺失、字段缺失、类型不匹配或行为异常时，立即阻断并生成《接口联调清单.md》确认单；
3. 清单实时更新，缺口跑通即删除。

### git-commit-message —— Trae 规则

Git 提交信息使用中文生成。

## 使用方式

- **AGENTS.md** 是跨工具通用标准：复制到目标项目根目录即可，ZCode、Codex 等原生读取；Claude Code 通过同目录的 `CLAUDE.md`（`@AGENTS.md`）引用同一份规则。
- **api-integration-checklist** skill 放在项目的 `.agents/skills/` 目录下即可被 ZCode 发现，涉及接口联调时自动触发。
- **.trae/rules/** 下的规则文件适用于 Trae，`alwaysApply: true` 表示对所有会话生效。

也可以把本仓库整体作为新项目的前端 AI 配置模板，按需删减。
