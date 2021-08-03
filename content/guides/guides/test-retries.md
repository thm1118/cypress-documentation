---
title: 测试重试
---

<Alert type="info">

## <Icon name="graduation-cap"></Icon> 你将学习

- 什么是测试重试?
- 为什么测试重试很重要?
- 如何配置测试重试

</Alert>

## 介绍

端到端(E2E)测试擅长于测试复杂的系统。然而，仍然有一些行为很难验证，并使测试不可靠(即，不可靠)，有时由于不可预测的条件(例如，外部依赖的临时中断，随机网络错误等不可靠)而失败。
其他一些可能导致不可靠测试的常见竞态条件包括:

- 动画
- API 调用
- 测试服务器 / 数据库的可用性
- 依赖资源的可用性
- 网络问题

通过测试重试，Cypress能够重试失败的测试，以帮助减少脆弱测试和持续集成(CI)构建失败。这样做可以节省你的团队宝贵的时间和资源，让你专注于对你最重要的事情。

## 它是如何运作的

默认情况下，测试失败时不会重试。您将需要[在您的配置中启用测试重试](#Configure-Test-Retries)来使用此特性。

启用测试重试后，可以将测试配置为具有X次重试尝试。例如，如果测试重试被配置为“2”重试尝试，Cypress将重试测试至多2次(总共3次尝试)，然后可能被标记为失败的测试。

当每个测试再次运行时，下面的[钩子](/guides/core-concepts/writing-and-organizing-tests#Hooks)也将重新运行:

- `beforeEach`
- `afterEach`

<Alert type="warning">

但是，`before` 和 `after`钩子中的失败将不会触发重试.

</Alert>

**下面是测试重试工作原理的详细示例:**

假设我们已经配置了“2”重试尝试(总共3次尝试)，下面是测试可能运行的方式:

1. 测试第一次运行。如果
   <Icon name="check-circle" color="green"></Icon> 测试通过, Cypress将一如既往地进行余下的测试.

2. 如果 <Icon name="times" color="red"></Icon> 测试失败, Cypress将告诉你第一次尝试失败，并将尝试运行第二次测试。

<DocsImage src="/img/guides/test-retries/attempt-2-start.png"></DocsImage>

3. 如果 <Icon name="check-circle" color="green"></Icon> 第二次尝试测试通过, Cypress 会继续进行其他测试.

4. 如果 <Icon name="times" color="red"></Icon> 第二次测试失败,
   Cypress 会进行最后的第三次尝试重新运行测试.

<DocsImage src="/img/guides/test-retries/attempt-3-start.png"></DocsImage>

5. 如果 <Icon name="times" color="red"></Icon> 第三次测试失败,
   Cypress 是否将测试标记为失败，然后继续运行任何剩余的测试.

<DocsImage src="/img/guides/test-retries/attempt-3-fail.png"></DocsImage>

下面是当通过[cypress run](/guides/guides/command-line#cypress-run)运行时，在同一个失败的测试上重试的屏幕截图.

<DocsImage src="/img/guides/test-retries/cli-error-message.png"></DocsImage>

在[cypress open](/guides/guides/command-line#cypress-open)期间，您将能够在[Command Log](/guides/core-concepts/test-runner#Command-Log)中看到尝试的次数，如果需要，可以点击展开每一次尝试，进行检查和调试。

<DocsVideo src="/img/guides/test-retries/attempt-expand-collapse-time-travel.mp4"></DocsVideo>

## 配置测试重试

### 全局配置

通常，你会`cypress run`
和 `cypress open`想要定义不同的重试尝试. 您可以在您的[配置文件](/guides/guides/command-line#cypress-open-config-file-lt-config-file-gt) 传递`retries`选项对象，如下:

- `runMode` 允许您定义运行`cypress run`时测试重试的次数
- `openMode` 允许您定义`cypress open`运行时测试重试的次数

```jsx
{
  "retries": {
    // 为 `cypress run`配置重试尝试
    // 默认是 0
    "runMode": 2,
    // 为`cypress open`配置重试尝试
    // 默认是0
    "openMode": 0
  }
}
```

#### 为所有模式配置重试尝试

如果您想为`cypress run` 和 `cypress open`中运行的所有测试配置重试尝试,你可以在你的[配置文件](/guides/guides/command-line#cypress-open-config-file-lt-config-file-gt)中定义`retries`属性并设置期望的重试次数。

```jsx
{
  "retries": 1
}
```

### 自定义配置

#### 单独的测试(s)

如果您想在特定的测试上配置重试尝试，您可以使用[单个测试的配置](/guides/core-concepts/writing-and-organizing-tests#Test-Configuration) 设置重试尝试。

```jsx
// 为单个测试定制重试尝试
describe('User sign-up and login', () => {
  // 没有自定义配置的`it`测试块
  it('should redirect unauthenticated user to sign-in page', () => {
    // ...
  })

  // 带有自定义配置的`it`测试块
  it(
    'allows user to login',
    {
      retries: {
        runMode: 2,
        openMode: 1,
      },
    },
    () => {
      // ...
    }
  )
})
```

#### 测试集(s)

如果您想为一组测试配置重试，可以通过设置套件的配置来实现。

```jsx
// 为一组测试定制重试尝试
describe('User bank accounts', {
  retries: {
    runMode: 2,
    openMode: 1,
  }
}, () => {
  // 每个套件的配置应用于每个测试
  // 如果测试失败，将重新尝试
  it('allows a user to view their transactions', () => {
    // ...
  }

  it('allows a user to edit their transactions', () => {
    // ...
  }
})
```

您可以在这里找到更多关于自定义配置的信息:[单个测试配置](/guides/references/configuration#Test-Configuration)

## 截屏

当测试重试时，Cypress将继续为每一个失败的尝试或[cy.screenshot()](/api/commands/screenshot)抓取屏幕截图，并在每个新截图的后缀中加上`(attempt n)`，对应当前的重试尝试数。

使用下面的测试代码，当3次尝试都失败时，你会看到下面的截图文件名:

```js
describe('User Login', () => {
  it('displays login errors', () => {
    cy.visit('/')
    cy.screenshot('user-login-errors')
    // ...
  })
})
```

```js
// 第一次尝试时cy.screenshot()的截屏文件名
'user-login-errors.png'
// 第一次尝试并失败时cy.screenshot()的截屏文件名
'user-login-errors (failed).png'
// 第2次尝试时cy.screenshot()的截屏文件名
'user-login-errors (attempt 2).png'
// 第2次 失败时cy.screenshot()的截屏文件名
'user-login-errors (failed) (attempt 2).png'
// 第3次尝试时cy.screenshot()的截屏文件名
'user-login-errors (attempt 3).png'
// 第3次 失败时cy.screenshot()的截屏文件名
'user-login-errors (failed) (attempt 3).png'

```

## 视频

你可以使用Cypress的[`after:spec`](/api/plugins/after-spec-api)事件监听器，它会在每个spec文件运行后触发，以删除没有重试尝试或失败的spec的录制视频。
在运行后删除传递的和未重试的视频可以节省机器上的资源空间，并跳过用于处理、压缩和上传视频到[Dashboard服务](/guides/dashboard/introduction)的时间。

### 仅上传测试spec失败或重试的视频

下面的示例演示如何在启用Cypress测试重试时，删除没有重试或成功通过的spec的录制视频。

```js
// plugins/index.js

// 需要安装这些依赖项
// npm i lodash del --save-dev
const _ = require('lodash')
const del = require('del')

module.exports = (on, config) => {
  on('after:spec', (spec, results) => {
    if (results && results.video) {
      // 我们是否有失败的重试尝试?
      const failures = _.some(results.tests, (test) => {
        return _.some(test.attempts, { state: 'failed' })
      })
      if (!failures) {
        // 如果spec通过且没有重试测试，则删除视频
        return del(results.video)
      }
    }
  })
}
```

## Dashboard

如果您正在使用[Cypress Dashboard](/guides/dashboard/introduction),
与测试重试相关的信息显示在运行的“测试结果”选项卡上。选择Flaky筛选器将显示在运行期间重试然后通过的测试。

在“最新运行”页和“运行详细信息”页上的“测试结果”选项卡上还会显示这些测试。

<DocsVideo src="/img/guides/test-retries/flaky-test-filter.mp4" title="Flaky test filter"></DocsVideo>

点击测试结果将打开测试用例历史记录屏幕。这显示了失败的尝试的数量，失败的尝试的截图或视频，以及失败的尝试的错误。

<DocsImage src="/img/guides/test-retries/flake-artifacts-and-errors.png" alt="Flake artifacts and errors" ></DocsImage>

您还可以看到一个给定测试的脆弱率。

<DocsImage src="/img/guides/test-retries/flaky-rate.png" alt="Flaky rate" ></DocsImage>

对于脆弱测试是如何影响您的整个测试套件的全面视图，您可以查看在管理脆弱测试指南内查看 [脆弱检测](/guides/dashboard/flaky-test-management#Flake-Detection) 以及
[脆弱报警](/guides/dashboard/flaky-test-management#Flake-Alerting)这些亮点功能

## 常见问题

### 在我的账单中，重试的测试是否会被计费为一个以上的测试结果?

不。在“cypress run”期间用“——record”标记记录的测试无论是否重试都将被计算为相同的值。

我们将每次调用`it()`函数视为单个测试，以实现计费目的。在您的账单中，测试重试将不计入额外的测试结果。

在[Dashboard](https://on.cypress.io/dashboard)中，您总是可以看到您从组织的Billing & Usage页面记录了多少测试。.

### 我可以从测试中访问当前的重试计数器吗?

是的，尽管通常您不需要这样做，因为这是一个底层的细节。但是如果你想使用当前的尝试次数和允许的总尝试次数，你可以做以下事情:

```javascript
it('does something differently on retry', { retries: 3 }, () => {
  // cy.state('runnable') 返回当前测试对象
  // 我们可以抓住现在的尝试 and
  // 从它的属性中允许尝试的总数
  const attempt = cy.state('runnable')._currentRetry
  const retries = cy.state('runnable')._retries
  // 使用"attempt" 和 "retries" 值
})
```

上面的“attempt”变量的值从0到3(第一次默认的测试执行加上三次允许的重试). 在这种情况下，`retries`常量总是3。

**提示:** Cypress [bundles Lodash](/api/utilities/_) 库. 使用它的帮助器方法来安全地访问对象的属性。让我们通过退回到默认值来确保该函数支持不同的Cypress版本.

```javascript
it('does something differently on retry', { retries: 3 }, () => {
  // _.get: 如果缺少对象或属性，请使用提供的默认值
  const attempt = Cypress._.get(cy.state('runnable'), '_currentRetry', 0)
  const retries = Cypress._.get(cy.state('runnable'), '_retries', 0)
  // 使用"attempt" 和 "retries" 值
})
```
