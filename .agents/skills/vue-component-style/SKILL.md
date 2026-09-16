---
name: vue-component-style
description: "Vue / uni-app 组件的内联优先细则、职责归属与 Tailwind / Windi 类名规范：短逻辑内联，不包装 uni.showToast / this.$emit 等简单调用；请求与提交由消费它的组件自己发起（谁消费谁请求），禁止上提父组件再 props 下传或 emit 反向调用；弹窗 / 抽屉显隐自持，对外暴露 open() / close()；Tailwind / Windi 类名必须真实存在、布局优先 flex、不混用互斥类名、同一元素不超过 10 个；空成对标签自闭合（纯 HTML 除外）。Use whenever 写或改 Vue 组件、uni-app 页面，给弹窗（Dialog）、抽屉（Drawer）、面板、行内编辑等子组件接数据或接口，新增或修改弹窗 / 抽屉的打开、关闭、显隐与提交逻辑，判断某份数据或请求该写在父组件还是子组件，使用 Tailwind / Windi 原子类，处理组件事件或 onMounted / onLoad 初始化，书写空标签。"
---

# Vue 组件内联细则、职责归属与 Tailwind / Windi 类名规范

## 一、组件职责归属：谁消费，谁请求

判断依据是**这份数据、这个操作的消费方是谁**，不是「谁是父组件」。弹窗（Dialog）、抽屉（Drawer）、面板（Tab / Collapse）、表格行内编辑等子组件，只要这份数据是它自己消费的，请求就在它内部发起。

1. **禁止请求上提**：子组件自己消费的数据与操作（取详情、取下拉选项、提交），必须在该组件内部发起并持有；严禁写在父组件，再通过 props 下传结果、或通过 emit 反向调用父组件的方法。
2. **传标识，不传结果**：父组件只传定位用的标识（`id` / `rowId` / `type`），由子组件自己去请求；严禁父组件请求好整个数据对象再 props 下传。例外：父组件已有的字段子组件全部直接使用、且无需额外请求时（如删除确认弹窗只展示名称），可直接传该字段。
3. **成功后只传信号**：子组件操作成功后 `emit('success')`，父组件只负责刷新自己持有的数据（如列表）；严禁父组件替子组件发起请求、再把请求函数 props 传给子组件。
4. **上提的唯一条件是多个消费者**：只有父组件与子组件都消费同一份数据、或多个兄弟组件共享时，才把请求与状态上提到父组件或 composable（对齐 AGENTS.md 5.7）；「父组件先写的」不构成上提理由——上提的触发条件是消费者数量，不是书写顺序。

```vue
<!-- 坏：父组件替弹窗请求详情、替弹窗提交 -->
<DetailDialog :detail="detail" :submitting="submitting" @submit="handleSubmit" />
```
```js
// 父组件：替弹窗请求它自己消费的数据
const openDialog = async (row) => {
  visible.value = true
  detail.value = await fetchDetail(row.id).finally(() => { loading.value = false })
}
```
```vue
<!-- 好：父组件只传标识、只收信号；弹窗自己请求、自己管 loading -->
<DetailDialog ref="detailDialogRef" :id="currentId" @success="fetchList" />

<!-- DetailDialog.vue -->
watch(visible, () => {
  fetchDetail(props.id).finally(() => { loading.value = false })
})
```

弹窗 / 抽屉的显隐是它自己消费的状态，与上述请求同源——以下为该节在显隐上的展开，父组件不再持有 `v-model`：

5. **显隐自持，`open()` / `close()` 对外**：弹窗、抽屉内部持有 `const visible = ref(false)`，用 `defineExpose` 暴露 `open()` 与 `close()`；父组件用 `ref<InstanceType<typeof XModal> | null>(null)` 持有并调用。
   - 坏：父组件 `const showXxx = ref(false)` + `<XModal v-model="showXxx" />` + `showXxx.value = true`
   - 好：父组件 `const xxxRef = ref<InstanceType<typeof XModal> | null>(null)` + `<XModal ref="xxxRef" />` + `xxxRef.value?.open()`
   - Vue 2 / uni-app 对照：`data` 里放 `visible`，`methods` 里写 `open` / `close`，父组件 `this.$refs.xxx.open()`
