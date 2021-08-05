---
title: get
---

通过选择器或[别名](/guides/core-concepts/variables-and-aliases) 获取一个或多个DOM元素.

<Alert type="info">

这个命令的查询行为类似于[`$(...)`](http://api.jquery.com/jQuery/) 在jQuery中的工作方式.

</Alert>

## 语法

```javascript
cy.get(selector)
cy.get(alias)
cy.get(selector, options)
cy.get(alias, options)
```

### 用法

**<Icon name="check-circle" color="green"></Icon> 正确的用法**

```javascript
cy.get('.list > li') // 产生 .list内的  <li>
```

### 参数

**<Icon name="angle-right"></Icon> 选择器** **_(String类型 选择器)_**

选择器用于过滤匹配的DOM元素.

**<Icon name="angle-right"></Icon> 别名** **_(String)_**

使用[`.as()`](/api/commands/as)命令定义的别名，并使用`@`字符+别名 引用.

您可以使用`cy.get()`作为基本数据类型、常规对象甚至DOM元素的别名。

当对DOM元素使用别名时，Cypress将再次查询之前使用别名的DOM元素是否过期.

<Alert type="info">

<strong class="alert-header">核心概念</strong>

[你可以在我们的核心概念指南中阅读更多关于别名对象和元素的内容](/guides/core-concepts/variables-and-aliases#Aliases).

</Alert>

**<Icon name="angle-right"></Icon> 选项** **_(Object)_**

传入一个options对象以更改`cy.get()`的默认行为.

| 选项                | 默认值                                                                            | 描述                                                                                                  |
| ------------------ | --------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| `log`              | `true`                                                                            | 在[命令日志](/guides/core-concepts/test-runner#Command-Log) 中显示命令                    |
| `timeout`          | [`defaultCommandTimeout`](/guides/references/configuration#Timeouts)              | `cy.get()`在[超时](#Timeouts) 之前等待解决完成的时间                                       |
| `withinSubject`    | null                                                                              | 从哪个元素开始查找（其子元素）。如果为空，则搜索从根级DOM元素开始                        |
| `includeShadowDom` | [`includeShadowDom` config option value](/guides/references/configuration#Global) | 是否遍历阴影DOM边界并在生成的结果中包含阴影DOM中的元素. |

### Yields 生成[<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Subject-Management)

<List><li>`cy.get()` 生成找到的DOM元素.</li></List>

## 例子

### 选择器

#### 获取input元素

```javascript
cy.get('input').should('be.disabled')
```

#### 在`ul`中找到第一个`li`子项

```javascript
cy.get('ul li:first').should('have.class', 'active')
```

#### 找到下拉菜单并单击它

```javascript
cy.get('.dropdown-menu').click()
```

#### 查找具有给定数据属性的5个元素

```javascript
cy.get('[data-test-id="test-example"]').should('have.length', 5)
```

#### 找到含有“questions”的href属性的链接并点击它

```javascript
cy.get('a[href*="questions"]').click()
```

#### 查找id以"local-"开头的元素

```javascript
cy.get('[id^=local-]')
```

#### 查找id以"-remote"结尾的元素

```javascript
cy.get('[id$=-remote]')
```

#### 查找id以“local-”开始，以“-remote”结束的元素

```javascript
cy.get('[id^=local-][id$=-remote]')
```

#### 查找具有CSS中使用的字符的id元素，如 ".", ":".

```javascript
cy.get('#id\\.\\.\\.1234') // 使用 \\ 转义字符
```

### 在`.within()` 内执行get

#### [`.within()`](/api/commands/within)命令中的`cy.get()`

因为`cy.get()`是链接了`cy`, 它总是在整个`document`中寻找选择器. 唯一的例外是在[.within()](/api/commands/within)命令中使用.

```javascript
cy.get('form').within(() => {
  cy.get('input').type('Pamela') // 只产生 表单内的input
  cy.get('textarea').type('is a developer') // 只产生 表单内 textareas
})
```

### Get 对比 Find

`cy.get`命令总是从[cy.root](https://on.cypress.io/root) 元素开始搜索。在大多数情况下, 根元素是`document`元素, 除非在[.within()](/api/commands/within) 命令中使用. 命令[.find](https://on.cypress.io/find) 从当前目标开始搜索.

```html
<div class="test-title">cy.get 比较 .find</div>
<section id="comparison">
  <div class="feature">都是查询命令</div>
</section>
```

```js
cy.get('#comparison')
  .get('div')
  // 在#parent 之外查找div.test-title
  // and the div.feature inside
  .should('have.class', 'test-title')
  .and('have.class', 'feature')
cy.get('#comparison')
  .find('div')
  //搜索被限制在 #comparison 元素的树中
  // 它只找到div.feature
  .should('have.length', 1)
  .and('have.class', 'feature')
```

### 别名

参阅别名的详细解释, [在这里阅读更多关于别名](/guides/core-concepts/variables-and-aliases#Aliases).

#### 获取“todos”元素的别名

```javascript
cy.get('ul#todos').as('todos')

//...hack hack hack...

//稍后检索 todos
cy.get('@todos')
```

#### 获取'submitBtn'元素的别名

```javascript
beforeEach(() => {
  cy.get('button[type=submit]').as('submitBtn')
})

it('disables on click', () => {
  cy.get('@submitBtn').should('be.disabled')
})
```

#### 获取“users” 夹具的别名

```javascript
beforeEach(() => {
  cy.fixture('users.json').as('users')
})

it('disables on click', () => {
  // 访问users数组
  cy.get('@users').then((users) => {
    // 获取第一个user
    const user = users[0]

    cy.get('header').contains(user.name)
  })
})
```

## 规则

### 需要 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Chains-of-Commands)

<List><li>`cy.get()` 需要链接一个命令，该命令生成DOM元素.</li></List>

### 断言 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Assertions)

<List><li>`cy.get()` 会自动 [重试](/guides/core-concepts/retry-ability) 直到元素 [在DOM里存在](/guides/core-concepts/introduction-to-cypress#Default-Assertions)</li><li>`cy.get()`  会自动 [重试](/guides/core-concepts/retry-ability) 直到所有链接的断言都通过</li></List>

### 超时 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Timeouts)

<List><li>`cy.get()` 在等待元素[在DOM中存在](/guides/core-concepts/introduction-to-cypress#Default-Assertions) 直到超时.</li><li>`cy.get()` 等待断言通过，直到超时.</li></List>

## 命令日志

**_获取一个input并断言该值_**

```javascript
cy.get('input[name="firstName"]').should('have.value', 'Homer')
```

上面的命令将在命令日志中显示为:

<DocsImage src="/img/api/get/get-element-and-make-an-assertion.png" alt="Command Log get" ></DocsImage>

当单击命令日志中的`get`命令时，控制台输出如下内容:

<DocsImage src="/img/api/get/console-log-get-command-and-elements-found.png" alt="Console Log get" ></DocsImage>

## 历史

| Version                                     | Changes                          |
| ------------------------------------------- | -------------------------------- |
| [5.2.0](/guides/references/changelog#5-2-0) | Added `includeShadowDom` option. |

## 另请参阅

- [`.as()`](/api/commands/as)
- [`cy.contains()`](/api/commands/contains)
- [`.find()`](/api/commands/find)
- [`.within()`](/api/commands/within)
- [重试能力](/guides/core-concepts/retry-ability)
