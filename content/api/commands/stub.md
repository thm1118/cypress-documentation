---
title: stub
---

替换一个函数，记录它的使用并控制它的行为。

<Alert type="info">

**注意:** `.stub()`假设你已经熟悉我们的指南:[桩，间谍和时钟](/guides/guides/stubs-spies-and-clocks)

</Alert>

## 语法

```javascript
cy.stub()
cy.stub(object, method)
cy.stub(object, method, replacerFn)
```

### 用法

**<Icon name="check-circle" color="green"></Icon> 正确的用法**

```javascript
cy.stub(user, 'addFriend')
```

### 参数

**<Icon name="angle-right"></Icon> object** **_(Object)_**

需要替换的某方法的对象。

**<Icon name="angle-right"></Icon> method** **_(String)_**

要封装的对象上的方法名称。

**<Icon name="angle-right"></Icon> replacerFn** **_(Function)_**

用来替换对象上的方法的函数。

### Yields 输出 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Subject-Management)

与大多数Cypress命令不同，`cy.stub()` 是同步的，立即返回一个值(桩)，而不是类似promise的可链对象。

`cy.stub()` 返回一个 [Sinon.js stub](http://sinonjs.org). 支持在[Sinon.js](http://sinonjs.org)间谍和桩上找到的所有方法.

## 例子

### 方法

#### 创建桩并手动替换函数

```javascript
// 假设 App.start 会调用 util.addListeners
util.addListeners = cy.stub()

App.start()
expect(util.addListeners).to.be.called
```

#### 用桩替换方法

```javascript
// 假设 App.start 会调用 util.addListeners
cy.stub(util, 'addListeners')

App.start()
expect(util.addListeners).to.be.called
```

#### 用一个函数替换方法

```javascript
// 假设 App.start 会调用 util.addListeners
let listenersAdded = false

cy.stub(util, 'addListeners', () => {
  listenersAdded = true
})

App.start()
expect(listenersAdded).to.be.true
```

#### 指定桩方法的返回值

```javascript
// 假设 App.start 会调用 util.addListeners, 这个函数会返回一个方法
// that removes the listeners
const removeStub = cy.stub()

cy.stub(util, 'addListeners').returns(removeStub)

App.start()
App.stop()
expect(removeStub).to.be.called
```

#### 替换 window 的内置方法，比如 prompt

```javascript
// 假设 App.start 使用 prompt 来设置 一个样式类为"name"元素的值
cy.visit('http://localhost:3000', {
  onBeforeLoad(win) {
    cy.stub(win, 'prompt').returns('my custom message')
  },
})

App.start()

cy.window().its('prompt').should('be.called')
cy.get('.name').should('have.value', 'my custom message')
```

#### 禁用命令日志记录

你可以链接一个`.log(bool)` 方法来禁止`cy.stub()`调用显示在命令日志中。 当调用存根的次数过多时，这可能很有用。

```javascript
const obj = {
  foo() {},
}
const stub = cy.stub(obj, 'foo').log(false)
```

#### 更多的 `cy.stub()` 例子

<Alert type="info">

[看看我们的例子配方测试间谍，桩和时钟](/examples/examples/recipes#Stubbing-and-spying)

</Alert>

### 别名

使用[`.as()`](/api/commands/as) 向桩添加别名，可以更容易地在错误消息和Cypress的命令日志中识别它们.

```javascript
const obj = {
  foo() {},
}
const stub = cy.stub(obj, 'foo').as('anyArgs')
const withFoo = stub.withArgs('foo').as('withFoo')

obj.foo()
expect(stub).to.be.called
expect(withFoo).to.be.called // 故意失败的断言
```

您将在命令日志中看到以下内容:

<DocsImage src="/img/api/stub/stubs-with-aliases-and-error-in-command-log.png" alt="stubs with aliases" ></DocsImage>

## 注意

### 还原

#### 多个测试之间 会自动重设和还原

`cy.stub()` 在[沙盒](http://sinonjs.org/releases/v2.0.0/sandbox/) 中创建桩, 因此，所有创建的桩都会在测试之间自动重设和还原，而不必显式地重设和还原。

### 区别

#### cy.spy() 和 cy.stub()的区别

`cy.spy()` 和 [`cy.stub()`](/api/commands/stub) 之间的主要区别是`cy.spy()`不替换方法, 它只是再次封装它. 因此，在记录调用的同时，仍然会调用原始方法. 在本地浏览器对象上测试方法时，这非常有用. 您可以验证一个方法正在被您的测试调用，并且仍然调用原始的方法操作.

## 规则

### 要求 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Chains-of-Commands)

<List><li>`cy.stub()` 需要链接自 `cy`.</li></List>

### 断言 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Assertions)

<List><li>`cy.stub()` 不能链接任何断言.</li></List>

### 超时 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Timeouts)

<List><li>`cy.stub()`不能超时.</li></List>

## 命令日志

**_创造一个桩，取别名，再调用它_**

```javascript
const obj = {
  foo() {},
}
const stub = cy.stub(obj, 'foo').as('foo')

obj.foo('foo', 'bar')
expect(stub).to.be.called
```

上面的命令将在命令日志中显示为:

<DocsImage src="/img/api/stub/stub-in-command-log.png" alt="Command Log stub" ></DocsImage>

当单击命令日志中的`(stub-1)`事件时，控制台输出如下内容:

<DocsImage src="/img/api/stub/inspect-the-stubbed-object-and-any-calls-or-arguments-made.png" alt="Console Log stub" ></DocsImage>

## History

| Version                                       | Changes                   |
| --------------------------------------------- | ------------------------- |
| [0.20.0](/guides/references/changelog#0-20.0) | Added `.log(bool)` method |
| [0.18.8](/guides/references/changelog#0-18-8) | `cy.stub()` command added |

## See also

- [`.as()`](/api/commands/as)
- [`cy.clock()`](/api/commands/clock)
- [`cy.spy()`](/api/commands/spy)
- [指南:桩、间谍和时钟](/guides/guides/stubs-spies-and-clocks)
- [配方:桩,间谍](/examples/examples/recipes#Stubbing-and-spying)
- [配方:单元测试-模拟依赖](/examples/examples/recipes)
- [在端到端测试中的模拟导航器API](https://glebbahmutov.com/blog/stub-navigator-api/)
