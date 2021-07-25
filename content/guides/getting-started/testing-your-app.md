---
title: 测试您的应用程序
---

<Alert type="info">

## <Icon name="graduation-cap"></Icon> 你会学到什么

- cypress与后端之间的关系
- 如何配置cypress以适合您的应用程序
- 与你程序的验证机制一起工作
- 有效利用测试数据

</Alert>

<!-- textlint-disable terminology -->

<DocsVideo src="https://youtube.com/embed/5XQOK0v_YRE"></DocsVideo>

<!-- textlint-enable -->

## <Icon name="terminal"></Icon> 第1步：启动服务器

假设你成功
[安装了测试运行器](/guides/getting-started/installing-cypress#Installing)
和
[打开测试运行器](/guides/getting-started/installing-cypress#Opening-Cypress)
, 你想要做的第一件事就是启动你的本地应用程序和开启服务。

它应该看起来像 **http://localhost:8080**.

<Alert type="warning">

<strong class="alert-header">反对的模式</strong>

不要尝试从cypress脚本中启动Web服务器。 请阅读
[最佳实践](/guides/references/best-practices#Web-Servers) .

</Alert>

<Alert type="info">

<strong class="alert-header">为什么要启动本地开发服务器？</strong>

你可能会想知道 - 为什么我不能只访问已经部署在生产环境的应用程序来进行测试？

虽然你当然可以测试已经部署的应用程序，但那不是使用cypress的**最佳策略**。

cypress是为优化你的每日开发而建造的。事实上，在开始使用cypress一段时间后，你可能会发现它甚至适用于你所有的开发任务。

最终你不仅可以同时 **测试和开发** , 还可以 **更快** 构建您的应用程序，因为测试是"免费的".

更重要的是- 由于cypress可以模拟 **网络请求** ，您可以在不需要构建web服务器的情况下，提供有效的JSON响应。

重要的一点是 - 为已经构建的应用程序编写测试案例，通常比一边开发程序一边写案例更困难。 

最后, 或许是最重要的原因，是因为在本地应用程序，你可以完全 **控制**它，而生产上的应用程序，你无法控制。

当它在开发中运行时，您可以:

- 更便捷
- 通过运行可执行脚本生成数据
- 禁用令自动化测试困难的安全功能
- 在服务器/数据库上重置状态

照这样说 - 你还是可以选择 **两种方式**.

我们的许多用户对本地的集成测试运行 _主要_ 的案例，但然后保留一组数量较少的**冒烟测试**案例运行在生产的应用程序上。

</Alert>

## <Icon name="globe"></Icon> 第2步：访问您的服务器

一旦您的服务器运行，就是时候访问它了。

让我们删除 `sample_spec.js` 这个在上一个教程中创建的文件，它不再需要。

```shell
rm cypress/integration/sample_spec.js
```

现在让我们创建自己的测试文件 `home_page_spec.js`.

```shell
touch cypress/integration/home_page_spec.js
```

创建该文件后，您应该在文件列表中看到它。

<DocsImage src="/img/guides/testing-your-app-home-page-spec.png" alt="List of files including home_page_spec.js"></DocsImage>

现在，您需要在测试文件中添加以下代码以访问您的服务器：

```js
describe('The Home Page', () => {
  it('successfully loads', () => {
    cy.visit('http://localhost:8080') // 更改URL以匹配你的开发服务器地址
  })
})
```

现在点击 `home_page_spec.js` 文件并看到cypress打开浏览器。

如果您忘记启动服务器，您将看到以下错误：

<!--
To reproduce the following screenshot:
it('successfully loads', () => {
  cy.visit('https://localhost:8080')
})
-->

<DocsImage src="/img/guides/testing-your-app-visit-fail.png" alt="Error in Test Runner showing cy.visit failed" ></DocsImage>

如果您已启动您的服务器，那么您应该会看到您的应用程序加载和在运行的。

## <Icon name="cogs"></Icon> 第3步：配置Cypress

如果您想得远一点，您将迅速意识到您将输入很多次这个URL, 因为每次测试都需要访问这个地址。 幸运地, Cypress 提供一个
[配置选项](/guides/references/configuration) . 让我们
现在使用它。

打开你的[配置文件](/guides/references/configuration)
(默认为在你项目路径下的`cypress.json` 文件) 它开始是空白的:

```json
{}
```

让我们添加`baseurl`选项.

```json
{
  "baseUrl": "http://localhost:8080"
}
```

这会自动带入到这些命令的**前缀url**： [`cy.visit()`](/api/commands/visit) 和
[`cy.request()`](/api/commands/request) .

<Alert type="info">

每当你修改配置文件后，cypress将自动重启并杀调其它打开的浏览器。这是正常的。

</Alert>

我们现在可以访问一个相对路径并省略主机名和端口。

```js
describe('The Home Page', () => {
  it('successfully loads', () => {
    cy.visit('/')
  })
})
```

很好！一切都应该是绿色的。

<Alert type="info">

<strong class="alert-header">配置选项</strong>

Cypress 有很多的配置选项，您可以用于自定义其
行为。比如像你的测试位置，默认超时时间，环境变量，使用何种报告等。

在[配置]中查看它们(/guides/references/configuration)!

</Alert>

## 测试策略

即将开始为您的应用程序编写案例, 只有 _你_
了解你的应用程序, 所以我们没有很多具体建议给你。

**测试什么，边界测试，执行什么回归测试等等，
完全取决于您，您的应用和您的团队.**

也就是说，现代Web测试有每个团队都会经历的一些困难，所以以下是常见情况的一些建议。

### 准备数据

取决于您的应用程序是如何构建的 - 它可能受到服务器的影响和控制。

现在典型的服务器是通过JSON与前端应用进行通信，但是你也可以运行传统的服务端呈现HTML Web应用程序。

通常，服务器负责发送反映某种类型的响应**状态** - 通常在数据库中。

传统上，使用selenium进行`E2E`测试， 在进行测前会做 **set up and tear down** 配置。

也许你需要生成一个用户，并关联相应记录。 您可能熟悉使用诸如fixture的东西。

为了测试各种页面状态 - 例如空视图或分页视图，你需要设置服务器状态，以便可以测试此状态。

**你使用cypress时通常有这三种方式
:**

- [`cy.exec()`](/api/commands/exec) - 运行系统命令
- [`cy.task()`](/api/commands/task) - 在node中运行命令通过
  [插件文件](/guides/references/configuration#Folders-Files)
- [`cy.request()`](/api/commands/request) - 进行HTTP请求

如果你在使用 `node.js` ，你可能会在执行`npm`任务前增加 `before` 或
`beforeEach` 钩子。

```js
describe('The Home Page', () => {
  beforeEach(() => {
    // 在每个测试之前重置和准备数据库
    cy.exec('npm run db:reset && npm run db:seed')
  })

  it('successfully loads', () => {
    cy.visit('/')
  })
})
```

除了执行一个系统命令，你可能需要更多的灵活性。

**例如，你可以将多个请求组合在一起以告诉你的服务器
您所需要的状态。**

```js
describe('The Home Page', () => {
  beforeEach(() => {
    // 在每个测试之前重置和准备数据库
    cy.exec('npm run db:reset && npm run db:seed')

    // 发送post请求
    cy.request('POST', '/test/seed/post', {
      title: 'First Post',
      authorId: 1,
      body: '...',
    })

    // 发送post请求，准备一个用户
    cy.request('POST', '/test/seed/user', { name: 'Jane' })
      .its('body')
      .as('currentUser')
  })

  it('successfully loads', () => {
    // 这个currentUser可以用于登录我们的系统
    

    cy.visit('/')
  })
})
```

虽然这种方法没有什么错误, 但它确实增加了很多复杂性。 您需要奋战在服务器和浏览器之间的状态- 并且你总是需要在测试前设置/销毁状态 (这很慢).

好消息是我们不是Selenium，也不是传统的E2E测试
工具。 这意味着我们不受同样的限制。

**在Cypress, 有几种其他方法可以提供
更好、更快的体验。**

### 模拟后端服务（挡板）

与服务器交互相反的一种有效的做法是
完全绕过它。

虽然常规地，你通过[`cy.visit()`](/api/commands/visit) 访问你的应用常规的HTML / JS / CSS
资源， - 但你可以模拟服务器的JSON返回.

这意味着，不需要重置或准备数据库, 你可以让服务器返回 **任何** 你想要的东西.
通过这种方式，我们不仅可以防止需要同步服务器和浏览器之间的状态
，我们还防止了从我们的测试中状态发生变化。
这意味着测试不会对其他测试的状态产生影响。

另一个好处是你可以 **构建您的应用程序**
而不需要后端服务器的存在. 你可以构建你期望的数据结构, 对边界情况进行测试。

虽然模拟后端服务很棒，但这意味着你无法保证这些
响应与服务器实际发送的内容匹配。但这是有办法解决的:

#### 提前生成挡板

你可以让服务器提前生成所有挡板。这意味着他们与服务器实际返回的内容一致。

#### 写一个没有使用挡板的E2E测试，然后设置挡板

另一种均衡的方法是整合两种策略。 你可以使用 **一个测试** 是进行真实 `e2e` 测试（不使用挡板）。
这会涉及到数据准备。

一旦它正常运行起来后，你可以设置挡板来测试其余的场景。使用真实数据测试绝大多数场景是没有好处的
。 我们建议绝大多数测试使用
挡板数据。它们会更更快，并且没那么复杂。

<Alert type="info">

<strong class="alert-header">指南：网络请求</strong>

请阅读我们的[网络请求指南](/guides/guides/network-requests) ，
来进行更彻底的分析和实现这一目标。

</Alert>

### 登录

其中一个（并且可以说是最艰难的障碍之一）需要克服的困难是登录你的系统。


必须登录，让测试变慢,但一个好的应用程序需要经过身份验证的用户才能使用！这里有一些建议。

#### 完全测试登录流程 -- 但只有一次!

把注册和登录流程进行覆盖性的测试是一个好主意
，这对所有用户来说都非常重要，你永远不想打破它。

我们建议您使用真实的用户，通过UI测试注册和登录：

这是一个例子 :

```js
describe('The Login Page', () => {
  beforeEach(() => {
    // 在每个测试之前重置和准备数据库
    cy.exec('npm run db:reset && npm run db:seed')

    // 准备一个用户数据
    // 假设它将返回一个随机密码
    cy.request('POST', '/test/seed/user', { username: 'jane.lane' })
      .its('body')
      .as('currentUser')
  })

  it('sets auth cookie when logging in via form submission', function () {
    
    const { username, password } = this.currentUser

    cy.visit('/login')

    cy.get('input[name=username]').type(username)

    // {enter} 后将提交表单
    cy.get('input[name=password]').type(`${password}{enter}`)

    // 重定向到 /dashboard
    cy.url().should('include', '/dashboard')

    // 验证cookie 
    cy.getCookie('your-session-cookie').should('exist')

    // UI 显示该用户已登录
    cy.get('h1').should('contain', 'jane.lane')
  })
})
```

您可能还希望测试您的登录UI：

- 无效的用户名/密码
- 用户名已被使用
- 密码复杂性要求
- 锁定/已删除帐户的案例

这些可能需要一个完整的E2E测试。

现在，一旦您完全测试了您的登录 - 您可能会思考:

> "...好，太棒了！让我们在每次测试之前重复此登录过程！"

<Alert type="danger">

<strong class="alert-header">不！请不要。</strong>

不要在每个测试使用 **你的UI** 去进行登录.

</Alert>

让我们分析为什么。

#### 绕过你的UI.

当你需要测试应用的某些 **具体特征**, 你 _应该_ 用你的UI
测试它。

但是当你测试系统的_其他_区域，并依赖之前的状态时: **不要通过你的UI设置此状态**.

这是一个更强大的例子：

想象一下你正在测试 **购物车**功能. 为了测试它，你需要往购物车增加商品。那么这些商品来自哪里？你需要使用UI登录系统并进入管理模块，新建商品，包括它的描述、种类、和图片？创建好之后，你需要把他们放到购物车里？

不，你不应该这么做。

<Alert type="warning">

<strong class="alert-header">反对的模式</strong>

不要使用您的UI建立状态！ 它非常慢、繁琐、和
不必要。

阅读关于[最佳实践](/guides/references/best-practices) here.

</Alert>

通过UI来 **登录** 是跟我们上面描述的场景一模一样。 登录是其他测试的先决条件
。

因为Cypress 不是 Selenium,我们可以通过捷径，不需要UI登录，那就是使用 [`cy.request()`](/api/commands/request).

因为 [`cy.request()`](/api/commands/request) 自动获取并设置
cookie, 我们可以通过它来设置服务器的状态，而不是使用UI，但它的结果跟我们通过浏览器操作是一样的！

让我们回到上面的例子，假设我们正在测试系统的其他部分。

```js
describe('The Dashboard Page', () => {
  beforeEach(() => {
    
    cy.exec('npm run db:reset && npm run db:seed')


    cy.request('POST', '/test/seed/user', { username: 'jane.lane' })
      .its('body')
      .as('currentUser')
  })

  it('logs in programmatically without using the UI', function () {
    
    const { username, password } = this.currentUser

    // 不通过UI方式登录到我们的系统
    cy.request('POST', '/login', {
      username,
      password,
    })

    // 现在我们已经登录了，可以做我们想做的测试
    cy.visit('/dashboard')


    cy.getCookie('your-session-cookie').should('exist')

    
    cy.get('h1').should('contain', 'jane.lane')
  })
})
```

你看得到差别吗？ 我们能够在不需要实际使用UI的情况下登录系统。这为我们节省了很多时间。

在系统需要设置状态的地方，使用以上的方法。记住，不要使用UI！

## 开始

好的，现在请开始测试您的应用程序！

您可能想要探索更多我们的指南：

- [教程视频](/examples/examples/tutorials) 观看教程
  视频
- [Cypress API](/api/table-of-contents) 要了解哪些命令可用于
  你工作
- [介绍 Cypress](/guides/core-concepts/introduction-to-cypress)
  解释 Cypress如何工作
- [命令行](/guides/guides/command-line) 通过`cypress run`运行所有测试 
- [持续集成](/guides/continuous-integration/introduction) 在CI上运行cypress
- [跨浏览器测试](/guides/guides/cross-browser-testing) 在CI上运行Firefox和Chrome的跨浏览器测试
- <Icon name="github"></Icon>
  [Cypress真实世界程序 (RWA)](https://github.com/cypress-io/cypress-realworld-app)
  真实的应用于实际项目的cypress实践、配置、策略演示。
