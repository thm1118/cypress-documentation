---
title: 测试运行器
---

<Alert type="info">

## <Icon name="graduation-cap"></Icon>你将学习

- Cypress测试运行器可视部分的名称和用途
- 如何通过选择器Playground来定位页面元素

</Alert>

## 概述

Cypress在一个独特的交互式运行器中运行测试，该运行器允许您在执行命令时查看命令，同时还可以查看正在测试的应用程序。

<DocsImage src="/img/guides/gui-diagram.png" alt="Cypress Test Runner"></DocsImage>

## 命令日志

测试运行器的左边是测试套件的可视化表示. 每个测试块都被正确嵌套，当单击每个测试时，显示在测试块中执行的每个Cypress命令和断言，
以及在相关的`before`， `beforeEach`， `afterEach`和`after`钩子中执行的所有命令或断言。

<DocsImage src="/img/guides/command-log.png" alt="Cypress Test Runner" width-600 ></DocsImage>

### 在你的IDE中打开文件

在命令日志中有一些地方显示代码所在文件的链接.点击此链接将在您的[首选文件打开器](/guides/tooling/IDE-integration#File-Opener-Preference) 中打开文件.

<DocsImage src="/img/guides/open-file-in-IDE.gif" alt="Open file your IDE" ></DocsImage>

### 在命令上悬停鼠标

当鼠标悬停在每个命令和断言上时，会将Application Under Test(右侧)恢复到执行该命令时的状态。
这允许您在测试时“时间旅行”到应用程序以前的状态。

<Alert type="info">

默认情况下，Cypress为时间旅行保留50个测试值的快照和命令数据。
如果你在浏览器中看到极高的内存消耗，你可能想要降低[配置](/guides/references/configuration#Global) 中的`numTestsKeptInMemory`.

</Alert>

### 点击命令

当单击每个命令、断言或错误时，会在开发工具控制台中显示额外的信息。当命令执行时，单击“将”待测试应用程序(右侧)“钉”到它以前的状态.

<DocsImage src="/img/guides/clicking-commands.png" alt="Click to console.log and to pin" ></DocsImage>

## 错误

当Cypress测试期间发生错误时，Cypress打印的一些信息。

1. **Error name**: 这是错误的类型(例如AssertionError, CypressError)
1. **Error message**: 这通常会告诉你哪里出了问题。它的长度可以变化。有些是短的，如示例中所示，而有些是长的，并可能确切地告诉您如何修复错误.
1. **Learn more:** 一些错误消息包含一个`Learn more`链接，将带您到相关的Cypress文档。
1. **Code frame file**: 这通常是堆栈跟踪的最上面一行，它显示了文件、行号和列号，在下面的代码框架中高亮显示。点击这个链接将在你的[首选的文件编辑器](https://on.cypress.io/IDE-integration#File-Opener-Preference) 中打开文件，并在支持它的编辑器中突出显示行和列.
1. **Code frame**: 这显示了发生故障的代码片段，并突出显示了相关的行和列。
1. **View stack trace**: 单击此按钮将切换堆栈跟踪的可见性。堆栈跟踪的长度不同。点击一个蓝色的文件路径将在您的 [首选文件编辑器](https://on.cypress.io/IDE-integration#File-Opener-Preference) 中打开文件.
1. **Print to console button**: 单击此以打印完整的错误到您的DevTools控制台。这通常允许您点击堆栈跟踪中的行，并在DevTools中打开文件。

<DocsImage src="/img/guides/command-failure-error.png" alt="example command failure error" ></DocsImage>

## 仪表盘

一些特定的命令，比如 [`cy.intercept()`](/api/commands/intercept),
[`cy.stub()`](/api/commands/stub), 以及 [`cy.spy()`](/api/commands/spy), 测试上方会显示一个额外的仪表板，以提供有关测试状态的更多信息。

###  路由

<DocsImage src="/img/guides/instrument-panel-routes.png" alt="Routes Instrument Panel" ></DocsImage>

### 桩

<DocsImage src="/img/guides/instrument-panel-stubs.png" alt="Stubs Instrument Panel" ></DocsImage>

### 间谍

<DocsImage src="/img/guides/instrument-panel-spies.png" alt="Spies Instrument Panel" ></DocsImage>

## 被测试应用程序

测试运行器的右侧，是被测试应用程序(AUT):使用[`cy.visit()`](/api/commands/visit) 导航到的应用程序，或从所访问的应用程序发出的任何后续路由调用.

在下面的例子中，我们在测试文件中编写了以下代码:

```javascript
cy.visit('https://example.cypress.io')

cy.title().should('include', 'Kitchen Sink')
```

在下面相应的应用预览中，你可以看到`https://example.cypress.io`显示在右侧。应用程序不仅是可见的，而且是完全可交互的。
您可以打开开发人员工具来检查元素，就像在普通应用程序中那样。DOM完全可以用于调试。

<DocsImage src="/img/guides/application-under-test.png" alt="Application Under Test" ></DocsImage>

AUT还以测试中指定的大小和方向显示。你可以使用[`cy.viewport()`](/api/commands/viewport) 命令或
[Cypress configuration](/guides/references/configuration#Viewport)命令更改大小或方向。 
如果AUT不适合当前浏览器窗口，则适当缩放以适应窗口。

AUT的当前大小和比例显示在窗口的右上角。

下图显示了我们的应用程序显示的宽度为`1000px`，高度为`660px`，缩放到`100%`。

<DocsImage src="/img/guides/viewport-scaling.png" alt="Viewport Scaling" ></DocsImage>

_注意:右边也可以用来显示测试文件中阻止测试运行的语法错误._

<DocsImage src="/img/guides/errors.png" alt="Errors" ></DocsImage>

_注意:在内部，AUT在是在iframe中渲染的。这有时会导致意想不到的行为,[此处解释](/api/commands/window#Cypress-uses-2-different-windows)_

## 选择器Playground

选择器游乐场是一个交互式功能，可以帮助您:

- 为一个元素确定唯一的选择器.
- 查看哪些元素匹配给定的选择器.
- 看看什么元素匹配一个文本字符串.

<DocsVideo src="/img/snippets/selector-playground.mp4"></DocsVideo>

### 唯一性

Cypress将通过运行一系列选择器策略自动计算一个**唯一选择器**来使用目标元素。

默认情况下，Cypress将会支持:

1. `data-cy`
2. `data-test`
3. `data-testid`
4. `id`
5. `class`
6. `tag`
7. `attributes`
8. `nth-child`

<Alert type="info">

<strong class="alert-header">这是可配置的</strong>

Cypress允许您控制如何确定选择器.

使用[Cypress.SelectorPlayground](/api/cypress-api/selector-playground-api) API来控制你想要返回的选择器。

</Alert>

### 最佳实践

您可能会发现自己很难写出好的选择器，因为:

- 应用程序使用动态ID和类名
- 只要有CSS或内容更改，测试就会中断

为了帮助解决这些常见的问题，选择器Playground在决定唯一选择器时自动选择某些`data-*`属性.

请阅读我们的[最佳实践指南](/guides/references/best-practices#Selecting-Elements)，以帮助您定位元素，防止测试被CSS或JS的变化破坏。

### 找到选择器

要打开选择器playground，点击运行器的顶部URL旁边的<Icon name="crosshairs"></Icon>按钮。将鼠标悬停在应用程序中的元素上，可以在工具提示中预览该元素的唯一选择器。

<DocsImage src="/img/guides/test-runner/open-selector-playground.gif" alt="打开选择器playground，并将鼠标悬停在元素上" ></DocsImage>

单击元素，它的选择器将出现在顶部。从那里，你可以复制它到剪贴板(<Icon name="copy"></Icon>)或打印到控制台( <Icon name="terminal"></Icon> ).

<DocsImage src="/img/guides/test-runner/copy-selector-in-selector-playground.gif" alt="单击元素，将其选择器复制到剪贴板，并将其打印到控制台" ></DocsImage>

### 运行实验

顶部显示选择器的框也是一个文本输入.

#### 编辑选择器

当你编辑选择器，它会显示你有多少元素匹配，并突出显示那些元素在你的应用程序。

<DocsImage src="/img/guides/test-runner/typing-a-selector-to-find-in-playground.gif" alt="键入一个选择器以查看它匹配的元素" ></DocsImage>

#### 切换到contains

您还可以试验[`cy.contains()`](/api/commands/contains)会生成给定的文本字符串。点击`cy.get`并切换到`cy.contains`。

输入文本以查看匹配的元素。注意[`cy.contains()`](/api/commands/contains) 只生成与文本匹配的第一个元素，即使页面上有多个元素包含文本。

<DocsImage src="/img/guides/test-runner/cy-contains-in-selector-playground.gif" alt="Experiment with cy.contains" ></DocsImage>

#### 禁用高亮

如果你想在选择器 Playground打开时与你的应用程序交互，元素高亮可能会碍事。关闭高亮显示可以让你更轻松地与应用程序交互。

<DocsImage src="/img/guides/test-runner/turn-off-highlight-in-selector-playground.gif" alt="Turn off highlighting" ></DocsImage>

## 键盘快捷键

有键盘快捷键可以从测试运行器中快速执行常见操作。

| Key | Action                        |
| --- | ----------------------------- |
| `r` | Rerun tests                   |
| `s` | Stop tests                    |
| `f` | Bring focus to 'specs' window |

<DocsImage src="/img/guides/test-runner/keyboard-shortcuts.png" alt="Tooltips show keyboard shortcuts" ></DocsImage>

## 历史

| 版本                                        | 变更                                 |
| ------------------------------------------- | --------------------------------------- |
| [3.5.0](/guides/references/changelog#3-5-0) | Added keyboard shortcuts to Test Runner |
| [1.3.0](/guides/references/changelog#1-3-0) | Added Selector Playground               |
