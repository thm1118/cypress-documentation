---
title: visit
---

访问远程URL.

<Alert type="warning">

<strong class="alert-header">最佳实践</strong>

我们建议在使用`cyl .visit()`时设置`baseUrl`.

阅读[最佳实践](/guides/references/best-practices#Setting-a-global-baseUrl) .

</Alert>

## 语法

```javascript
cy.visit(url)
cy.visit(url, options)
cy.visit(options)
```

### 用法

**<Icon name="check-circle" color="green"></Icon> 正确的用法**

```javascript
cy.visit('http://localhost:3000')
cy.visit('/') // 访问 baseUrl
cy.visit('index.html') // 访问本地文件 "index.html"
cy.visit('./pages/hello.html')
```

### 参数

**<Icon name="angle-right"></Icon> url** **_(String)_**

要访问的URL.

Cypress将在您的[网络选项](/guides/references/configuration#Global) 中配置的`baseUrl`作为URL前缀，如果你设置的化.

如果没有设置`baseUrl` , 你可以指定一个html文件的相对路径，Cypress将自动使用内置的静态服务器来服务这个文件. 该路径相对于项目的根目录。 注意，不需要`file://`前缀.

**<Icon name="angle-right"></Icon> options** **_(Object)_**

传入一个options对象来控制 `cy.visit()`的行为.

| 选项                       | 默认值                                                          | 描述                                                                                                                                                                                                                              |
| -------------------------- | -------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `url`                      | `null`                                                         | 要访问的URL。行为与`url`参数相同.                                                                                                                                                                                |
| `method`                   | `GET`                                                          | 访问中使用的HTTP方法。`GET` 或 `POST`.                                                                                                                                                                             |
| `body`                     | `null`                                                         | 与`POST`请求一起发送的可选body。 如果它是一个字符串，它将不加修改地传递. 如果它是一个object，它将被编码为字符串的URL，并与`Content-Type: application/x-www-urlencoded`头一起发送. |
| `headers`                  | `{}`                                                           | 随request发送的HTTP header，由键值对组成的对象. _注意:_ `headers` 仅在初始化的 `cy.visit()` request时发送, 不会被子requests发送.                                            |
| `qs`                       | `null`                                                         | 附加到请求的`url`的查询参数                                                                                                                                                                                   |
| `log`                      | `true`                                                         | 是否在[命令日志](/guides/core-concepts/test-runner#Command-Log) 中显示命令                                                                                                                                                |
| `auth`                     | `null`                                                         | 添加基本授权头                                                                                                                                                                                                         |
| `failOnStatusCode`         | `true`                                                         | 响应码不是`2xx` 和 `3xx`时，visit是否失败                                                                                                                                                                             |
| `onBeforeLoad`             | `function`                                                     | 在页面加载其所有资源之前调用的函数.                                                                                                                                                                                 |
| `onLoad`                   | `function`                                                     | 一旦页面触发了它的load事件就调用的函数.                                                                                                                                                                                          |
| `retryOnStatusCodeFailure` | `false`                                                        | 状态代码错误时，Cypress是否应该在底层自动重试. 如果设置为true, Cypress将重试一个请求最多4次.                                                                                         |
| `retryOnNetworkFailure`    | `true`                                                         | 瞬态网络错误时，Cypress是否应该在底层自动重试. 如果设置为true, Cypress将重试一个请求最多4次.                                                                                   |
| `timeout`                  | [`pageLoadTimeout`](/guides/references/configuration#超时) | `cy.visit()` 在[超时](#超时)之前等待的时间                                                                                                                                                                  |

你也可以在[configuration](/guides/references/configuration)中全局设置所有的`cy.visit()` 命令的' `pageLoadTimeout` 和 `baseUrl`.

### Yields [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#目标管理)

<List><li>`cy.visit()` '在页面完成加载后yields（生成） `window` 对象' </li></List>

让我们在访问该网站后检查 `window.navigator.language`:

```javascript
cy.visit('/') // yields the window 对象
  .its('navigator.language') // yields window.navigator.language
  .should('equal', 'en-US') // 断言预期值
```

## 例子

### URL

#### 访问运行在`http://localhost:8000`上的本地服务

`cy.visit()` 将在远程页面触发其`load`事件时解析.

```javascript
cy.visit('http://localhost:8000')
```

### 选项

#### 更改默认超时时间

```javascript
// 等待页面'load'事件30秒
cy.visit('/index.html', { timeout: 30000 })
```

#### 添加基本身份验证头

如果您试图访问一个需要[基本身份验证](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication) 的应用程序，Cypress将自动应用正确的授权头。.

在`auth`对象中提供`username` 和 `password` . 然后，所有与您正在测试的源匹配的后续请求都将在网络级别附加这个头.

```javascript
cy.visit('https://www.acme.com/', {
  auth: {
    username: 'wile',
    password: 'coyote',
  },
})
```

您还可以在URL中直接提供用户名和密码.

```javascript
// 这与提供认证对象是一样的
cy.visit('https://wile:coyote@www.acme.com')
```

<Alert type="info">

Cypress在浏览器外，基于网络代理级自动附加这个头. 因此，你**不会**在Dev Tools中看到这个头.

</Alert>

#### 提供一个`onBeforeLoad`回调函数

`onBeforeLoad`会在页面加载所有资源之前被尽快调用. 您的脚本现在还没有准备好，但是它是一个很好的钩子，可以潜在地操纵页面.

```javascript
cy.visit('http://localhost:3000/#dashboard', {
  onBeforeLoad: (contentWindow) => {
    // contentWindow是远程页面的窗口对象
  },
})
```

<Alert type="info">

查看我们的示例配方，使用`cy.visit()`的 `onBeforeLoad`选项:

- [启动你的应用](/examples/examples/recipes#Server-Communication)
- [在单点登录期间为登录设置一个令牌，保存到`localStorage` ](/examples/examples/recipes#Logging-In)
- [模拟 `window.fetch`](/examples/examples/recipes#Stubbing-and-spying)

</Alert>

#### 提供一个`onLoad` 回调函数

一旦你的页面触发了它的`load`事件，就会调用`onLoad` . 此时，所有的脚本、样式表、html和其他资源都保证可用.

```javascript
cy.visit('http://localhost:3000/#/users', {
  onLoad: (contentWindow) => {
    // contentWindow是远程页面的窗口对象
    if (contentWindow.angular) {
      // 做某事
    }
  },
})
```

#### 添加查询参数

通过将`qs`传递给`options`，你可以将查询参数作为对象提供给`cy.visit()`。

```js
// visits http://localhost:3500/users?page=1&role=admin
cy.visit('http://localhost:3500/users', {
  qs: {
    page: '1',
    role: 'admin',
  },
})
```

传递给`qs`的参数将合并到`url`上的现有查询参数中。.

```js
// visits http://example.com/users?page=1&admin=true
cy.visit('http://example.com/users?page=1', {
  qs: { admin: true },
})
```

#### 提交表单

要发送一个看起来像用户提交HTML表单的请求，可以使用带有包含表单值`body`的`POST`方法:

```javascript
cy.visit({
  url: 'http://localhost:3000/cgi-bin/newsletterSignup',
  method: 'POST',
  body: {
    name: 'George P. Burdell',
    email: 'burdell@microsoft.com',
  },
})
```

## 注意

### 重定向

#### 访问将自动遵循重定向

```javascript
// 我们没有登录，所以我们的网络服务器将我们重定向到 /login
cy.visit('http://localhost:3000/admin')
cy.url().should('match', /login/)
```

### 协议

#### 普通host可以省略协议

Cypress自动将`http://`协议附加到普通host。 如果您没有使用下面 3个主机中的一个，那么请确保自己提供协议.

```javascript
cy.visit('localhost:3000') // Visits http://localhost:3000
cy.visit('0.0.0.0:3000') // Visits http://0.0.0.0:3000
cy.visit('127.0.0.1:3000') // Visits http://127.0.0.1:3000
```

### Web服务

#### Cypress能够可选的作为您的web服务

如果你不提供host并且`baseUrl`没有定义，Cypress将自动尝试为你的文件提供服务. 该路径应该相对于项目的根文件夹(根目录会已有默认生成的 `cypress.json` 文件).

在小型项目和示例应用程序中，让Cypress为你的文件提供服务很有用，但不推荐用于生产. 最好运行自己的服务器，并向Cypress提供url.

```javascript
cy.visit('app/index.html')
```

#### 当设置了`baseUrl`时访问本地文件

如果设置了`baseUrl`，但需要在单个测试或一组测试中访问本地文件，请使用[单个测试配置](/guides/references/configuration#Test-Configuration)里禁用`baseUrl`. 想象我们的 `cypress.json`文件:

```json
{
  "baseUrl": "https://example.cypress.io"
}
```

第一个测试访问`baseUrl`，而第二个测试访问本地文件。

```javascript
it('访问baseUrl', () => {
  cy.visit('/')
  cy.contains('h1', 'Kitchen Sink')
})

it('访问本地文件', { baseUrl: null }, () => {
  cy.visit('index.html')
  cy.contains('local file')
})
```

**提示:** 因为访问每个新域都需要重新加载Test Runner窗口，所以我们建议将上述两个测试放在单独，分隔的两个spec文件中.

### 前缀

#### Visit会自动加上`baseUrl`前缀

在你的[配置(`cypress.json` 默认)](/guides/references/configuration) 中配置`baseUrl` ，以免在每个`cy.visit()`命令中重复这些前缀.

```json
{
  "baseUrl": "http://localhost:3000/#/"
}
```

```javascript
cy.visit('dashboard') // Visits http://localhost:3000/#/dashboard
```

### Window

#### 当Visit 完成解析时，总是会产生（yield）远程页面的`window`对象

```javascript
cy.visit('index.html').then((contentWindow) => {
  // contentWindow是远程页面的窗口对象
})
```

### User agent

试图改变`User-Agent`? 你可以在配置文件中将`userAgent`设置[配置值](/guides/references/configuration#Browser).

### 路由

#### 在远程页面最初加载之前阻止请求

Cypress支持的一个常见场景是访问远程页面并防止立即发出任何Ajax请求。

你可能认为这是可行的:

```javascript
// 根据实现的不同，此代码可能无法工作
cy.visit('http://localhost:8000/#/app')
cy.intercept('/users/**', { fixture: 'users' })
```

但如果你的应用程序在初始化时发出请求， _上面的代码不能工作_. `cy.visit()` 将在它的`load`事件触发后解析. [`cy.intercept()`](/api/commands/intercept)命令在`cy.visit()`解析完成后才会被处理。

在上面代码中的`cy.visit()`解析时，许多应用程序已经开始路由、初始化和请求了. 因此，创建[`cy.intercept()`](/api/commands/intercept)路由会发生得太晚，Cypress将不会处理请求.

幸运的是Cypress支持这个场景。颠倒命令的顺序:

```javascript
// 这段代码可能就是您想要的
cy.intercept('/users/**', {...})
cy.visit('http://localhost:8000/#/app')
```

Cypress将自动将路由应用到下一个`cy.visit()`，并在任何应用程序代码运行之前执行。

## 规则

### 需要 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Chains-of-Commands)

<List><li>`cy.visit()` 需要链在`cy`后 .</li><li>`cy.visit()` 需要响应内容是`content-type: text/html`.</li><li>`cy.visit()` 在被重定向后，需要最终的响应状态码为 `2xx` .</li><li>`cy.visit()` 需要 `load` 事件最终被触发.</li></List>

### 断言 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Assertions)

<List><li>`cy.visit()` 将自动等待已链接的断言通过</li></List>

### 超时 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Timeouts)

<List><li>`cy.visit()` 等待页面触发`load`'事件,直至超时.</li><li>`cy.visit()` 等待链接的断言通过，直至超时.</li></List>

## 命令日志

**_在`beforeEach`中访问示例应用程序_**

```javascript
beforeEach(() => {
  cy.visit('https://example.cypress.io/commands/viewport')
})
```

上面的命令将在命令日志中显示为:

<DocsImage src="/img/api/visit/visit-example-page-in-before-each-of-test.png" alt="Command Log visit" ></DocsImage>

当单击命令日志中的`visit`时，控制台输出如下内容:

<DocsImage src="/img/api/visit/visit-shows-any-redirect-or-cookies-set-in-the-console.png" alt="console Log visit" ></DocsImage>

## 历史

| Version                                       | Changes                                                                          |
| --------------------------------------------- | -------------------------------------------------------------------------------- |
| [3.5.0](/guides/references/changelog#3-5-0)   | Added support for options `qs`                                                   |
| [3.3.0](/guides/references/changelog#3-3-0)   | Added support for options `retryOnStatusCodeFailure` and `retryOnNetworkFailure` |
| [3.2.0](/guides/references/changelog#3-2-0)   | Added options `url`, `method`, `body`, and `headers`                             |
| [1.1.3](/guides/references/changelog#1-1-3)   | Added option `failOnStatusCode`                                                  |
| [0.18.2](/guides/references/changelog#0-18-2) | Automatically send `Accept: text/html,*/*` request header                        |
| [0.18.2](/guides/references/changelog#0-18-2) | Automatically send `User-Agent` header                                           |
| [0.17.0](/guides/references/changelog#0-17-0) | Cannot `cy.visit()` two different super domains in a single test                 |
| [0.6.8](/guides/references/changelog#0-6-8)   | Added option `log`                                                               |
| [0.4.3](/guides/references/changelog#0-4-3)   | Added option `onBeforeLoad`                                                      |
| [< 0.3.3](/guides/references/changelog#0-3.3) | `cy.visit()` command added                                                       |

## 另请参阅

- [`cy.go()`](/api/commands/go)
- [`cy.reload()`](/api/commands/reload)
- [`cy.request()`](/api/commands/request)
- [配方:启动你的应用](/examples/examples/recipes#Server-Communication)
- [配方:登录-单点登录](/examples/examples/recipes#Logging-In)
- [配方:模拟 `window.fetch`](/examples/examples/recipes#Stubbing-and-spying)
