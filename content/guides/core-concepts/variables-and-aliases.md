---
title: 变量和别名
---

<Alert type="info">

## <Icon name="graduation-cap"></Icon> 你将学习

- 如何处理异步命令
- 别名是什么以及它们如何简化您的代码
- 为什么在Cypress中很少需要使用变量
- 如何为对象，元素和路由使用别名

</Alert>

## Return Values

Cypress的新用户最初可能会发现使用我们api的异步特性很有挑战性。

<Alert type="success">

<strong class="alert-header">不要担心!</strong>

有许多方法可以引用、比较和利用Cypress命令生成的对象。

一旦你掌握了异步代码的窍门，你就会意识到你可以做所有你可以同步做的事情，而不会让你的代码做后空翻。

本指南探索了许多常见的模式，用于编写能够处理最复杂情况的优秀Cypress代码。

</Alert>

异步api始终存在JavaScript中。它们在现代代码中随处可见。事实上，大多数新的浏览器api都是异步的，许多核心Node模块也是异步的.

下面我们将探索的模式在Cypress内外都很有用。

你应该认识到的第一个也是最重要的概念是...

<Alert type="danger">

<strong class="alert-header">返回值</strong>

您不能分配或使用任何 **Cypress命令的返回值**. 命令排队并异步运行.

</Alert>

```js
// 事情不会像你想的那样发生
const button = cy.get('button')
const form = cy.get('form')

button.click()
```

### 闭包

使用[`.then()`](/api/commands/then)可以访问每个Cypress命令输出的结果.

```js
cy.get('button').then(($btn) => {
  // $btn是前一个命令输出给我们的对象
})
```

如果你熟悉[原生Promises](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises) ，Cypress的`.then() `也以同样的方式工作. 您可以继续在`.then()`中嵌套更多的Cypress命令.

每个嵌套命令都可以访问前面命令中完成的工作. 下面的代码是更好的阐述.

```js
cy.get('button').then(($btn) => {

  // 存储按钮的文本
  const txt = $btn.text()

  // 提交表单
  cy.get('form').submit()

  // 比较两个按钮的文本，确保它们是不同的
  cy.get('button').should(($btn2) => {
    expect($btn2.text()).not.to.eq(txt)
  })
})

// 这些命令在所有其他前面的命令完成后运行
cy.get(...).find(...).should(...)
```

直到所有嵌套的命令都完成，`.then()` 之外的命令才会运行，

<Alert type="info">

通过使用回调函数，我们创建了一个[闭包](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Closures). 闭包使我们能够保持引用，用来引用之前命令已完成的工作.

</Alert>

### Debugging

使用`.then()`函数是使用[`debugger`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/debugger) 的绝佳机会. 这可以帮助您理解命令运行的顺序。这还使您能够检查Cypress在每个命令中生成的对象。

```js
cy.get('button').then(($btn) => {
  // 检查 $btn <object>
  debugger

  cy.get('#countries')
    .select('USA')
    .then(($select) => {
      // 检查 $select <object>
      debugger

      cy.url().should((url) => {
        // 检查 the url <string>
        debugger

        $btn // 仍然可用
        $select // 也仍然可用
      })
    })
})
```

###  变量

通常在Cypress中, 你几乎不需要使用`const`, `let`, 或 `var`. 当使用闭包时，你总是可以访问那些给你的对象，而不需要分配它们到某个变量。

这个规则的一个例外是当你处理可变对象(改变状态)时.当事情的状态发生变化时，你通常想要比较对象的前一个值和下一个值。

这里有一个`const`的很好的用例.

```html
<button>increment</button>

你点击按钮 <span id="num">0</span> 次
```

```js
// 应用代码
let count = 0

$('button').on('click', () => {
  $('#num').text((count += 1))
})
```

```js
// cypress 测试代码
cy.get('#num').then(($span) => {
  // 捕获num现在是什么值
  const num1 = parseFloat($span.text())

  cy.get('button')
    .click()
    .then(() => {
      // 现在再捕捉一次
      const num2 = parseFloat($span.text())

      // 确保这是我们所期望的
      expect(num2).to.eq(num1 + 1)
    })
})
```

使用`const`的原因是`$span`对象是可变的. 当你有可变对象并试图比较它们时，你需要存储它们的值。使用`const`是一种完美的方式.

## 别名

使用`.then()`回调函数来访问之前的命令值是很好的;但是当你在`before`or `beforeEach`这样的钩子中运行代码,会发生什么呢 ?

```js
beforeEach(() => {
  cy.button().then(($btn) => {
    const text = $btn.text()
  })
})

it('does not have access to text', () => {
  //我们如何访问 text ?!
})
```

我们将如何访问`text`?

我们可以使用“`let`让代码做一些丑陋的后空翻来访问它.

<Alert type="danger">

<strong class="alert-header">不要这样做</strong>

下面的代码只是用于不好的演示。

</Alert>

