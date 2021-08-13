---
title: contains
---

获取包含特定文本的DOM元素. DOM元素可以实际包含比所需文本更多的内容，但仍然能够匹配上. 此外, Cypress[偏好某些DOM元素](#Notes)，而不是找到的最深的元素.

## 语法

```javascript
.contains(content)
.contains(content, options)
.contains(selector, content)
.contains(selector, content, options)

// ---or---

cy.contains(content)
cy.contains(content, options)
cy.contains(selector, content)
cy.contains(selector, content, options)
```

### 用法

**<Icon name="check-circle" color="green"></Icon> 正确的用法**

```javascript
cy.get('.nav').contains('About') // 输出在.nav 里的 包含 'About'文博内容的元素；
cy.contains('Hello') // 输出document 内第一个包含'Hello'的元素
```

**<Icon name="exclamation-triangle" color="red"></Icon> 不正确的用法**

```javascript
cy.title().contains('My App') // 错误, 'title' 不会输出 DOM 元素
cy.getCookies().contains('_key') // 错误, 'getCookies' 不会输出 DOM 元素
```

### 参数

**<Icon name="angle-right"></Icon> content** **_(String, Number, RegExp)_**

获取的元素所包含的文本.

**<Icon name="angle-right"></Icon> selector** **_(String selector)_**

指定一个选择器来过滤包含文本的DOM元素. 对于指定的选择器，Cypress将 _忽略_ 它的[默认优先顺序](#Notes). 使用选择器可以返回包含特定文本的更浅的元素(树的更高位置).

**<Icon name="angle-right"></Icon> options** **_(Object)_**

传入一个options对象来改变`.contains()`的默认行为.

| 选项               | 默认值                                                                             | 描述                                                                                                  |
| ------------------ | --------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| `matchCase`        | `true`                                                                            | 是否检查大小写敏感性                                                                                       |
| `log`              | `true`                                                                            | 是否在[命令日志](/guides/core-concepts/test-runner#Command-Log) 中显示命令                    |
| `timeout`          | [`defaultCommandTimeout`](/guides/references/configuration#Timeouts)              | 在[超时](#Timeouts) 之前等待 `.contains()`解析的时间                                    |
| `includeShadowDom` | [`includeShadowDom` config option value](/guides/references/configuration#Global) | 是否遍历影子DOM边界并在生成的结果中包含影子DOM中的元素. |

### Yields [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Subject-Management) 输出

<List><li>`.contains()` 输出它找到的新DOM元素.</li></List>

## 示例

### Content

#### 找到第一个包含指定文本的元素

```html
<ul>
  <li>apples</li>
  <li>oranges</li>
  <li>bananas</li>
</ul>
```

```javascript
// 输出 <li>apples</li>
cy.contains('apples')
```

#### 根据值找到`input[type='submit']`

获取form元素并在其后代中搜索内容“提交表单!”

```html
<div id="main">
  <form>
    <div>
      <label>name</label>
      <input name="name" />
    </div>
    <div>
      <label>age</label>
      <input name="age" />
    </div>
    <input type="submit" value="提交表单!" />
  </form>
</div>
```

```javascript
// 输出 input[type='submit'] 元素，然后再单击
cy.get('form').contains('提交表单!').click()
```

### Number

#### 找到第一个包含指定数值的元素

即使`<span>`是包含"4"的最深的元素, Cypress 依然是只是自动输出`<button>`元素，因为它的[首选元素顺序](#Preferences).

```html
<button class="btn btn-primary" type="button">
  Messages <span class="badge">4</span>
</button>
```

```javascript
// 输出 <button> 而不是 <span>
cy.contains(4)
```

### 正则表达式

#### 找到与正则表达式匹配的文本的第一个元素

```html
<ul>
  <li>apples</li>
  <li>oranges</li>
  <li>bananas</li>
</ul>
```

```javascript
// 输出 <li>bananas</li>
cy.contains(/^b\w+/)
```

### 选择器

#### 指定一个选择器以返回特定的元素

从技术上讲，下面例子中的`<html>`, `<body>`, `<ul>`, 和第一个`<li>`都包含`apples`.

通常Cypress会返回第一个`<li>`，因为这是包含"apples"的最深的元素。.

为了覆盖生成的元素，我们可以传递'ul'作为选择器。

```html
<html>
  <body>
    <ul>
      <li>apples</li>
      <li>oranges</li>
      <li>bananas</li>
    </ul>
  </body>
</html>
```

```javascript
// 输出 <ul>...</ul>
cy.contains('ul', 'apples')
```

#### 始终以form为目标

下面是一个使用选择器的示例，以确保始终以`<form>`为[目标](guidescore-conceptsintroduction-to-cypressSubject-Management)用于后面的链接命令.

```html
<form>
  <div>
    <label>name</label>
    <input name="name" />
  </div>
  <button type="submit">Proceed</button>
</form>
```

```javascript
cy.get('form') // 输出 <form>...</form>
  .contains('form', 'Proceed') // 输出 <form>...</form>
  .submit() // 输出 <form>...</form>
```

如果没有显式指定`form`选择器，目标将更改为`<button>`. 使用显式选择器确保链接的命令将以`<form>`作为目标.

### 区分大小写

下面是一个使用`matchCase`选项来忽略大小写敏感性的示例.

```html
<div>Capital Sentence</div>
```

```js
cy.get('div').contains('capital sentence') // 失败
cy.get('div').contains('capital sentence', { matchCase: false }) // 通过
```

## Notes

### 作用域

`.contains()` 可能是一系列命令的起始，或者链接到一个现有的命令链，其搜索范围是不同的.

#### 一系列命令的起始:

这将查询整个`document的内容。

```javascript
cy.contains('Log In')
```

#### 链接到一个现有的命令链

这将在`<#checkout-container>`元素内部进行查询。

```javascript
cy.get('#checkout-container').contains('Buy Now')
```

#### 链接多个`contains`时要小心

让我们设想这样一个场景:您单击一个按钮要删除用户，然后出现一个对话框，要求您确认删除。

```javascript
// 这不会像预期的那样工作
cy.contains('Delete User').click().contains('Yes, Delete!').click()
```

因为第二个`.contains()` 是由一个输出 `<button>`的命令链接起来的, Cypress将在 `<button>`的内部搜索。

换句话说，Cypress将在“Delete User”`<button>`内搜索包含"Yes, Delete!"内容的元素, 这不是我们想要的行为.

你要做的是，再次调用`cy`,它会自动创建一个新的作用域为`document`的链.

```javascript
cy.contains('Delete User').click()
cy.contains('Yes, Delete!').click()
```

### `<pre>`标签不会忽略前导、尾随和重复的空格

与其他标签不同，`<pre>`不会忽略前导、尾随或重复的空格，如下所示:

```html
<!--Code for test-->
<h2>Other tags</h2>
<p>Hello, World !</p>

<h2>Pre tag</h2>
<pre>                 Hello,           World      !</pre>
```

呈现的结果:

<DocsImage src="/img/api/contains/contains-pre-exception.png" alt="The result of pre tag" ></DocsImage>

为了反映这种行为，Cypress也没有忽视他们.

```js
// 为以上代码的测试结果

cy.get('p').contains('Hello, World !') // 通过
cy.get('p').contains('           Hello,          World   !') // 失败

cy.get('pre').contains('Hello, World !') // 失败
cy.get('pre').contains('                 Hello,           World      !') // 通过
```

### 非分隔空格

您可以在 `cy.contains()`中使用空格字符来匹配HTML中使用非分隔空格实体`&nbsp;`的文本。

```html
<span>Hello&nbsp;world</span>
```

```javascript
// 找到span元素
cy.contains('Hello world')
```

**提示:** 在 [如何获取元素的文本内容?](/faq/questions/using-cypress-faq#How-do-I-get-an-element-s-text-contents)内阅读关于使用非分隔空格实体的文本的断言

### 单个元素

#### 只返回 _第一个_ 匹配的元素

```html
<ul id="header">
  <li>Welcome, Jane Lane</li>
</ul>
<div id="main">
  <span>These users have 10 connections with Jane Lane</span>
  <ul>
    <li>Jamal</li>
    <li>Patricia</li>
  </ul>
</div>
```

下面的例子将返回`#header`中的`<li>`，因为这是包含文本"Jane Lane"的 _第一个_ 元素.

```javascript
// 输出 #header li
cy.contains('Jane Lane')
```

如果想选择`<span>`，可以缩小`.contains()`之前输出的元素。

```javascript
// 输出 <span>
cy.get('#main').contains('Jane Lane')
```

### 首选项

#### 元素查找的偏好顺序

`.contains()`默认选择树中较高位置的元素:

- `input[type='submit']`
- `button`
- `a`
- `label`

如果你将selector参数传递给`.contains()`， Cypress将忽略这个元素的优先级顺序。.

#### 优先`<button>`而不是其他更深层次的元素

即使`<span>`是包含"Search"的最深层次的元素, Cypress 依然输出`<button>`元素.

```html
<form>
  <button>
    <i class="fa fa-search"></i>
    <span>Search</span>
  </button>
</form>
```

```javascript
// 输出 <button>
cy.contains('Search').children('i').should('have.class', 'fa-search')
```

#### `<a>`优于其他更深层次的元素

即使`<span>` 是包含"Sign Out"的最深层次的元素，Cypress 依然输出 `<a>`元素.

```html
<nav>
  <a href="/users">
    <span>Users</span>
  </a>
  <a href="/signout">
    <span>Sign Out</span>
  </a>
</nav>
```

```javascript
// 输出 <a>
cy.get('nav').contains('Sign Out').should('have.attr', 'href', '/signout')
```

#### `<label>`优于其他更深层次的元素

即使“<span>”是包含“Age”的最深层次的元素，Cypress依然输出`<label>`元素。.

```html
<form>
  <label>
    <span>Name:</span>
    <input name="name" />
  </label>
  <label>
    <span>Age:</span>
    <input name="age" />
  </label>
</form>
```

```javascript
// 输出 label
cy.contains('Age').find('input').type('29')
```

## 规则

### 需要 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Chains-of-Commands)

<List><li>`.contains()`可以直接链接在`cy`后，也可以链接在输出DOM元素的命令链接后。</li></List>

### 断言 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Assertions)

<List><li>`.contains()` will automatically [retry](/guides/core-concepts/retry-ability) until the element(s) [exist in the DOM](/guides/core-concepts/introduction-to-cypress#Default-Assertions)</li><li>`.contains()` will automatically [retry](/guides/core-concepts/retry-ability) until all chained assertions have passed</li></List>

### 超时 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Timeouts)

<List><li>`.contains()`在等待[存在于DOM中](/guides/core-concepts/introduction-to-cypress#Default-Assertions)的元素时可能超时.</li><li>`.contains()` can time out waiting for assertions you've added to pass.</li></List>

## 命令日志

**_包含文本“New User”的元素_**

```javascript
cy.get('h1').contains('New User')
```

上面的命令将在命令日志中显示为:

<DocsImage src="/img/api/contains/find-el-that-contains-text.png" alt="Command Log contains" ></DocsImage>

当单击命令日志中的`contains`命令时，控制台输出如下内容:

<DocsImage src="/img/api/contains/see-elements-found-from-contains-in-console.png" alt="console.log contains" ></DocsImage>

## History

| Version                                     | Changes                               |
| ------------------------------------------- | ------------------------------------- |
| [5.2.0](/guides/references/changelog#5-2-0) | Added `includeShadowDom` option.      |
| [4.0.0](/guides/references/changelog#4-0-0) | Added support for option `matchCase`. |

## See also

- [`cy.get()`](/api/commands/get)
- [`.invoke()`](/api/commands/invoke)
- [`.within()`](/api/commands/within)
- [Retry-ability](/guides/core-concepts/retry-ability)
