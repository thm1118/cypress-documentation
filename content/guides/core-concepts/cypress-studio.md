---
title: Cypress Studio
---

<Alert type="info">

## <Icon name="graduation-cap"></Icon> 你将学习

- 如何使用Cypress Studio交互式地扩展测试
- 如何使用Cypress Studio交互式地添加新的测试

</Alert>

## 概述

Cypress Studio通过记录与被测应用程序的交互，提供了在Test Runner中生成测试的可视化方法.

 支持Cypress命令[`.click()`](/api/commands/click), [`.type()`](/api/commands/type), [`.check()`](/api/commands/check), [`.uncheck()`](/api/commands/uncheck), 以及 [`.select()`](/api/commands/select)，当与Cypress Studio中的DOM交互时将生成测试代码.

## 使用Cypress Studio

<Alert type="info">

Cypress Studio是一个实验性的特性，可以通过将[experimentalStudio](/guides/references/experiments)属性添加到您的配置文件(默认是`Cypress.json`)。

</Alert>

```json
{
  "experimentalStudio": true
}
```

Cypress <Icon name="github"></Icon> [Real World App (RWA)](https://github.com/cypress-io/cypress-realworld-app) 是一个开源项目，实现了一个支付应用程序，演示了Cypress测试方法、模式和工作流的真实使用情况。下面将用它来演示Cypress Studio的功能。

### 扩展测试

你可以扩展任何已经存在的测试，或者在你的 [integrationFolder](/guides/references/configuration#Folders-Files) (默认是`cypress/integration` )中创建一个新的测试，使用下面的测试脚手架.

```js
// 来自Real World App (RWA)的代码
describe('Cypress Studio Demo', () => {
  beforeEach(() => {
    // 生成测试数据
    cy.task('db:seed')

    // 登录测试用户
    cy.database('find', 'users').then((user) => {
      cy.login(user.username, 's3cret', true)
    })
  })

  it('创建新交易', () => {
    // 使用Cypress Studio扩展测试
  })
})
```

<Alert type="info">

##### <Icon name="graduation-cap"></Icon> 真实世界的例子

Clone <Icon name="github"></Icon> [Real World App (RWA)](https://github.com/cypress-io/cypress-realworld-app) 并参考文件 [cypress/tests/demo/cypress-studio.spec.ts](https://github.com/cypress-io/cypress-realworld-app/blob/develop/cypress/tests/demo/cypress-studio.spec.ts).

</Alert>

#### 步骤 1 - 运行spec

我们将使用Cypress Studio执行一个“新交易”的用户旅程。首先，启动Test Runner并运行前一步中创建的spec。

<DocsImage src="/img/guides/cypress-studio/run-spec-1.png" alt="Cypress Studio" no-border></DocsImage>

测试完成运行后，将鼠标悬停在命令日志中的测试上方，以显示“添加命令到测试”按钮。

点击“添加命令到测试”将启动Cypress Studio。

<Alert type="info">

Cypress Studio直接与[命令日志](/guides/core-concepts/test-runner#Command-Log)集成.

</Alert>

<DocsImage src="/img/guides/cypress-studio/run-spec-2.png" alt="Cypress Studio" no-border></DocsImage>

#### 步骤 2 - 启动Cypress Studio

<Alert type="success">

Cypress将自动执行所有钩子和当前呈现的测试代码，然后测试可以从那一点上扩展(例如，我们登录到应用程序内部的`beforeEach`块).

</Alert>

接下来，测试运行器将单独执行测试，并在测试中的最后一条命令之后暂停。

<DocsImage src="/img/guides/cypress-studio/extend-new-transaction-ready.png" alt="Cypress Studio Ready" no-border></DocsImage>

现在，我们可以开始更新测试以创建用户之间的新交易。

#### 步骤 3 - 与应用程序交互

要记录操作，请开始与应用程序交互。在这里，我们将单击姓名输入，结果我们将看到在命令日志中记录的单击。

<DocsImage src="/img/guides/cypress-studio/extend-new-transaction-user-list.png" alt="Cypress Studio Extend Test" no-border></DocsImage>

接下来，我们可以键入要支付的用户名，并在结果中单击该用户。

<DocsImage src="/img/guides/cypress-studio/extend-new-transaction-click-user.png" alt="Cypress Studio Extend Test" no-border></DocsImage>

我们将通过点击并输入金额和描述输入来完成交易表格。

<DocsImage src="/img/guides/cypress-studio/extend-new-transaction-form.png" alt="Cypress Studio Extend Test" no-border></DocsImage>

<Alert type="success">

注意命令日志中生成的命令。

</Alert>

最后，我们将点击“支付”按钮。

<DocsImage src="/img/guides/cypress-studio/extend-new-transaction-pay.png" alt="Cypress Studio Extend Test" no-border></DocsImage>

我们收到了新交易的确认页。

<DocsImage src="/img/guides/cypress-studio/extend-new-transaction-confirmation.png" alt="Cypress Studio Extend Test Confirmation" no-border></DocsImage>

若要放弃交互，请单击“取消”按钮退出Cypress Studio。如果满意与应用程序的交互，单击“Save Commands”，测试代码将被保存到您的规范文件中。

#### 生成测试代码

查看我们的测试代码，我们可以看到，在点击“Save Commands”后，我们在Cypress Studio中记录的操作更新了测试。

```js
//  Real World App (RWA)中的代码
describe('Cypress Studio Demo', () => {
  beforeEach(() => {
    // 造数
    cy.task('db:seed')

    // 登录测试用户
    cy.database('find', 'users').then((user) => {
      cy.login(user.username, 's3cret', true)
    })
  })

  it('创建新交易', () => {
    /* ==== 由Cypress Studio生成 ==== */
    cy.get('[data-test=nav-top-new-transaction]').click()
    cy.get('[data-test=user-list-search-input]').click()
    cy.get('[data-test=user-list-search-input]').type('dev')
    cy.get('[data-test=user-list-item-tsHF6_D5oQ]').click()
    cy.get('#amount').type('$25')
    cy.get('#transaction-create-description-input').click()
    cy.get('#transaction-create-description-input').type('Sushi dinner')
    cy.get(
      '[data-test=transaction-create-submit-payment] > .MuiButton-label'
    ).click()
    /* ==== End Cypress Studio ==== */
  })
})
```

### 添加新测试

您可以添加一个新的测试到任何现有的`describe`或`context`块，通过点击我们定义的`describe`块上的`add new test`。

<DocsImage src="/img/guides/cypress-studio/add-test-1.png" alt="Cypress Studio Add Test" no-border></DocsImage>

我们进入Cypress Studio，可以开始与我们的应用程序进行交互以生成测试。

对于这个测试，我们将添加一个新的银行账户。我们的互动如下:

1. 点击左边导航栏的“银行账户”
   <DocsImage src="/img/guides/cypress-studio/add-test-2.png" alt="Cypress Studio Begin Add Test" no-border></DocsImage>
2. 点击银行账户页面上的“创建”按钮
   <DocsImage src="/img/guides/cypress-studio/add-test-create.png" alt="Cypress Studio Add Test Create Bank Account" no-border></DocsImage>
3. 填写银行账户信息
   <DocsImage src="/img/guides/cypress-studio/add-test-form-complete.png" alt="Cypress Studio Add Test Complete Bank Account Form" no-border></DocsImage>
4. 点击“保存”按钮
   <DocsImage src="/img/guides/cypress-studio/add-test-form-saving.png" alt="Cypress Studio Add Test Saving Bank Account" no-border></DocsImage>

若要放弃交互，请单击“取消”按钮退出Cypress Studio。

如果对与应用程序的交互满意，单击“Save Commands”，提示符将询问测试的名称。点击“Save Test”，测试将被保存到文件中。

<DocsImage src="/img/guides/cypress-studio/add-test-save-test.png" alt="Cypress Studio Add Test Completed Run" no-border></DocsImage>

一旦保存，文件将在Cypress中再次运行。

<DocsImage src="/img/guides/cypress-studio/add-test-final.png" alt="Cypress Studio Add Test Completed Run" no-border></DocsImage>

最后，查看我们的测试代码，我们可以看到，在点击“Save Commands”后，我们用在Cypress Studio中记录的动作更新了测试。

```js
// Real World App (RWA)的代码
import { User } from 'models'

describe('Cypress Studio Demo', () => {
  beforeEach(() => {
    cy.task('db:seed')

    cy.database('find', 'users').then((user: User) => {
      cy.login(user.username, 's3cret', true)
    })
  })

  it('create new transaction', () => {
    // 使用Cypress Studio扩展测试
  })

  /* === Cypress Studio 创建的测试=== */
  it('create bank account', function () {
    /* ==== 由Cypress Studio生成 ==== */
    cy.get('[data-test=sidenav-bankaccounts]').click()
    cy.get('[data-test=bankaccount-new] > .MuiButton-label').click()
    cy.get('#bankaccount-bankName-input').click()
    cy.get('#bankaccount-bankName-input').type('Test Bank Account')
    cy.get('#bankaccount-routingNumber-input').click()
    cy.get('#bankaccount-routingNumber-input').type('987654321')
    cy.get('#bankaccount-accountNumber-input').click()
    cy.get('#bankaccount-accountNumber-input').type('123456789')
    cy.get('[data-test=bankaccount-submit] > .MuiButton-label').click()
    /* ==== End Cypress Studio ==== */
  })
})
```

<Alert type="info">

##### <Icon name="graduation-cap"></Icon> 真实世界的例子

Clone <Icon name="github"></Icon> [Real World App (RWA)](https://github.com/cypress-io/cypress-realworld-app) 并参考 [cypress/tests/demo/cypress-studio.spec.ts](https://github.com/cypress-io/cypress-realworld-app/blob/develop/cypress/tests/demo/cypress-studio.spec.ts) 文件.

</Alert>

## 历史

| 版本                                        | 变更                              |
| ------------------------------------------- | ------------------------------------ |
| [6.3.0](/guides/references/changelog#6-3-0) | Added Cypress Studio as experimental |
