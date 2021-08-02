---
layout: toc-top
title: 使用Cypress
containerClass: faq
---

## <Icon name="angle-right"></Icon> 如何获取元素的文本内容?

Cypress命令生成jQuery对象，因此您可以调用它们的方法。

如果你试图断言一个元素的文本内容:

```javascript
cy.get('div').should('have.text', 'foobarbaz')
```

如果文本包含[非间断空格](https://en.wikipedia.org/wiki/Non-breaking_space) 实体`&nbsp;`，那么使用Unicode字符`\u00a0`而不是`&nbsp;`。

```html
<div>Hello&nbsp;world</div>
```

```javascript
cy.get('div').should('have.text', 'Hello\u00a0world')
```

您还可以使用[cy.contains](/api/commands/contains) 命令来处理非间断空格实体

```javascript
cy.contains('div', 'Hello world')
```

**提示:** 观看[用非间断空格实体确认文本](https://youtu.be/6CxZuolWlYM) 视频。

如果你想在断言之前处理文本:

```javascript
cy.get('div').should(($div) => {
  const text = $div.text()

  expect(text).to.match(/foo/)
  expect(text).to.include('foo')
  expect(text).not.to.include('bar')
})
```

如果您需要在检查文本是否大于10之前将其转换为数字:

```javascript
cy.get('div').invoke('text').then(parseFloat).should('be.gt', 10)
```

如果需要保存文本的引用或比较值:

```javascript
cy.get('div')
  .invoke('text')
  .then((text1) => {
    // 在这里做更多的事情

    // 单击更改div文本的按钮
    cy.get('button').click()

    // 再次抓取这个div并将其前面的文本与当前的文本进行比较
    cy.get('div')
      .invoke('text')
      .should((text2) => {
        expect(text1).not.to.eq(text2)
      })
  })
```

jQuery的`.text()`方法会自动调用底层`elem.textContent`.如果你想使用`innerText`，你可以做以下操作:

```javascript
cy.get('div').should(($div) => {
  // 访问原生DOM元素
  expect($div.get(0).innerText).to.eq('foobarbaz')
})
```

这相当于Selenium的 `getText()`方法，它返回可见元素的innerText。

## <Icon name="angle-right"></Icon> 我如何得到一个输入值?

Cypress会生成jQuery对象，因此您可以对它们调用方法。

如果你试图断言输入的值:

```javascript
// 对值进行断言
cy.get('input').should('have.value', 'abc')
```

如果你想在断言之前修改或处理文本:

```javascript
cy.get('input').should(($input) => {
  const val = $input.val()

  expect(val).to.match(/foo/)
  expect(val).to.include('foo')
  expect(val).not.to.include('bar')
})
```

如果需要保存文本的引用或比较值:

```javascript
cy.get('input')
  .invoke('val')
  .then((val1) => {
    // do more work here

    // 单击更改输入框的按钮
    cy.get('button').click()

    // 再次获取输入并将其以前的值与当前值进行比较
    cy.get('input')
      .invoke('val')
      .should((val2) => {
        expect(val1).not.to.eq(val2)
      })
  })
```

## <Icon name="angle-right"></Icon> 我如何比较一个事物与另一个事物的值或状态?

我们的[变量和别名指南](/guides/core-concepts/variables-and-aliases)给出了这样做的例子.

## <Icon name="angle-right"></Icon> 我可以将属性的值存储在常量或变量中以供以后使用吗?

是的，有几种方法可以做到这一点。保存值或引用的一种方法是使用[闭包](/guides/core-concepts/variables-and-aliases#Closures).
通常，用户认为他们需要在`const`, `var`, 或 `let`.中存储值。 Cypress建议只在处理可变对象(改变状态)时这样做.

例如如何做到这一点，请阅读我们的[变量和别名指南](/guides/core-concepts/variables-and-aliases).

## <Icon name="angle-right"></Icon> 如何获得使用Cypress找到的元素的原生DOM引用?

Cypress用jQuery包装元素，这样你就可以在[.then()](/api/commands/then)命令中获取本地元素.

```javascript
cy.get('button').then(($el) => {
  $el.get(0)
})
```

## <Icon name="angle-right"></Icon> 如果元素不存在，我怎么做不同的事情?

你问的是条件测试和控制流。

请阅读我们广泛的[条件测试指南](/guides/core-concepts/conditional-testing)，其中详细解释了这一点。

## <Icon name="angle-right"></Icon> 我如何让Cypress等待直到某些东西在DOM中可见?

<Alert type="info">

<strong class="alert-header">牢记</strong>

基于DOM的命令会自动[retry](/guides/core-concepts/retry-ability) ，并在失败之前等待它们相应的元素存在。

</Alert>

Cypress为您提供了许多健壮的方法来[查询DOM](/guides/core-concepts/introduction-to-cypress#Querying-Elements)，所有这些都用重试和超时逻辑包装.

等待元素在DOM中出现的其他方法是通过`timeouts`。 Cypress命令默认超时4秒，然而，大多数Cypress命令有[可定制的超时选项](/guides/references/configuration#Timeouts). 超时可以全局配置，也可以按每个命令配置.

在 [某些场景](/guides/core-concepts/interacting-with-elements#Visibility)下, 您的DOM元素将不可操作. Cypress给你一个强大的[`{force:true}`](/guides/core-concepts/interacting-with-elements#Forcing) 选项，你可以传递给大多数操作命令。

**请阅读**我们的[Cypress核心概念简介](/guides/core-concepts/introduction-to-cypress). 这是理解如何使用Cypress进行测试的最重要的指南.

## <Icon name="angle-right"></Icon> 我如何等待我的应用程序加载?

我们已经看到了这个问题的许多不同版本。根据应用程序的行为方式和测试环境的不同，答案可能会有所不同。下面是这个问题最常见的几个版本。

**_我如何知道我的页面是否已经加载完毕?_**

当您使用`cy.visit()`加载应用程序时, Cypress将等待`load`事件触发. [cy.visit()](/api/commands/visit#Usage)命令加载一个远程页面，直到所有外部资源完成加载阶段才解析. 因为我们希望您的应用程序观察不同的加载时间, 该命令的默认超时设置为60000ms. 如果您访问一个无效的url或[第二唯一域](/guides/guides/web-security#Same-superdomain-per-test), Cypress将记录一个详细但友好的错误消息.

**_在CI中，我如何确保我的服务已经启动?_**

对于这个用例，我们推荐这些很棒的模块:

- [`wait-on`](https://www.npmjs.com/package/wait-on)
- [`start-server-and-test`](https://github.com/bahmutov/start-server-and-test)

**_我如何等待我的请求完成?_**

指定的方法是使用[cy.intercept()](/api/commands/intercept)来定义您的路由。在访问之前为这些路由创建[aliases](/guides/core-concepts/variables-and-aliases#Aliases), 然后您可以使用[cy.wait()](/api/commands/wait#Syntax)显式地告诉Cypress您希望等待哪些路由。. **没有什么神奇的方法可以等待所有的XHRs或Ajax请求完成**。 由于这些请求的异步性质，Cypress不能直观地知道要等待它们。您必须定义这些路由，并能够明确地告诉Cypress您希望等待哪些请求。

## <Icon name="angle-right"></Icon> 我可以测试HTML `<head>`元素吗?

是的，你当然可以。在测试运行程序中执行测试时, 你可以看到整个`window.document`。使用[cy.document()](/api/commands/document)打开控制台中的 `window.document`对象. 您甚至可以在`<head>`元素上进行断言。看看这个例子.

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="Content-Security-Policy" content="default-src 'self'" />
    <meta name="description" content="This description is so meta" />
    <title>Test the HEAD content</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
  </head>
  <body></body>
</html>
```

```js
describe('document元数据', () => {
  beforeEach(() => {
    cy.visit('/')
  })

  it('使用 `cy.document()`查看里面的head内容', () => {
    // 这将生成整个window.document对象
    // 如果您从命令日志中单击DOCUMENT,
    // 它将把整个document输出到控制台
    cy.document()
  })

  // 或者对head元素中的任何元数据进行断言

  it('查看<title>标签内部', () => {
    cy.get('head title').should('contain', 'Test the HEAD content')
  })

  it('查看<meta>标签内部的description', () => {
    cy.get('head meta[name="description"]').should(
      'have.attr',
      'content',
      'This description is so meta'
    )
  })
})
```

## <Icon name="angle-right"></Icon> 当输入无效时，我可以检查表单的HTML表单验证是否显示?

你当然可以。

**测试默认验证错误r**

```html
<form>
  <input type="text" id="name" name="name" required />
  <button type="submit">提交</button>
</form>
```

```js
cy.get('[type="submit"]').click()
cy.get('input:invalid').should('have.length', 1)
cy.get('#name').then(($input) => {
  expect($input[0].validationMessage).to.eq('Please fill out this field.')
})
```

**测试自定义验证错误**

```html
<body>
  <form>
    <input type="email" id="email" name="email" />
    <button type="submit">提交</button>
  </form>
  <script>
    const email = document.getElementById('email')

    email.addEventListener('input', function (event) {
      if (email.validity.typeMismatch) {
        email.setCustomValidity('请输入邮件地址!')
      } else {
        email.setCustomValidity('')
      }
    })
  </script>
</body>
```

```javascript
cy.get('input:invalid').should('have.length', 0)
cy.get('[type="email"]').type('not_an_email')
cy.get('[type="submit"]').click()
cy.get('input:invalid').should('have.length', 1)
cy.get('[type="email"]').then(($input) => {
  expect($input[0].validationMessage).to.eq('请输入邮件地址!')
})
```

更多的例子，请阅读博客文章[Cypress中的HTML表单验证](https://glebbahmutov.com/blog/form-validation-in-cypress/).

## <Icon name="angle-right"></Icon> 我可以使用Cypress降低网络速度吗?

您可以通过访问Developer Tools network面板来限制网络连接. Additionally, 您可以在网络条件内通过选择 **custom > add **添加自己的自定义预设。

我们目前在`cypress run `时不提供选项来模拟网速.

## <Icon name="angle-right"></Icon> 我可以使用新的 ES7 async / await语法吗?

不。Command API的设计方式并不能实现这一点. 这并不是Cypress的限制 - 这是一个非常有意识和重要的设计决策.

Async / await是围绕promise的语法糖，而Cypress命令是promise和流的混合。

如果你好奇，请阅读:

- 我们的[介绍Cypress指南](/guides/core-concepts/introduction-to-cypress#Commands-Are-Asynchronous) 解释了如何设计命令
- 我们的[变量和别名指南](/guides/core-concepts/variables-and-aliases)讨论了处理异步代码的模式

## <Icon name="angle-right"></Icon> 如果我的应用程序使用动态class或动态id，我如何选择或查询元素?

不要使用class或id。您可以向元素添加'`data-*`属性并以这种方式定位它们.

阅读更多关于[选择元素的最佳实践](/guides/references/best-practices#Selecting-Elements)的内容.

## <Icon name="angle-right"></Icon> 我只想在一个特定的文件夹中运行测试。我该怎么做呢?

您可以指定在[cypress run](/guides/guides/command-line#cypress-run)运行过程中要运行的测试文件，方法是[向`--spec`标志传递一个glob](/guides/guides/command-line#cypress-run-spec-lt-spec-gt)匹配您想要运行的文件. 您应该能够通过与要运行测试的特定文件夹相匹配的全局变量。

然而，当使用[cypress open](/guides/guides/command-line#cypress-open)时，该功能不可用.

## <Icon name="angle-right"></Icon> 对于如何定位元素或编写元素选择器，是否有建议的方法或最佳实践?

是的。阅读更多关于[选择元素的最佳实践](/guides/references/best-practices#Selecting-Elements)内容.

## <Icon name="angle-right"></Icon> 当我的应用程序抛出一个未捕获的异常错误时，我可以防止Cypress失败我的测试吗?

 是的.

默认情况下，任何时候，你的应用程序抛出一个未捕获的异常, Cypress会自动失败。

Cypress为此公开了一个事件(在许多其他事件中)，你可以聆听其中之一:

- 调试错误实例本身
- 防止Cypress测试失败

详细记录在[事件目录](/api/events/catalog-of-events) 页面和配方[处理错误](/examples/examples/recipes#Fundamentals).

## <Icon name="angle-right"></Icon> 当一个应用程序没有处理被拒绝的promise时，Cypress会通过测试吗?

默认情况下，是的，Cypress不会在您的应用程序中侦听未处理的promise拒绝事件，因此不会失败. 您可以设置自己的侦听器，但测试失败，请参阅我们的配方[处理错误](/examples/examples/recipes#Fundamentals):
** 译者：注意，这段信息可能已过期，Cypress 版本7 以上，已调整成 自动失败，[处理错误](/examples/examples/recipes#Fundamentals)中的信息是最新的***
```js
// 在cy.visit期间注册监听器
it('未处理的拒绝失败', () => {
  cy.visit('/', {
    onBeforeLoad(win) {
      win.addEventListener('unhandledrejection', (event) => {
        const msg = `UNHANDLED PROMISE REJECTION: ${event.reason}`

        // 让测试失败
        throw new Error(msg)
      })
    },
  })
})

// 可选的: 为这个测试注册侦听器
it('未处理的拒绝失败', () => {
  cy.on('window:before:load', (win) => {
    win.addEventListener('unhandledrejection', (event) => {
      const msg = `UNHANDLED PROMISE REJECTION: ${event.reason}`

      // 让测试失败
      throw new Error(msg)
    })
  })

  cy.visit('/')
})

// 可选的:为所有测试中注册听众
before(() => {
  Cypress.on('window:before:load', (win) => {
    win.addEventListener('unhandledrejection', (event) => {
      const msg = `UNHANDLED PROMISE REJECTION: ${event.reason}`

      // 让测试失败
      throw new Error(msg)
    })
  })
})

it('未处理的拒绝失败', () => {
  cy.visit('/')
})
```

## <Icon name="angle-right"></Icon> 我可以覆盖环境变量或为不同的环境创建配置吗?

是的，您可以通过环境变量、CLI参数、JSON文件和其他方式将配置传递给Cypress。

[请阅读环境变量指南。](/guides/guides/environment-variables)

## <Icon name="angle-right"></Icon> 我可以覆盖或更改浏览器使用的默认user agent吗?

是的. [你可以在配置文件中用`userAgent`覆盖它 (默认配置文件`cypress.json`).](/guides/references/configuration#Browser)

## <Icon name="angle-right"></Icon> 我可以阻止流量去特定的域吗?我想阻止谷歌Analytics或其他外部API提供商.

是的. [你可以在配置文件 (默认配置文件`cypress.json`)中用`blockHosts`来设置.](/guides/references/configuration#Browser)

另外，请查看我们的[Stubbing谷歌Analytics 配方](/examples/examples/recipes#Stubbing-and-spying).

## <Icon name="angle-right"></Icon> 我如何验证调用的分析，如谷歌analytics是正确的?

你可以模拟他们的功能，然后确保他们被调用.

查看我们的[Stubbing谷歌Analytics配方](/examples/examples/recipes#Stubbing-and-spying).

## <Icon name="angle-right"></Icon> 我想测试一个聊天应用程序。我可以使用Cypress同时运行多个浏览器吗?

[我们已经详细地回答了这个问题.](/guides/references/trade-offs#Multiple-browsers-open-at-the-same-time)

## <Icon name="angle-right"></Icon> 我可以测试一个chrome扩展吗?我如何加载我的chrome扩展?

是的。你可以通过[启动浏览器时加载它们](/api/plugins/browser-launch-api)来测试你的扩展。.

## <Icon name="angle-right"></Icon> 如何修改或传递用于启动浏览器的参数?

你使用[`before:browser:launch`](/api/plugins/browser-launch-api)插件事件.

## <Icon name="angle-right"></Icon> 我是否可以进行cy.request()轮询，直到满足条件?

是的。你用[和其他递归循环一样的方法](/api/commands/request#Request-Polling).

## <Icon name="angle-right"></Icon> 我可以使用页面对象模式吗?

是的.

页面对象模式实际上没有任何“特殊”之处。 如果您来自Selenium，那么您可能习惯于创建类的实例，但这完全没有必要，也无关紧要.

“页面对象模式”实际上应该重命名为:“使用函数和创建自定义命令”.

如果你想抽象行为或卷起一系列动作，你可以创建可重用的[API自定义命令](/api/cypress-api/custom-commands). 你也可以使用常规的JavaScript函数，而不用像“页面对象”那样繁琐。.

对于那些希望使用页面对象的人，我们突出显示了用于复制页面对象模式的[最佳实践](/api/cypress-api/custom-commands#Best-Practices).

## <Icon name="angle-right"></Icon> 为什么我的Cypress测试在本地通过了，但在CI中没有通过?

有很多原因导致测试在CI中失败，但在本地通过。其中包括:

- Electron浏览器有一个孤立问题(`cypress run`默认运行在Electron浏览器)
- CI中的测试失败可能会突出显示CI构建过程中的错误
- 在CI中运行应用程序时的时间变量 (例如，在本地超时内解析的网络请求在CI中可能需要更长的时间)
- CI与本地机器之间的机器差异——CPU资源、环境变量等.

要排除测试在CI中失败但在本地通过的原因，可以尝试以下策略:

- 使用Electron在本地进行测试，以确定问题是否特定于浏览器.
- 您还可以通过在CI中使用`--browser`标志运行不同的浏览器来识别特定于浏览器的问题.
- 检查CI构建过程，确保应用程序没有发生任何可能导致测试失败的更改.
- 删除测试中对时间敏感的变量. 例如，在查找依赖于网络请求数据的DOM元素之前，确保网络请求已经完成. 你可以利用[别名](/guides/core-concepts/variables-and-aliases#Aliases).
- 确保为CI运行启用了视频录制或（并）屏幕截图，并在本地运行测试时将录制与命令日志进行比较.

## <Icon name="angle-right"></Icon> 为什么我CI时录制的视频发现测试运行冻结或丢帧?

如果在CI容器中运行测试时没有足够的可用资源，则在持续集成上录制的视频可能会冻结或掉帧. 与任何应用程序一样，需要有所需的CPU来运行Cypress并录制视频. 您可以在[启用内存和CPU日志](/guides/references/troubleshooting#Log-memory-and-CPU-usage)的情况下运行测试，以确定和评估CI中的资源利用率。

如果遇到这个问题，我们建议您切换到功能更强大的CI容器或CI提供商.

## <Icon name="angle-right"></Icon> 如果CI中测试崩溃或挂起，该怎么办?

正如一些用户所注意到的，在CI上运行时，较长的测试挂起甚至崩溃的几率更高.当测试长时间运行时，它的命令和应用程序本身可能会分配比可用内存更多的内存，从而导致崩溃. 崩溃的确切风险取决于应用程序和可用的硬件资源.虽然没有单一的时间限制来解决这个问题，但一般来说，我们建议拆分spec文件，每个文件的运行时间不超过一分钟. 你可以阅读博客文章[通过拆分spec使Cypress运行得更快](https://glebbahmutov.com/blog/split-spec/) 来学习如何拆分spec文件。

您可以进一步分割各个长时间运行的测试. 例如，您可以在单独的测试中验证较长的用户功能的部分，如[使用App Actions将非常长的Cypress测试分割为较短的测试](https://www.cypress.io/blog/2019/10/29/split-a-very-long-cypress-test-into-shorter-ones-using-app-actions/) 中所述。.

## <Icon name="angle-right"></Icon> 我如何让测试并行执行?

你可以在[这里](/guides/guides/parallelization)阅读更多关于并行化的内容。.

## <Icon name="angle-right"></Icon> 我可以运行单个测试或一组测试吗?

您可以通过在测试集或特定测试上放置[`.only`](/guides/core-concepts/writing-and-organizing-tests#Excluding-and-Including-Tests)来运行一组测试或单个测试.

您可以通过传递`--spec`标志到[cypress run](/guides/guides/command-line#cypress-run)来运行单个测试文件或一组测试。.

## <Icon name="angle-right"></Icon> 如何测试上传文件?

在你的应用程序中上传文件是可能的，但这取决于你如何编写自己的上传代码。 许多人通过使用社区插件[cypress-file-upload](https://github.com/abramenal/cypress-file-upload)获得了成功. 这个插件添加了一个自定义子命令`.attachFile`。

```javascript
// 附加文件 cypress/fixtures/data.json
cy.get('[data-cy="file-input"]').attachFile('data.json')
```

你可以在[这个问题](https://github.com/cypress-io/cypress/issues/170)中阅读更多关于上传文件的内容。.

## <Icon name="angle-right"></Icon> projectId是做什么用的?

“projectId”是一个6个字符的字符串，一旦你[设置好要记录的测试](/guides/dashboard/runs)，它就可以帮助识别你的项目。它是由Cypress生成的，通常是在您的[配置文件(默认是`Cypress.json`)](/guides/references/configuration) 中.

```json
{
  "projectId": "a7bq2k"
}
```

要了解更多细节，请参阅[Dashboard 服务](/guides/dashboard/projects#Identification)文档中的[Identification](/guides/dashboard/introduction)部分.

## <Icon name="angle-right"></Icon> 什么是记录密钥?

一个 _记录密钥_ 是一个GUID，它当你已经[设置记录你的测试](/guides/dashboard/runs)，由Cypress自动生成的。 它有助于识别您的项目，并验证您的项目是否 _允许_ 记录测试.

您可以在Test Runner中的_Settings_选项卡中找到项目的记录密钥.

<DocsImage src="/img/dashboard/record-key-shown-in-desktop-gui-configuration.jpg" alt="Record Key in Configuration Tab" ></DocsImage>

要了解更多细节，请参阅[Dashboard 服务](/guides/dashboard/projects#Identification)文档中的[Identification](/guides/dashboard/introduction)部分..

## <Icon name="angle-right"></Icon> 我如何检查邮件是否已发出?

<Alert type="warning">

<strong class="alert-header">Anti-Pattern</strong>

不要尝试使用UI去查看邮件。相反，选择以编程方式使用第三方api或直接与服务器对话. 在这里阅读有关[最佳实践](/guides/references/best-practices#Visiting-external-sites).

</Alert>

1. 如果您的应用程序在本地运行并直接通过SMTP服务器发送电子邮件，您可以使用在Cypress test Runner中运行的临时本地测试SMTP服务器。详情请阅读博客文章[“使用Cypress测试HTML邮件”](https://www.cypress.io/blog/2021/05/11/testing-html-emails-using-cypress/).
2. 如果您的应用程序正在使用第三方电子邮件服务，或者您不能“挡板”SMTP请求，那么您可以使用带有API访问的测试电子邮件收件箱。详情请阅读博客文章[“使用SendGrid和Ethereal账户测试HTML邮件”](https://www.cypress.io/blog/2021/05/24/full-testing-of-html-emails-using-ethereal-accounts/) .

Cypress甚至可以在浏览器中加载接收到的HTML电子邮件，以验证电子邮件的功能和视觉风格:

<DocsImage
  src="/img/guides/references/email-test.png"
  title="The HTML email loaded during the test"
  alt="The test finds and clicks the Confirm registration button"></DocsImage>

3. 您可以使用第三方电子邮件服务提供临时电子邮件地址进行测试. 有些服务甚至提供了一个[Cypress插件](/plugins/directory#Email)来访问电子邮件.

## <Icon name="angle-right"></Icon>我如何等待对同一个url的多个请求?

您应该设置一个别名(使用[`.as()`](/api/commands/as))，以匹配所有XHRs的单个[`cy.intercept()`](/api/commands/intercept). 然后可以对它进行多次 [`cy.wait()`](/api/commands/wait)操作. Cypress会跟踪有所有匹配的请求.

```javascript
cy.intercept('/users*').as('getUsers')
cy.wait('@getUsers') // 等待第一次 GET to /users/
cy.get('#list>li').should('have.length', 10)
cy.get('#load-more-btn').click()
cy.wait('@getUsers') // 等待第二次 GET to /users/
cy.get('#list>li').should('have.length', 20)
```

## <Icon name="angle-right"></Icon> 我如何在测试数据库上 造数或重置?

您可以使用[`cy.request()`](/api/commands/request), [`cy.exec()`](/api/commands/exec), 或 [`cy.task()`](/api/commands/task)与您的后端就造数通信.

你也可以直接使用[`cy.intercept()`](/api/commands/intercept)将模拟请求响应，这样就避免了数据库的麻烦.

## <Icon name="angle-right"></Icon> 如何测试iframe中的元素?

我们有一个[开放提案](https://github.com/cypress-io/cypress/issues/685)来扩展api，以支持“切换到”iframe，然后退出它们.

## <Icon name="angle-right"></Icon> 如何在测试之间保存 cookie 和 localStorage?

默认情况下，Cypress自动[在每次测试前清除所有cookie](/api/commands/clearcookies)以防止状态构建。

你可以使用[Cypress.Cookies api](/api/cypress-api/cookies)，在多个测试之间保存特定的cookie :

```javascript
// 现在，任何名为“session_id”的cookie都
// 不会在每次测试运行前不被清除
Cypress.Cookies.defaults({
  preserve: 'session_id',
})
```

您目前**无法** 跨测试 保留localStorage，可以在[此问题](https://github.com/cypress-io/cypress/issues/461#issuecomment-325402086)中读取更多信息。.

## <Icon name="angle-right"></Icon> 我的一些元素进入动画;我该如何解决这个问题呢?

通常你可以通过断言 [`.should('be.visible')`](/api/commands/should) 或 [其他断言](/guides/core-concepts/introduction-to-cypress#Assertions)来期望进入动画的元素的最后状态.

```javascript
// 假设一个点击事件导致了动画
cy.get('.element').click().should('not.have.class', 'animating')
```

如果动画特别长，您可以通过增加断言之前的前一个命令的`timeout`来延长Cypress等待断言通过的时间.

```javascript
cy.get('button', { timeout: 10000 }) // 等待这个“按钮”存在10秒
  .should('be.visible') //并且是可见的

cy.get('.element')
  .click({ timeout: 10000 })
  .should('not.have.class', 'animating')
// 最长等待10秒.element将没有'animating'class
```

然而，大多数时候你甚至不需要担心动画. 为什么不需要呢? Cypress通过动作命令，如`.click()`或`.type()`与元素交互，将[自动等待](/guides/core-concepts/interacting-with-elements)元素停止动画.

## <Icon name="angle-right"></Icon> 我可以测试会打开新标签页的link吗?

由于各种原因，Cypress不支持也可能永远不支持多标签（tab）页。

幸运的是，有许多清晰和安全的变通方法可以让您在应用程序中测试此行为。

[请阅读关于标签页处理和链接的菜谱，了解如何测试link](/examples/examples/recipes#Testing-the-DOM)

## <Icon name="angle-right"></Icon> 我可以动态测试多个视口吗?

是的,你可以。我们提供了一个[示例](/api/commands/viewport#Width-Height).

## <Icon name="angle-right"></Icon> 我可以在多个子域上运行相同的测试吗?

是的。在这个例子中，我们循环了一个url数组并在logo上进行断言.

```javascript
const urls = ['https://docs.cypress.io', 'https://www.cypress.io']

describe('Logo', () => {
  urls.forEach((url) => {
    it(`应该在多个${url}上显示logo`, () => {
      cy.visit(url)
      cy.get('#logo img').should('have.attr', 'src').and('include', 'logo')
    })
  })
})
```

<DocsImage src="/img/faq/questions/command-log-of-dynamic-url-test.png" alt="Command Log multiple urls" ></DocsImage>

## <Icon name="angle-right"></Icon> 如何在Cypress中 require 或 import node的模块?

你用Cypress编写的代码是在浏览器中执行的，所以你可以 require 或 import 任意能在浏览器中工作的JS模块.

你可以像你习惯的那样`require` or `import`它们. 我们用webpack和Babel对你的spec文件进行预处理。

我们建议使用以下方法之一在浏览器外执行代码. 此外，通过在配置中设置[nodeVersion](/guides/references/configuration#Node-version)，您可以在代码执行期间使用自己的Node版本.

- [`cy.task()`](/api/commands/task)通过[pluginsFile](/guides/references/configuration#Folders-Files)在Node中运行代码
- [`cy.exec()`](/api/commands/exec)执行shell命令

[查看“Node Modules”示例菜谱.](/examples/examples/recipes#Fundamentals)

## <Icon name="angle-right"></Icon> 有没有办法给你的代理提供正确的SSL证书，这样页面就不会显示为“不安全”?

没有，Cypress实时修改网络流量，因此必须位于服务器和浏览器之间. 我们没有其他的方法来实现这一点.

## <Icon name="angle-right"></Icon> 有没有办法检测我的应用程序是否在Cypress下运行?

在你的**应用程序代码**中，可以检查`window.Cypress`是否存在。。

这里有一个例子:

```javascript
if (window.Cypress) {
  // 我们在Cypress中运行
  // 可以在这里做些不同的事情
  window.env = 'test'
} else {
  // 我们在一个常规场景中的浏览器中运行
}
```

## <Icon name="angle-right"></Icon> 测试支持 before, before each, after, or after each钩子 吗?

是的。你可以在[这里](/guides/core-concepts/writing-and-organizing-tests#Hooks)阅读更多.

## <Icon name="angle-right"></Icon> 我试图在我的CI中 安装Cypress，但我得到了错误: `EACCES: permission denied`.

首先，确保您的系统上安装了[Node](https://nodejs.org) 。 `npm`是一个Node包，当你安装Node时默认全局安装，并且需要安装我们的[`cypress` npm 包](/guides/guides/command-line).

接下来，你需要检查你是否有正确的安装权限，或者你可能需要运行 `sudo npm install cypress`.

## <Icon name="angle-right"></Icon> 有没有一种方法来测试一个文件被下载了? 我想测试一下点击按钮是否会触发下载.

有很多方法可以测试，所以要视情况而定。您需要了解导致下载的实际机制，然后考虑测试该机制的方法.

如果您的服务器发送特定的配置头，导致浏览器提示下载，您可以找出这个请求的URL，并使用[cy.request()](/api/commands/request)直接命中该请求. 然后您可以测试服务器是否发送了正确的响应头.

如果它是一个启动下载的link，你可以测试它是否有正确的`href`属性. 只要您能够验证单击按钮将发出正确的HTTP请求，这就足够进行测试了。

最后，如果你想真正下载文件并验证其内容，请查看我们的[文件下载](https://github.com/cypress-io/cypress-example-recipes#testing-the-dom) 食谱.

最后，取决于您是否了解您的实现并进行足够的测试以覆盖所有内容.

## <Icon name="angle-right"></Icon> 有可能在Cypress中 ，catch promise吗?

不能。不能为命令添加`catch`捕获失败。 [阅读更多关于Cypress的命令不是promise](/guides/core-concepts/introduction-to-cypress#Commands-Are-Not-Promises)

## <Icon name="angle-right"></Icon> 有办法修改截屏或视频的分辨率吗?

有一个[open中的问题]((https://github.com/cypress-io/cypress/issues/587))在讨论是否更简单配置.

你可以在无头运行时修改屏幕截图和视频大小，采用[这个变通方法](/api/plugins/browser-launch-api#Set-screen-size-when-running-headless).

## <Icon name="angle-right"></Icon>Cypress支持ES7吗?

是的。你可以使用我们的一个[预处理器插件](/plugins/directory)或 [编写自己的自定义预处理器](/api/plugins/preprocessors-api)来 自定义spec 是如何预处理处理 .

通常情况下，你会重用现有的Babel和webpack配置.

## <Icon name="angle-right"></Icon> 如何确定最新版本的Cypress是什么?

有几种方法.

- 最简单的方法可能是查看我们的[更新日志](/guides/references/changelog).
- 你也可以在[这里](https://download.cypress.io/desktop.json) 查看最新版本.
- 它也一直在我们的[代码库]中(https://github.com/cypress-io/cypress).

## <Icon name="angle-right"></Icon> Cypress有一个ESLint插件或一个全局变量清单吗?

是的!看看我们的[ESLint插件](https://github.com/cypress-io/eslint-plugin-cypress). 它将设置运行Cypress所需的所有全局变量，包括浏览器全局变量和[Mocha](https://mochajs.org/) 全局变量.

## <Icon name="angle-right"></Icon> 当我直接访问我的网站时，证书被验证，但是通过Cypress启动的浏览器显示它“不安全”。为什么?

当使用Cypress测试HTTPS站点时，您可能会在浏览器URL旁边看到一个浏览器警告. 这是正常的。Cypress修改您的服务器和浏览器之间的通信. 浏览器注意到这一点并显示一个证书警告.然而，这纯粹是装饰，不会以任何方式改变测试中的应用程序的运行方式，所以您可以安全地忽略此警告. Cypress和后端服务器之间的网络通信仍然是通过HTTPS进行的.

参见[Web安全](/guides/guides/web-security)指南.

## <Icon name="angle-right"></Icon> 是否可以在开发人员工具打开的情况下在CI中运行Cypress? 我们想跟踪 network 和console 输出的问题.

不。目前没有一种方式运行Cypress在` Cypress运行`时，打开开发者工具. 如果你喜欢这个功能，请参考[这个问题](https://github.com/cypress-io/cypress/issues/2024).

你可以试着在本地运行测试并[选择 Electron浏览器](/guides/guides/launching-browsers#Electron-Browser)，这就近似于 你打开开发者员工具并复制`cypress run`期间运行的环境一样。

## <Icon name="angle-right"></Icon> 如何同时运行前端启动服务和测试，然后关闭服务?

要启动前端服务，并运行测试，然后关闭前端服务，我们推荐[这些npm工具](/guides/continuous-integration/introduction#Boot-your-server).

## <Icon name="angle-right"></Icon> 我可以测试我的Electron应用程序吗?

测试你的Electron子应用程序不会“只是工作”，因为Cypress是设计来测试任何运行在浏览器的应用。而Electron是一个浏览器应用+Node应用。

也就是说，我们使用Cypress来测试我们自己的桌面应用程序的前端——通过模拟拦截Electron的事件. 这些测试是开源的，所以你可以在 [这里](https://github.com/cypress-io/cypress/tree/develop/packages/desktop-gui/cypress/integration) 查看它们 。

## <Icon name="angle-right"></Icon>我发现了一个漏洞!我该怎么办?

- 搜索现有的[open中的问题](https://github.com/cypress-io/cypress/issues)，它可能已经被报告!
- 更新Cypress。您的问题可能已经[被修复](/guides/references/changelog).
- [打开一个问题](https://github.com/cypress-io/cypress/issues/new/choose). 快速查看bug的最佳机会是提供一个存储库，其中包含可以克隆和运行的可复制bug。

## <Icon name="angle-right"></Icon> 组织测试的最佳实践是什么?

我们看到组织开始Cypress时，通过在单独的代码库中放置端到端测试. 这是一个很棒的实践，可以让团队成员在几分钟内完成一些测试原型，并对Cypress进行评估. 随着时间的推移和测试数量的增加，我们强烈建议将端到端测试移到前端代码旁边. 这带来了很多好处:

- 让开发人员更快地编写端到端测试
- 保持测试和所测试的功能同步
- 每次代码更改时都可以运行测试
- 允许在应用程序代码和测试之间共享代码(如选择器)

## <Icon name="angle-right"></Icon> 自定义命令和实用函数之间的如何 正确平衡?

在[自定义命令](/api/cypress-api/custom-commands#Best-Practices)指南中，已经有一大块内容讨论了自定义命令和实用函数之间的权衡. 我们认为可重用的功能通常是可行的。另外，它们不会混淆[像自定义命令一样的智能感知](https://github.com/cypress-io/cypress/issues/1065).

## <Icon name="angle-right"></Icon> 我可以在终端中打印来自测试的命令列表吗?

如果测试失败，Cypress将获取一个截屏，但不会在终端中打印命令列表，只打印失败的断言. 有一个用户空间插件[cypress-failed-log](https://github.com/bahmutov/cypress-failed-log) ，它保存一个JSON文件，其中包含来自失败测试的所有命令。

## <Icon name="angle-right"></Icon> 我的测试可以与 Redux 或 Vuex数据存储交互吗?

通常，端到端测试通过公共浏览器api (DOM、网络、存储等)与应用程序交互。 但有时您可能希望对应用程序数据存储中的数据进行断言. Cypress帮你做到这一点. 测试在同一个浏览器实例中正确运行，可以使用[`cy.window`](/api/commands/window)进入应用程序的上下文。通过有条件地从应用程序代码中公开应用程序引用和数据存储，可以允许测试对数据存储进行断言，甚至通过Redux操作驱动应用程序。

- 参见[测试 Redux Store](https://www.cypress.io/blog/2018/11/14/testing-redux-store/)博客文章和[Redux测试](/examples/examples/recipes#Blogs)食谱.
- 参见[使用Vuex数据存储和REST后端测试Vue web应用程序](https://www.cypress.io/blog/2017/11/28/testing-vue-web-application-with-vuex-data-store-and-rest-backend/) 博客文章和[Vue + Vuex + REST测试](/examples/examples/recipes#Blogs)食谱。

## <Icon name="angle-right"></Icon> 如何 模拟间谍 console.log?

要模拟监视`console.log`，你应该使用[cy.stub()](/api/commands/stub).

```javascript
cy.visit('/', {
  onBeforeLoad(win) {
    cy.stub(win.console, 'log').as('consoleLog')
  },
})

//...
cy.get('@consoleLog').should('be.calledWith', 'Hello World!')
```

还有，看看我们的[模拟 `console` 食谱](/examples/examples/recipes#Stubbing-and-spying).

## <Icon name="angle-right"></Icon> 如何在`cy.get()`时使用特殊字符 ?

特殊字符，如`/`, `.`，[根据CSS规范](https://www.w3.org/TR/html50/dom.html#the-id-attribute) ，是id的有效字符.

要测试id中包含这些字符的元素，需要使用[`CSS.escape`](https://developer.mozilla.org/en-US/docs/Web/API/CSS/escape) 或 [`Cypress.$.escapeSelector`](https://api.jquery.com/jQuery.escapeSelector/) 进行转义。.

```html
<!DOCTYPE html>
<html lang="en">
  <body>
    <div id="Configuration/Setup/TextField.id">Hello World</div>
  </body>
</html>
```

```js
it('test', () => {
  cy.visit('index.html')
  cy.get(`#${CSS.escape('Configuration/Setup/TextField.id')}`).contains(
    'Hello World'
  )

  cy.get(
    `#${Cypress.$.escapeSelector('Configuration/Setup/TextField.id')}`
  ).contains('Hello World')
})
```

注意`cy.$$.escapeSelector()`不起作用。 `cy.$$`并不是引用`jQuery`.它只查询DOM. [了解更多原因](/api/utilities/$#Notes)

## <Icon name="angle-right"></Icon> 我可以使用Cypress测试图表和图形吗?

是的。您可以利用可视化测试工具来测试图表和图形是否按照预期的方式呈现. 要了解更多信息，请查看[视觉测试指南](/guides/tooling/visual-testing)和下面的博客文章。

- 参见[用Cypress测试应用程序图表](https://glebbahmutov.com/blog/testing-a-chart/)
- 参见[用Cypress和Percy.io测试应用程序如何渲染绘图](https://glebbahmutov.com/blog/testing-visually/)

## <Icon name="angle-right"></Icon> 为什么`instanceof Event`不起作用?

可能是因为在Cypress Test Runner中有两个不同的窗口. 欲了解更多信息，请点击[此处提示](/api/commands/window#Cypress-uses-2-different-windows).

## <Icon name="angle-right"></Icon> 我可以使用Cucumber来编写测试吗?

是的,你可以。您可以编写包含Cucumber场景的特性文件，然后使用Cypress在spec文件中编写步骤定义. 然后，一个特殊的预处理器将场景和步骤定义转换为“常规”JavaScript Cypress测试。

- 尝试使用[Cucumber preprocessor](https://github.com/TheBrainFamily/cypress-cucumber-preprocessor)，并搜索我们的[Plugins](/plugins/directory) 页面，以获得更多的帮助插件
- 阅读[Cypress 超级模式:如何提高测试集的质量](https://dev.to/wescopeland/cypress-super-patterns-how-to-elevate-the-quality-of-your-test-suite-1lcf) ，了解编写Cucumber测试时的最佳实践
- take a look at [briebug/bba-cypress-quickstart](https://github.com/briebug/bba-cypress-quickstart) example application

## <Icon name="angle-right"></Icon> 我可以使用Cypress测试Next.js 网站吗?

是的,当然。在[next-and-cypress-example](https://github.com/bahmutov/next-and-cypress-example) 库中可以看到一个示例，在那里我们展示了如何检测应用程序的源代码，以从测试中获得[代码覆盖率](/guides/tooling/code-coverage). 你可以在这个[教程](https://getstarted.sh/bulletproof-next/e2e-testing-with-cypress) 中学习如何为Next.js应用程序设置Cypress测试。

## <Icon name="angle-right"></Icon> 我可以使用Cypress测试 Gatsby.js网站吗?

是的，你可以在官方的[Gatsby文档](https://www.gatsbyjs.com/docs/end-to-end-testing/) 中读到. 您还可以观看“Cypress + Gatsby网络研讨会”的视频(https://www.youtube.com/watch?v=Tx6Lg9mwcCE)和浏览网络研讨会的幻灯片(https://cypress.slides.com/amirrustam/cypress-gatsby-confidently-fast-web-development)。

## <Icon name="angle-right"></Icon> 我可以使用Cypress测试React应用程序吗?

是的,当然。一个经过充分测试的React应用程序的好例子是我们的[Cypress RealWorld App](https://github.com/cypress-io/cypress-example-realworld) 和 [TodoMVC Redux App](https://github.com/cypress-io/cypress-example-todomvc-redux) 。 您甚至可以在测试您的应用程序时使用React DevTools，请阅读[连接Cypress和React DevTools的最简单的方法](https://dev.to/dmtrkovalenko/the-easiest-way-to-connect-cypress-and-react-devtools-5hgm). 如果你真的需要根据名称、道具或状态选择React组件，请查看[cypress-react-selector](https://github.com/abhinaba-ghosh/cypress-react-selector).

最后，你可能想看看[React 组件测试](/guides/component-testing/introduction) 适配器，它允许你在Cypress中测试React组件。

## <Icon name="angle-right"></Icon> 我可以使用Cypress检查 GraphQL网络调用吗?

是的，通过使用更新的API命令[cy.intercept()](/api/commands/intercept)，如[Smart GraphQL Stubbing in Cypress](https://glebbahmutov.com/blog/smart-graphql-stubbing/) 博客中描述的，或通过使用[Cypress - GraphQL -mock](https://github.com/tgriesser/cypress-graphql-mock)插件。

## <Icon name="angle-right"></Icon> Cypress可以用于基于模型的测试吗?

可以，例如，请参阅由Curiosity Software主办的[网络研讨会](https://www.youtube.com/watch?v=U30BKedA2CY) . 此外，由于我们的[Real World App (RWA)](https://github.com/cypress-io/cypress-realworld-app) 是使用XState模型状态库实现的，我们正在寻找使基于模型的测试更简单和更强大的方法. 读取我们开始的[访问XState从Cypress Test](https://glebbahmutov.com/blog/cypress-and-xstate/)。

## <Icon name="angle-right"></Icon> Cypress可以用于性能测试吗?

Cypress不是为性能测试而构建的。因为Cypress检测被测试页面，代理网络请求，并严格控制测试步骤，所以test Runner增加了自己的开销. 因此，您从Cypress测试中得到的性能数字比“正常”使用要慢. 不过，您仍然可以访问原生`window.performance`对象并获取页面时间度量，请参见[评估性能指标](https://github.com/cypress-io/cypress-example-recipes#testing-the-dom) 食谱.你也可以通过[Cypress -audit](https://www.npmjs.com/package/cypress-audit) 社区插件[直接从Cypress运行灯塔审计](https://www.mariedrake.com/post/web-performance-testing-with-google-lighthouse)。

## <Icon name="angle-right"></Icon> Cypress能测试 WASM 代码吗?

是的，阅读博客文章[Cypress WASM示例](https://glebbahmutov.com/blog/cypress-wasm-example/). 我们欢迎更多的用户反馈，使WASM测试更简单.

## <Icon name="angle-right"></Icon> 我可以使用Cypress 作为应用的文档吗?

端到端测试是保持应用程序文档准确和最新的一种很好的方法. 阅读[Cypress Book](https://glebbahmutov.com/blog/cypress-book/) 博客文章，并查看[Cypress -movie](https://github.com/bahmutov/cypress-movie)项目。

## <Icon name="angle-right"></Icon> 我可以使用Jest快照吗?

虽然Cypress中没有内置的“快照”命令，但您可以创建自己的快照断言命令。 请参阅我们的博客文章[端到端快照测试](https://www.cypress.io/blog/2018/01/16/end-to-end-snapshot-testing/). 我们推荐使用第三方模块[cypress-plugin-snapshots](https://github.com/meinaart/cypress-plugin-snapshots). 其他快照插件，请搜索[plugins](/plugins/directory) 页.

## <Icon name="angle-right"></Icon> 我可以使用Testing Library?

绝对的!您可以随意添加[@testing-librarycypress](https://testing-library.com/docs/cypress-testing-library/intro/)到您的设置中，并使用它的方法，如`findByRole`, `findByLabelText`, `findByText`, `findByTestId`等来查找DOM元素。

下面的示例来自Testing Library的文档

```js
cy.findByRole('button', { name: /Jackie Chan/i }).click()
cy.findByRole('button', { name: /Button Text/i }).should('exist')
cy.findByRole('button', { name: /Non-existing Button Text/i }).should(
  'not.exist'
)

cy.findByLabelText(/Label text/i, { timeout: 7000 }).should('exist')

// findAllByText _inside_ a form element
cy.get('form')
  .findByText('button', { name: /Button Text/i })
  .should('exist')

cy.findByRole('dialog').within(() => {
  cy.findByRole('button', { name: /confirm/i })
})
```

我们与[Roman Sandler](https://twitter.com/RomanSndlr)进行了一次网络研讨会，在那里他给出了使用Testing Library编写有效测试的实用建议。 你可以在[这里](https://www.cypress.io/blog/2020/07/15/webcast-recording-build-invincible-integration-tests-using-cypress-and-cypress-testing-library/)找到录音和幻灯片.
