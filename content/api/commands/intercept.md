---
title: intercept
---

监视和模拟网络请求和响应。

<Alert type="info">

**提示**: 我们建议您先阅读[网络请求](/guides/guides/network-requests)指南.

</Alert>

<Alert type="bolt">

在Cypress 6.0.0中，`cy.intercept()`是`cy.route()`的继承者。 参见[与`cy.route()` 的比较](#Comparison-to-cy-route).

</Alert>

<Alert type="warning">

每次测试之前都会自动清除所有拦截.

</Alert>

## 语法

```js
// 仅仅监视
cy.intercept(url)
cy.intercept(method, url)
cy.intercept(routeMatcher)
```

查看参数[url](/api/commands/intercept#url-String-Glob-RegExp), [method](/api/commands/intercept#method-String) 和 [routeMatcher](/api/commands/intercept#routeMatcher-RouteMatcher)

```js
// 监视和拦截响应
cy.intercept(url, staticResponse)
cy.intercept(method, url, staticResponse)
cy.intercept(routeMatcher, staticResponse)
cy.intercept(url, routeMatcher, staticResponse)
```

查看 [staticResponse](/api/commands/intercept#staticResponse-lt-code-gtStaticResponselt-code-gt) 参数

```js
// 监视, 动态模拟, 请求修改, 等等.
cy.intercept(url, routeHandler)
cy.intercept(method, url, routeHandler)
cy.intercept(routeMatcher, routeHandler)
cy.intercept(url, routeMatcher, routeHandler)
```

查看 [routeHandler](/api/commands/intercept#routeHandler-lt-code-gtFunctionlt-code-gt) 参数

### 用法

**<Icon name="check-circle" color="green"></Icon> 正确的用法**

```js
// 监视
cy.intercept('/users/**')
cy.intercept('GET', '/users*')
cy.intercept({
  method: 'GET',
  url: '/users*',
  hostname: 'localhost',
})

// 监视和 响应模拟
cy.intercept('POST', '/users*', {
  statusCode: 201,
  body: {
    name: 'Peter Pan',
  },
})

// 监视、动态模拟响应、请求修改等.
cy.intercept('/users*', { hostname: 'localhost' }, (req) => {
  /* 对request 以及/或者 响应 进行操作 */
})
```

### 参数

#### **<Icon name="angle-right"></Icon> method** **_(String)_**

将路由匹配到特定的[HTTP方法](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods) (`GET`, `POST`, `PUT`, 等).

<Alert type="bolt">

如果没有定义方法，默认情况下Cypress将匹配所有请求。

</Alert>

#### **<Icon name="angle-right"></Icon> url** **_(String, Glob, RegExp)_**

指定要匹配的URL。参见[匹配`url`](#match-url)的示例.

或者，通过[`routeMatcher`][arg-routematcher]参数指定URL(见下面内容)。

#### **<Icon name="angle-right"></Icon> routeMatcher** **_(`RouteMatcher`)_**

`routeMatcher` 是使用一个对象来匹配传入的HTTP请求与此拦截路由.

所有属性都是可选的，但所有设置的属性必须与要拦截的请求匹配. 如果一个`string`被传递给任何属性，它将使用[`Cypress.minimatch`](/api/utilities/minimatch)对请求进行全局匹配。

| 选项       | 描述                                                                                     |
| ---------- | ----------------------------------------------------------------------------------------------- |
| auth       | HTTP基本身份验证(`object` with keys `username` and `password`)                        |
| headers    | HTTP请求头 (`object`)                                                                 |
| hostname   | HTTP请求的主机名                                                                          |
| https      | `true`: 仅安全的(https://)请求, `false`: 仅不安全的(http://)请求              |
| method     | HTTP请求方法(默认匹配任何方法)                                             |
| middleware | `true`: 先匹配路由，并按照定义的顺序匹配, `false`:倒序匹配路由(默认) |
| path       | 主机名后的HTTP请求路径，包括查询参数                                |
| pathname   | 类似于`path`，但没有查询参数                                                       |
| port       | HTTP请求端口(`number` 或 `Array`)                                                      |
| query      | 解析查询字符串 (`object`)                                                                  |
| times      | 最大匹配次数 (`number`)                                                     |
| url        | 完整的HTTP请求URL                                                                           |

请参阅下面的[例子](#With-RouteMatcher)。

#### <Icon name="angle-right"></Icon> staticResponse (<code>[StaticResponse][staticresponse]</code>)

通过传递一个 `StaticResponse`作为最后的参数, 您可以为匹配的请求[静态定义(模拟)一个响应](#Stubbing-a-response)，包括响应体，以及头和HTTP状态代码:

| 选项       | 描述                                                      |
| ---------- | ---------------------------------------------------------------- |
| statusCode | HTTP响应状态码                                        |
| headers    | HTTP响应头                                            |
| body       | 提供一个静态响应体 (`object`, `string`, `ArrayBuffer`) |
| fixture    | 将一个fixture作为HTTP响应体                        |

`StaticResponse` 还提供用于模拟降级或中断的网络连接的选项:

| 选项              | 描述                                                                 |
| ----------------- | --------------------------------------------------------------------------- |
| forceNetworkError | 通过破坏浏览器连接强制执行错误                         |
| delay             | 增加到响应时间的最小网络延迟或延迟(毫秒) |
| throttleKbps      | 响应的最大数据传输速率(千比特/秒)                |

**注意:** 所有属性都是可选的.

参见[用一个`StaticResponse`对象模拟响应](#With-a-StaticResponse-object)的示例.

另请参阅 [`StaticResponse` 对象](#StaticResponse-objects).

#### <Icon name="angle-right"></Icon> routeHandler (<code>Function</code>)

只要匹配了请求，就会调用`routeHandler`函数，第一个参数是请求对象. 在回调内部，您可以访问整个请求-响应，您可以修改传出请求、发送响应、访问实际响应等等.

参见[“拦截请求”][req]和[使用' routeHandler '修改RequestResponse](#Request-Response-Modification-with-routeHandler).

### Yields 输出[<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Subject-Management)

- `cy.intercept()` 输出 `null`.
- `cy.intercept()` 可以别名，但不能进一步链接.
- 使用[cy.wait()](/api/commands/wait)等待别名的`cy.intercept()`路由将生成一个包含有关匹配请求响应闭环信息的对象. 请参阅[使用yield对象](#Using-the-yielded-object)以了解如何使用这个对象。

## 例子

<Alert type="info">

`cy.intercept` 可以单独用于间谍: 被动地监听匹配的路由，并对它们应用[别名](#Aliasing-a-Route)，而不以任何方式操纵请求或其响应. 这本身就很强大，因为它允许您[等待](#Waiting-on-a-request)这些请求，从而产生更可靠的测试.

</Alert>

### 匹配 `url`

您可以提供精确的[URL](#Arguments) 来匹配或使用模式匹配来一次匹配多个URL, 否则要么使用globs，要么用regex。参见[Glob模式匹配url](#Glob-Pattern-Matching-URLs).

```js
// 匹配任何与URL完全匹配的请求
cy.intercept('https://prod.cypress.io/users')

// 匹配任何满足glob模式的请求
cy.intercept('/users?_limit=*')

// 匹配任何满足正则表达式模式的请求
cy.intercept(/\/users\?_limit=(3|5)$/)
```

### 匹配 `method`

<Alert type="warning">

如果你没有传入[' method '参数][arg-method], 那么会匹配所有方法 (`GET`, `POST`, `PUT`, `PATCH`, `DELETE`, 等.) .

</Alert>

```js
cy.intercept('/users')
// 匹配这: GET http://localhost/users
// ...还有这个: POST http://localhost/users

cy.intercept('GET', '/users')
// 匹配这: GET http://localhost/users
// ...但不匹配这个: POST http://localhost/users
```

### 用 [RouteMatcher](#routeMatcher-RouteMatcher) 匹配

也可以通过将 `routeMatcher`对象传递给`cy.intercept`来指定要匹配的`method` 和 `url`:

```js
// 这两者的结果是一样的:
cy.intercept({ method: 'GET', url: '**/users' })
cy.intercept('GET', '**/users')
```

```js
// 使用路径名`/search`和查询参数'q=some+terms'匹配任何类型的请求
cy.intercept({
  pathname: '/search',
  query: {
    q: 'some terms',
  },
}).as('searchForTerms')
```

```js
cy.intercept(
  {
    // 这个RegExp匹配任何以'http://api.example.com/'开头并以'/edit' 或 '/save'结尾的URL
    url: /^http:\/\/api\.example\.com\/.*\/(edit|save)/,
    // 匹配的请求也必须包含此头
    headers: {
      'x-requested-with': 'exampleClient',
    },
  })
```

```js
// 这个例子将导致一个请求 `/temporary-error`接收到一个网络错误，随后的请求将不匹配这个`RouteMatcher`
cy.intercept('/temporary-error', { times: 1 }, { forceNetworkError: true })
```

### 模式匹配

```js
// 使用glob匹配匹配`/users`端点的更新
cy.intercept({
  method: '+(PUT|PATCH)',
  url: '**/users/*',
})
// 匹配有:
//   PUT /users/1
//   PATCH /users/1
//   doesn't match
//   GET /users
//   GET /users/1

// 和上面一样，但是使用regex
cy.intercept({
  method: '/PUT|PATCH/',
  url: '**/users/*',
})
```

### 别名 拦截的路由

`cy.intercept` 不会输出任何返回结果, 你可以将[`.as`](/api/commands/as)链接到它来创建一个[别名](/guides/core-concepts/variables-and-aliases#Aliases)，别名可以用来[等待一个request](#Waiting-on-a-request).

```js
cy.intercept('GET', '/users').as('getAllUsers')
cy.intercept('POST', '/users').as('createUser')
```

### 别名单个请求

通过设置拦截请求的`alias`属性，可以根据每个请求设置别名. 这在拦截GraphQL请求时特别有用:

```js
cy.intercept('POST', '/graphql', (req) => {
  if (req.body.hasOwnProperty('query') && req.body.query.includes('mutation')) {
    req.alias = 'gqlMutation'
  }
})

// 断言已经发出了一个匹配的请求
cy.wait('@gqlMutation')
```

<Alert type="info">

有关使用GraphQL对请求进行别名的更多指导, 参阅 [使用GraphQL](/guides/testing-strategies/working-with-graphql)

</Alert>

### 等待请求

使用[cy.wait()](/api/commands/wait)和[别名一个拦截路由](#aliasing-an-intercepted-route)来等待请求响应闭环完成.

#### 使用 URL

```js
cy.intercept('http://example.com/settings').as('getSettings')

// 一旦一个获取设置的请求得到响应，'cy.wait'将被解决
cy.wait('@getSettings')
```

#### 使用 [RouteMatcher](#routeMatcher-RouteMatcher)

```js
cy.intercept({
  url: 'http://example.com/search*',
  query: { q: 'expected terms' },
}).as('search')

// 一旦使用包含'q=expected+terms'的查询字符串进行搜索的任何类型的请求响应，'cy.wait'将被解析
cy.wait('@search')
```

#### 使用输出对象

在 `cy.intercept()` 路由别名上使用[cy.wait()](/api/commands/wait)会输出一个表述请求/响应闭环的拦截对象:
Using [cy.wait()](/api/commands/wait) on a `cy.intercept()` route alias yields an interception object which represents the request/response cycle:

```js
cy.wait('@someRoute').then((interception) => {
  // 'interception'是一个属性为'id'， 'request'和'response'的对象
})
```

你可以链接[`.its()`](/api/commands/its) 和 [`.should()`](/api/commands/should)来断言请求/响应闭环:

```js
// 断言对该路由的请求的body 包含了'user'
cy.wait('@someRoute').its('request.body').should('include', 'user')

// 断言对该路由的请求收到了HTTP状态为500的响应
cy.wait('@someRoute').its('response.statusCode').should('eq', 500)

// 断言对该路由的请求收到了包含“id”的 响应body
cy.wait('@someRoute').its('response.body').should('include', 'id')
```

#### 等待错误

你可以使用[cy.wait()](/api/commands/wait)来等待以网络错误结束的请求:

```js
cy.intercept('GET', '/should-err', { forceNetworkError: true }).as('err')

// 断言此请求发生并且以错误结束
cy.wait('@err').should('have.property', 'error')
```

### 模拟一个响应

#### 使用字符串

```js
// 请求'/update'，将以'success' body响应。
cy.intercept('/update', 'success')
```

#### 使用 fixture

```js
// 请求的'/users.json'将由fixture 'users.json'的内容来响应
cy.intercept('/users.json', { fixture: 'users.json' })
```

#### 使用 `StaticResponse` 对象

对象[`StaticResponse`][staticresponse]表述对HTTP请求的响应，可以用来模拟路由:

```js
const staticResponse = {
  /* 这里有一些StaticResponse属性... */
}

cy.intercept('/projects', staticResponse)
```

使用JSON模拟响应BODY:

```js
cy.intercept('/projects', {
  body: [{ projectId: '1' }, { projectId: '2' }],
})
```

一次性模拟所有：header、状态代码和body:

```js
cy.intercept('/not-found', {
  statusCode: 404,
  body: '404 Not Found!',
  headers: {
    'x-not-found': 'true',
  },
})
```

参阅 [`StaticResponse` 对象][staticresponse].

### 使用 **`routeHandler`** 函数

通过指定[`routeHandler`][arg-routehandler] 函数作为`cy.intercept`的最后一个参数,您将可以访问整个请求-响应会话, 使您能够修改传出请求、操作实际响应、进行断言等.

`routeHandler`接受传入的HTTP请求(`IncomingHTTPRequest`)作为第一个参数。

```js
cy.intercept('/users*', (req) => {
  /* 用请求和/或 响应来做某事 */
})
```

<Alert type="info">

在这些示例中，我们将传入的HTTP请求称为`req`. 有[Express.js](https://expressjs.com/) [middleware](https://expressjs.com/en/guide/writing-middleware.html)经验的人应该熟悉这个语法.

</Alert>

#### 对请求进行断言

```js
cy.intercept('POST', '/organization', (req) => {
  expect(req.body).to.include('Acme Company')
})
```

#### 修改正在传出的请求

您可以使用请求处理程序回调来修改[截获的请求对象][req]，然后再发送它。

```js
// 在将请求体发送到目的地之前，将其设置为不同的内容
cy.intercept('POST', '/login', (req) => {
  req.body = 'username=janelane&password=secret123'
})

//动态设置别名
cy.intercept('POST', '/login', (req) => {
  req.alias = 'login'
})
```

#### 向传出请求添加 header

您可以向传出请求添加header，也可以修改已存在的header

```js
cy.intercept('/req-headers', (req) => {
  req.headers['x-custom-headers'] = 'added by cy.intercept'
})
```

**注意:** 因为请求已经离开浏览器，所以新的header将不会显示在浏览器的Network选项卡中. 您仍然可以通过等待拦截来确认添加了header，如下所示:

#### 等待intercept

```js
cy.intercept('/req-headers', (req) => {
  req.headers['x-custom-headers'] = 'added by cy.intercept'
}).as('headers')

// the application makes the call ...
// confirm the custom header was added
cy.wait('@headers')
  .its('request.headers')
  .should('have.property', 'x-custom-headers', 'added by cy.intercept')
```

#### 添加、修改或删除所有外发请求的header

你可以在`cypress/support/index.js`文件中使用`beforeEach()`添加、修改或删除所有传出请求的header

```js
// cypress/support/index.ts

beforeEach(() => {
  cy.intercept(
    { url: 'http://localhost:3001/**', middleware: true },
    // 从所有发出的请求中删除'if-none-match' header 
    (req) => delete req.headers['if-none-match']
  )
})
```

#### 动态模拟响应

可以使用[`req.reply()`][req-reply]函数动态控制对请求的响应.

```js
cy.intercept('/billing', (req) => {
  // 在这里，可以使用'req'上的函数来动态响应请求

  //将请求发送到目标服务器
  req.reply()

  // 使用JSON对象响应请求
  req.reply({ plan: 'starter' })

  // 将请求发送到目标服务器并拦截响应
  req.continue((res) => {
    // 'res' 表述真实目的地的响应
    // 有关更多细节和示例，请参阅“拦截响应”
  })
})
```

有关`req`对象及其属性和方法的更多信息，请参阅["拦截请求"][req].

#### 返回一个 Promise

如果一个Promise从路由回调中返回，请求继续之前将等待这个promise的解决.

```js
cy.intercept('POST', '/login', (req) => {
  // 您可以异步获取测试数据。..
  return getLoginCredentials().then((credentials) => {
    // ...然后，用它来补充外发请求
    req.headers['authorization'] = credentials
  })
})
```

#### 将请求传递给下一个请求处理程序

如果 [`req.reply()`][req-reply] 或 [`req.continue()`][req-continue]没有在请求处理程序中显式调用, 请求将传递给下一个请求处理程序，直到没有所有请求完成.

```js
// 您可以使用顶层中间件处理程序在所有请求上设置认证令牌
// 但是请记住设置‘middleware: true’将导致它总是先被调用
cy.intercept('http://api.company.com/', { middleware: true }, (req) => {
  req.headers['authorization'] = `token ${token}`
})

// 然后有另一个处理程序对某些请求进行更严格的断言
cy.intercept('POST', 'http://api.company.com/widgets', (req) => {
  expect(req.body).to.include('analytics')
})

// 一个对http://api.company.com/widgets的POST请求将命中这两个回调, 首先是 middleware , 然后将请求连同修改后的请求头一起发送到真正的目的地
```

### 拦截一个响应

在传递给 `req.continue()`的回调函数中，您可以访问目标服务器的真实响应。

```js
cy.intercept('/integrations', (req) => {
  // 使用回调的req.continue()将把请求发送到目标服务器
  req.continue((res) => {
    // 'res'表示真实的目标响应
    // 你可以在将'res'发送到浏览器之前对其进行修改操作
  })
})
```

有关`res`对象的更多信息，请参见["拦截响应"][res]. 有关`req.continue()`的更多信息，请参见["用`req.continue()`控制出站请求"][request -continue].

#### 对响应进行断言

```js
cy.intercept('/projects/2', (req) => {
  req.continue((res) => {
    expect(res.body).to.include('My Project')
  })
})
```

#### 返回一个 Promise

如果从路由回调中返回了Promise，它将在向浏览器发送响应之前被等待.

```js
cy.intercept('/users', (req) => {
  req.continue((res) => {
    // 在'waitForSomething()'解析之前，响应不会被发送到浏览器
    return waitForSomething()
  })
})
```

#### 限速或延迟响应所有传入的响应

你可以使用`cypress/support/index.js` 文件中的`beforeEach()`限速或延迟所有传入响应

```js
// cypress/support/index.ts

// 限速API响应以模拟真实环境
cy.intercept(
  {
    url: 'http://localhost:3001/**',
    middleware: true,
  },
  (req) => {
    req.on('response', (res) => {
      // 将响应限速在1Mbps，以模拟移动3G连接
      res.setThrottle(1000)
    })
  }
)
```

### 使用`routeHandler`修改请求/响应

指定[`routeHandler`][arg-routehandler]作为修改传出请求、模拟响应、进行断言等的最后一个参数。

<!-- TODO DX-188 emphasize the usage of StaticResponse as the routeHandler -->

如果一个函数作为`routeHandler`传递，它将被拦截的HTTP请求调用:

```js
cy.intercept('/api', (req) => {
  // 对截获的请求做...
})
```

从这里开始，您可以对拦截的请求做几件事:

<!-- TODO DX-190 add links to examples -->

- 修改请求，并对请求的body、head、URL、方法等进行断言. ([示例](#Asserting-on-a-request-1))
- 在不与实际后端交互的情况下终止响应 ([示例](#Controlling-the-response)
- 将请求传递到其目的地，并在返回的过程中修改或断言真实的响应([示例](#Controlling-the-response))
- 将侦听器附加到请求的各种事件([示例](#Controlling-the-response))

#### 对请求进行断言

您可以使用请求处理程序回调在[被拦截的请求对象][req]被发送之前对其进行断言.

```js
// 匹配创建用户的请求
cy.intercept('POST', '/users', (req) => {
  // 对请求的装载内容进行断言
  expect(req.body).to.include('Peter Pan')
})
```

#### 控制外发请求

发出的请求，包括它的boyd、head等，可以在发送之前修改。

```js
// 在将请求body发送到目的地之前修改请求body
cy.intercept('POST', '/users', (req) => {
  req.body = {
    name: 'Peter Pan',
  }
})

// 向传出请求添加header
cy.intercept('POST', '/users', (req) => {
  req.headers['x-custom-header'] = 'added by cy.intercept'
})

// 修改已存在的header
cy.intercept('POST', '/users', (req) => {
  req.headers['authorization'] = 'Basic YWxhZGRpbjpvcGVuc2VzYW1l'
})
```

#### 验证请求的修改

```js
cy.intercept('POST', '/users', (req) => {
  req.headers['x-custom-header'] = 'added by cy.intercept'
}).as('createUser')

cy.get('button.save').click()
// 通过在命令日志中选择这一行，可以在控制台输出中看到header:
cy.wait('@createUser')
  // ...或者作出断言:
  .its('request.headers')
  .should('have.property', 'x-custom-header', 'added by cy.intercept')
```

<Alert type="warning">

请求修改不能通过检查浏览器的网络流量来验证(例如，在Chrome DevTools中)， 因为浏览器在Cypress拦截 _之前_ 就记录了网络流量.

</Alert>

<Alert type="warning">

`cy.intercept()` 无法使用[`cy.request()`](/api/commands/request)调试! Cypress只拦截由前端应用程序发出的请求.

</Alert>

#### 控制响应

被拦截的请求传递给路由处理程序(以下称为`req`，不过可以使用任何名称)包含一些方法来动态控制对请求的响应:

- `req.reply()` -    不依赖实际后端，立即响应
- `req.continue()` - 修改或断言真实的实际后端的响应
- `req.destroy()` - 销毁请求并返回一个网络错误
- `req.redirect()` -以重定向到指定位置的方式响应请求
- `req.on()` -  通过附加到事件来修改响应

立即响应 (`req.reply()`):

`req.reply()` 以[`StaticResponse`][staticresponse] 对象作为第一个参数:

```js
// 不与实际后端交互，立即响应
cy.intercept('POST', '/users', (req) => {
  req.reply({
    headers: {
      Set-Cookie: 'newUserName=Peter Pan;'
    },
    statusCode: 201,
    body: {
      name: 'Peter Pan'
    },
    delay: 10, // milliseconds
    throttleKbps: 1000, // 模拟3G连接
    forceNetworkError: false // 默认
  })
})

// 使用一个fixture 作为 body来响应 
cy.intercept('GET', '/users', (req) => {
  req.reply({
    statusCode: 200, // default
    fixture: 'users.json'
  })
})
```

更多信息请参见下面的[`StaticResponse`对象][StaticResponse]。

`reply` 方法还支持简写，以避免必须指定`StaticResponse` 对象:

```js
// 等效于`req.reply({ body })`
req.reply(body)

//等效于 `req.reply({ body, headers })`
req.reply(body, headers)

// 等效于 `req.reply({ statusCode, body, headers})`
req.reply(statusCode, body, headers)
```

<Alert type="bolt">

注意:调用`reply()`将结束请求阶段，并停止将请求传播到行中下一个匹配的请求处理程序. 查看 [拦截生命周期][生命周期].

</Alert>

请参见[使用`req.reply()`提供模拟响应](#Providing-a-stub-response-with-req-reply)

修改真实的响应(`continue`):

`continue`方法接受一个函数，该函数被传递给一个对象，表示在返回客户端(你的前端应用程序)的过程中被拦截的真实响应。.

```js
// 传递请求并对实际响应进行断言
cy.intercept('POST', '/users', (req) => {
  req.continue((res) => {
    expect(res.body).to.include('Peter Pan')
  })
})
```

请参见[使用`req.continue()`控制出站请求](#Controlling-the-outbound-request-with-req-continue)

响应一个网络错误(`destroy`):

```js
// 动态地销毁请求并响应一个网络错误
cy.intercept('POST', '/users', (req) => {
  if (mustDestroy(req)) {
    req.destroy()
  }

  function mustDestroy(req) {
    // 根据`req`的内容决定是否强制执行网络错误的代码
  }
})
```

用一个新location(`redirect`)来响应:

```js
// 用重定向到一个新的“location”来响应这个请求
cy.intercept('GET', '/users', (req) => {
  // 状态码默认为 `302`
  req.redirect('/customers', 301)
})
```

通过监听事件来响应(`on`):

```js
cy.intercept('GET', '/users', (req) => {
  req.on('before:response', (res) => {
    // 当`before:response`事件被触发时做....
  })
})
cy.intercept('POST', '/users', (req) => {
  req.on('response', (res) => {
    // 当 `response`事件被触发时做......
  })
})
```

参见[限速响应](#Throttle-or-delay-response-all-incoming-responses)的示例
参见[事件](#Request-events)的更多例子

#### 返回一个 Promise

如果一个Promise从路由回调中返回，请求在继续之前将等待promise。

```js
cy.intercept('POST', '/users', (req) => {
  // 异步获取测试数据
  return getAuthToken().then((token) => {
    // ...并将其应用于传出请求
    req.headers['Authorization'] = `Basic ${token}`
  })
})

cy.intercept('POST', '/users', (req) => {
  req.continue((res) => {
    // 在' waitForSomething() '解析之前，响应不会被发送到浏览器:
    return waitForSomething()
  })
})
```

#### 用字符串模拟响应

```js
// requests to create a user will be fulfilled with a body of 'success'
cy.intercept('POST', '/users', 'success')
// { body: 'sucess' }
```

## 拦截的请求

如果函数作为`cy.intercept()`的处理程序传递，它将被调用，第一个参数是一个代表被拦截的HTTP请求的对象:

```js
cy.intercept('/api', (req) => {
  // `req`表示拦截的HTTP请求
})
```

从这里开始，您可以对被拦截的请求做以下几件事:

- 您可以对请求的属性进行修改和断言(body, headers, URL, method...)
- 请求可以发送到真实的上游服务器
  - 您还可以选择从中截取响应
- 可以提供一个响应来终止请求
- 监听器可以附加到请求的各种事件

### 请求对象属性

请求对象(`req`)具有来自HTTP请求本身的几个属性. 除了`httpVersion`之外， `req`上的所有以下属性都可以修改:

```ts
{
  /**
   * 请求的 body.
   * 如果使用了JSON Content-Type并且body是有效的JSON，
   * 这将是一个对象.
   * 如果body是二进制内容，那么这将是一个buffer.
   */
  body: string | object | any
  /**
   * 请求的 headers 
   */
  headers: { [key: string]: string }
  /**
   * 请求的 HTTP 方法 (GET, POST, ...).
   */
  method: string
  /**
   * 请求 URL.
   */
  url: string
  /**
   * URL对象格式的查询字符串.
   */
  query: Record<string, string|number>
  /**
   * 请求中使用的HTTP版本。只读.
   */
  httpVersion: string
}
```

`req`也有一些可选属性，可以设置为控制特定的cypress行为:

```ts
{
  /**
   * 如果提供，此请求的上游响应时间如超过，则超时并导致错误。
   * 默认情况下，使用config中的`responseTimeout`。
   */
  responseTimeout?: number
  /**
   * 设置当发出此请求时是否应遵循重定向.
   * 默认情况下，请求在生成响应之前不会遵循重定向(生成了3xx重定向).
   */
  followRedirect?: boolean
  /**
   *如果设置, 就能用`cy.wait('@alias')` 来等待请求/响应闭环 来完成此请求。
   */
  alias?: string
}
```

对`req`'属性的任何修改都将持久化到其他请求处理程序中，并最终合并到实际的出站HTTP请求中。

### 使用`req.continue()`控制出站请求

不带任何参数调用`req.continue()`将导致请求被发送出去，并且在调用了任何其他侦听器之后，响应将被返回给浏览器. 例如，下面的代码修改了一个`POST` 请求，然后将它发送到上游服务器:

```js
cy.intercept('POST', '/submitStory', (req) => {
  req.body.storyName = 'some name'
  // 发送修改后的请求并跳过任何其他匹配的请求处理程序
  req.continue()
})
```

如果一个函数被传递给`req.continue()`，请求将被发送到真正的上游服务器，当从服务器完全接收到响应后，回调函数将被调用. 查看["拦截响应"][res]

注意:调用`req.continue()` 将阻止请求传播到行中下一个匹配的请求处理程序. 更多信息参阅 ["拦截生命周期"][生命周期].

### 使用`req.reply()`提供模拟响应

`req.reply()`函数可以用来为被拦截的请求发送一个模拟响应. 通过将字符串、对象或[`StaticResponse`][staticresponse]传递给`req.reply()`, 请求可能会阻止到达目标服务器。

例如，下面的代码将请求拦截器中的JSON响应:

```js
cy.intercept('/billing', (req) => {
  // 在请求时动态获取账单计划名称
  const planName = getPlanName()
  // 该对象将自动转为为JSON.stringified并作为响应发送
  req.reply({ plan: planName })
})
```

你也可以传递一个[`StaticResponse`][staticresponse]对象，而不是传递一个普通对象或字符串给`req.reply()`. 使用[`StaticResponse`][staticresponse]，你可以强制一个网络错误，延迟响应，发送一个fixture等等。

例如，以下代码为一个动态选择的fixture提供延迟为500ms的服务:

```js
cy.intercept('/api/users/*', async (req) => {
  // 在请求时异步检索fixture文件
  const fixtureFilename = await getFixtureFilenameForUrl(req.url)
  req.reply({
    fixture: fixtureFilename,
    delay: 500,
  })
})
```

请参阅[`StaticResponse`文档][StaticResponse]以获得更多关于以这种方式模拟响应的信息。

#### `req.reply()` 简写

`req.reply()`也支持简写，类似于 [`res.send()`][res-send]，以避免必须指定`StaticResponse` 对象:

```js
// 等效于`req.reply({ body })`
req.reply(body)

// 等效于 `req.reply({ body, headers })`
req.reply(body, headers)

// 等效于 `req.reply({ statusCode, body, headers})`
req.reply(statusCode, body, headers)
```

#### 快捷函数

在`req`上还有两个快捷函数:

```ts
{
  /**
   * 销毁请求并返回一个网络错误。
   */
  destroy(): void
  /**
   * 响应这个请求，重定向到一个新的'location'.。
   * @param statusCode 重定向使用的HTTP状态代码。默认: 302
   */
  redirect(location: string, statusCode?: number): void
}
```

参见[控制响应](#Controlling-the-response) 章节中的示例。

注意:调用`req.reply()`将结束请求阶段，并停止将请求传播到行中下一个匹配的请求处理程序. 更多信息请参见[“拦截生命周期”][生命周期]。

### 请求事件

对于高级用途，在`req`上有几个事件可用，它们代表了[截取生命周期][生命周期]的不同阶段。

通过调用的请求。`req.on`你可以订阅不同的活动:

```js
cy.intercept('/shop', (req) => {
  req.on('before:response', (res) => {
    /**
     * 在`response`和'`req.continue` 处理程序之前触发。 
     * 对`res`的修改将应用于传入的响应. 
     * 如果返回一个promise，它将在处理其他事件处理程序之前被等待。
     */
  })

  req.on('response', (res) => {
    /**
     * 在`before:response`和'`req.continue` 处理程序之后触发——在响应发送到浏览器之前. 
     * 对`res`的修改将应用于传入的响应. 
     * 如果返回了promise，它将在处理其他事件处理程序之前被等待。
     */
  })

  req.on('after:response', (res) => {
    /**
     * 当对请求的响应完成发送到浏览器时触发。
     * 对`res`的修改没有影响。
     * 如果返回了promise，它将在处理其他事件处理程序之前被等待。
     */
  })
})
```

有关`before:response` 和  `response`输出的 `res` 对象的更多细节，请参见[“截获响应”][res]. 有关请求排序的更多细节，请参阅[“拦截生命周期”][生命周期]。

## 截获的响应

可以通过两种方式拦截响应:

- 通过在请求处理程序中传递回调[`req.continue()`](req-continue)
- 通过监听`before:response` 或 `response`请求事件(参见[“请求事件”](#Request-events))

response对象`res`将作为第一个参数传递给handler函数:

```js
cy.intercept('/url', (req) => {
  req.on('before:response', (res) => {
    // 这将在任何`req.continue` 或 `response`处理程序 之前被调用
  })

  req.continue((res) => {
    // 这将在所有`before:response`处理程序之后调用，并在任何`req.continue`处理的`response` 之前调用，
     // 我们表示这个请求处理程序将是最后一个，
     // 请求应该在此时发送出去。
    // 因此，每个请求只有一个 `req.continue` 处理程序
  })

  req.on('response', (res) => {
    // 这将在所有 `before:response`处理程序之后和 `req.continue` 处理程序之后被调用
    // 但在响应发送到浏览器之前
  })
})
```

### 响应对象属性

响应处理程序的响应对象(`res`)具有来自HTTP响应本身的几个属性。 `res`上的所有以下属性都可以修改:

| 属性           | 描述                                       |
| ------------- | ------------------------------------------------- |
| body          | 响应 body (`object`, `string`, `ArrayBuffer`) |
| headers       | 响应 headers (`object`)                       |
| statusCode    | 响应 status code (`number`)                   |
| statusMessage | 响应 status message (`string`)                |

**注意关于 `body`:** 如果响应头包含`Content-Type: application/json`，并且响应body包含有效的JSON, 这将是一个`object`. 如果body包含二进制内容，则是buffer.

`res`也有一些可选属性，可以设置为控制特定的cypress行为:

| 属性          | 描述                                                                 |
| ------------ | --------------------------------------------------------------------------- |
| throttleKbps | 响应的最大数据传输速率 (kilobits/second)                |
| delay        | 增加到响应时间的最小网络延迟或延迟 (milliseconds) |

对 `res` 属性的任何修改都将持久化到其他响应处理程序中，并最终合并到实际传入的HTTP响应中。

### 以`res.send()`结束响应

要结束请求的响应阶段，调用 `res.send()`.也可以将[`StaticResponse`][staticresponse] 传递给`res.send()`，与实际响应合并。

当 `res.send()`被调用时，响应阶段将立即结束，并且不会为当前请求调用其他响应处理程序. 下面是一个如何使用 `res.send()`的例子:

```js
cy.intercept('/notification', (req) => {
  req.continue((res) => {
    if (res.body.status === 'failed') {
      // 发送一个fixture 而不是现有的'res.body'
      res.send({ fixture: 'success.json' })
    }
  })
})
```

有关格式的更多信息，请参阅[`StaticResponse`文档][StaticResponse]。

#### `res.send()` 简写

`res.send()`也支持简写，类似于[`req.reply()`][req-reply]，以避免必须指定`StaticResponse`对象:

```js
// 等效于 `res.send({ body })`
res.send(body)

// 等效于 `res.send({ body, headers })`
res.send(body, headers)

// 等效于 `res.send({ statusCode, body, headers})`
res.send(statusCode, body, headers)
```

#### 便利函数

在`res`上还有两个便利的函数:

```ts
{
  /**
   * 在向客户端发送响应之前等待'delay'毫秒。
   */
  setDelay: (delay: number) => IncomingHttpResponse
  /**
   * 以每秒'throttleKbps'千字节的速度提供响应。
   */
  setThrottle: (throttleKbps: number) => IncomingHttpResponse
}
```

注意:调用`res.send()`将结束响应阶段，并停止将响应传播到行中下一个匹配的响应处理程序. 更多信息请参见[“拦截生命周期”][生命周期]。

## `StaticResponse` 对象

`StaticResponse` 表示对HTTP请求的模拟响应. 您可以通过3种方式向Cypress提供`StaticResponse` :

- 直接在`cy.intercept()` 中传递 [`staticResponse`](#staticResponse-lt-code-gtStaticResponselt-code-gt), 对一个路由模拟响应 `cy.intercept('/url', staticResponse)`
- 以[`req.reply()`][req-reply]方式, 请求处理程序中的模拟响应: `req.reply(staticResponse)`
- 以 [`res.send()`][res-send] 方式, 响应处理程序中的模拟响应: `res.send(staticResponse)`

以下属性在`StaticResponse`上可用。所有属性都是可选的:

| 选项              | 描述                                                                 |
| ----------------- | --------------------------------------------------------------------------- |
| fixture           | 提供一个fixture作为HTTP响应body                                   |
| body              | 提供静态响应 body (`object`, `string`, `ArrayBuffer`)            |
| headers           | HTTP响应headers                                                       |
| statusCode        | HTTP响应状态码                                                   |
| forceNetworkError | 通过破坏浏览器连接强制执行错误                         |
| delay             | 增加到响应时间的最小网络延迟或延迟(毫秒) |
| throttleKbps      | 响应的最大数据传输速率(千比特秒)                |

请参阅["用 `StaticResponse`对象模拟响应"](#With-a-StaticResponse-object) ，以了解使用`cy.intercept()`模拟的示例。

## 拦截生命周期

`cy.intercept()`拦截的生命周期开始于当你的应用程序发送一个HTTP请求，匹配到一个或多个已注册的`cy.intercept()`路由。 从那里开始，每个拦截都有两个阶段:请求和响应。

`cy.intercept()` 路由的匹配顺序与定义的顺序相反，除非路由是用`{ middleware: true }`定义的，这会总是先运行。 这允许您通过定义一个重合的`cy.intercept()`来覆盖已有的`cy.intercept()`声明:

<DocsImage src="/img/api/intercept/middleware-algo.png" alt="Middleware Algorithm" ></DocsImage>

### 请求阶段

下面的步骤用于处理请求阶段。

1. 根据上述算法从第一个匹配路由开始(首先是middleware，然后是倒序的处理程序)。
2. 有没有提供给 `cy.intercept()`的处理程序(body, [`StaticResponse`][staticresponse],或函数 ) ? 如果没有，继续步骤 7.
3. 如果处理程序是一个body或[`StaticResponse`][staticresponse]，立即用该响应结束请求。
4. 如果该处理程序是一个函数，则使用`req`作为传入请求的第一个参数来调用该函数.有关`req`对象的更多信息，请参阅["拦截请求"][req].
   - 如果[`req.reply()`][req-reply]被调用，立即用提供的响应结束请求阶段.请参见["使用req.reply()`提供模拟响应"](#Providing-a-stub-response-with-req-reply).
   - 如果[`req.continue()`]][request -continue]被调用，立即结束请求阶段，并将请求发送到目标服务器. 如果有回调函数提供给[`req.continue()`][request -continue]，它将在[响应阶段](#Response-phase)被调用
5. 如果处理程序返回Promise，则等待Promise解析。
6. 将对请求对象的任何修改与实际请求合并。
7. 如果有另一个匹配的 `cy.intercept()`，返回到步骤2并继续执行该路由的步骤。
8. 将请求传出到目标服务器并结束请求阶段.  [响应阶段](#Response-phase)将在收到响应后开始.

### 响应阶段

一旦从上游服务器接收到HTTP响应，将应用以下步骤:

1. 获取一个已注册的`before:response`事件监听器列表。
2. 对于每个`before:response`监听器(如果有的话)，用[`res`][res]对象调用它。
   - 如果[`res.send()`][res-send] 被调用，结束响应阶段并将所有传入的参数与响应合并.
   - 如果一个Promise被返回，等待它。将任何修改过的响应属性与实际响应合并.
3. 如果为该路由声明了带回调的`req.continue()` ，则使用[`res`][res]对象调用回调。
   - 如果[`res.send()`][res-send] 被调用，结束响应阶段并将所有传入的参数与响应合并。
   - 如果一个Promise被返回，等待它。将任何修改过的响应属性与实际响应合并。
4. 获取已注册的`response`事件监听器列表。
5. 对于每个`response` 监听器(如果有的话)，使用[`res`][res]对象调用它。
   - 如果[`res.send()`][res-send]被调用，结束响应阶段并将所有传入的参数与响应合并。
   - 如果一个Promise被返回，等待它。将任何修改过的响应属性与实际响应合并。
6. 将响应发送到浏览器。
7. 一旦响应完成，获取一个已注册的 `after:response`事件监听器列表。
8. 对于每个`after:response`监听器(如果有的话)，用[`res`][res]对象调用它(减去`res.send`)
   - 如果一个Promise被返回，等待它。
9. 结束响应阶段.

## Glob 模式匹配url

当[匹配URL][match- URL]时，提供精确的URL来匹配可能会受到太大的限制。例如，如果您想在另一个主机上运行测试，该怎么办?

```js
// 匹配任何与URL完全匹配的请求
cy.intercept('https://prod.cypress.io/users')
// 匹配到这个: https://prod.cypress.io/users
// ...但这个不行: https://staging.cypress.io/users
// ...或者这也不行: http://localhost/users
```

Glob模式匹配提供了必要的灵活性:

```js
cy.intercept('/users')
// 匹配所有这些:
//   https://prod.cypress.io/users
//   https://staging.cypress.io/users
//   http://localhost/users

cy.intercept('/users?_limit=+(3|5)')
// 匹配所有这些:
//   https://prod.cypress.io/users?_limit=3
//   http://localhost/users?_limit=5
```

### Cypress.minimatch

在底层，Cypress使用[minimatch](apiutilitiesminimatch)库进行glob匹配，并通过全局对象`Cypress`访问。
这使您能够在Test Runner浏览器的控制台中测试 匹配模式。

你可以调用`Cypress.minimatch`，只需要两个参数——URL (`string`)和 pattern (`string`)——如果输出`true`,，那么你就有了一个匹配!

```javascript
// 在Test Runner浏览器控制台中执行:
Cypress.minimatch('http://localhost/users?_limit=3', '/users?_limit=+(3|5)')
// true
Cypress.minimatch('http://localhost/users?_limit=5', '/users?_limit=+(3|5)')
// true
Cypress.minimatch('http://localhost/users?_limit=7', '/users?_limit=+(3|5)')
// false
```

#### minimatch 选项

你也可以传入选项(`object`)作为第三个参数，其中一个是 `debug`，如果设置为`true`，将产生详细的输出，可以帮助你理解为什么你的模式不能像你期望的那样工作:

```js
Cypress.minimatch('http://localhost/users?_limit=3', '/users?_limit=+(3|5)', {
  debug: true,
})
// true (增加调试消息)
```

## 对比`cy.route()`

与 [cy.route()](/api/commands/route)不同, `cy.intercept()`:

- 可以拦截所有类型的网络请求，包括Fetch API、页面加载、xmlhttprequest、资源加载等.
- 在使用之前不需要调用[cy.server()](/api/commands/server)  -事实上，`cy.server()`根本不影响' cy.intercept() '。
- 默认情况下没有方法设置`GET`，但是拦截`*` 方法。

## History

| Version                                     | Changes                                                                                                                                                                                                                                                                                              |
| ------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [7.6.0](/guides/references/changelog#7-0-0) | Added `query` option to `req` (The incoming request object yielded to request handler functions).                                                                                                                                                                                                    |
| [7.0.0](/guides/references/changelog#7-0-0) | Removed `matchUrlAgainstPath` option from `RouteMatcher`, reversed handler ordering, added request events, removed substring URL matching, removed `cy.route2` alias, added `middleware` RouteMatcher option, renamed `res.delay()` to `res.setDelay()` and `res.throttle()` to `res.setThrottle()`. |
| [6.4.0](/guides/references/changelog#6-4-0) | Renamed `delayMs` property to `delay` (backwards-compatible).                                                                                                                                                                                                                                        |
| [6.2.0](/guides/references/changelog#6-2-0) | Added `matchUrlAgainstPath` option to `RouteMatcher`.                                                                                                                                                                                                                                                |
| [6.0.0](/guides/references/changelog#6-0-0) | Renamed `cy.route2()` to `cy.intercept()`.                                                                                                                                                                                                                                                           |
| [6.0.0](/guides/references/changelog#6-0-0) | Removed `experimentalNetworkStubbing` option and made it the default behavior.                                                                                                                                                                                                                       |
| [5.1.0](/guides/references/changelog#5-1-0) | Added experimental `cy.route2()` command under `experimentalNetworkStubbing` option.                                                                                                                                                                                                                 |

## 另请参阅

- [`.as()`](/api/commands/as)
- [`cy.wait()`](/api/commands/wait)
- [网络请求指南](/guides/guides/network-requests)
- [Cypress 例子配方](https://github.com/cypress-io/cypress-example-recipes#stubbing-and-spying)
- [Kitchen Sink Examples](https://github.com/cypress-io/cypress-example-kitchensink/blob/master/cypress/integration/examples/network_requests.spec.js)
- [从 `cy.route()` 迁移到 `cy.intercept()`](/guides/references/migration-guide#Migrating-cy-route-to-cy-intercept)
<!-- TODO add examples from the resources below to `cypress-example-recipes` repo -->
- [Cypress中的智能 GraphQL桩 ](https://glebbahmutov.com/blog/smart-graphql-stubbing/) blog post
- [cy.intercept的机制](https://slides.com/bahmutov/how-cy-intercept-works)
- [Cypress `cy.intercept()` 问题](https://glebbahmutov.com/blog/cypress-intercept-problems/)

[staticresponse]: #StaticResponse-objects
[lifecycle]: #Interception-lifecycle
[req]: #Intercepted-requests
[req-continue]: #Controlling-the-outbound-request-with-req-continue
[req-reply]: #Providing-a-stub-response-with-req-reply
[res]: #Intercepted-responses
[res-send]: #Ending-the-response-with-res-send
[match-url]: #Matching-url
[glob-match-url]: #Glob-Pattern-Matching-URLs
[arg-method]: #method-String
[arg-routehandler]: #routeHandler-lt-code-gtstring-object-Function-StaticResponselt-code-gt
[arg-routematcher]: #routeMatcher-RouteMatcher
