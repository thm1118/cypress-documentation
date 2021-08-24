---
title: spy
---

将方法包装在spy中，以便记录对函数的调用，以及用什么参数调用.

<Alert type="info">

**注意:** `.spy()` 假设你已经熟悉我们的指南:[桩，间谍和时钟](/guides/guides/stubs-spies-and-clocks)

</Alert>

## 语法

```javascript
cy.spy(object, method)
```

### 用法

**<Icon name="check-circle" color="green"></Icon> 正确的用法**

```javascript
cy.spy(user, 'addFriend')
```

### 参数

**<Icon name="angle-right"></Icon> object** **_(Object)_**

具有需要包装方法的对象。

**<Icon name="angle-right"></Icon> method** **_(String)_**

要包装对象上的方法的名称。

### Yields 输出[<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Subject-Management)

与大多数Cypress命令不同，`cy.spy()是同步的，立即返回一个值(间谍)，而不是类似promise的可链对象。

`cy.spy()` 返回 一个 [Sinon.js spy](https://sinonjs.org/releases/v6.1.5/spies/). 支持 所有 Sinon.JS spies上的方法。

## 例子

### 方法

#### 用间谍包装方法

```javascript
// 假设 App.start 会调用 util.addListeners
cy.spy(util, 'addListeners')
App.start()
expect(util.addListeners).to.be.called
```

#### 禁用命令日志记录

你可以链接一个`.log(bool)`方法来禁止 `cy.stub()`调用显示在命令日志中. 当调用桩的次数过多时，这可能很有用.

```javascript
const obj = {
  foo() {},
}
const stub = cy.stub(obj, 'foo').log(false)
```

#### 更多的`cy.spy()`例子

<Alert type="info">

[看看我们的例子配方测试间谍，桩和时钟](/examples/examples/recipes#Stubbing-and-spying)

</Alert>

### 别名

使用[`.as()`](/api/commands/as) 为间谍添加一个别名，可以更容易地在错误消息和Cypress的命令日志中识别它们.

```javascript
const obj = {
  foo() {},
}
const spy = cy.spy(obj, 'foo').as('anyArgs')
const withFoo = spy.withArgs('foo').as('withFoo')

obj.foo()
expect(spy).to.be.called
expect(withFoo).to.be.called // 故意失败的断言
```

您将在命令日志中看到以下内容:

<DocsImage src="/img/api/spy/using-spy-with-alias.png" alt="spies with aliases" ></DocsImage>

## 注意

### Restores

#### 在多个测试之间 自动 重置/还原

`cy.spy()` 在[沙箱](https://sinonjs.org/releases/v6.1.5/sandbox/) 中创建间谍, 所以所有创建的间谍在测试之间自动重置/还原，而无需你显式地重新重置/还原.

### 区别

#### cy.spy() 和 cy.stub()之间的区别

`cy.spy()` 和 [`cy.stub()`](/api/commands/stub) 之间的主要区别是`cy.spy()`不替换方法, 它只是再次封装它. 因此，在记录调用的同时，仍然会调用原始方法. 在本地浏览器对象上测试方法时，这非常有用. 您可以验证一个方法正在被您的测试调用，并且仍然调用原始的方法操作.

### 断言

#### 断言支持

Cypress 也内置[sinon-chai](/guides/references/bundled-tools#Sinon-Chai)支持, 因此，任何[由`sinon-chai`支持的断言](/guides/references/assertions#Sinon-Chai)都可以使用，无需任何配置。

## 规则

### 要求 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Chains-of-Commands)

<List><li>`cy.spy()` 需要链接自 `cy`.</li></List>

### 断言 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Assertions)

<List><li>`cy.spy()` 不能链接任何断言.</li></List>

### 超时 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Timeouts)

<List><li>`cy.spy()` 不能超时.</li></List>

## 命令日志
**_创造一个间谍，取别名，再调用它_**

```javascript
const obj = {
  foo() {},
}
const spy = cy.spy(obj, 'foo').as('foo')

obj.foo('foo', 'bar')
expect(spy).to.be.called
```

上面的命令将在命令日志中显示为:

<DocsImage src="/img/api/spy/spying-shows-any-aliases-and-also-any-assertions-made.png" alt="Command Log spy" ></DocsImage>

当单击命令日志中的 `spy-1`事件时，控制台输出如下内容:

<DocsImage src="/img/api/spy/console-shows-spy-arguments-calls-and-the-object-being-spied.png" alt="Console Log spy" ></DocsImage>

## History

| Version                                       | Changes                   |
| --------------------------------------------- | ------------------------- |
| [0.20.0](/guides/references/changelog#0-20.0) | Added `.log(bool)` method |
| [0.18.8](/guides/references/changelog#0-18-8) | `cy.spy()` command added  |

## 另请参阅

- [`.as()`](/api/commands/as)
- [`cy.clock()`](/api/commands/clock)
- [指南:桩、间谍和时钟](/guides/guides/stubs-spies-and-clocks)
- [配方:桩,间谍](/examples/examples/recipes#Stubbing-and-spying)
- [`cy.stub()`](/api/commands/stub)
