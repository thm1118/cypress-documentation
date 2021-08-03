---
title: 网络请求
---

<Alert type="info">

## <Icon name="graduation-cap"></Icon> 你将学习

- Cypress如何使用[`cy.intercept()`](/api/commands/intercept)来仿真后端
- 当我们模拟我们的网络请求时，我们做了什么权衡
- Cypress如何在命令日志中可视化网络管理
- 如何使用别名返回请求和等待他们
- 如何编写抗脆弱的声明性测试

</Alert>

<Alert type="info">

**注意:** 如果您正在寻找一个资源来进行HTTP请求，请查看[cy.request()](/api/commands/request)

</Alert>

## 测试策略

Cypress帮助您测试应用程序中HTTP请求的整个生命周期. Cypress为您提供了对带有请求信息的对象的访问，使您能够对其属性进行断言. 此外，您甚至可以仿真和模拟请求的响应。

**_常见的测试场景:_**

- 对请求的body进行断言
- 断言请求的url
- 对请求头进行断言
- 模拟一个响应的body
- 模拟响应的状态码
- 模拟响应头
- 延迟响应
- 等待响应的发生

在Cypress中，您可以选择是否模拟响应或允许它们实际访问您的后端服务. 您还可以在同一个测试中混合匹配，选择模拟某些请求，同时允许其他请求访问后端服务。

让我们来研究这两种策略，为什么你会使用其中一种而不是另一种，以及为什么你应该经常使用这两种策略.

### 使用服务端响应

没有被模拟的请求实际上会到达服务器. 通过不模拟响应，您正在编写真正的端到端测试. 这意味着您正在以与真实用户相同的方式驱动应用程序.

> 当没有模拟请求时，这保证了客户端和服务器之间的契约是正常工作的。

换句话说，您可以确信服务器正在以正确的结构将正确的数据发送给客户机以供使用. 围绕应用程序的关键路径进行端到端测试是个好主意. 这些通常包括用户登录、注册或其他关键路径，如计费.

**_你应该意识到，不要生硬地回答，真实也有缺点:_**

- 因为没有模拟响应，这意味着你的服务器必须实际发送真实的响应. 这可能会有问题，因为您可能必须在每次测试之前为数据库准备测试数据以生成状态. 例如，如果您正在测试分页，则必须在数据库中植入用于在应用程序中复制该特性的每个对象。
- 由于实际的响应会通过服务器的每一层(控制器、模型、视图等)，所以测试通常比仿真响应慢得多.

如果您正在编写一个传统的服务器端应用程序，其中大多数响应都是HTML，那么您可能会有很少的模拟响应. 然而，大多数提供JSON的现代应用程序都可以利用模拟技术。

<Alert type="success">

<strong class="alert-header">好处</strong>

- 更像在生产环境工作
- 围绕服务器端点进行测试
- 非常适合传统的服务器端HTML渲染

</Alert>

<Alert type="danger">

<strong class="alert-header">缺点</strong>

- 需要播种数据
- 慢得多
- 更难以测试边缘情况

</Alert>

<Alert type="info">

<strong class="alert-header">建议使用</strong>

- 尽量少使用
- 非常适合应用程序的关键路径
- 围绕功能的快乐路径进行一次测试是有帮助的

</Alert>

### 模拟响应

模拟响应使您能够控制响应的每个方面，包括响应的`body`,  `status`, `headers`，甚至是网络的“延迟”。 桩非常快，大多数响应将在20毫秒内返回.

> 模拟响应是控制返回给客户端的数据的一种很好的方法.

您不需要在服务器上做任何工作. 您的应用程序将不知道它的请求被模拟，因此不需要更改代码。

<Alert type="success">

<strong class="alert-header">好处</strong>

- 控制响应的`body`,  `status`, `headers`
- 是否可以强制响应花费更长的时间来模拟网络延迟
- 对服务器或客户端代码没有任何代码更改
- 快速，< 20ms响应时间

</Alert>

<Alert type="danger">

<strong class="alert-header">缺点</strong>

