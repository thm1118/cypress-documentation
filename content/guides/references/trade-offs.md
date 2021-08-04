---
title: 取舍
containerClass: faq
---

Cypress用自己独特的架构自动化了浏览器. 虽然这样做可以让你有能力做你在其他地方找不到的事情，但也有一些具体的权衡. 没有免费的午餐!

在本指南中，我们将列出做了哪些取舍，特别是如何围绕它们工作。

虽然乍一看，这似乎是Cypress严格限制 - 我们认为你很快就会意识到，许多这些界限实际上是好的. 从某种意义上说，它们可以防止编写糟糕的、缓慢的或不可靠的测试.

#### 永久取舍:

- Cypress不是通用的[自动化工具](#Automation-restrictions).
- Cypress命令[在浏览器内](#Inside-the-browser)运行.
- 永远不会支持[多浏览器标签页](#Multiple-tabs).
- 您不能使用Cypress [同时驱动两个浏览器](#Multiple-browsers-open-at-the-same-time).
- 每个测试绑定到一个[单一源](#Same-origin).

#### 临时取舍:

我们有[打开的问题](https://github.com/cypress-io/cypress/issues)，在那里你可以找到Cypress最终将解决的事情的完整列表，我们想强调一些更重要的临时限制，Cypress最终将解决. [我们欢迎 PRs ;-)](https://on.cypress.io/contributing)

其中许多问题目前正在研究或正在我们的[路线图](/guides/references/roadmap)中。

- [缺少`cy.hover()`命令的解决方案.](/api/commands/hover)
- [`cy.tab()` 命令.](https://github.com/cypress-io/cypress/issues/299)
- [不支持任何原生或移动事件.](https://github.com/cypress-io/cypress/issues/311#issuecomment-339824191)
- [测试文件上传是特定于应用程序的。](https://github.com/cypress-io/cypress/issues/170#issuecomment-340012621)
- [Iframe支持有些有限，但确实有效。](https://github.com/cypress-io/cypress/issues/136)

## 永久的取舍

### 自动化限制

Cyperss是一个专门的工具，它在一件事上做得很好: 对正在开发中的web应用程序进行端到端测试. 你不应该使用Cypress来做它不适合的事情，比如:

- 索引网页
- 爬取链接
- 性能测试
- 为第三方站点编写脚本

有其他优秀的工具可以用于完成上面列出的每一项任务。

Cypress的最大优点是可以在构建应用程序时用作测试工具. 它是为开发人员和QA工程师而构建的，而不是手工测试人员或探索性测试.

### 在浏览器内

以防你之前错过了- Cypress测试是在浏览器中运行! 这意味着我们能做别人做不到的事情. 没有对象序列化或JSON连接协议. 您可以实际地、本机地访问待测试应用程序中的所有内容. Cypress不可能“错过”元素，它总是知道你的应用程序何时触发任何类型的事件.

但这也意味着测试代码是在浏览器中执行的。 不是在在Node中执行测试代码, 或其他任意服务端. 我们永远支持的唯一语言就是网络语言: JavaScript.

这种取舍意味着与后端通信有点困难 - 比如服务器或数据库. 您将无法直接连接或导入这些服务器端库或模块. 尽管你可以在`requrire`可以在浏览器中使用的`node_modules`. 此外，您还可以使用Node通过[我们的Plugins API](/api/plugins/writing-a-plugin) 或 [cy.task()](/api/commands/task) 直接导入或与后端脚本对话。.

要与数据库或服务器对话，需要使用[`cy.exec()`](/api/commands/exec), [`cy.task()`](/api/commands/task), 或 [`cy.request()`](/api/commands/request)命令。 这意味着您需要公开一种方法来造数和设置数据库. 这确实不是那么困难，但是它可能比用后端语言编写的其他测试工具要花费更多的精力。

这里的取舍是，在浏览器中做所有的事情(基本上所有的测试)在Cypress中是一个更好的体验. 但是在浏览器之外做一些事情可能需要一些额外的工作.

在未来，我们**确实**计划为其他语言发布后端适配器。

### 多标签页

因为Cypress是在浏览器中运行的，所以它永远不会支持多标签. 我们确实可以使用浏览器自动化api来切换选项卡，但我们没有理由公开它们.

大多数情况下，当用户点击一个`<a>`打开一个新标签时，需要这个使用场景. 然后，用户希望切换到该标签页，以验证内容已加载。 但是，你不需要这样做. 事实上，我们有[教你如何在没有多标签页的情况下测试它的配方](/examples/examples/recipes#Testing-the-DOM).

为了更进一步 - 我们不相信有任何测试浏览器原生行为的使用场景. 你应该问自己为什么你正在测试点击一个`<a href="/foo" target="_blank">`打开一个新标签页.您已经知道这是浏览器的设计目的，并且您已经知道它是由`target="_blank"`属性触发的.

既然是这种情况，那么就测试触发浏览器执行此行为的东西 - 而不是测试行为本身.

```js
cy.get('a[href="/foo"]').should('have.attr', 'target', '_blank')
```

这个原则适用于Cypress的一切。 不要测试不需要的测试. 它是缓慢的，脆弱的，零价值的. 只测试导致您所关心的行为的底层事物.

### 同时打开多个浏览器

就像多标签页一样- Cypress不支持同时控制超过一个浏览器。

但是，可以将Cypress与另一个后端进程同步 - 无论是Selenium还是Puppeteer来驱动第二个打开的浏览器.事实上，我们已经看到这种方法很好地结合在一起!

尽管如此，除了在最不寻常和罕见的情况下，您仍然可以在不同时打开多个浏览器的情况下测试大多数应用程序的行为.

你可能会这样问这个功能:

> 我想测试一个聊天应用程序。我可以使用Cypress同时运行多个浏览器吗?

不管你是在测试一个聊天应用程序还是其他什么——你真正想要的是测试协作. 但是，**您不需要重新创建整个环境来测试100%覆盖率的协作**.

这样做可以更快、更准确、更可扩展.

虽然超出了本文的范围，但您可以使用以下原则测试聊天应用程序. 每一个都将逐步引入更多的协作:

#### 1. 只使用浏览器:

```text
    ↓
← browser →
    ↑
```

避免服务端调用，手动调用JavaScript回调，从而模拟“通知进来”或“用户离开聊天”时在浏览器中发生的情况。

您可以[模拟](/api/commands/stub)一切，并模拟每个单独的场景，聊天消息、离线消息、连接、重新连接、断开连接、群组聊天等. 浏览器内部发生的一切都可以进行全面测试. 离开浏览器的请求也可能被模拟，您可以断言请求body是否正确.

#### 2. 模拟另一个连接:

```text
server → browser
            ↓
server ← browser
  ↓
(其他连接的模拟)
  ↓
server → browser
```

使用您的服务器从浏览器接收消息，并通过作为该参与者发送消息来模拟“其他参与者”。 这当然是特定于应用程序的，但一般情况下，您可以将记录插入到数据库中，或者执行服务器需要执行的任何操作，就好像需要将客户机的消息发送回浏览器一样。

通常情况下，这种模式使您可以避免建立二次WebSocket连接，但仍然满足双向浏览器和服务器的约定。 这意味着您也可以在不实际处理实际连接的情况下测试边缘情况(断开连接等)。

#### 3: 引入另一个连接:

```text
server → browser
            ↓
server ← browser
  ↓
server → other connection
            ↓
server ← other connection
  ↓
server → browser
```

要做到这一点 - 你需要一个浏览器之外的后台进程来建立底层的WebSocket连接，然后你就可以与之进行通信和控制。

您可以通过许多方式来实现这一点，下面是一个使用HTTP服务器作为客户机并公开REST接口的示例，该接口使我们能够控制它。

```js
// Cypress tests

// 告诉8081的HTTP服务器连接到8080
cy.request('http://localhost:8081/connect?url=http://localhost:8080')

// 告诉8081的HTTP服务器发送一条消息
cy.request('http://localhost:8081/message?m=hello')

//告诉8081的HTTP服务器断开连接
cy.request('http://localhost:8081/disconnect')
```

HTTP服务器代码是这样的…

```js
const client = require('socket.io:client')
const express = require('express')

const app = express()

let socket

app.get('/connect', (req, res) => {
  const url = req.query.url

  socket = client(url)

  socket.on('connect', () => {
    res.sendStatus(200)
  })
})

app.get('/message', (req, res) => {
  const msg = req.query.m

  socket.send(msg, () => {
    res.sendStatus(200)
  })
})

app.get('/disconnect', (req, res) => {
  socket.on('disconnect', () => {
    res.sendStatus(200)
  })

  socket.disconnect()
})

app.listen(8081, () => {})
```

这避免了需要打开第二个浏览器，但仍然提供了一个端到端测试，它提供了两个客户机可以相互通信的100%的信心。

### 同源

每个测试被限制仅访问被确定为同源规则的域。

同源是什么?如果两个url的协议、端口(如果指定)和主机相同，则两个url具有相同的来源. Cypress通过将[`document.domain`](https://developer.mozilla.org/en-US/docs/Web/API/Document/domain)属性注入访问的`text/html`页面，自动处理相同超级域的主机, 因此，相同超域的主机被认为是正常的.

给定下面的url，与`https://www.cypress.io`相比，它们都是同源的。.

- `https://cypress.io`
- `https://docs.cypress.io`
- `https://example.cypress.io/commands/querying`

然而，下面的url与`https://www.cypress.io`的来源不同。.

- `http://www.cypress.io` (Different protocol)
- `https://docs.cypress.io:81` (Different port)
- `https://www.auth0.com/` (Different host of different superdomain)

如果端口不同，`http://localhost` 的url也不同. 例如，`http://localhost:3000`URL被认为是与`http://localhost:8080` URL不同的来源。

这些规则是:

- <Icon name="exclamation-triangle" color="red"></Icon> 在同一个测试中**不能**[visit](/api/commands/visit)两个不同来源的域.
- <Icon name="check-circle" color="green"></Icon> 在不同的测试中，您**能够**[visit](/api/commands/visit)两个或多个不同来源的域.

```javascript
it('navigates', () => {
  cy.visit('https://www.cypress.io')
  cy.visit('https://docs.cypress.io') // 正常
})
```

```javascript
it('navigates', () => {
  cy.visit('https://apple.com')
  cy.visit('https://google.com') // 报错
})
```

```javascript
it('navigates', () => {
  cy.visit('https://apple.com')
})

// 在另一个测试中访问不同的来源
it('navigates to new origin', () => {
  cy.visit('https://google.com') // 正常
})
```

存在这个限制是因为Cypress在运行时在每个特定测试下切换域。

#### 其他解决方法

还有其他方法可以测试两个超域之间的相互作用. 因为浏览器有一个名为“同源策略”的天然安全屏障，这意味着像`localStorage`, `cookies`, `service workers`和许多其他api这样的状态无论如何都不会在它们之间共享。

所以你在一个网站上做的事情不会直接影响到另一个网站。

作为最佳实践，您不应访问或与不在您控制下的第三方服务进行交互. 然而，也有例外! 如果您的组织使用单点登录(SSO)或OAuth，那么您可能需要使用超级域以外的第三方服务。

我们已经专门编写了一些其他的指南来处理这种情况。

- [最佳实践:访问外部站点](/guides/references/best-practices#Visiting-external-sites)
- [Web安全:常见的解决方案](/guides/guides/web-security#Common-Workarounds)
- [配方:登录-单点登录](/examples/examples/recipes#Logging-In)
