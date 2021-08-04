---
title: Web安全
---

浏览器遵循严格的[同源策略](https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy). 这意味着当浏览器的原始策略不匹配时，它们会限制在`<iframes>` 之间的访问.

因为Cypress在浏览器中工作，所以Cypress必须能够在任何时候直接与您的远程应用程序通信. 不幸的是，浏览器很自然地试图阻止Cypress这样做.

为了绕过这些限制，Cypress实现了一些策略，包括JavaScript代码、浏览器的内部api和网络代理，以遵循同源策略的规则. 我们的目标是完全自动化测试中的应用程序，而不需要修改应用程序的代码 -我们基本上做到了这一点。

#### 以下是Cypress的底层行为:

- 将[`document.domain`](https://developer.mozilla.org/en-US/docs/Web/API/Document/domain) 注入到`text/html`页面.
- 代理所有HTTP/HTTPS通信。
- 更改host URL以匹配被测试应用程序的URL.
- 使用浏览器的内部api进行网络级通信.

当Cypress首次加载时，内部的Cypress web应用程序托管在一个随机端口上: 比如 `http://localhost:65874/__/`.

在测试中发出第一个[`cy.visit()`](/api/commands/visit)命令之后，Cypress将更改其URL以匹配远程应用程序的来源，从而解决了同源策略的第一个主要障碍.您的应用程序代码执行的方式与在Cypress之外执行的方式相同，一切都按照预期工作.

<Alert type="info">

<strong class="alert-header">如何支持HTTPS?</strong>

Cypress做了一些非常有趣的事情来让HTTPS测试站点工作. Cypress使您能够在网络级别控制和模拟. 因此，Cypress必须分配和管理浏览器证书，以便能够实时修改通信.

你会注意到Chrome显示一个警告“SSL证书不匹配”. 这是正常和正确的. 在幕后，我们充当自己的CA权威机构，动态地颁发证书，以便拦截无法访问的请求. 我们只对当前正在测试的超级域这样做，并让其他通信直接通过. 这就是为什么如果您在Cypress中打开另一个站点的新标签页，证书正常符合预期.

请注意，Cypress允许您可选地指定用于HTTPS站点的CA客户端证书信息. 请参见[配置客户端证书](/guides/references/client-certificates). 如果远程服务器请求一个配置URL的客户端证书，Cypress将提供它。

</Alert>

## 限制

值得注意的是，尽管我们尽最大努力确保您的应用程序在Cypress中正常工作，但您需要了解一些限制.

### 每个测试都有相同的超域

因为Cypress更改自己的主机URL以匹配您的应用程序的主机URL，所以它要求导航的URL在整个单个测试中具有相同的超域.

如果您试图访问两个不同的超域，Cypress将出错. 访问子域一切正常. 您可以在不同的测试中访问不同的超域，但不能在同一测试中访问.

```javascript
it('navigates', () => {
  cy.visit('https://www.cypress.io')
  cy.visit('https://docs.cypress.io') // 是的，正常
})
```

```javascript
it('navigates', () => {
  cy.visit('https://apple.com')
  cy.visit('https://google.com') // 这将会报错
})
```

```javascript
it('navigates', () => {
  cy.visit('https://apple.com')
})

// 在另一个测试中访问不同的来源
it('navigates to new origin', () => {
  cy.visit('https://google.com') // 是的，正常
})
```

尽管Cypress试图执行这一限制，但您的应用程序有可能绕过Cypress的检测能力.

#### 由于超域限制而出错的测试用例的例子

1. [`.click()`](/api/commands/click)一个 有着 `href`的超链接 `<a>` 跳转到另一个超级域。
2. [`.submit()`](/api/commands/submit)一个`<form>`， 导致你的web服务器重定向到一个不同的超级域。
3. 在应用程序中发出JavaScript重定向，例如 `window.location.href = '...'`, 到一个不同的超级域.

在每一种情况下，Cypress将失去自动化应用程序的能力，并将立即出错.

继续读下去，了解[如何解决这些常见问题](/guides/guides/web-security#Common-Workarounds) 或者 甚至完全[禁用web安全](/guides/guides/web-security#Disabling-Web-Security) .

### 跨源 iframes

如果你的网站嵌入了一个`<iframe>`，这是一个跨源框架，Cypress将不能自动或与这个`<iframe>`通信。

#### 跨源 iframe 的使用场景

- 嵌入Vimeo或YouTube视频。
- 显示来自Stripe或Braintree的信用卡表单。
- 显示来自Auth0的嵌入式登录表单.
- 显示来自Disqus的评论。

实际上，Cypress可以像Selenium一样适应这些情况，但您永远无法从Cypress内部访问这些iframes.

作为一个解决方案，你可以使用[`window.postMessage`](https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage) 直接与这些iframe通信并控制它们(如果第三方iframe支持它)。.

除此之外，您将不得不等待我们实现api来支持它(查看我们的[open 问题](https://github.com/cypress-io/cypress/issues/136)),或者你可以 [禁用web安全](/guides/guides/web-security#Disabling-Web-Security) .

### 不安全的内容

由于Cypress的设计方式，如果您正在测试一个HTTPS网站，Cypress将在您试图导航回一个HTTP网站时，抛出错误. 这种行为有助于突出应用程序的一个相当严重的安全问题.

#### 访问不安全内容的示例

```javascript
// 测试代码
cy.visit('https://app.corp.com')
```

在你的应用程序代码中，你设置了`cookies`并在浏览器中存储了一个会话. 现在让我们假设您的应用程序代码中有一个“`不安全` 链接(或JavaScript重定向).

```html
<!-- 应用程序代码 -->
<html>
  <a href="http://app.corp.com/page2">Page 2</a>
</html>
```

Cypress将立即失败与以下测试代码:

```javascript
// 测试代码
cy.visit('https://app.corp.com')
cy.get('a').click() // 将会失败
```

浏览器拒绝在安全页面上显示不安全的内容。由于Cypress最初将其URL更改为匹配`https://app.corp.com`，当浏览器遵循 `href`为 `http://app.corp.com/page2`时，浏览器将拒绝显示内容.

现在你可能会想, _这听起来像Cypress的一个问题，因为当我与我的应用程序在Cypress之外工作时，它工作得很好._

然而，事实是，Cypress在您的应用程序中暴露了一个安全漏洞，您希望它在Cypress中失败.

未将`secure`标志设置为`true`的`cookies`将以明文形式发送到不安全的URL. 这使得应用程序容易受到会话劫持的攻击.

即使您的web服务器强制`301 redirect`回HTTPS站点，这个安全漏洞仍然存在. 最初的HTTP请求仍然只发出一次，暴露了不安全的会话信息。

#### 解决方案

更新HTML或JavaScript代码，避免导航到不安全的HTTP页面，而只使用HTTPS. 另外，确保cookies的`secure` 标志设置为`true`.

如果你无法控制代码，或者无法解决这个问题，你可以通过[禁用web安全](/guides/guides/web-security#Disabling-Web-Security)绕过Cypress中的限制。.

### 每次测试的端口相同

Cypress要求导航的url在整个测试中具有相同的端口(如果指定了). 这与浏览器的正常[同源策略](https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy) 行为相匹配。.

## 常见的解决方法

让我们研究一下如何在测试代码中遇到跨源错误，并分析如何在Cypress中处理这些错误。

### 外部导航

最常见的情况可能会遇到这个错误是当你点击一个`<a>` 导航到另一个超级域.

```html
<!-- 应用代码，服务开启在 `localhost:8080` -->
<html>
  <a href="https://google.com">Google</a>
</html>
```

```javascript
//测试代码
cy.visit('http://localhost:8080') // 你的web服务器+ HTML托管的地方
cy.get('a').click() // 浏览器试图加载 google.com, Cypress 发出错误
```

我们不建议访问一个你在测试中无法控制的超级域名，你可以在[这里](/guides/references/best-practices#Visiting-external-sites) 阅读更多信息。

相反，您可以测试的是 `href`属性是否正确!

```javascript
// 这个测试会验证行为，并且会运行得更快
cy.visit('http://localhost:8080')
cy.get('a').should('have.attr', 'href', 'https://google.com') // 没有页面需要加载!
```

好吧，但假设你担心`google.com`提供正确的HTML内容. 你会怎么测试呢?我们可以直接向它发送[`cy.request()`](/api/commands/request). [`cy.request()`](/api/commands/request)  _未绑定到CORS或同源策略_.

```javascript
cy.visit('http://localhost:8080')
cy.get('a').then(($a) => {
  // 从<a>中拉出完全限定的href
  const url = $a.prop('href')

  // 向它发出cy.request
  cy.request(url).its('body').should('include', '</html>')
})
```

如果你仍然需要访问一个不同的源URL，那么请阅读[禁用web安全](/guides/guides/web-security#Disabling-Web-Security).

### 表单提交重定向

当您提交一个常规的HTML表单时，浏览器将遵循HTTP(s)请求。

```html
<!-- 在`localhost:8080`上提供的应用程序代码-->
<html>
  <form method="POST" action="/submit">
    <input type="text" name="email" />
    <input type="submit" value="Submit" />
  </form>
</html>
```

```javascript
cy.visit('http://localhost:8080')
cy.get('form').submit() // 提交表单!
```

如果你处理`/submit`路由的后端服务器做了一个`30x`重定向到一个不同的超级域，你会得到一个跨源错误.

```javascript
// 假设这是您的localhost:8080服务器上的node / express 代码

app.post('/submit', (req, res) => {
  // 将浏览器重定向到 google.com
  res.redirect('https://google.com')
})
```

一个常见的场景是单点登录(SSO). 在这种情况下，您可能会 `POST` 到不同的服务器，并被重定向到其他地方(通常在URL中带有会话令牌)。

如果是这种情况，您仍然可以使用[`cy.request()`](/api/commands/request)测试此行为。. [`cy.request()`](/api/commands/request) **没有绑定到CORS或同源策略**.

事实上，我们可以完全绕过初始访问，直接 `POST`到您的SSO服务器.

```javascript
cy.request('POST', 'https://sso.corp.com/auth', {
  username: 'foo',
  password: 'bar',
}).then((response) => {
  // 找出重定向的location
  const loc = response.headers['Location']

  // 从url中解析出令牌(假设它在那里)
  const token = parseOutMyToken(loc)

  // 对令牌做一些你的web应用程序期望的可能与你的SSO在后台所做的相同的行为，假设它处理这样的查询字符串令牌
  cy.visit('http://localhost:8080?token=' + token)

  // 如果不需要使用令牌，有时可以直接访问位置标头
  cy.visit(loc)
})
```

如果您仍然希望能够重定向到您的SSO服务器，您可以阅读[禁用web安全](/guides/guides/web-security#Disabling-Web-Security).

### JavaScript重定向

当我们说JavaScript重定向时，我们指的是任何类似这样的代码:

```javascript
window.location.href = 'http://some.superdomain.com'
```

这可能是最难测试的情况，因为它通常是由于其他原因发生的. 您需要弄清楚为什么JavaScript代码要重定向。 也许您没有登录，您需要在其他地方处理这个设置. 也许您正在使用单点登录(SSO)服务器，您可以阅读前面关于如何处理它的部分。

如果你想继续使用代码导航到不同的超级域，那么你可能想要阅读[禁用web安全](/guides/guides/web-security#Disabling-Web-Security).

## 禁用web安全

因此，如果你不能使用上面建议的解决方法来解决任何问题，你可能想要禁用web安全。

这里需要考虑的最后一件事是，我们每隔一段时间就会在Cypress中发现导致跨源错误的bug，否则这些错误是可以修复的。 如果你认为你正在经历一个bug，[打开一个问题](https://github.com/cypress-io/cypress/issues/new/choose).

<Alert type="warning">

<strong class="alert-header">仅适用于Chrome</strong>

仅支持在基于chrome的浏览器中禁用web安全功能。 在`chromeWebSecurity`中的设置在其他浏览器中将没有效果. 在这种情况下，我们将记录一个警告.

<DocsImage src="/img/guides/chrome-web-security-stdout-warning.jpg" alt='chromeWebSecurity warning in stdout'></DocsImage>

如果您依赖于禁用网络安全，那么您将无法在不支持此功能的浏览器上运行测试。

</Alert>

### 设置`chromeWebSecurity`为 false`

在基于chrome的浏览器中设置`chromeWebSecurity`为 false`允许你做以下操作:

- 显示不安全的内容
- 导航到任何超域没有跨源错误
- 访问嵌入在应用程序中的跨源iframe

您可能会注意到，Cypress仍然使用[`cy.visit()`](/api/commands/visit) 强制访问单个超级域。 但是有一个[打开着的问题](https:github.comcypress-iocypressissues944)来改变这个限制.

还在这里吗?太酷了，让我们禁用web安全吧!

#### 在你的[配置文件(默认是`cypress.json`)](/guides/references/configuration) 中将`chromeWebSecurity`设置为 false`

```json
{
  "chromeWebSecurity": false
}
```
