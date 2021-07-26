---
title: 与DOM元素的互动
---

<Alert type="info">

## <Icon name="graduation-cap"></Icon> 你将学习

- Cypress如何计算可见性
- Cypress如何确保元素是可操作的
- Cypress如何处理动画元素
- 如何绕过这些检查和强制事件

</Alert>

## 可操作性

Cypress中的一些命令是用于与DOM交互的，比如:

- [`.click()`](/api/commands/click)
- [`.dblclick()`](/api/commands/dblclick)
- [`.rightclick()`](/api/commands/rightclick)
- [`.type()`](/api/commands/type)
- [`.clear()`](/api/commands/clear)
- [`.check()`](/api/commands/check)
- [`.uncheck()`](/api/commands/uncheck)
- [`.select()`](/api/commands/select)
- [`.trigger()`](/api/commands/trigger)

这些命令模拟用户与应用程序交互。在幕后，Cypress触发浏览器会触发的事件，从而导致应用程序的事件绑定被触发。

在发出任何命令之前，我们检查DOM的当前状态，并采取一些操作来确保DOM元素已经“准备好”接收操作。

Cypress将在持续时间[`defaultCommandTimeout`](/guides/references/configuration#Timeouts) 内等待元素通过所有这些检查.(在[默认断言](/guides/core-concepts/introduction-to-cypress#Default-Assertions)中进行了深入的核心概念描述).

**_执行的检查和操作_**

- [将元素滚动到视野中.](#Scrolling)
- [确保元素没有被隐藏.](#Visibility)
- [确保元素没有被禁用.](#Disability)
- [确保元素没有分离.](#Detached)
- [确保元素不是只读的.](#Readonly)
- [确保元素不在动画中.](#Animations)
- [确保元素没有被覆盖.](#Covering)
- [如果仍然被位置固定的元素覆盖，则滚动页面.](#Scrolling)
- [在所需的坐标处触发事件.](#Coordinates)

每当Cypress不能与元素交互时，它可能会在上述任何步骤中失败。您通常会得到一个错误，解释为什么没有发现元素来操作。

### 可见性

Cypress通过检查很多东西来确定元素的可见性。包括以下这些在CSS翻译和转换时的计算因子。

#### 一个元素如果被认为是隐藏的，是因为:

- 它的`width` 或 `height` 是 `0`.
- 它的CSS属性(或其祖先)是 `visibility: hidden`.
- 它的CSS属性(或祖先)是 `display: none`.
- 其CSS属性为 `position: fixed`，并且在屏幕外或者被覆盖.
- 它的任一个祖先 **隐藏溢出**
  - 这个祖先的宽度或高度都是0
  - 以及该祖先和元素之间的元素是绝对位置 `position: absolute`
- 它的任一祖先 **隐藏溢出**
  - 这个祖先或者它和那个祖先之间的祖先是它的偏移父代？？-- todo： off 的翻译？
  - 并且它位于祖先的边界之外
- 它的任一个祖先 **隐藏溢出**
  - 它的位置是 `position: relative`
  - 并且它位于祖先的边界之外

\***隐藏溢出** 的含义表示元素有这样的属性 `overflow: hidden`, `overflow-x: hidden`, `overflow-y: hidden`, `overflow: scroll`, 或 `overflow: auto`

<Alert type="info">

<strong class="alert-header">CSS属性 Opacity(不透明度)</strong>

CSS属性(或祖先属性)`opacity:0`的元素在[直接断言元素的可见性](/guides/references/assertions#Visibility)时被认为是隐藏的.

然而，CSS属性(或祖先)为`opacity:0`的元素被认为是可操作的，任何用于与隐藏元素交互的命令都将执行该操作。

</Alert>

### 禁用

Cypress检查一个元素的`disabled`属性是否为`true`。

### 分离

当许多应用程序重新呈现DOM时，它们实际上删除了DOM元素，并使用新更改的属性在其位置插入新的DOM元素。

Cypress检查正在进行断言的元素是否与DOM分离。这将检查元素是否仍然在被测试应用程序的`document`中。

### 只读

Cypress检查在[.type()](/api/commands/type)键入期间是否设置了元素的`readonly`属性.

### 动画

Cypress将自动确定一个元素是否是正在动画过程中，并会等待到它停止。

为了计算一个元素是否正在执行动画，我们取它在最后位置的一个样本，并计算该元素的斜率。你们可能还记得8年级的代数课。 😉

为了计算一个元素是否在动画，我们检查元素本身的当前和以前的位置。如果距离超过[`animationDistanceThreshold`](/guides/references/configuration#Actionability), 那么我们认为元素在执行动画。

当我们想出这个值时，我们做了一些实验，以找到一个“感觉”过快的用户交互速度。你可以[增加或减少这个阈值](/guides/references/configuration#Actionability).

你也可以使用配置选项[`waitForAnimations`](/guides/references/configuration#Actionability)来关闭我们的动画检查。.

### 遮盖

我们还确保我们试图交互的元素不在父元素中.

例如，一个元素可以通过之前的所有检查，但一个巨大的对话框可能会覆盖整个屏幕，使任何真正的用户都无法与该元素进行交互。

<Alert type="info">

当检查元素是否被覆盖时，我们总是检查它的中心坐标。

</Alert>

如果元素的子元素覆盖了它，那也没关系。事实上，我们会自动向该子对象发出我们所触发的事件。

假设你有一个按钮:

```html
<button>
  <i class="fa fa-check">
  <span>Submit</span>
</button>
```

通常情况下，`<i>`或`<span>`元素覆盖了我们试图与之交互按钮的精确坐标。在这些情况下，事件会触发在子元素上。我们在[命令日志](/guides/core-concepts/test-runner#Command-Log)中标注这个

### 滚动

在与元素交互之前，我们 _总是_ 将它滚动到视野中(包括它的任何父容器)。即使元素在不滚动的情况下是可见的，我们也会执行滚动算法，以便在每次运行命令时重现相同的行为。

<Alert type="info">

这个滚动逻辑只适用于[上面提到的可操作的命令](#Actionability).当使用[cy.get()](/api/commands/get)或者[.find()](/api/commands/find)这样的DOM操作命令时，我们不会将元素滚动到视野中。

</Alert>

默认情况下，滚动算法的工作原理是将发出命令的元素的顶部最左的点滚动到可滚动容器的顶部最左的可滚动点。

在滚动元素之后，如果我们确定它仍然被覆盖，我们将继续滚动和“轻推”页面，直到它变得可见. 这种情况最常发生在`position: fixed`或`position: sticky`导航元素固定在页面顶部时.

我们的算法 _应该_ 总是能够滚动到元素没有被覆盖。

要改变视图中滚动元素的位置，你可以使用[`scrollBehavior`](/guides/references/configuration#Actionability)配置选项. 如果元素在对齐到视口顶部时被覆盖，或者如果您只是希望元素在滚动操作命令时居中，那么这将非常有用. 可接受的选项是`center`、`top`、`bottom`、`nearest`和`false`，`false`禁用滚动。

###  坐标

在我们确定元素可以被操作之后，Cypress将触发所有适当的事件和相应的默认操作.通常这些事件的坐标是在元素的中心触发，但是大多数命令都允许您更改触发位置.

```js
cy.get('button').click({ position: 'topLeft' })
```

当点击[命令日志](/guides/core-concepts/test-runner#Command-Log)中的命令时，我们触发事件的坐标通常可用。

<DocsImage src="/img/guides/coords.png" alt="Event coordinates" ></DocsImage>

此外，我们将显示一个红色的`点击框`——这是一个表示事件坐标的圆点。

<DocsImage src="/img/guides/hitbox.png" alt="Hitbox" ></DocsImage>

## 调试

当Cypress认为元素不可操作时，调试问题可能会很困难.

尽管您应该会看到一个很好的错误消息，但没有什么比亲自查看DOM来理解原因更棒了。

当你使用[命令日志](/guides/core-concepts/test-runner#Command-Log)，把鼠标悬停在一个命令上时，你会注意到我们总是将对应的元素滚动到视野中。请注意，这里的算法与我们上面描述的 _不一样_

事实上，只有在使用上述算法运行操作命令时，我们才会将元素滚动到视野中. 我们在使用常规的DOM命令(如[`cy.get()`](/api/commands/get) 或 [`.find()`](/api/commands/find))时，_不会_ 将元素滚动到视野中。.

当鼠标悬停在快照上时，我们将元素滚动到视野中的原因是帮助您查看相应的命令找到了哪个元素. 它是一个纯粹的视觉特性，并不一定反映您的页面在命令运行时的样子.

换句话说，当你查看之前的快照时，你无法得到Cypress“看到”的正确的视觉表现.

“看到”和调试为什么Cypress认为一个元素是不可见的唯一方法是使用`debugger`语句.

我们建议在操作之前直接放置`debugger`或使用[`.debug()`](/api/commands/debug) 命令.

确保你的开发工具是打开状态，你可以非常接近“看到”Cypress正在执行的计算。

你也可以[绑定事件](/api/events/catalog-of-events)， Cypress在处理你的元素时触发它. 使用带有这些事件的debugger将使您对Cypress如何工作有一个更低层次的了解。

```js
// 在动作命令之前在调试器前停止
cy.get('button').debug().click()
```

## 强制

虽然上面的检查在寻找可能阻止用户与元素交互的情况时非常有用——但有时它们会碍事!

有时候，尝试“像用户一样行事”让机器人执行用户与元素交互的精确步骤是不值得的。

假设您有一个嵌套的导航结构，用户必须将鼠标悬停在上面，并以非常特定的模式移动鼠标才能到达所需的链接。

当您进行测试时，是否值得尝试完整复制 ?

也许不是! 对于这些情况，我们给你一个逃生出口，绕过上面所有的检查，强制事件触发!

您可以将`{force: true}`传递给大多数动作命令。

```js
// 强制点击并触发所有后续事件，即使该元素不被认为是“可操作的”
cy.get('button').click({ force: true })
```

<Alert type="info">

<strong class="alert-header">有什么不同?</strong>

当你强迫某件事发生时，我们会:

- 继续执行所有默认动作
- 强制在元素上触发事件

我们不会执行这些:

- 将元素滚动到视野中
- 确保是可见的
- 确保它没有被禁用
- 确保它没有被分离
- 确保它不是只读的
- 确保它不在动画中
- 确保它没有被覆盖
- 向后代发射事件

</Alert>

总之，`{ force: true }`'会跳过检查，并且总是在所需的元素上触发事件。

<Alert type="warning">

<strong class="alert-header">强制`.select()`禁用选项</strong>

将`{force: true}`传递给[.select()](/api/commands/select)不会覆盖选择禁用的`<option>`或禁用的`<optgroup>`中的选项时的可操作性检查. 详见[此问题](https://github.com/cypress-io/cypress/issues/107).

</Alert>