6. **每次打开都要做的重置写进 `open()`**：清空表单、重置分页与校验放 `open()` 内，父组件不再每次打开前手工重置（无 props 依赖的弹窗适用，如「打开即清空拒绝理由」）。
7. **模板内的关闭点直接走 `close()`**：关闭图标、取消按钮写 `@click="close()"`，成功回调里的关闭同理，不再出现 `visible = false`。
8. **例外：依赖 props 的初始化不要同步塞进 `open()`**：父组件常见写法是「先给 props 赋值、紧接着调 `open()`」，而 props 要到下一个渲染周期才更新，同步读 `props.xxx` 会拿到上一份数据。这类逻辑（按 id 拉详情、预加载选项）保留在 `watch(visible)` 内——pre-flush，触发时 props 已更新，与改造前语义一致；或让父组件改成 `nextTick(() => xxxRef.value?.open())`。二选一，在代码里注明取舍即可。
9. **联动关闭必须显式补**：父级容器（抽屉）关闭时若需一并关掉子弹窗，写 `childRef.value?.close()`。改造后不再有 `v-model`，原来靠 `watch(visible)` 联动重置子组件状态的代码会静默失效（不报错、弹窗就是打不开 / 关不掉）——这是该模式唯一的真实风险，改完必须 grep 旧变量名确认无残留。
10. **成功信号与关闭分离**：子组件操作成功后照旧 `emit('success' / 'confirm')` 让父组件刷新自己的数据，关闭动作由子组件自己 `close()`，不要父组件替它关。

```vue
<!-- 坏：父组件持有显隐、v-model 下传 -->
<PayModal v-model="showPayModal" :task="currentPayTask" @confirm="fetchDetail" />
```
```js
const showPayModal = ref(false)
const currentPayTask = ref({})
const handlePay = (row) => {
  currentPayTask.value = row
  showPayModal.value = true
}
```
```vue
<!-- 好：父组件只持有引用，打开走组件自己暴露的方法 -->
<PayModal ref="payModalRef" :task="currentPayTask" @confirm="fetchDetail" />
```
```js
const payModalRef = ref<InstanceType<typeof PayModal> | null>(null)
const currentPayTask = ref({})
const handlePay = (row) => {
  currentPayTask.value = row
  payModalRef.value?.open()   // 打开
}
```
```vue
<!-- PayModal.vue -->
<script setup lang="ts">
const visible = ref(false)

// 打开弹窗
const open = () => {
  visible.value = true
}
// 关闭弹窗
const close = () => {
  visible.value = false
}
defineExpose({ open, close })
</script>
```

## 二、Vue / uni-app 组件规则

阈值与取舍不在这里复述，一律对齐 AGENTS.md 5.1（只用一次、短于 8 行的逻辑必须内联；同一逻辑出现 2 次以上或超过 10 行才考虑提取）。落地到 Vue 的形态：

1. 模板事件处理直接内联，如 `@click="count++"`，不写 `increment()` 方法。
2. 计算属性优先写在模板里，如 `{{ price * quantity }}`；只在需要缓存或复用时才用 `computed`。
3. `mounted` / `onLoad` 的初始化逻辑加注释、空行后直接内联，不拆成多个一次性方法；`watch` 回调同理。
4. 不要把 `uni.showToast`、`uni.setStorageSync`、`this.$emit`、`console.log` 这类简单调用包装成方法。

## 三、Tailwind CSS / Windi CSS 规则

使用 Tailwind CSS 和 Windi CSS 生成代码时，严格遵守：

1. 只使用必要的、真实存在的 Tailwind CSS 和 Windi CSS 类名，不使用生僻的或 AI 编造的类名
2. 布局优先使用 flex，其次是 grid
3. 优先使用 Windi 的标准前缀：p、m、w、h、text、bg、border、rounded、flex、grid
4. 不混用互斥的类名（block + inline、p-1 + p-2）
5. 同一元素上的类名不超过 10 个
6. 不使用 CSS 属性名作为类名（如 padding、margin）

## 四、空标签自闭合

任何没有子节点或文本内容的非 void 元素（如 `a`、`div`、`span`、`p`、`button` 等），必须写成自闭合形式 `<tag-name />`。禁止写成 `<tag-name></tag-name>` 这类无内容的成对标签。

**适用范围：**仅限 Vue 模板和 JSX/TSX 中的空成对标签。输出纯 HTML 时，非 void 元素不得自闭合（浏览器会把 `<div />` 当作未闭合的开始标签处理）。

- 错误（空但未自闭合）：`<a href="/"></a>`、`<div></div>`、`<span></span>`
- 正确（空且自闭合）：`<a href="/" />`、`<div />`、`<span />`
