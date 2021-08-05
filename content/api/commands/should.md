---
title: should
---

创建一个断言。断言会自动重试，直到它们通过或超时.

<Alert type="info">

别名 [`.and()`](/api/commands/and)

</Alert>

<Alert type="info">

**注意:** `.should()` 假设您已经熟悉核心概念，如[断言](/guides/core-concepts/introduction-to-cypress#Assertions)

</Alert>

## 语法

```javascript
.should(chainers)
.should(chainers, value)
.should(chainers, method, value)
.should(callbackFn)
```

### 用法

**<Icon name="check-circle" color="green"></Icon> 正确的用法**

```javascript
cy.get('.error').should('be.empty') // 断言 '.error' 是 empty
cy.contains('Login').should('be.visible') // 断言这个元素是  visible
cy.wrap({ foo: 'bar' }).its('foo').should('eq', 'bar') // 断言属性 'foo' 等于 'bar'
```

**<Icon name="exclamation-triangle" color="red"></Icon> 不正确的使用**

```javascript
cy.should('eq', '42') // 不能 直接链在 'cy'后
```

### 参数

**<Icon name="angle-right"></Icon> chainers** **_(String)_**

任何来自[Chai](/guides/references/assertions#Chai) 或 [Chai-jQuery](/guides/references/assertions#Chai-jQuery) 或 [Sinon-Chai](/guides/references/assertions#Sinon-Chai)的有效chainer.

**<Icon name="angle-right"></Icon> value** **_(String)_**

断言chainer的值.  

**<Icon name="angle-right"></Icon> method** **_(String)_**

在 chainer 上调用的方法.

**<Icon name="angle-right"></Icon> callbackFn** **_(Function)_**

传递一个函数，其中可以包含任意数量的显式断言. 传递给函数的参数，函数最终都会输出回来.

### Yields [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Subject-Management)

<List><li>大部分情况下, `.should()` 产生与前一个命令相同的目标.</li></List>

```javascript
cy.get('nav') // yields <nav>
  .should('be.visible') // yields <nav>
```

然而，一些chainer改变了目标. 在下面的例子中, 第二个`.should()`产生了字符串`sans-serif` 因为chainer `have.css, 'font-family'`改变了目标.

```javascript
cy.get('nav') // yields 产生<nav>
  .should('be.visible') // yields产生 <nav>
  .should('have.css', 'font-family') // 产生 'sans-serif'
  .and('match', /serif/) // 产生 'sans-serif'
```

## 例子

### Chainers

#### 断言复选框已被禁用

```javascript
cy.get(':checkbox').should('be.disabled')
```

#### 生成当前DOM元素

```javascript
cy.get('option:first')
  .should('be.selected')
  .then(($option) => {
    // $option is yielded
  })
```

### 值

#### A这个类是 'form-horizontal'

```javascript
cy.get('form').should('have.class', 'form-horizontal')
```

#### 断言 值不是'Jane'

```javascript
cy.get('input').should('not.have.value', 'Jane')
```

#### 生成当前的目标

```javascript
cy.get('button')
  .should('have.id', 'new-user')
  .then(($button) => {
    // $button is yielded
  })
```

### 方法和值

#### 断言锚元素具有href属性

```javascript
// have.attr 来自 chai-jquery
cy.get('#header a').should('have.attr', 'href')
```

#### 断言href属性等于'/users'

```javascript
cy.get('#header a').should('have.attr', 'href', '/users')
```

**注意:** `have.attr`断言将当前的目标从原始元素更改为属性值

```javascript
cy.get('#header a') // 生成 元素
  .should('have.attr', 'href') // 生成"href"属性
  .and('equal', '/users') // 检查"href"值
```

### 焦点

#### 断言单击按钮后一个输入框获得焦点

```javascript
cy.get('#btn-focuses-input').click()
cy.get('#input-receives-focus').should('have.focus') // 相当于 should('be.focused')
```

### 函数

将函数传递给`.should()` 使您能够对所生成的目标进行多个断言. 这也给你机会充分操作你想要断言的目标.

请确保不要在回调函数中包含任何有副作用的代码. 回调函数将被一次又一次地重试，直到其中没有断言抛出.

#### 验证多个元素 长度，内容和类 `<p>`

```html
<div>
  <p class="text-primary">Hello World</p>
  <p class="text-danger">You have an error</p>
  <p class="text-default">Try again later</p>
</div>
```

```javascript
cy.get('p').should(($p) => {
  // 应该找到3个元素
  expect($p).to.have.length(3)

  // 确保第一个包含一些文本内容
  expect($p.first()).to.contain('Hello World')

  // 使用jquery的map来抓取它们的所有类
  // Jquery的map返回一个新的Jquery对象
  const classes = $p.map((i, el) => {
    return Cypress.$(el).attr('class')
  })

  // 调用classes.get()使其成为普通数组
  expect(classes.get()).to.deep.eq([
    'text-primary',
    'text-danger',
    'text-default',
  ])
})
```

**<Icon name="exclamation-triangle" color="red"></Icon> 警告** `.should()`回调函数返回的任何值都将被忽略. 原来的目标将继续传递给下一个命令.

```js
cy.get('p')
  .should(($p) => {
    expect($p).to.have.length(3)

    return 'foo'
  })
  .then(($p) => {
    //参数$p是3个元素，而不是"foo"
  })
```

#### 断言类名包含`heading-`

```html
<div class="docs-header">
  <div class="main-abc123 heading-xyz987">Introduction</div>
</div>
```

```js
cy.get('.docs-header')
  .find('div')
  // .should(cb) 回调函数将被重试
  .should(($div) => {
    expect($div).to.have.length(1)

    const className = $div[0].className

    expect(className).to.match(/heading-/)
  })
  // .then(cb) 回调不会被重试,
  // 要么通过，要么失败
  .then(($div) => {
    expect($div).to.have.text('Introduction')
  })
```

您甚至可以从回调函数抛出自己的错误。

```js
cy.get('.docs-header')
  .find('div')
  .should(($div) => {
    if ($div.length !== 1) {
      //你可以抛出自己的错误
      throw new Error('Did not find 1 element')
    }

    const className = $div[0].className

    if (!className.match(/heading-/)) {
      throw new Error(`No class "heading-" in ${className}`)
    }
  })
```

#### 断言3个元素的文本内容

下面的示例首先断言有3个元素，然后检查每个元素的文本内容.

```html
<ul class="connectors-list">
  <li>Walk the dog</li>
  <li>Feed the cat</li>
  <li>Write JavaScript</li>
</ul>
```

```javascript
cy.get('.connectors-list > li').should(($lis) => {
  expect($lis).to.have.length(3)
  expect($lis.eq(0)).to.contain('Walk the dog')
  expect($lis.eq(1)).to.contain('Feed the cat')
  expect($lis.eq(2)).to.contain('Write JavaScript')
})
```

<Alert type="info">

阅读[Cypress should 回调](https://glebbahmutov.com/blog/cypress-should-callback/) 博客文章，查看以上例子的更多变体e.

</Alert>

为清晰起见，您可以将字符串消息作为第二个参数传递给任何`expect`断言, 查看 [Chai#expect](https://www.chaijs.com/guide/styles/#expect).

```javascript
cy.get('.connectors-list > li').should(($lis) => {
  expect($lis, '3 items').to.have.length(3)
  expect($lis.eq(0), 'first item').to.contain('Walk the dog')
  expect($lis.eq(1), 'second item').to.contain('Feed the cat')
  expect($lis.eq(2), 'third item').to.contain('Write JavaScript')
})
```

这些字符串消息将显示在命令日志中，为每个断言提供更多的上下文。

<DocsImage src="/img/api/should/expect-with-message.png" alt="Expect assertions with messages" ></DocsImage>

#### 比较两个元素的文本值

下面的示例获取一个元素中包含的文本，并将其保存在闭包变量中. 然后测试获取另一个元素中的文本，并断言规范化后的两个文本值是相同的。

```html
<div class="company-details">
  <div class="title">Acme Developers</div>
  <div class="identifier">ACMEDEVELOPERS</div>
</div>
```

```javascript
const normalizeText = (s) => s.replace(/\s/g, '').toLowerCase()

// 保存从标题元素获取的文本
let titleText

cy.get('.company-details')
  .find('.title')
  .then(($title) => {
    // 保存第一个元素 的文本 
    titleText = normalizeText($title.text())
  })

cy.get('.company-details')
  .find('.identifier')
  .should(($identifier) => {
    //我们可以在比较前预处理文字
    const idText = normalizeText($identifier.text())

    // 标题元素中的文本应该已经设置
    expect(idText, 'ID').to.equal(titleText)
  })
```

### 多个断言

#### 链上多个断言

Cypress使将断言链在一起变得更容易。

在这个例子中，我们使用与`.should()`等价的[`.and()`](/api/commands/and).

```javascript
// 我们的目标并没有因为第一个断言而改变，
// 所以我们可以继续使用基于DOM的断言
cy.get('option:first').should('be.selected').and('have.value', 'Metallica')
```

### 持续等待，直到断言通过

Cypress不会解决完成你的命令，直到所有的断言通过。

```javascript
// 应用程序代码
$('button').click(() => {
  $button = $(this)

  setTimeout(() => {
    $button.removeClass('inactive').addClass('active')
  }, 1000)
})
```

```javascript
cy.get('button')
  .click()
  .should('have.class', 'active')
  .and('not.have.class', 'inactive')
```

## 注意

### 目标

#### 我如何知道哪些断言改变了目标，哪些断言保持了目标不变?

来自[Chai](/guides/references/bundled-tools#Chai) 或 [Chai-jQuery](/guides/references/bundled-tools#Chai-jQuery)的 chainer 都在文档中写清楚了返回的内容.

#### 使用回调函数不会改变所生成的目标

无论函数返回什么都会被忽略。Cypress总是强制命令生成前一个cy命令的生成值 (下面的例子是一个 `<button>`)

```javascript
cy.get('button')
  .should(($button) => {
    expect({ foo: 'bar' }).to.deep.eq({ foo: 'bar' })

    return { foo: 'bar' } // 返回被忽略, .should() 生成 <button>
  })
  .then(($button) => {
    // 对<button>做任何我们想要的事情
  })
```

### 差异

### ' `.then()` 和 `.should()`/`.and()` 之间的区别是什么??

使用`.then()` 允许您在回调函数中使用生成的目标，当您需要操作一些值或执行一些操作时应该使用.

当使用带有`.should()` 或 `.and()`的回调函数时, 另一方面, 有一个特殊的逻辑可以重新运行回调函数，直到其中没有抛出断言为止. 你应该注意`.should()` or `.and()`回调函数中不希望被多次执行的副作用。

## 规则

### 需要 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Chains-of-Commands)

<List><li>`.should()` 需要链接在一个其他命令之后.</li></List>

### 超时 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Timeouts)

<List><li>`.should()` 会继续[重试](/guides/core-concepts/retry-ability)它指定的断言，直到它超时.</li></List>

```javascript
cy.get('input', { timeout: 10000 }).should('have.value', '10')
// 这里的超时配置 将被传递给'.should()'
// 它将重试10秒
```

```javascript
cy.get('input', { timeout: 10000 }).should(($input) => {
  // 这里的超时配置 将被传递给'.should()'
  // 除非在前面抛出断言,
  // 所有断言将重试至多10秒
  expect($input).to.not.be('disabled')
  expect($input).to.not.have.class('error')
  expect($input).to.have.value('US')
})
```

## 命令日志

**_断言导航中应该有8个子导航_**

```javascript
cy.get('.left-nav>.nav').children().should('have.length', 8)
```

上面的命令将在命令日志中显示为:

<DocsImage src="/img/api/should/should-command-shows-up-as-assert-for-each-assertion.png" alt="Command Log should" ></DocsImage>

当在命令日志中单击`assert` 时, 控制台输出如下内容:

<DocsImage src="/img/api/should/assertion-in-console-log-shows-actual-versus-expected-data.png" alt="Console Log should" ></DocsImage>

## 历史

| Version                                       | Changes                           |
| --------------------------------------------- | --------------------------------- |
| [0.11.4](/guides/references/changelog#0-11-4) | Allows callback function argument |
| [< 0.3.3](/guides/references/changelog#0-3-3) | `.should()` command added         |

## 另请参阅

- [`.and()`](/api/commands/and)
- [指南:介绍Cypress](/guides/core-concepts/introduction-to-cypress#Assertions)
- [参考:断言列表](/guides/references/assertions)
- [cypress-example-kitchensink 断言](https://example.cypress.io/commands/assertions)
