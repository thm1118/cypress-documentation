---
title: 调试
---

<Alert type="info">

## <Icon name="graduation-cap"></Icon> 你将学习

- Cypress如何与您的代码在相同的事件循环中运行，使调试要求更低，更容易理解
- Cypress如何拥抱标准的开发工具
- 如何以及何时使用`debugger` 和简写[`.debug()`](/api/commands/debug) 命令

</Alert>

## 使用 `debugger`

您的Cypress测试代码在与应用程序相同的运行循环中运行. 这意味着你可以访问在页面上运行的代码，以及浏览器提供给你的东西，比如`document`, `window`, 和 `debugger`。

### 就像你经常做的那样调试

基于这些语句，您可能会忍不住在测试中抛出一个`debugger`，就像这样:

```js
it('让我像个恶魔一样调试', () => {
  cy.visit('/my/page/path')

  cy.get('.selector-in-question')

  debugger // 不起作用
})
```

这可能不完全像您所期望的那样工作. 你们可能还记得[Cypress简介](/guides/core-concepts/introduction-to-cypress), `cy` 命令将一个稍后要执行的动作编入队列。你能看到上面的测试在这个视角下的作用吗?

[`cy.visit()`](/api/commands/visit) 和 [`cy.get()`](/api/commands/get) 都会立即返回，并将它们的工作排队待稍后完成, 并且 `debugger` 将在任何命令实际运行之前执行.

让我们使用[`.then()`](/api/commands/then) 在执行过程中进入Cypress命令，并在适当的时候添加一个`debugger`:

```js
it('让我在命令执行后进行调试', () => {
  cy.visit('/my/page/path')

  cy.get('.selector-in-question').then(($selectedElement) => {
    // 调试器在cy.visit之后被命中
    // 并且cy.get命令已经完成
    debugger
  })
})
```

现在我们开始做事了!首先通过[`cy.visit()`](/api/commands/visit) 和 [`cy.get()`](/api/commands/get)链(附带它的[`.then()`](/api/commands/then))被排队等待Cypress执行.  其次`it`代码块退出, Cypress正式开始了它的工作:

1. 页面被访问，Cypress等待它加载.
2. 查询元素，如果没有立即找到，Cypress会自动等待并重试几分钟。
3. 将执行传递给[`.then()`](/api/commands/then) 的函数，并将找到的元素交给它.
4. 在[`.then()`](/api/commands/then)函数的上下文中，将调用`debugger`，停止浏览器并将焦点转移到开发人员工具。
5. 现在你在里面了! 检查你的应用程序的状态，就像你通常会在你的应用程序代码中删除`debugger`一样.

### 使用 [`.debug()`](/api/commands/debug)

Cypress还提供了一个调试命令的快捷方式, [`.debug()`](/api/commands/debug). 让我们使用这个帮助方法重写上面的测试:

```js
it('让我像个恶魔一样调试', () => {
  cy.visit('/my/page/path')

  cy.get('.selector-in-question').debug()
})
```

由[`cy.get()`](/api/commands/get) 生成的当前目标将在开发人员工具中作为变量`subject`公开，以便您可以在控制台与它进行交互。

<DocsImage src="/img/guides/debugging-subject.png" alt="Debugging Subject" ></DocsImage>

使用[`.debug()`](/api/commands/debug)可以在测试期间快速检查应用程序的任何(或许多)部分。 您可以将它附加到任何Cypress命令链上，以查看此时系统的状态.

## 逐步执行测试命令

您可以使用[`.pause()`](/api/commands/pause)命令,通过命令运行test命令.

```javascript
it('adds items', () => {
  cy.pause()
  cy.get('.new-todo')
  // 更多的命令
})
```

这允许您在每个命令之后检查web应用程序、DOM、网络和任何存储，以确保一切按照预期进行.

## 使用开发者工具

尽管Cypress已经构建了[一个优秀的测试运行器](/guides/core-concepts/test-runner) 来帮助您理解应用程序和测试中发生的事情，但没有什么能取代浏览器团队在其内置开发工具上所做的所有令人惊讶的工作. 我们再一次看到，Cypress顺应了现代生态系统的潮流，选择在任何可能的地方利用这些工具。

<Alert type="info">

### <Icon name="video"></Icon> 看它的作用!