```js
describe('a suite', () => {
  //这创建了一个围绕'text'的闭包，这样我们就可以访问它了
  let text

  beforeEach(() => {
    cy.button().then(($btn) => {
      // 定义 text的引用
      text = $btn.text()
    })
  })

  it('可以使用text', () => {
    // 现在我们可以使用text，但这不是一个很好的解决方案:(
    text
  })
})
```

幸运的是，您不必让您的代码做后空翻。有了Cypress，我们能更好地处理这些情况。

<Alert type="success">

<strong class="alert-header">引入别名</strong>

别名在Cypress中是一个功能强大的结构，有很多用途。我们将在下面探索它们的每个功能.

首先，我们将使用它们在钩子和测试之间共享对象.

</Alert>

### 共享上下文

共享上下文是使用别名的最简单方法.

使用[`.as()`](/api/commands/as)命令别名您想要共享的内容.

让我们看一下前面使用别名的示例.

```js
beforeEach(() => {
  // 将$btn.text()别名为'text'
  cy.get('button').invoke('text').as('text')
})

it('has access to text', function () {
  this.text // 现在可以引用
})
```

在底层，别名的基本对象和原语利用了Mocha的共享[`context`](https://github.com/mochajs/mocha/wiki/Shared-Behaviours) 对象:也就是说，别名可以通过`this.*`的属性使用.

Mocha在每个测试的所有适用钩子上自动为我们共享上下文. 此外，这些别名和属性会在每次测试后自动清除。

```js
describe('parent', () => {
  beforeEach(() => {
    cy.wrap('one').as('a')
  })

  context('child', () => {
    beforeEach(() => {
      cy.wrap('two').as('b')
    })

    describe('grandchild', () => {
      beforeEach(() => {
        cy.wrap('three').as('c')
      })

      it('可以访问作为属性的所有别名', function () {
        expect(this.a).to.eq('one') // true
        expect(this.b).to.eq('two') // true
        expect(this.c).to.eq('three') // true
      })
    })
  })
})
```

#### 访问夹具:

共享上下文最常见的用例是在处理[`cy.fixture()`](/api/commands/fixture).

通常情况下，您可能会在`beforeEach` 钩子中加载一个fixture，在测试中使用.

```js
beforeEach(() => {
  // 别名 用户fixture
  cy.fixture('users.json').as('users')
})

it('以某种方式使用用户', function () {
  // 访问users属性
  const user = this.users[0]

  // 确保标题包含第一个
  // user的name
  cy.get('header').should('contain', user.name)
})
```

<Alert type="danger">

<strong class="alert-header">注意异步命令</strong>

不要忘记 **Cypress命令是异步的** !

在`.as()`命令运行完成前，你不能用`this.*`引用.

</Alert>

```js
it('不正确使用别名', function () {
  cy.fixture('users.json').as('users')

  // 这是错误的
  //
  // this.users 还没有定义
  // 因为`as`命令只被加入了队列-它还没有运行
  const user = this.users[0]
})
```

我们以前介绍过很多次的原则也适用于这种情况。如果你想要访问命令产生的结果你必须在闭包中使用[`.then()`](/api/commands/then).

```js
// 是的好
cy.fixture('users.json').then((users) => {
  // 现在我们可以完全避免使用别名
  // 并使用回调函数
  const user = users[0]

  // 通过
  cy.get('header').should('contain', user.name)
})
```

#### 避免使用 `this`

<Alert type="warning">

<strong class="alert-header">箭头函数</strong>

如果你使用[箭头函数](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions) 作为测试或钩子函数体，就无法使用`this.*`属性访问别名，

这就是为什么我们所有的例子都使用常规的`function(){}`语法而不是lambda的`fat arrow`语法`() => {}`.

</Alert>

除了`this.*`语法访问别名，还有另一种访问别名的方法。

[`cy.get()`](/api/commands/get) 命令能够使用特殊的语法使用`@`字符访问别名:

```js
beforeEach(() => {
  // 别名用户fixture
  cy.fixture('users.json').as('users')
})

it('以某种方式使用用户', function () {
  // 使用特殊的'@'语法访问别名
  // 从而避免使用`this.*`
  cy.get('@users').then((users) => {
    // 访问users
    const user = users[0]

    // 确保标题包含第一个
    // user's name
    cy.get('header').should('contain', user.name)
  })
})
```

通过使用[`cy.get()`](/api/commands/get) 我们可以避免使用`this`.

记住，这两种方法都有用例，因为它们有不同的工效.

当使用`this.users`时，是同步访问它, 而当使用 `cy.get('@users')`时，它变成了一个异步命令.

你可以把`cy.get('@users')`想成与[`cy.wrap(this.users)`](/api/commands/wrap)一样 .

### 元素

在与DOM元素一起使用时，别名还有其他特殊特征.

在给DOM元素起了别名之后，可用于后面的重用。

```javascript
// 将table 中找到的所有tr别名为'rows'
cy.get('table').find('tr').as('rows')
```

在内部，Cypress引用了`<tr>`集合作为别名"rows"返回。 要在以后引用这些“rows”，可以使用[`cy.get()`](/api/commands/get) 命令.

```javascript
// Cypress返回对<tr> 的引用，
// 这允许我们继续链上查找第一行的命令
cy.get('@rows').first().click()
```

因为我们在[`cy.get()`](/api/commands/get)中使用了`@`字符，而不是在DOM中查询元素，[`cy.get()`](/api/commands/get)查找名为`rows`的现有别名并返回引用(如果找到它).

#### 不新鲜的元素:

在许多单页面JavaScript应用程序中，DOM不断地重新呈现应用程序的某些部分. 如果在使用别名调用[`cy.get()`](/api/commands/get)时将已从DOM中删除的DOM元素作为别名，Cypress将自动重新查询DOM以再次找到这些元素。

```html
<ul id="todos">
  <li>
   遛狗
    <button class="edit">编辑</button>
  </li>
  <li>
    喂猫
    <button class="edit">编辑</button>
  </li>
</ul>
```

让我们想象一下，当我们点击'.edit'按钮，我们的`<li>`在DOM中被重新渲染. 它不再显示编辑案例，而是显示了一个`<input />`表单文本，从而允许您编辑todo. 之前的`<li>`已经完全从DOM中删除，并在其位置呈现一个新的`<li>`.

```javascript
cy.get('#todos li').first().as('firstTodo')
cy.get('@firstTodo').find('.edit').click()
cy.get('@firstTodo')
  .should('have.class', 'editing')
  .find('input')
  .type('Clean the kitchen')
```

当我们引用`@firstTodo`时，Cypress会检查它所引用的所有元素是否仍然在DOM中. 如果是，则返回那些现有的元素。如果不是，Cypress将重播通向别名定义的命令.

在我们的例子中，它将重新发出命令: `cy.get('#todos li').first()`. 一切正常，因为找到了新的`<li>`。

<Alert type="warning">

通常，重放以前的命令会返回您所期望的结果，但并不总是如此. 建议您尽快为元素设置别名，而不是进一步使用命令链.

- `cy.get('#nav header .user').as('user')` <Icon name="check-circle" color="green"></Icon> (好)
- `cy.get('#nav').find('header').find('.user').as('user')` <Icon name="exclamation-triangle" color="red"></Icon> (差)

当有疑问时，您总是可以发出一个常规的[`cy.get()`](/api/commands/get)来再次查询元素.

</Alert>

### 拦截

别名也可以与[cy.intercept()](/api/commands/intercept)一起使用. 别名你拦截的路由可以让你:

- 确保应用程序发出预期的请求
- 等待服务器发送响应
- 访问断言的实际请求对象

<DocsImage src="/img/guides/aliasing-routes.jpg" alt="Alias commands" ></DocsImage>

这里有一个别名拦截路由的例子，并等待它完成。

```js
cy.intercept('POST', '/users', { id: 123 }).as('postUser')

cy.get('form').submit()

cy.wait('@postUser').then(({ request }) => {
  expect(request.body).to.have.property('name', 'Brian')
})

cy.contains('成功创建用户: Brian')
```

<Alert type="info">

<strong class="alert-header">刚接触Cypress ?</strong>

[我们有一个关于路由网络请求的更详细和全面的指南](/guides/guides/network-requests)

</Alert>

###  请求

别名也可以用于[请求](/api/commands/request).

下面是一个别名请求，并稍后访问其属性的示例.

```js
cy.request('https://jsonplaceholder.cypress.io/comments').as('comments')

// 这里还有 其他测试代码

cy.get('@comments').should((response) => {
  if (response.status === 200) {
      expect(response).to.have.property('duration')
    } else {
      // 你想查什么都行
    }
  })
})
```

### 在每个测试之前都会重置别名

**Note:** 在每个测试之前会重置所有别名. 一个常见的用户错误是使用`before`钩子创建别名. 这样的别名仅在第一个测试中有效!

```js
// 🚨 这是错误的例子
before(() => {
  // 注意，这个别名只使用`before`钩子创建了一次
  cy.wrap('some value').as('exampleValue')
})

it('在第一个测试中有效', () => {
  cy.get('@exampleValue').should('equal', 'some value')
})

// 说明由于别名被重置，第二次测试失败
it('不存在于第二次测试吗', () => {
  // 这里没有别名，因为它是在第一个测试之前创建的，
  // 并且在第二个测试之前重置
  cy.get('@exampleValue').should('equal', 'some value')
})
```

解决方案是在每次测试之前使用 `beforeEach`钩子创建别名

```js
// ✅ 正确的例子
beforeEach(() => {
  // 我们将在每次测试之前创建一个新的别名
  cy.wrap('some value').as('exampleValue')
})

it('在第一个测试中有效', () => {
  cy.get('@exampleValue').should('equal', 'some value')
})

it('在第二个测试中有效', () => {
  cy.get('@exampleValue').should('equal', 'some value')
})
```

## 参见

- [博客:从Cypress自定义命令加载夹具](https://glebbahmutov.com/blog/fixtures-in-custom-commands/) 说明如何加载或导入要在Cypress自定义命令中使用的fixture.
