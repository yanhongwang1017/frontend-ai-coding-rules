---
name: vue-component-style
description: "生成或修改 Vue / uni-app 组件模板、脚本与 Tailwind CSS / Windi CSS 样式时的内联优先编码细则与类名规范：事件处理、计算属性、生命周期初始化、watch 的短逻辑一律内联，禁止包装 uni.showToast / this.$emit 等简单调用；Tailwind / Windi 类名必须真实存在、布局优先 flex、不混用互斥类名、同一元素类名不超过 10 个；空成对标签一律自闭合（纯 HTML 除外）。Use whenever 写 Vue 组件、改 Vue 模板、写 uni-app 页面、使用 Tailwind CSS / Windi CSS / 原子类、处理组件事件或 onMounted / onLoad 初始化逻辑、书写空标签或自闭合标签——即使用户没有明确提到「内联」或「样式规范」。"
---

# Vue 组件内联细则与 Tailwind / Windi 类名规范

## 一、Vue / uni-app 组件规则

1. 事件处理：短于 8 行的直接内联写在模板里，例如 `@click="count++"`，不要写 `increment()` 方法。
2. 计算属性：简单计算可以直接写在模板里，例如 `{{ price * quantity }}`。只在需要缓存或复用时才使用 `computed`。
3. `mounted` / `onLoad`：初始化逻辑加注释、空行后直接内联编写，不要拆成多个一次性方法。
4. `watch`：短于 5 行的回调逻辑直接写，不要抽成方法。
5. 不要把 `uni.showToast`、`uni.setStorageSync`、`this.$emit`、`console.log` 这类简单调用包装成方法。

## 二、Tailwind CSS / Windi CSS 规则

使用 Tailwind CSS 和 Windi CSS 生成代码时，严格遵守：

1. 只使用必要的、真实存在的 Tailwind CSS 和 Windi CSS 类名
2. 布局优先使用 flex，其次是 grid
3. 不使用生僻的或 AI 编造的类名
4. 优先使用 Windi 的标准前缀：p、m、w、h、text、bg、border、rounded、flex、grid
5. 不混用互斥的类名（block + inline、p-1 + p-2）
6. 同一元素上的类名不超过 10 个
7. 不使用 CSS 属性名作为类名（如 padding、margin）

## 三、空标签自闭合

任何没有子节点或文本内容的非 void 元素（如 `a`、`div`、`span`、`p`、`button` 等），必须写成自闭合形式 `<tag-name />`。禁止写成 `<tag-name></tag-name>` 这类无内容的成对标签。

**适用范围：**仅限 Vue 模板和 JSX/TSX 中的空成对标签。输出纯 HTML 时，非 void 元素不得自闭合（浏览器会把 `<div />` 当作未闭合的开始标签处理）。

- 错误（空但未自闭合）：`<a href="/"></a>`、`<div></div>`、`<span></span>`
- 正确（空且自闭合）：`<a href="/" />`、`<div />`、`<span />`

注意：有内容时正常书写，例如 `<a href="/">Home</a>`。本条只针对空标签。输出代码时，自动把所有空的成对标签转换为自闭合形式。