你可以看到一个从Cypress调试一些应用程序代码的演练[在我们的React教程系列的这个部分](https://vimeo.com/242961930#t=264s).

</Alert>

### 获取命令的控制台日志

所有Cypress的命令，当点击[命令日志](/guides/core-concepts/test-runner#Command-Log)，打印关于命令的额外信息，它的目标元素，和它产生的结果. 尝试打开开发人员工具在命令日志中单击! 你可以在这里找到一些有用的信息.

#### 当单击.type()`命令时，开发人员工具控制台输出如下内容:

<DocsImage src="/img/api/type/console-log-of-typing-with-entire-key-events-table-for-each-character.png" alt="Console Log type" ></DocsImage>

## 错误

有时测试失败。有时我们希望他们失败，这样我们就知道当他们通过时，他们在测试正确的东西。 但有时，测试在无意中失败了，我们需要找出原因。Cypress提供了一些工具，以帮助使这一过程尽可能容易.

### 剖析一个错误

让我们看看错误的剖析，以及如何通过失败的测试在Cypress中显示它。

```js
it('在用户页面上重新路由', () => {
  cy.contains('Users').click()
  cy.url().should('include', 'users')
})
```

`<li>Users</li>`元素的中心在我们测试的应用程序中被隐藏，所以上面的测试将失败. 在Cypress中，失败将显示一个错误，其中包括以下信息片段:

1. **Error name**: 这是错误的类型(例如AssertionError, CypressError)
1. **Error message**: 这通常会告诉你哪里出了问题. 它的长度可以变化.有些是短的，如示例中所示，而有些是长的，并可能确切地告诉您如何修复错误.
1. **Learn more:** 一些错误消息包含一个“Learn more”链接，将带您到相关的Cypress文档.
1. **Code frame file**: 这通常是堆栈跟踪的最上面一行，它显示了文件、行号和列号，在下面的代码框架中高亮显示. 点击此链接将在您的[首选文件打开器](https://on.cypress.io/IDE-integration#File-Opener-Preference) 中打开代码文件，并在支持它的编辑器中突出显示行和列.
1. **Code frame**: 这显示了发生故障的代码片段，并突出显示了相关的行和列.
1. **View stack trace**: 单击此按钮将切换堆栈跟踪的可见性。堆栈跟踪的长度不同. 点击一个蓝色的文件路径将在您的[首选文件打开器](https://on.cypress.io/IDE-integration#File-Opener-Preference) 中打开文件.
1. **Print to console button**: 单击此以打印完整的错误到您的DevTools控制台. 这通常允许您点击堆栈跟踪中的行，并在DevTools中打开文件.

<DocsImage src="/img/guides/command-failure-error.png" alt="example command failure error" ></DocsImage>

### Source maps

Cypress利用Source maps来增强错误体验. 栈跟踪被转换，从而显示您的源代码文件，而不是由浏览器加载的生成文件. 这也支持显示代码帧。如果没有内联Source maps，您将看不到代码帧.

默认情况下，Cypress将在您的spec文件中包含一个内联Source maps，因此您将最大限度地利用错误体验. 如果你[修改了预处理器](/api/plugins/preprocessors-api), 确保内联Source maps能够获得相同的体验. 比如，使用webpack和[webpack preprocessor](https://github.com/cypress-io/cypress/tree/master/npm/webpack-preprocessor) 时，设置[`devtool`选项](https://webpack.js.org/configuration/devtool/) 为 `inline-source-map`.

## 调试脆弱的测试

虽然Cypress是[抗脆弱的](/guides/overview/key-differences#Flake-resistant)，一些用户确实有脆弱的经验，特别是在CI和本地运行时. 在脆弱测试的情况下，我们经常看到，在进行下一个断言之前，围绕测试操作或网络请求没有足够的断言。

如果在本地运行时**网络请求或响应的速度**与在CI中运行时存在任何变化，那么其中一个可能会出现故障。

因此，我们建议在进行测试之前尽可能多地断言所需的步骤。 这也有助于以后在调试时隔离故障的确切位置。

当本地环境和CI环境之间存在差异时，也会发生脆弱. 可以使用以下方法对本地通过但在CI中失败的测试进行故障排除.

- 检查CI构建过程，确保应用程序没有发生任何可能导致测试失败的更改.
- 删除测试中对时间敏感的变量. 例如，在查找依赖于网络请求数据的DOM元素之前，确保网络请求已经完成. 你可以利用[别名](/guides/core-concepts/variables-and-aliases#Aliases) .

Cypress Dashboard还提供[分析](/guides/dashboard/analytics)，分析测试中的趋势，并有助于识别最常失败的测试. 这有助于缩小造成脆弱的趋势 -- 例如，在更改测试环境后看到增加的失败可能表明新环境存在问题.

欲知更多处理脆弱的建议，请阅读[我们的博客系列文章](https://cypress.io/blog/tag/flake/) 以及 [Cypress 大使](https://www.cypress.io/ambassadors/) Josh Justice写的[Cypress中的坏味道代码](https://codingitwrong.com/2020/10/09/identifying-code-smells-in-cypress.html) .

## 输出Cypress事件日志

Cypress发出多个事件，如下所示. [在浏览器中阅读更多关于日志事件的信息](/api/events/catalog-of-events#Logging-All-Events).

<DocsImage src="/img/api/catalog-of-events/console-log-events-debug.png" alt="console log events for debugging" ></DocsImage>

## 在测试外部运行Cypress命令

如果需要直接从Developer Tools控制台运行Cypress命令，可以使用内部命令`cy.now('command name', ...arguments)`. 例如，在正常的执行命令链之外运行`cy.task('database', 123)`:

```javascript
cy.now('task', 123).then(console.log)
// 运行 cy.task(123) 并打印解析值
```

<Alert type="warning">

`cy.now()`命令是一个内部命令，将来可能会更改.

</Alert>

## Cypress fiddle

在学习Cypress的同时，对一些HTML进行小测试可能是一个好主意. 我们已经为此编写了一个[@cypressfiddle](https://github.com/cypress-io/cypress-fiddle) 插件. 它可以快速装入任何给定的HTML并对其运行一些Cypress测试命令.

## Cypress故障排除

有时您会遇到错误或Cypress本身的意外行为。在这种情况下，我们建议查看我们的[故障排除指南](/guides/references/troubleshooting).

## 更多信息

通常，调试失败的Cypress测试意味着更好地理解您自己的应用程序如何工作，以及应用程序如何与测试命令竞争。 我们建议阅读这些博客文章，其中展示了常见的错误场景以及如何解决它们:

- [测试什么时候开始?](https://www.cypress.io/blog/2018/02/05/when-can-the-test-start/)
- [测试什么时候可以停止?](https://www.cypress.io/blog/2020/01/16/when-can-the-test-stop/)
- [测试什么时候可以点击?](https://www.cypress.io/blog/2019/01/22/when-can-the-test-click/)
- [测试什么时候可以退出?](https://www.cypress.io/blog/2020/06/25/when-can-the-test-log-out/)
- [不要获取太多的已分离元素](https://www.cypress.io/blog/2020/07/22/do-not-get-too-detached/)