- 不能保证您的模拟响应与服务器发送的实际数据匹配
- 在一些服务器端点上没有测试覆盖
- 如果您使用的是传统的服务器端HTML呈现，则没有那么有用

</Alert>

<Alert type="info">

<strong class="alert-header">建议使用</strong>

- 用于绝大多数测试
- 混合和匹配，通常有一个真正的端到端测试，然后模拟其他的
- 对JSON api 是完美的

</Alert>

<Alert type="info">

##### <Icon name="graduation-cap"></Icon> 真实世界的例子

Cypress [Real World App (RWA)](https://github.com/cypress-io/cypress-realworld-app) 端到端测试主要依赖于服务器的响应，并且只 [在一些情况下](https://github.com/cypress-io/cypress-realworld-app/blob/07a6483dfe7ee44823380832b0b23a4dacd72504/cypress/tests/ui/notifications.spec.ts#L250-L264) 模拟网络响应，  来方便地创建边缘情况或难以创建的应用程序状态。

这种做法允许项目实现完全[代码覆盖](/guides/tooling/code-coverage)前端和后端应用程序,但是这也需要创建复杂的数据库播种或测试数据工厂的脚本,以生成适当的，符合应用程序的业务逻辑的测试数据。

查看[真实世界应用程序测试集](https://github.com/cypress-io/cypress-realworld-app/tree/develop/cypress/tests/ui) ，以看到Cypress网络处理实战。

</Alert>

## 桩

Cypress允许你模拟响应，并控制`body`, `status`, `headers`，甚至延迟。

[`cy.intercept()`](/api/commands/intercept)用于控制HTTP请求的行为. 您可以静态地定义正文、HTTP状态代码、标题和其他响应特征。

<Alert type="info">

有关模拟响应的更多信息和示例，请参阅[cy.intercept()](/api/commands/intercept)。

</Alert>

## 路由

```javascript
cy.intercept(
  {
    method: 'GET', // 路由所有GET请求
    url: '/users/*', // 匹配'/users/*'的URL 
  },
  [] // 强制响应: []
)
```

当你使用[`cy.intercept()`](/api/commands/intercept)定义一条路由时，Cypress会在命令日志的"Routes"下显示它。

<DocsImage src="/img/guides/server-routing-table.png" alt="Routing Table" ></DocsImage>

当一个新的测试运行时，Cypress将恢复默认行为并删除所有路由和桩. 有关API和选项的完整参考，请参阅[`cy.intercept()`](/api/commands/intercept)文档。.

## fixture夹具

fixture是位于测试中使用的文件中的一组固定数据. 目的是确保有一个众所周知的、固定的环境来运行测试，以便结果是可重复的. 可以通过调用[`cy.fixture()`](/api/commands/fixture)命令在测试中访问fixture.

使用Cypress，您可以模拟网络请求，并让它立即响应fixture数据。

在对模拟响应时，通常需要管理可能较大且复杂的JSON对象。Cypress允许您直接将fixture语法集成到响应中。

```javascript
// 我们将响应设置为activites.json夹具
cy.intercept('GET', '/activities/*', { fixture: 'activities.json' })
```

### 组织

Cypress自动构建出一个建议的文件夹结构，用于组织每个新项目的夹具. 当你添加项目到Cypress时，默认创建一个 `example.json` 文件.

```text
/cypress/fixtures/example.json
```

您的fixture可以在其他文件夹中进一步组织. 例如，你可以创建另一个名为`images`的文件夹并添加图像:

```text
/cypress/fixtures/images/cats.png
/cypress/fixtures/images/dogs.png
/cypress/fixtures/images/birds.png
```

要访问嵌套在`images`文件夹中的fixture，请在 [`cy.fixture()`](/api/commands/fixture)命令中包含该文件夹。

```javascript
cy.fixture('images/dogs.png') // 以 Base64 输出 dogs.png
```

## 等待

无论您是否选择模拟响应，Cypress允许您声明性地[`cy.wait()`](/api/commands/wait)请求及其响应.

<Alert type="info">

下面的部分使用了一个名为[Aliasing](/guides/core-concepts/variables-and-aliases)的概念. 如果你刚接触Cypress，你可能想先去看看。

</Alert>

下面是一个别名请求并随后等待它们的示例:

```javascript
cy.intercept('/activities/*', { fixture: 'activities' }).as('getActivities')
cy.intercept('/messages/*', { fixture: 'messages' }).as('getMessages')

// 访问仪表板，它应该发出匹配上面两条路由的请求
cy.visit('http://localhost:8888/dashboard')

// 传递一组路由别名，迫使Cypress等待
// 直到它看到每个匹配这些别名的请求的响应为止
cy.wait(['@getActivities', '@getMessages'])

// 在上面的wait命令解析之前，这些命令不会运行
cy.get('h1').should('contain', 'Dashboard')
```

如果您想检查别名路由的每个响应的响应数据，可以使用几个`cy.wait()`调用.

```javascript
cy.intercept({
  method: 'POST',
  url: '/myApi',
}).as('apiCheck')

cy.visit('/')
cy.wait('@apiCheck').then((interception) => {
  assert.isNotNull(interception.response.body, '1st API call has data')
})

cy.wait('@apiCheck').then((interception) => {
  assert.isNotNull(interception.response.body, '2nd API call has data')
})

cy.wait('@apiCheck').then((interception) => {
  assert.isNotNull(interception.response.body, '3rd API call has data')
})
```

在别名路由上等待有很大的好处:

1. 脆弱少，测试更稳定。
2. 失败消息更精确.
3. 您可以断言底层请求对象.

让我们调查一下每一个好处.

### 脆弱

声明式等待响应的一个好处是它减少了测试脆弱.您可以将[`cy.wait()`](/api/commands/wait)视为一个守卫，当您希望发出一个匹配特定路由别名的请求时，它将指示Cypress。 这可以防止下一个命令在响应返回之前运行，并且可以防止请求最初被延迟的情况。

**_自动完成的例子:_**

使下面这个例子如此强大的是，Cypress将自动等待匹配`getSearch` 别名的请求。 您可以测试产生结果的实际原因，而不是强迫Cypress测试成功请求的副作用(显示Book结果)。

```javascript
cy.intercept('/search*', [{ item: 'Book 1' }, { item: 'Book 2' }]).as(
  'getSearch'
)

// 我们的自动完成字段是节流的，这意味着它只在500ms后从最后一个键按下请求
cy.get('#autocomplete').type('Book')

// 等待请求+响应，从而将我们与节流请求隔离开来
cy.wait('@getSearch')

cy.get('#results').should('contain', 'Book 1').and('contain', 'Book 2')
```

<Alert type="info">

##### <Icon name="graduation-cap"></Icon> 真实世界的例子

Cypress [Real World App (RWA)](https://github.com/cypress-io/cypress-realworld-app)有各种测试，用于在一个大型用户旅程测试中测试自动完成字段，正确等待自动完成输入更改触发的请求. 看看这个例子:

- <Icon name="github"></Icon> [自动完成的测试代码](https://github.com/cypress-io/cypress-realworld-app/blob/07a6483dfe7ee44823380832b0b23a4dacd72504/cypress/tests/ui/new-transaction.spec.ts#L36-L50)
- <Icon name="video"></Icon> [自动完成的测试运行录像](https://dashboard.cypress.io/projects/7s5okt/runs/2352/test-results/3bf064fd-6959-441c-bf31-a9f276db0627/video) in Cypress Dashboard.

</Alert>

### 失败

在上面的示例中，我们在搜索结果的显示中添加了一个断言。

**_在我们的应用程序中，搜索结果与一些东西耦合在一起:_**

1. 我们的应用程序向正确的URL发出请求.
2. 我们的应用程序正确地处理响应.
3. 我们的应用程序将结果插入到DOM.

在这个例子中，有许多可能的失败来源. 在大多数测试工具中，如果我们的请求没有发出，我们通常只在尝试在DOM中查找结果并发现没有匹配元素时才会得到错误. 这是有问题的，因为不知道为什么结果没有显示出来. 我们的渲染代码有问题吗?我们是否修改或更改了元素上的属性，如`id` 或 `class` ?也许我们的服务器给我们发送了不同的Book item。

使用Cypress，通过添加[`cy.wait()`](/api/commands/wait)，您可以更容易地查明具体问题. 如果响应没有返回，您将收到这样的错误:

<!--
To reproduce the following screenshot:
it('test', () => {
  cy.intercept('/foo/bar').as('getSearch')
  cy.wait('@getSearch')
})
-->

<DocsImage src="/img/guides/clear-source-of-failure.png" alt="Wait Failure" ></DocsImage>

现在我们知道为什么测试失败了。它与DOM没有任何关系. 相反，我们可以看到要么是我们的请求没有发出，要么是请求发送到了错误的URL.

### 断言

在请求上使用[`cy.wait()`](/api/commands/wait)的另一个好处是它允许您访问实际的请求对象. 当您希望对该对象进行断言时，这是非常有用的。

在上面的例子中，我们可以断言请求对象，以验证它将数据作为URL中的查询字符串发送. 尽管我们模拟了响应，但仍然可以验证应用程序发送了正确的请求.

```javascript
// 任何访问"/search/*"端点的请求都会自动收到一个包含两个book对象的数组
cy.intercept('/search/*', [{ item: 'Book 1' }, { item: 'Book 2' }]).as(
  'getSearch'
)

cy.get('#autocomplete').type('Book')

// 这就产生了包含请求和响应字段的对象
cy.wait('@getSearch').its('request.url').should('include', '/search?query=Book')

cy.get('#results').should('contain', 'Book 1').and('contain', 'Book 2')
```

**_[`cy.wait()`](/api/commands/wait)产生的截取对象拥有进行断言所需的一切，包括:_**

- URL
- Method
- Status Code
- Request Body
- Request Headers
- Response Body
- Response Headers

**例子**

```javascript
// 监视对/users端点的POST请求
cy.intercept('POST', '/users').as('new-user')
// 然后通过操作web应用程序的用户界面触发网络调用
cy.wait('@new-user').should('have.property', 'response.statusCode', 201)

// 我们可以使用cy.get(<alias>)再次获取已完成的拦截对象，以运行更多断言。
cy.get('@new-user') //生成相同的拦截对象
  .its('request.body')
  .should(
    'deep.equal',
    JSON.stringify({
      id: '101',
      firstName: 'Joe',
      lastName: 'Black',
    })
  )

// 我们可以在一个“should”回调中放置多个断言
cy.get('@new-user').should(({ request, response }) => {
  expect(request.url).to.match(/\/users$/)
  expect(request.method).to.equal('POST')
  // 将断言消息添加为expect()的第二个参数是一个很好的实践
  expect(response.headers, 'response headers').to.include({
    'cache-control': 'no-cache',
    expires: '-1',
    'content-type': 'application/json; charset=utf-8',
    location: '<domain>/users/101',
  })
})
```

**提示:** 您可以通过将其记录到控制台来检查整个请求周期对象

```javascript
cy.wait('@new-user').then(console.log)
```

## 另请参阅

- [网络请求在厨房水槽的例子](https://github.com/cypress-io/cypress-example-kitchensink/blob/master/cypress/integration/examples/network_requests.spec.js)
- [了解如何使用`cy.request()`发出请求](/api/commands/request)
- [Real World App (RWA)](https://github.com/cypress-io/cypress-realworld-app) 测试集，查看Cypress网络处理实战.
- 阅读[cy.route和cy.route2的区别](https://glebbahmutov.com/blog/cy-route-vs-route2/) 博客
- 阅读博客文章[从Cypress测试断言网络调研](https://www.cypress.io/blog/2019/12/23/asserting-network-calls-from-cypress-tests/)
- 如果您需要在离线模式下测试应用程序，请读[在离线网络模式下测试应用程序](https://www.cypress.io/blog/2020/11/12/testing-application-in-offline-network-mode/)
