---
title: 最佳实践
layout: toc-top
---

<Alert type="info">

### <Icon name="graduation-cap"></Icon> 真实世界的实践

Cypress团队维护<Icon name="github"></Icon> [Real World App (RWA)](https://github.com/cypress-io/cypress-realworld-app), 一个完整的堆栈示例应用程序，演示了在实际和现实的场景中使用Cypress的最佳实践和可伸缩策略。

RWA通过[端到端测试](/guides/tooling/code-coverage) 以及[跨多个浏览器](/guides/guides/cross-browser-testing) 和 [设备尺寸](/api/commands/viewport) 实现了完整的[代码覆盖](/guides/tooling/code-coverage)  , 但也包括[视觉回归测试](/guides/tooling/visual-testing), API 测试, 单元测试，以及全部测试都在 [有效的CI管道](https://dashboard.cypress.io/projects/7s5okt) 上运行.

这个应用程序与你需要的所有东西捆绑在一起, [只需克隆存储库](https://github.com/cypress-io/cypress-realworld-app) 并启动测试.

</Alert>

## 组织测试、登录、控制状态

<Alert type="danger">

<Icon name="exclamation-triangle" color="red"></Icon> **反模式:** 共享页面对象，使用UI登录，不使用快捷方式.

</Alert>

<Alert type="success">

<Icon name="check-circle" color="green"></Icon> **最佳实践:** 隔离测试规范，以编程方式登录到应用程序，并控制应用程序的状态.

</Alert>

2018年2月，我们在AssertJS上做了一次“最佳实践”会议演讲。本视频演示如何编写快速、可扩展的测试。

<Icon name="play-circle"></Icon> [https://www.youtube.com/watch?v=5XQOK0v_YRE](https://www.youtube.com/watch?v=5XQOK0v_YRE)

在我们的示例中有几个[登录的食谱](https://github.com/cypress-io/cypress-example-recipes#logging-in-recipes) .

## 选择元素

<Alert type="danger">

<Icon name="exclamation-triangle" color="red"></Icon> **反模式:** 使用易变化的易脆选择器。

</Alert>

<Alert type="success">

<Icon name="check-circle" color="green"></Icon> **最佳实践:** 使用`data-*`属性为您的选择器提供上下文，并将它们与CSS或JS变更隔离。

</Alert>

您编写的每个测试都将包含元素的选择器。为了避免很多麻烦，您应该编写能够适应变更的选择器。

我们经常看到用户在定位他们的元素时遇到问题，因为:

- 您的应用程序可能会使用动态class或变化的id
- 你的选择器被对CSS样式或JS行为的开发变更破坏

幸运的是，这两个问题都是可以避免的.

1. 不要基于CSS属性来定位元素，比如: `id`, `class`, `tag`
2. 不要定位那些可能变更`textContent`的元素
3. 添加`data-*` 属性，使定位元素更容易

### 如何运作:

给定一个我们想要交互的按钮:

```html
<button
  id="main"
  class="btn btn-large"
  name="submission"
  role="button"
  data-cy="submit"
>
  Submit
</button>
```

让我们研究一下如何定位它:

| 选择器                                 | 是否推荐                                                            | 注意                                                           |
| ------------------------------------- | ------------------------------------------------------------------ | --------------------------------------------------------------- |
| `cy.get('button').click()`            | <Icon name="exclamation-triangle" color="red"></Icon> 从不        | 最糟糕——太笼统了，没有上下文.                                |
| `cy.get('.btn.btn-large').click()`    | <Icon name="exclamation-triangle" color="red"></Icon> 从不        | 差。耦合了样式。很容易改变.              |
| `cy.get('#main').click()`             | <Icon name="exclamation-triangle" color="orange"></Icon> 部分推荐 | 好一点了。但仍然与样式化或JS事件监听器耦合.     |
| `cy.get('[name=submission]').click()` | <Icon name="exclamation-triangle" color="orange"></Icon> 部分推荐 | 耦合到具有HTML语义的`name`属性.       |
| `cy.contains('Submit').click()`       | <Icon name="check-circle" color="green"></Icon> 有条件            | 好多了。但仍然与文本内容相结合，这可能会改变. |
| `cy.get('[data-cy=submit]').click()`  | <Icon name="check-circle" color="green"></Icon> 总是              | 最佳，与所有变化隔离。                                |

通过`tag`, `class` 或 `id` 来定位上面的元素是非常不稳定的，并且极易发生变化. 您可能替换元素，可以重构CSS并更新id，或者可以添加或删除影响元素样式的类。

相反，在元素中添加`data-cy`属性会给我们一个只用于测试的目标选择器。

`data-cy`属性不会因为CSS样式或JS行为的改变而改变，这意味着它不会与元素的行为或样式耦合。

此外，它使每个人都清楚地知道这个元素是由测试代码直接使用的。

<Alert type="info">

<strong class="alert-header">你知道吗?</strong>

[选择器Playground](/guides/core-concepts/test-runner#Selector-Playground)自动遵循这些最佳实践。

当决定一个唯一的选择器时，它会自动选择元素:

- `data-cy`
- `data-test`
- `data-testid`

</Alert>

#### <Icon name="graduation-cap"></Icon> 真实世界的例子

[Real World App (RWA)](https://github.com/cypress-io/cypress-realworld-app) 使用两个有用的自定义命令来选择测试元素:

- `getBySel` 输出具有`data-test`属性的元素，该属性与指定的选择器 **匹配**.
- `getBySelLike` 输出具有`data-test`属性的元素，该属性**包含**指定的选择器。

```ts
// cypress/support/commands.ts

Cypress.Commands.add('getBySel', (selector, ...args) => {
  return cy.get(`[data-test=${selector}]`, ...args)
})

Cypress.Commands.add('getBySelLike', (selector, ...args) => {
  return cy.get(`[data-test*=${selector}]`, ...args)
})
```

> _<Icon name="github"></Icon> 源码: [cypress/support/commands.ts](https://github.com/cypress-io/cypress-realworld-app/blob/develop/cypress/support/commands.ts)_

### 文本内容:

在阅读了以上规则后，你可能会想:

> 如果我总是使用数据属性，那么我应该在什么时候使用 `cy.contains()`?

一个经验法则是问你自己:

如果元素的内容**改变**了，您是否希望测试失败 ?

- 如果答案是肯定的，那就使用 [`cy.contains()`](/api/commands/contains)
- 如果答案是否定的，那么使用data属性.

**例子:**

如果我们再次查看按钮的`<html>` ...

```html
<button id="main" class="btn btn-large" data-cy="submit">提交</button>
```

问题是:`提交`这个文本内容对您的测试有多重要? 如果文本从`提交`更改为`保存`-你希望测试失败吗?

如果答案是肯定的，因为`提交`这个词很重要，不应该被更改，那么就使用[`cy.contains()`](/api/commands/contains) 来定位元素. 这样，如果更改了，测试就会失败.

如果答案是否定的，因为文本可以修改，那就通过data属性使用[`cy.get()`](/api/commands/get) . 将文本更改为`保存`不会导致测试失败.

## 分配返回值

<Alert type="danger">

<Icon name="exclamation-triangle" color="red"></Icon> **反模式:** 尝试分配命令的返回值 `const`, `let`, or `var`.

</Alert>

<Alert type="success">

<Icon name="check-circle" color="green"></Icon> **最佳实践:** 使用[闭包访问和存储](/guides/core-concepts/variables-and-aliases)命令输出的东西.

</Alert>

许多第一次看到Cypress代码的用户认为它是同步运行的.

我们看到新用户通常会编写这样的代码:

```js
// 不要这样做。事情并不像你想的那样.
const a = cy.get('a')

cy.visit('https://example.cypress.io')

// 失败
a.first().click()
```

<Alert type="info">

<strong class="alert-header">你知道吗?</strong>

在Cypress中，你很少需要使用`const`, `let`, 或 `var`. 如果您正在使用它们，则需要进行一些重构.

</Alert>

如果您是Cypress的新手，想更好地理解Commands的工作原理-[请阅读我们的Cypress入门指南](/guides/core-concepts/introduction-to-cypress#Chains-of-Commands).

如果你已经熟悉Cypress命令，但发现自己使用`const`, `let`, 或 `var` ，那么你通常会尝试做以下两件事之一:

- 您试图存储和比较**text**, **classes**, **attributes**等值。
- 你试图在测试和钩子之间共享值，比如`before`和`beforeEach`.

使用这些模式，请阅读我们的[变量和别名指南](/guides/core-concepts/variables-and-aliases).

## 访问外部网站

<Alert type="danger">

<Icon name="exclamation-triangle" color="red"></Icon> **反模式:** 试图访问或与您不控制的网站或服务器进行交互.

</Alert>

<Alert type="success">

<Icon name="check-circle" color="green"></Icon> **最佳实践:** 只测试你所控制的。尽量避免使用第三方服务器。必要时，总是使用[`cy.request()`](/api/commands/request)通过第三方服务器的api与它们对话。

</Alert>

我们的许多用户尝试做的第一件事就是在他们的测试中使用第三方服务器.

在某些情况下，您可能希望访问第三方服务器:

1. 测试登录时，你的应用程序使用另一个提供商的OAuth.
2. 验证您的服务器更新第三方服务器.
3. 检查你的邮件，看看你的服务器是否发送了一个“忘记密码”的邮件.

最初，您可能会试图使用[`cy.visit()`](/api/commands/visit)或使用Cypress来遍历第三方登录窗口。

然而，在测试时你不应该使用你的UI或访问第三方网站，因为:

- 这非常耗时，并且会减慢测试速度.
- 第三方网站可能已更改或更新其内容.
- 第三方网站可能存在您无法控制的问题.
- 第三方网站可能会通过脚本检测到你正在测试并阻止你.
- 第三方网站可能正在运行A/B活动.

让我们来看看一些应对这些情况的策略.

### 当登录时:

许多OAuth提供商会运行A/B实验，这意味着他们的登录屏幕是动态变化的。这使得自动化测试变得困难.

许多OAuth提供商也会限制你向他们发出的网络请求的数量。例如，如果你尝试测试谷歌，谷歌会自动检测到你不是人类，而不是给你一个OAuth登录屏幕，他们会让你填写一个验证码。

此外，通过OAuth提供程序进行测试是可变的——你首先需要在他们的服务上有一个真正的用户，然后修改该用户上的任何东西可能会影响下游的其他测试。

**以下是缓解这些问题的潜在解决方案:**

1. [Stub](apicommandsstub)避开OAuth提供者，并完全绕过使用他们的UI. 您可以欺骗应用程序，使其相信OAuth提供者已将其令牌传递给您的应用程序。
2. 如果你必须得到一个真正的令牌，你可以使用[`cy.request()`](/api/commands/request)并使用你的OAuth提供者提供的编程API。这些api可能更不频繁地更改，您可以避免节流和A/B活动等问题。
3. 您也可以向服务器寻求帮助，而不是让您的测试代码绕过OAuth。也许OAuth令牌所做的只是在数据库中生成一个用户。通常情况下，OAuth只在初始阶段有用，服务器与客户端建立自己的会话。如果是这种情况，使用[`cy.request()`](/api/commands/request)直接从服务器获取会话，完全绕过提供者。

<Alert type="info">

<strong class="alert-header">Recipes</strong>

[在我们的食谱日志中有几个这样做的例子。](/examples/examples/recipes)

</Alert>

### 第三方服务:

有时，您在应用程序中采取的操作可能会影响其他第三方应用程序。这些情况并不常见，但也是可能的。想象你的应用程序集成了GitHub，通过使用你的应用程序，你可以改变GitHub内部的数据.

在运行你的测试时，你可以通过编程方式用[`cy.request()`](/api/commands/request)直接与GitHub的api交互, ，而不是用[`cy.visit()`](api/commands/visit) 访问GitHub页面。

这就避免需要接触另一个应用程序的UI.

### 验证发送电子邮件:

通常，当遇到用户注册或忘记密码等情况时，服务器会安排发送一封电子邮件.

1. 如果您的应用程序在本地运行并直接通过SMTP服务器发送电子邮件，您可以使用在Cypress test Runner中运行的临时本地测试SMTP服务器。详情请阅读博客文章[“使用Cypress测试HTML邮件”](https://www.cypress.io/blog/2021/05/11/testing-html-emails-using-cypress/) .
2. 如果您的应用程序正在使用第三方电子邮件服务，或者您不能模拟SMTP请求的响应，那么您可以使用带有API访问的测试电子邮件收件箱。详情请阅读博客文章[“使用SendGrid和Ethereal账户测试HTML邮件”](https://www.cypress.io/blog/2021/05/24/full-testing-of-html-emails-using-ethereal-accounts/) 。

Cypress甚至可以在浏览器中加载接收到的HTML电子邮件，以验证电子邮件的功能和视觉风格:

<DocsImage
  src="/img/guides/references/email-test.png"
  title="The HTML email loaded during the test"
  alt="测试找到并单击Confirm注册按钮"></DocsImage>

3. 在其他情况下，您应该尝试使用[`cy.request()`](/api/commands/request) 命令查询服务器上的API端点，该端点告诉您哪些电子邮件已经排队或发送。这样你就可以在不涉及UI的情况下通过编程来了解。您的服务器必须公开这个API端点。
4. 您还可以使用`cy.request()`到第三方电子邮件接收服务器，该服务器公开了一个API来读取电子邮件. 然后，您将需要适当的身份验证凭证(服务器可以提供)，或者您可以使用环境变量。一些电子邮件服务已经提供[Cypress插件](/plugins/directory#Email)来访问电子邮件。

## 测试依赖于前面测试的状态

<Alert type="danger">

<Icon name="exclamation-triangle" color="red"></Icon> **反模式:** 将多个测试耦合在一起.

</Alert>

<Alert type="success">

<Icon name="check-circle" color="green"></Icon> **最佳实践:** 测试应该始终能够相互独立地运行，并且始终能够通过.

</Alert>

您只需要做一件事，就可以知道您是否错误地耦合了测试，或者一个测试是否依赖于前一个测试的状态.

在测试中将`it`更改为[`it.only`](https://jestjs.io/docs/api#testonlyname-fn-timeout)，并刷新浏览器.

如果这个测试可以自己运行并通过----恭喜你写了一个好的测试.

如果不是这样，那么您应该重构并更改您的方法.

如何解决这个问题:

- 将之前测试中的重复代码移动到`before`或`before each`钩子上.
- 将多个测试合并为一个更大的测试.

让我们想象下面的测试是如何填写表单的.

```javascript
// 一个不应该做什么的例子
describe('我的表单', () => {
  it('visits the form', () => {
    cy.visit('/users/new')
  })

  it('requires first name', () => {
    cy.get('#first').type('Johnny')
  })

  it('requires last name', () => {
    cy.get('#last').type('Appleseed')
  })

  it('can submit a valid form', () => {
    cy.get('form').submit()
  })
})
```

上面的测试有什么问题?它们都是耦合在一起的!

如果在最后三个测试中将`it`更改为[`it.only`](https://jestjs.io/docs/api#testonlyname-fn-timeout)，它们将失败。每个测试都要求前一个测试以特定的顺序运行，以通过测试.

有两种方法可以解决这个问题:

### 1. 合并成一个测试

```javascript
// 稍微好一点
describe('my form', () => {
  it('can submit a valid form', () => {
    cy.visit('/users/new')

    cy.log('filling out first name') // 如果你真的需要的话
    cy.get('#first').type('Johnny')

    cy.log('filling out last name') // 如果你真的需要的话
    cy.get('#last').type('Appleseed')

    cy.log('submitting form') // 如果你真的需要的话
    cy.get('form').submit()
  })
})
```

现在我们可以加上一个`.only`在这个测试中，它将成功运行，而不管其他任何测试。理想的Cypress工作流是每次编写和迭代一个测试。

### 2. 在每次测试之前运行共享代码

```javascript
describe('my form', () => {
  beforeEach(() => {
    cy.visit('/users/new')
    cy.get('#first').type('Johnny')
    cy.get('#last').type('Appleseed')
  })

  it('displays form validation', () => {
    cy.get('#first').clear() // 去掉名字
    cy.get('form').submit()
    cy.get('#errors').should('contain', 'First name is required')
  })

  it('能提交有效的表单', () => {
    cy.get('form').submit()
  })
})
```

上面的示例是理想的，因为现在我们正在重新设置每个测试之间的状态，并确保以前的测试不会泄露到后续的测试中。

我们还为针对表单的“默认”状态编写多个测试铺平了道路。这样，每个测试都保持精简，但每个测试都可以独立运行并通过。

## 使用单个断言创建“微”测试

<Alert type="danger">

<Icon name="exclamation-triangle" color="red"></Icon> **反模式:** 就像你在写单元测试一样。

</Alert>

<Alert type="success">

<Icon name="check-circle" color="green"></Icon> **最佳实践:** 添加多个断言，不要担心太多了

</Alert>

我们已经看到许多用户编写了这种代码:

```javascript
describe('my form', () => {
  before(() => {
    cy.visit('/users/new')
    cy.get('#first').type('johnny')
  })

  it('有验证attr', () => {
    cy.get('#first').should('have.attr', 'data-validation', 'required')
  })

  it('有 active class', () => {
    cy.get('#first').should('have.class', 'active')
  })

  it('已格式化名字', () => {
    cy.get('#first').should('have.value', 'Johnny') // 大写首字母
  })
})
```

虽然从技术上讲这运行得很好，但这确实是过度的，而不是性能.

为什么在单元测试中使用这种模式:

- 当断言失败时，你依靠测试标题来知道什么失败了
- 你被告知添加多个断言是不好的，并将其视为事实
- 拆分多个测试不会造成性能损失，因为它们运行得非常快

你为什么不应该在Cypress里这么做:

- 编写集成测试与编写单元测试不同
- 您将始终知道(并且可以直观地看到)在大型测试中哪个断言失败了
- Cypress运行一系列异步生命周期事件来重置测试之间的状态
- 重置测试比添加更多断言要慢得多

在Cypress测试中，通常会发出30多个命令。因为几乎每个命令都有一个默认断言(因此可能会失败)，即使限制断言，也没有为自己节省任何东西，因为任何单个命令都可能隐式地失败。

您应该如何重写这些测试:

```javascript
describe('my form', () => {
  before(() => {
    cy.visit('/users/new')
  })

  it('validates and formats first name', () => {
    cy.get('#first')
      .type('johnny')
      .should('have.attr', 'data-validation', 'required')
      .and('have.class', 'active')
      .and('have.value', 'Johnny')
  })
})
```

## 使用`after` 或 `afterEach`钩子

<Alert type="danger">

<Icon name="exclamation-triangle" color="red"></Icon> **反模式:** 使用`after` 或 `afterEach`钩子来清理状态。

</Alert>

<Alert type="success">

<Icon name="check-circle" color="green"></Icon> **最佳实践:** 在测试**运行前**清理状态.

</Alert>

我们看到许多用户将代码添加到`after` 或 `afterEach`钩子中，以清理当前测试生成的状态。

我们经常看到这样的测试代码:

```js
describe('logged in user', () => {
  beforeEach(() => {
    cy.login()
  })

  afterEach(() => {
    cy.logout()
  })

  it('tests', ...)
  it('more', ...)
  it('things', ...)
})
```

让我们看看为什么这不是真的必要.

### 保留状态是你的朋友:

Cypress最好的部分之一是它对可调试性的强调. 与其他测试工具不同的是——当测试结束时——您将在测试完成的确切位置保留工作应用程序。

这是您在测试完成状态下继续有机会使用应用程序! 使您能够编写**部分测试**，逐步驱动应用程序，同时编写测试和应用程序代码.

我们已经构建了Cypress来支持这种使用场景. In fact, 当测试结束时，Cypress**没有清理***自己的内部状态。 我们**希望**你在测试结束的时候有一个保留的状态! 像[stubs](/api/commands/stub), [spies](/api/commands/spy)这些, 甚至 [routes](/api/commands/route)在测试结束时都不会删除. 这意味着您的应用程序在运行Cypress命令时或在测试结束后手动使用它时的行为是相同的。

如果在每次测试后删除应用程序的状态，则立即失去在此模式下使用应用程序的能力. 在测试结束时注销总是会给您留下相同的登录页面. 为了调试您的应用程序或编写部分测试，您将始终不注释自定义的`cy.logout()`命令。

### 这都是不利因素，没有有利因素:

现在，让我们假设出于某种原因，您的应用程序迫切需要运行`after` 或 `afterEach` 代码的最后一部分。 让我们假设，如果没有运行该代码，则所有代码都将丢失。

这很好——但即使是这种情况，也不应该加入`after` or `afterEach` 钩子. 为什么?到目前为止，我们一直在讨论注销登录，让我们使用一个不同的示例，需要重置数据库的模式。

**这个想法是这样的:**

> 在每次测试之后，我都希望确保数据库被重置为0条记录，这样当下一次测试运行时，它将以干净状态运行.

**记住这一点，你就可以写出这样的东西:**

```js
afterEach(() => {
  cy.resetDb()
})
```

问题是:这个代码不能保证始终会运行。

假设，您编写这个命令是因为它必须在下一次测试之前运行，那么放置它的绝对最糟糕的地方是`after` 或 `afterEach`钩子.

为什么?因为如果你在测试中途刷新Cypress，你将在数据库中保留了部分状态，你的自定义`cy.resetDb()` 函数将**永远不会**被调用.

如果真的需要这种状态清理，那么下一个测试将立即失败。为什么? 因为你刷新Cypress时，并没有重置状态。

### 在每次测试之前应该进行状态重置:

这里最简单的解决方案是将重置代码移动到测试**运行之前**.

代码放入`before` or `beforeEach`钩子总是会在测试之前运行-即使你在现有的Cypress的中途刷新!

这也是一个很好的机会使用[mocha的的根级钩子](https://github.com/mochajs/mochajs.github.io/blob/master/index.md#root-level-hooks). [`cypress/support/index.js` 文件](/guides/core-concepts/writing-and-organizing-tests#Support-file)是放置这些代码的一个完美的地方，因为它总是在您的spec文件中的任何测试代码之前执行。

**添加到根目录的钩子总是在所有测试套件前运行!**

```js
// cypress/support/index.js

beforeEach(() => {
  //现在，无论什么情况，它都在每次测试之前运行
  cy.resetDb()
})
```

### 是否需要重置状态?

你应该问自己的最后一个问题是:重置状态是否有必要? 记住，Cypress已经在每次测试之前自动清除 [localStorage](/api/commands/clearlocalstorage), [cookies](/api/commands/clearcookies)、sessions等. 确保您没有试图清除Cypress已经自动清除的状态.

如果您试图清除的状态在服务器上存在----请想尽一切办法清除该状态. 您必须保持这一类的习惯! 但是如果这个状态与你正在测试的应用程序相关，你可能甚至不需要清除它.

唯一需要清理状态的情况是，一个测试运行的操作影响了下游的另一个测试.只有在这些情况下，才需要进行状态清理.

#### <Icon name="graduation-cap"></Icon> 真实世界的例子

[Real World App (RWA)](https://github.com/cypress-io/cypress-realworld-app) 通过一个自定义的[Cypress任务](/api/commands/task)在 `beforeEach`钩子中调用`db:seed`，重置测试数据并重新造数. 这允许每个测试都从一个清晰的白板和确定的状态开始。例如:

```ts
// cypress/tests/ui/auth.spec.ts

beforeEach(function () {
  cy.task('db:seed')
  // ...
})
```

> _<Icon name="github"></Icon> 源码: [cypress/tests/ui/auth.spec.ts](https://github.com/cypress-io/cypress-realworld-app/blob/develop/cypress/tests/ui/auth.spec.ts)_

`db:seed`任务是在项目的[plugins文件](/guides/core-concepts/writing-and-organizing-tests#Plugin-files) 中定义的，在这种情况下，向应用程序的专用后端API发送一个请求，以适当地重新造数。

```ts
// cypress/plugins/index.ts

on('task', {
  async 'db:seed'() {
    // 发送请求到后端API，以重新在数据库中插入测试数据
    const { data } = await axios.post(`${testDataApiEndpoint}/seed`)
    return data
  },
  //...
})
```

> _<Icon name="github"></Icon> 源码: [cypress/plugins/index.ts](https://github.com/cypress-io/cypress-realworld-app/blob/develop/cypress/plugins/index.ts)_

上面的实践同样适用于任何类型的数据库(PostgreSQL, MongoDB等)。在这个例子中，请求被发送到后端API，但是您也可以通过直接查询、自定义库等与数据库直接交互. 如果你已经有了处理或与数据库交互的非javascript方法，你可以使用`[cy.exec](/api/commands/exec)`，而不是`[cy.task](/api/commands/task)`来执行任何系统命令或脚本。

## 不必要的等待

<Alert type="danger">

<Icon name="exclamation-triangle" color="red"></Icon> **反模式:** 使用[`cy.wait(Number)`](/api/commands/wait#Time)等待任意时间段.

</Alert>

<Alert type="success">

<Icon name="check-circle" color="green"></Icon> **最佳实践:** 使用路由别名或断言来防止Cypress继续进行，直到满足明确的条件.

</Alert>

在Cypress中，几乎不需要在任意时间内使用`cy.wait()`。 如果你发现自己正在这样做，可能有一个更简单的方法。

让我们想象下面的例子:

### 对`cy.request()`的不必要等待

在这里等待是不必要的，因为 [`cy.request()`](/api/commands/request) 命令在收到来自服务器的响应之前不会解析. 在这里添加等待只会在 [`cy.request()`](/api/commands/request)解析之后再白白增加5秒.

```javascript
cy.request('http://localhost:8080/db/seed')
cy.wait(5000) // <--- 这是不必要的
```

### 没必要等待 `cy.visit()`

等待这个是不必要的，因为一旦页面触发它的`load`事件，[cy.visit()](/api/commands/visit)就会解析. 到那时，所有的资源都已经加载完毕，包括javascript、样式表和html.

```javascript
cy.visit('http://localhost/8080')
cy.wait(5000) // <--- 这是不必要的
```

### 没必要等待 `cy.get()`

等待下面的[`cy.get()`](/api/commands/get)是不必要的，因为[`cy.get()`](/api/commands/get)会自动重试，直到表的`tr`长度为2。

只要命令有一个断言，它们就不会解析，直到它们关联的断言通过。这使您能够描述应用程序的状态，而不必担心它何时到达那里。

```javascript
cy.intercept('GET', '/users', [{ name: 'Maggy' }, { name: 'Joan' }])
cy.get('#fetch').click()
cy.wait(4000) // <--- 这是不必要的
cy.get('table tr').should('have.length', 2)
```

另一种更好的解决方案是显式地等待一个别名路由.

```javascript
cy.intercept('GET', '/users', [{ name: 'Maggy' }, { name: 'Joan' }]).as(
  'getUsers'
)
cy.get('#fetch').click()
cy.wait('@getUsers') // <--- 显式地等待此路由完成
cy.get('table tr').should('have.length', 2)
```

## Web Servers

<Alert type="danger">

<Icon name="exclamation-triangle" color="red"></Icon> **反模式:** 尝试在Cypress脚本中使用 [`cy.exec()`](/api/commands/exec) 或 [`cy.task()`](/api/commands/task)启动web服务器.

</Alert>

<Alert type="success">

<Icon name="check-circle" color="green"></Icon> **最佳实践:** 在运行Cypress之前启动一个web服务器.

</Alert>

我们不建议尝试从Cypress内启动您的 web服务器.

由 [`cy.exec()`](/api/commands/exec) 或 [`cy.task()`](/api/commands/task)运行的任何命令最终都必须退出. 否则，Cypress将不会继续运行任何其他命令。

尝试从 [`cy.exec()`](/api/commands/exec) 或 [`cy.task()`](/api/commands/task)启动web服务器会导致各种问题，因为:

- 你必须了解整个过程
- 你无法通过终端访问它
- 您无法访问其`stdout`或日志
- 每次运行测试时，您都必须解决启动已经运行的web服务器的复杂性.
- 您可能会遇到经常的端口冲突

**为什么我不能在`after`钩子中关闭进程?**

因为不能保证在`after`中运行的代码总是运行。

在Cypress Test Runner中工作时，您总是可以在测试过程中重新启动刷新。当这种情况发生时，`after`中的代码将不会执行。

**那我该怎么做呢?**

在运行Cypress之前启动您的web服务器，并在它完成后杀死它.

你想加入CI吗?

我们有[向您展示如何启动和停止您的web服务器的示例](/guides/continuous-integration/introduction#Boot-your-server).

## 设置全局 baseUrl

<Alert type="danger">

<Icon name="exclamation-triangle" color="red"></Icon> **反模式:** 使用[cy.visit()](/api/commands/visit)而不设置 `baseUrl`.

</Alert>

<Alert type="success">

<Icon name="check-circle" color="green"></Icon> **最佳实践:** 在你的[配置文件，默认是`cyrpess.json`](/guides/references/configuration)中设置一个`baseUrl`.

</Alert>

在你的配置中添加一个[baseUrl](/guides/references/configuration#Global)可以让你忽略将 `baseUrl` 传递给命令，比如[cy.visit()](/api/commands/visit) 以及 [cy.request()](/api/commands/request)。Cypress假定这是您想要使用的url。

添加[baseUrl](/guides/references/configuration#Global)还可以在Cypress测试的初始启动期间节省一些时间。

当您开始运行测试时，Cypress并不知道您计划测试的应用程序的url。因此，Cypress最初打开 `https://localhost` + 随机端口.

### 如果没有设置`baseUrl`, Cypress将在 `localhost` +随机端口上 加载主窗口

<DocsImage src="/img/guides/cypress-loads-in-localhost-and-random-port.png" alt="Url address shows localhost:53927/__/#tests/integration/organizations/list_spec.coffee" ></DocsImage>

一旦遇到[cy.visit()](/api/commands/visit)， Cypress就会切换到主窗口的url到您访问时指定的url。这在测试第一次开始时，可能导致“闪屏”或“重加载”，。

通过设置`baseUrl`，你可以完全避免重载。一旦测试开始，Cypress将在您指定的`baseUrl`中加载主窗口。

###  配置文件 (默认是`cypress.json`)

```json
{
  "baseUrl": "http://localhost:8484"
}
```

### 有了 `baseUrl`设置，Cypress在`baseUrl`加载主窗口

<DocsImage src="/img/guides/cypress-loads-window-in-base-url-localhost.png" alt="Url address bar shows localhost:8484/__tests/integration/organizations/list_spec.coffee" ></DocsImage>

有一个`baseUrl` 配置给你的额外奖励，如果你的服务器在`cypress open`期间没有运行在指定的`baseUrl`.

<DocsImage src="/img/guides/cypress-ensures-baseUrl-server-is-running.png" alt="Test Runner with warning about how Cypress could not verify server set as the baseUrl is running"></DocsImage>

我们还显示一个错误，如果您的服务器在`cypress run`几次重试后, 没有运行在指定的`baseUrl`.

<DocsImage src="/img/guides/cypress-verifies-server-is-running-during-cypress-run.png" alt="The terminal warns and retries when the url at your baseUrl is not running" ></DocsImage>
