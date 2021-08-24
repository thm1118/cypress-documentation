---
title: wrap
---

输出传递给`.wrap()`的对象. 如果对象是一个promise，则输出其解决值.

## 语法

```javascript
cy.wrap(subject)
cy.wrap(subject, options)
```

### 用法

**<Icon name="check-circle" color="green"></Icon> 正确的用法**

```javascript
cy.wrap({ name: 'Jane Lane' })
```

### 参数

**<Icon name="angle-right"></Icon> subject** **_(Object)_**

要输出的东西.

**<Icon name="angle-right"></Icon> options** **_(Object)_**

传入一个options对象以更改`cy.wrap()`的默认行为.

| 选项      | 默认值                                                              | 描述                                                                              |
| --------- | -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| `log`     | `true`                                                               | 在[命令日志](/guides/core-concepts/test-runner#Command-Log) 中显示命令 |
| `timeout` | [`defaultCommandTimeout`](/guides/references/configuration#Timeouts) | 等待`cy.wrap()`在[超时](#Timeouts)之前解决的时间                   |

### Yields 输出[<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Subject-Management)

<List><li>`cy.wrap()` '输出调用它传入的参数对象' </li></List>

## 例子

### 对象

#### 调用包装的目标的函数并返回新值

```javascript
const getName = () => {
  return 'Jane Lane'
}

cy.wrap({ name: getName }).invoke('name').should('eq', 'Jane Lane') // true
```

### DOM元素

#### 包装元素以继续执行命令

```javascript
cy.get('form').within(($form) => {
  // ... 更多命令

  cy.wrap($form).should('have.class', 'form-container')
})
```

#### 有条件地包装元素

```javascript
cy.get('button').then(($button) => {
  // $button 是个jQuery封装的元素
  if ($button.someMethod() === 'something') {
    // 包装这个元素，这样我们就可以在它上面使用cypress命令
    cy.wrap($button).click()
  } else {
    // 做其他的事情
  }
})
```

### Promises

您可以包装应用程序代码返回的Promises. Cypress命令将自动等待Promises解决，然后继续使用下一个命令或断言所输出的值. 完整的示例请参见[使用应用程序代码登录](/examples/examples/recipes#Logging-In) 配方.

#### 简单的例子

```js
const myPromise = new Promise((resolve, reject) => {
  // 用 setTimeout(...)模拟异步代码.
  setTimeout(() => {
    resolve({
      type: 'success',
      message: 'It worked!',
    })
  }, 2500)
})

it('应该等Promise解决', () => {
  cy.wrap(myPromise).its('message').should('eq', 'It worked!')
})
```

<DocsImage src="/img/api/wrap/cypress-wrapped-promise-waits-to-resolve.gif" alt="Wrap of promises" ></DocsImage>

#### 应用程序实例

```javascript
// 导入应用代码 来登录
import { userService } from '../../src/_services/user.service'

it('使用 .should 可以断言对象已解析', () => {
  cy.log('user service login')
  const username = Cypress.env('username')
  const password = Cypress.env('password')

  // 包装应用程序代码返回的promise
  cy.wrap(userService.login(username, password))
    // 检查已输出的对象
    .should('be.an', 'object')
    .and('have.keys', ['firstName', 'lastName', 'username', 'id', 'token'])
    .and('contain', {
      username: 'test',
      firstName: 'Test',
      lastName: 'User',
    })

  // cy.visit 命令将等待从"userService.login"返回的promise 解决。 
  // 然后设置本地存储项，并立即对访问进行身份验证和登录
  cy.visit('/')
  // 我们应该登陆了
  cy.contains('Hi Test!').should('be.visible')
})
```

**注意:** `.wrap()` 不会为您同步异步函数调用. 例如，给出下面的例子:

- 有两个异步函数 `async function foo() {...}` 和 `async function bar() {...}`
- 你需要确保`foo()`在调用`bar()`之前已经被解析。
- `bar()`也依赖于在调用其他Cypress命令后创建的一些数据.

**<Icon name="exclamation-triangle" color="red"></Icon>** 如果你用`cy.wrap()`包装异步函数, 那么`bar()`可能会在所需数据可用之前被提前调用:

```javascript
cy.wrap(foo())

cy.get('some-button').click()
cy.get('some-input').type(someValue)
cy.get('some-submit-button').click()

// 这将立即执行`bar()`，而不会等待其他cy.get(…)函数完成
cy.wrap(bar()) // 不这样做
```

这种行为是由于函数调用`foo()` 和 `bar()`，它们会立即调用函数来返回Promise.

**<Icon name="check-circle" color="green"></Icon>** 如果你想在`foo()`和[cy.get()](/api/commands/get)命令 之后执行`bar()`, 一种解决方案是使用[.then()](/api/commands/then) 链接最终命令:

```javascript
cy.wrap(foo())

cy.get('some-button').click()
cy.get('some-input').type(someValue)
cy.get('some-submit-button')
  .click()
  .then(() => {
    // 这将在其他cy.get(…)函数完成后执行 `bar()`
    cy.wrap(bar())
  })
```

## 规则

### 要求 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Chains-of-Commands)

<List><li>`cy.wrap()`需要链接自 `cy`.</li></List>

### 断言 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Assertions)

<List><li>`cy.wrap()`, 当它的参数是一个promise时，将自动等待，直到promise被解决. 如果promise被rejected, `cy.wrap()`将让测试无法通过.</li><li>`cy.wrap()` 讲自动 [重试](/guides/core-concepts/retry-ability) 直到所有链接的断言通过</li></List>

### 超时 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Timeouts)

<List><li>`cy.wrap()` 在等待添加的断言通过时是否会超时.</li></List>

## 命令日志

**对对象进行断言**

```javascript
cy.wrap({ amount: 10 }).should('have.property', 'amount').and('eq', 10)
```

上面的命令将在命令日志中显示为:

<DocsImage src="/img/api/wrap/wrapped-object-in-cypress-tests.png" alt="Command Log wrap" ></DocsImage>

当单击命令日志中的`wrap`命令时，控制台输出如下内容:

<DocsImage src="/img/api/wrap/console-log-only-shows-yield-of-wrap.png" alt="Console Log wrap" ></DocsImage>

## History

| Version                                     | Changes                                                                             |
| ------------------------------------------- | ----------------------------------------------------------------------------------- |
| [3.2.0](/guides/references/changelog#3-2-0) | Retry `cy.wrap()` if `undefined` when followed by [.should()](/api/commands/should) |
| [0.4.5](/guides/references/changelog#0.4.5) | `cy.wrap()` command added                                                           |

## 另请参阅

- [`.invoke()`](/api/commands/invoke)
- [`.its()`](/api/commands/its)
- [`.should()`](/api/commands/should)
- [`.spread()`](/api/commands/spread)
- [`.then()`](/api/commands/then)
- [登录:使用应用程序代码](/examples/examples/recipes#Logging-In) 配方
- [单元测试:应用程序代码](/examples/examples/recipes#Unit-Testing) 配方
