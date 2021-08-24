---
title: fixture
---

加载位于文件中的一组固定数据。

## 语法

```javascript
cy.fixture(filePath)
cy.fixture(filePath, encoding)
cy.fixture(filePath, options)
cy.fixture(filePath, encoding, options)
```

### 用法

**<Icon name="check-circle" color="green"></Icon>正确的用法**

```javascript
cy.fixture('users').as('usersJson') // 从users.json 加载数据
cy.fixture('logo.png').then((logo) => {
  // 加载 logo.png 图片
})
```

### 参数

**<Icon name="angle-right"></Icon> filePath** **_(String)_**

[`fixturesFolder`](/guides/references/configuration#Folders-Files) 配置中的一个文件路径，默认为 `cypress/fixtures`.

您可以将 fixture 嵌套在文件夹中，并通过定义fixturesFolder路径来引用它们:

```javascript
cy.fixture('users/admin.json') // 从路径 {fixturesFolder}/users/admin.json 加载数据
```

**<Icon name="angle-right"></Icon> encoding** **_(String)_**

读取文件时使用的编码。支持以下编码:

- `ascii`
- `base64`
- `binary`
- `hex`
- `latin1`
- `utf8`
- `utf-8`
- `ucs2`
- `ucs-2`
- `utf16le`
- `utf-16le`

**<Icon name="angle-right"></Icon> options** **_(Object)_**

传入一个options对象以更改`cy.fixture()`的默认行为.

| 选项      | 默认值                                                          | 描述                                                               |
| --------- | -------------------------------------------------------------- | ------------------------------------------------------------------------- |
| `timeout` | [`responseTimeout`](/guides/references/configuration#Timeouts) | 在[超时](#Timeouts)之前等待 `cy.fixture()` 解决的时间 |

### Yields 输出[<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Subject-Management)

`cy.fixture()`将输出文件的内容。格式由文件扩展名决定.

## 例子

### JSON

#### 加载一个 `users.json` fixture

```javascript
cy.fixture('users.json').as('usersData')
```

#### 省略 fixture文件的扩展名

当没有扩展被传递给`cy.fixture()`时, Cypress将在[`fixturesFolder`](/guides/references/configuration#Folders-Files)(默认为`cypress/fixtures`)中搜索指定名称的文件，并解析第一个文件。

```javascript
cy.fixture('admin').as('adminJSON')
```

上面的例子将按照以下顺序解析:

1. `cypress/fixtures/admin.json`
2. `cypress/fixtures/admin.js`
3. `cypress/fixtures/admin.coffee`
4. `cypress/fixtures/admin.html`
5. `cypress/fixtures/admin.txt`
6. `cypress/fixtures/admin.csv`
7. `cypress/fixtures/admin.png`
8. `cypress/fixtures/admin.jpg`
9. `cypress/fixtures/admin.jpeg`
10. `cypress/fixtures/admin.gif`
11. `cypress/fixtures/admin.tif`
12. `cypress/fixtures/admin.tiff`
13. `cypress/fixtures/admin.zip`

#### 使用 `import`语句

如果你正在加载一个JSON fixture，你可以简单地使用 `import`语句，并让绑定器加载它:

```js
// cypress/integration/spec.js
import user from '../fixtures/user.json'
it('loads the same object', () => {
  cy.fixture('user').then((userFixture) => {
    expect(user, 'the same data').to.deep.equal(userFixture)
  })
})
```

### 图片

#### 图像 fixute 默认会以 `base64`编码加载

```javascript
cy.fixture('images/logo.png').then((logo) => {
  // Logo将被编码为base64
  // 类似这样的:
  // aIJKnwxydrB10NVWqhlmmC+ZiWs7otHotSAAAOw==...
})
```

#### 更改图像fixture的编码

```javascript
cy.fixture('images/logo.png', 'binary').then((logo) => {
  // logo将被编码为二进制
  // 类似这样:
  // 000000000000000000000000000000000000000000...
})
```

### 播放MP3文件

```javascript
cy.fixture('audio/sound.mp3', 'base64').then((mp3) => {
  const uri = 'data:audio/mp3;base64,' + mp3
  const audio = new Audio(uri)

  audio.play()
})
```

### 访问Fixture数据

#### 使用`.then()`访问fixture数据

```javascript
cy.fixture('users').then((json) => {
  cy.intercept('GET', '/users/**', json)
})
```

#### 使用fixture 引导数据

<Alert type="info">

[查看我们使用`cy.fixture()` 引导应用程序数据的示例配方.](/examples/examples/recipes#Server-Communication)

</Alert>

#### 在使用fixture数据之前修改它

在将fixture数据传递给路由之前，可以直接修改fixture数据。

```javascript
cy.fixture('user').then((user) => {
  user.firstName = 'Jane'
  cy.intercept('GET', '/users/1', user).as('getUser')
})

cy.visit('/users')
cy.wait('@getUser').then(({ request }) => {
  expect(request.body.firstName).to.eq('Jane')
})
```

## 注释

### 快捷方式

#### 使用 `fixture` `StaticResponse`属性

不使用`.fixture()`命令，也可以通过使用[`cy.intercept()`](/api/commands/intercept) `StaticResponse`对象的特定属性`fixture`

```javascript
cy.intercept('GET', '/users/**', { fixture: 'users' })
```

### 验证

#### 自动化文件验证

Cypress会自动验证你的fixture. 如果你的 `.json`, `.js`, 或 `.coffee`文件包含语法错误，它们将显示在命令日志中.

### 编码

#### 默认编码

Cypress自动确定以下文件类型的编码:

- `.json`
- `.js`
- `.coffee`
- `.html`
- `.txt`
- `.csv`
- `.png`
- `.jpg`
- `.jpeg`
- `.gif`
- `.tif`
- `.tiff`
- `.zip`

对于其他类型的文件，除非在`cy.fixture()`的第二个参数中指定，否则默认情况下它们将被读取为`utf8`.

### `this` 上下文

如果您使用`this` 这个当前测试上下文对象存储和访问fixture数据, 需要确保使用`function () { ... }` 形式的回调函数. 否则测试引擎将不会有指向当前测试的上下文的 `this`.

```javascript
describe('User page', () => {
  beforeEach(function () {
    // "this" 指向测试上下文对象
    cy.fixture('user').then((user) => {
      // "this" 仍然是同一个测试上下文对象
      this.user = user
    })
  })

  // 测试回调函数是 "function () { ... }" 形式
  it('has user', function () {
    // this.user 是存在的
    expect(this.user.firstName).to.equal('Jane')
  })
})
```

### 只加载一次

请记住，fixture文件在测试期间假定是不变的，因此测试运行程序只加载它们一次。 即使覆盖了fixture文件本身，已经加载的fixture数据仍然是不变的。

例如，如果您想用不同的对象响应一个网络请求，下面的操作将**不起作用**:

```js
// 🚨 行不通
cy.intercept('GET', '/todos/1', { fixture: 'todo' }).as('todo')
// 应用程序请求 /todos/1 资源
// 拦截器响应来自 todo.json 文件的数据

cy.wait('@todo').then(() => {
  cy.writeFile('/cypress/fixtures/todo.json', { title: '新数据' })
})
// 应用程序再次请求 /todos/1 资源
// 拦截将使用最初从 todo.json 文件加载的对象进行响应，而不是 { "title": "新数据" }
```

在这种情况下，避免使用fixture文件，而是用对象响应网络请求

```js
// ✅ 用对象响应
cy.fixture('todo.json').then((todo) => {
  cy.intercept('GET', '/todos/1', { body: todo }).as('todo')
  // 应用程序请求 /todos/1 资源
  // 拦截器使用初始的对象响应

  cy.wait('@todo').then(() => {
    // 修改响应对象
    todo.title = '新数据'
    // 覆盖拦截器响应
    cy.intercept('GET', '/todos/1', { body: todo })
  })
})
```

## 规则

### 要求 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Chains-of-Commands)

<List><li>`.fixture()` 只能从`cy` 链接.</li></List>

### 断言 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Assertions)

<List><li>`cy.fixture()` 只运行链接过的断言一次, 并且不会[重试](/guides/core-concepts/retry-ability).</li></List>

### 超时 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Timeouts)

- `cy.fixture()` 永远不会超时.

<Alert type="warning">

因为`cy.fixture()` 是异步的，所以在与内部Cypress自动化api通信时，在技术上可能会出现超时. 但出于实际目的，这是不应该发生的.

</Alert>

## 命令日志

- `cy.fixture()` _不_ 显示在命令日志中

## 另请参阅

- [指南:变量和别名](/guides/core-concepts/variables-and-aliases)
- [`cy.intercept()`](/api/commands/intercept)
- [`.then()`](/api/commands/then)
- [配方:引导应用测试数据](/examples/examples/recipes#Server-Communication)
- [Fixtures](https://github.com/cypress-io/testing-workshop-cypress#fixtures) Cypress测试工作坊的一部分
- [博客:从Cypress自定义命令加载fixture](https://glebbahmutov.com/blog/fixtures-in-custom-commands/) 说明如何加载或导入要在Cypress自定义命令中使用的fixture.
