---
title: 桩，间谍和时钟
---

<Alert type="info">

## <Icon name="graduation-cap"></Icon> 你将学习

- Cypress包括哪些库来提供典型的测试功能
- 如何使用桩断言代码被调用但阻止它执行
- 如何使用间谍断言代码被调用而不干扰其执行
- 对依赖时间的代码开展确定性测试时，如何控制时间
- Cypress如何改进和扩展所包含的库

</Alert>

## 能力

Cypress内置了使用[`cy.stub()`](/api/commands/stub), [`cy.spy()`](/api/commands/spy)或使用[`cy.clock()`](/api/commands/clock)修改应用程序的时间的能力。 -[`cy.clock()`](/api/commands/clock)允许您操作 `Date`, `setTimeout`, `clearTimeout`, `setInterval`, 或 `clearInterval`.

这些命令在编写**单元测试**和**集成测试**时都很有用.

## 库和工具

Cypress自动打包和包装这些库:

| 名称                                                  | 提供功能                                                                             |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| [`sinon`](http://sinonjs.org)                         | 提供[`cy.stub()`](/api/commands/stub) 和 [`cy.spy()`](/api/commands/spy) api     |
| [`lolex`](https://github.com/sinonjs/lolex)           | 提供[`cy.clock()`](/api/commands/clock) 和 [`cy.tick()`](/api/commands/tick) api |
| [`sinon-chai`](https://github.com/domenic/sinon-chai) | 对桩和间谍的`chai`断言                                                  |

您可以参考每个库的文档以获得更多的示例和解释.

## 常见的场景

<Alert type="info">

<strong class="alert-header">示例测试!</strong>

[看看我们的例子配方测试间谍，桩和时间](/examples/examples/recipes#Stubbing-and-spying)

</Alert>

### 桩

桩是一种修改函数并将其行为的控制权委托给你(程序)的方法。

桩在单元测试中最常用，但在一些集成端到端测试中仍然有用.

```javascript
// 创建一个独立的桩(通常用于单元测试)
cy.stub()

// 用桩函数替换obj.method()
cy.stub(obj, 'method')

// 强制obj.method()返回"foo"
cy.stub(obj, 'method').returns('foo')

// 使用bar参数强制obj.method()返回foo
cy.stub(obj, 'method').withArgs('bar').returns('foo')

// 强制obj.method()返回一个解析为"foo"的promise
cy.stub(obj, 'method').resolves('foo')

// 强制obj.method()返回一个被拒绝的返回一个错误的promise
cy.stub(obj, 'method').rejects(new Error('foo'))
```

当一个函数有你想要控制的副作用时，你通常会把它替换成桩。

#### 常见的场景:

- 您有一个接受回调的函数，并希望调用该回调.
- 你的函数返回一个`Promise`，你想要自动解决或者拒绝它.
- 你有一个包装`window.location`的函数。但又不希望你的应用程序真正被导航.
- 您试图通过强制执行失败来测试应用程序的“失败路径”.
- 您试图通过强制通过来测试应用程序的“快乐路径”.
- 您希望“欺骗”应用程序，使其认为已登录或已注销.
- 您正在使用`oauth`，并希望模拟登录方法.

<Alert type="info">

<strong class="alert-header">cy.stub()</strong>

[阅读更多关于如何使用 `cy.stub()`的信息](/api/commands/stub)

</Alert>

### 间谍

间谍给你“偷窥”函数的能力,通过让您捕获调用函数的参数，并断言参数调是否正确, 或者函数是否被调用了几次， 甚至是函数的返回值是否正确，函数调用的上下文是否正确.

间谍不会**改变**函数的行为- 函数完好无损. 当您测试多个函数之间的契约时，间谍是最有用的，并且你不关心实际函数可能产生的副作用(如果有的话).

```javascript
cy.spy(obj, 'method')
```

<Alert type="info">

<strong class="alert-header">cy.spy()</strong>

[阅读更多关于如何使用`cy.spy()`](/api/commands/spy).

</Alert>

### 时钟

在某些情况下，为了覆盖应用程序的行为或避免慢测试，需要控制应用程序的`date` 和 `time`.

使用[cy.clock()](/api/commands/clock)你可以控制:

- `Date`
- `setTimeout`
- `setInterval`

#### 常见的场景

##### 控制 `setInterval`

- 你用`setInterval`在应用中轮询某个东西并想控制它.
- 您有想要控制的**throttled** 或 **debounced**功能.

一旦你启用了[`cy.clock()`](/api/commands/clock)，你就可以让它以毫秒为单位前进来控制时间.

```javascript
cy.clock()
cy.visit('http://localhost:3333')
cy.get('#search').type('Acme Company')
cy.tick(1000)
```

你可以在访问你的应用程序之前调用[`cy.clock()`](/api/commands/clock)，我们会自动将它绑定到下一个[`cyl .visit()`](/api/commands/visit). 我们在调用应用程序的任何计时器**之前**进行绑定. 它的工作原理与 [`cy.server()`](/api/commands/server) 和 [`cy.route()`](/api/commands/route)相同.

##### 恢复时钟

您可以恢复时钟，并允许应用程序正常恢复，而无需操作与时间相关的本地全局函数. 这将在测试之间自动调用.

```javascript
cy.clock()
cy.visit('http://localhost:3333')
cy.get('#search').type('Acme Company')
cy.tick(1000)
// 更多测试代码

// 恢复时钟
cy.clock().then((clock) => {
  clock.restore()
})
// 更多测试代码
```

您还可以使用[.invoke()](/api/commands/invoke)来调用`restore`函数进行恢复.

```js
cy.clock().invoke('restore')
```

### 断言

一旦你有了`stub` 或  `spy`，你就可以创建关于它们的断言。

```javascript
const user = {
  getName: (arg) => {
    return arg
  },

  updateEmail: (arg) => {
    return arg
  },

  fail: () => {
    throw new Error('fail whale')
  },
}

// 强制user.getName()返回“Jane”
cy.stub(user, 'getName').returns('Jane Lane')

// 监视updateEmail函数，但不改变其行为
cy.spy(user, 'updateEmail')

// 监视fail函数，但不要改变它的行为
cy.spy(user, 'fail')

// 调用 getName
const name = user.getName(123)

// 调用 updateEmail
const email = user.updateEmail('jane@devs.com')

try {
  // 调用 fail
  user.fail()
} catch (e) {}

expect(name).to.eq('Jane Lane') // true
expect(user.getName).to.be.calledOnce // true
expect(user.getName).not.to.be.calledTwice // true
expect(user.getName).to.be.calledWith(123)
expect(user.getName).to.be.calledWithExactly(123) // true
expect(user.getName).to.be.calledOn(user) // true

expect(email).to.eq('jane@devs.com') // true
expect(user.updateEmail).to.be.calledWith('jane@devs.com') // true
expect(user.updateEmail).to.have.returned('jane@devs.com') // true

expect(user.fail).to.have.thrown('Error') // true
```

## 集成和扩展

除了将这些工具集成在一起，我们还扩展和改进了这些工具之间的协作。

**_一些例子:_**

- 我们将Sinon的参数stringifier替换为一个噪音更小、性能更好的自定义版本.
- 我们改进了`sinon-chai`断言输出，改变了通过测试和失败测试期间显示的内容.
- 我们为`stub` and `spy`api添加了别名支持.
- 在测试之间，我们会自动恢复和拆除`stub`, `spy`, 和 `clock`.

我们还将所有这些api直接集成到命令日志中，所以您可以直观地看到应用程序中发生了什么.

**_我们可以直观地指出:_**

- 一个 `stub` 被调用
- 一个 `spy` 被调用
- 一个 `clock` 被调用

当您使用[`.as()`](/api/commands/as)命令时，我们还将这些别名与调用关联起来. 这与别名[`cy.intercept()`](/api/commands/intercept)的工作原理相同.

当通过调用方法`.withArgs(...)` 创建桩时，我们也可以直观地将它们链接在一起.

当您单击桩或间谍时，我们还会输出**非常有用**的调试信息。

**_例如，我们自动显示:_**

- 调用计数(和总调用数)
- 参数,不会改变它们 (它们是真正的参数)
- 函数的返回值
- 调用函数时使用的上下文

## 另请参阅

- [间谍，桩和时钟](https://example.cypress.io/commands/spies-stubs-clocks) 例子
- [模拟端到端测试中的导航器API](https://glebbahmutov.com/blog/stub-navigator-api/)
- [使用应用动作和效果收缩不可测试代码](https://www.cypress.io/blog/2019/02/28/shrink-the-untestable-code-with-app-actions-and-effects/)
- [用cy.intercept 和 cy.clock组合测试周期性的网络请求](https://www.cypress.io/blog/2021/02/23/cy-intercept-and-cy-clock/)
