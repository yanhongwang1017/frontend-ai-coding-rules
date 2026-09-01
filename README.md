# frontend-ai-coding-rules

前端 AI 编码规则仓库：一套给 AI 编码助手（ZCode、Claude Code、Trae 等）用的规则与配置合集，核心是 [AGENTS.md](AGENTS.md) 编码规范，外加三个场景化 skill 和 Git 提交规范。

## 目录结构

```
.
├── AGENTS.md                            # 核心：AI 编码规则（跨工具通用）
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

## 内容说明

### AGENTS.md —— AI 编码规则

面向前端开发的完整行为规范，按「授权 → 实现 → 底线」三层展开，主要包含：

- **修改规则**：未经授权不修改任何文件；`review` / `answer` / `monitor` 只读，`change` 只做被要求的工作；严禁凭猜测修改需求文档。业务上常见 ≠ 用户要求，存在多种实现时选满足当前需求的最小实现。
- **工作流规则**：先理解再动手、优先复用现有代码、接口字段以真实契约为准、不随意新增依赖等。
- **技术栈约束**：Vue 2（Element UI）与 Vue 3（TypeScript、Element Plus、Ant Design Vue、Layui Vue、Windi CSS / Tailwind CSS）两套栈严禁混用；统一使用 yarn。
- **反过度工程化**：内联优先，短于 8 行的逻辑不抽方法；「六级懒人梯」决策顺序（YAGNI → 复用现有 → 标准库 → 已装依赖 → 一行 → 最少代码）；修 Bug 修根因不修症状。
- **数据与契约规则**：状态判断严禁汉字参与逻辑、严禁臆造别名做多重兼容；下拉枚举数据直通，禁止无意义的 `.map()` 转换和猜测性 `.filter()`；数据字段必须有明确来源，严禁堆叠 `||` 猜测字段，默认值优先 `??`。
- **输出风格**：中文注释、克制的 try-catch。Tailwind / Windi 类名、Vue 组件内联、空标签自闭合细则已拆分至 `vue-component-style` skill，按需加载。

### api-integration-checklist —— 接口联调 skill

前端与后端接口联调的契约校验规范，核心底线：

1. 禁止私自脑补——契约里没有的字段，严禁捏造字段名或写死 Mock 数据；
2. 检测到接口缺失、字段缺失、类型不匹配或行为异常时，立即阻断并生成《接口联调清单.md》确认单；
3. 清单实时更新，缺口跑通即删除；
4. 接口字段 ≠ 页面展示字段——接口多返回字段是正常情况，接口数据不能反向决定 UI，没有明确需求不新增展示列。

### vue-component-style —— 组件编码 skill

写 Vue / uni-app 组件模板、样式时按需加载的细则：

- **组件内联规则**：事件处理、计算属性、生命周期初始化、watch 的短逻辑一律内联，禁止包装 `uni.showToast` 这类简单调用；
- **Tailwind / Windi 类名规范**：只用真实存在的类名、布局优先 flex、不混用互斥类名、同一元素类名不超过 10 个；
- **空标签自闭合**：Vue 模板 / JSX 中空成对标签一律自闭合（纯 HTML 除外）。

AGENTS.md 对应小节只保留一行入口，细则集中在此，避免常驻上下文膨胀。

### simplify —— 代码化简与重构 skill

灵感来自 Claude Code `/simplify` 命令，用于保持行为不变的前提下进行代码无损瘦身：

- **保持行为不变**：严禁更改既有逻辑、返回值、副作用或公共接口；
- **消除多余复杂度**：拍平不必要嵌套、删除冗余抽象与包装层、收敛临时变量；
- **聚焦最近修改**：默认关注最近修改的代码，可由用户使用 `/simplify` 命令显式触发。


## 使用方式

- **AGENTS.md** 是跨工具通用标准：复制到目标项目根目录即可，ZCode、Codex 等原生读取；Claude Code 通过同目录的 `CLAUDE.md`（`@AGENTS.md`）引用同一份规则。
- **Skills** 放在项目的 `.agents/skills/` 目录下即可被 Agent 发现：接口联调、组件开发以及通过 `/simplify` 化简代码时按需触发。

也可以把本仓库整体作为新项目的前端 AI 配置模板，按需删减。
