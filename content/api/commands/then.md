---
title: then
---

使您能够使用前一个命令生成的目标。

<Alert type="info">

**注意:** `.then()` 假设您已经熟悉核心概念，如[闭包](/guides/core-concepts/variables-and-aliases#Closures).

</Alert>

<Alert type="info">

**注意:** 对于断言，宁愿使用 [`.should()` with callback](/api/commands/should#Function) 而不是`.then()`，因为它们会自动重试运行，直到其中没有断言再抛出，但要注意[区别](/api/commands/should#Differences).

</Alert>

## 语法

```javascript
.then(callbackFn)
.then(options, callbackFn)
```

### Usage

**<Icon name="check-circle" color="green"></Icon> 正确的用法**

```javascript
cy.get('.nav').then(($nav) => {}) // 输出.nav 作为第一个参数
cy.location().then((loc) => {}) // 输出location对象作为第一个参数
```

### 参数

**<Icon name="angle-right"></Icon> options** **_(Object)_**

传入一个options对象来改变 `.then()`的默认行为.

| 选项       | 默认值                                                               | 描述                                                          |
| --------- | -------------------------------------------------------------------- | -------------------------------------------------------------------- |
| `timeout` | [`defaultCommandTimeout`](/guides/references/configuration#Timeouts) | 等待`.then()` 在[超时](#Timeouts)之前解决的时间 |

**<Icon name="angle-right"></Icon> callbackFn** **_(Function)_**

传递一个函数，该函数接受前面命令输出的目标作为它的第一个参数.

### Yields 输出[<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Subject-Management)

`.then()`的行为与JavaScript中的promise 工作方式相同. 从回调函数返回的任何内容都将成为新的目标，并将流向下一个命令 (除了 `undefined`).

此外，回调函数中最后一个Cypress命令的结果将作为新输出的目标，如果没有`return`，则流入下一个命令。

当回调函数return `undefined`时，目标将不会被修改，而是会继续执行下一个命令.

就像promise一样，你可以返回任何兼容的`thenable`(具有`.then()`接口)的东西，Cypress会等待它解决，然后继续通过命令链前进.

## 例子

<Alert type="info">

在我们的[核心概念指南](/guides/core-concepts/variables-and-aliases)中有更多的例子，介绍了使用 `.then()`来存储、比较和调试值的各种方式.

</Alert>

### DOM 元素

#### 将输出 `button`元素

```javascript
cy.get('button').then(($btn) => {
  const cls = $btn.attr('class')

  cy.wrap($btn).click().should('not.have.class', cls)
})
```

#### 从先前的命令中输出 数值

```js
cy.wrap(1)
  .then((num) => {
    cy.wrap(num).should('equal', 1) // true
  })
  .should('equal', 1) // true
```

### 改变目标

#### el目标 被另一个命令改变

```javascript
cy.get('button')
  .then(($btn) => {
    const cls = $btn.attr('class')

    cy.wrap($btn).click().should('not.have.class', cls).find('i')
    // 因为没有显式的返回
    // 会输出Cypress最后一个命令所输出的目标
  })
  .should('have.class', 'spin') //在 i 元素上断言
```

#### 数值目标 被另一个命令更改

```javascript
cy.wrap(1).then((num) => {
  cy.wrap(num).should('equal', 1) // true
  cy.wrap(2)
}).should('equal', 2) // true
```

#### return 改变 数值目标

```javascript
cy.wrap(1)
  .then((num) => {
    cy.wrap(num).should('equal', 1) // true

    return 2
  })
  .should('equal', 2) // true
```

#### 返回`undefined`将不会修改输出目标

```javascript
cy.get('form')
  .then(($form) => {
    console.log('form is:', $form)
    //此处返回Undefined，但 $form 将被继续为输出目标
  })
  .find('input')
  .then(($input) => {
    //这里是input元素，因为我们在输出 form元素 上调用了 find('input')
  })
```

### 原始 htmlelement 是用jQuery封装的

```javascript
cy.get('div')
  .then(($div) => {
    return $div[0] // jQuery封装对象的第一个元素 才是真正的 HTMLDivElement
  })
  .then(($div) => {
    $div // 类型依然是 JQuery<HTMLDivElement>
  })
```

### Promises

Cypress等待Promises 解决后才继续

#### 使用 Q 的例子

```javascript
cy.get('button')
  .click()
  .then(($button) => {
    const p = Q.defer()

    setTimeout(() => {
      p.resolve()
    }, 1000)

    return p.promise
  })
```

#### 使用bluebird的例子

```javascript
cy.get('button')
  .click()
  .then(($button) => {
    return Promise.delay(1000)
  })
```

#### 使用 jQuery deferred 的例子

```javascript
cy.get('button')
  .click()
  .then(($button) => {
    const df = $.Deferred()

    setTimeout(() => {
      df.resolve()
    }, 1000)

    return df
  })
```

## 注意

### 区别

### `.then()` 和 `.should()`/`.and()`的区别是什么??

使用`.then()`允许您在回调函数中，能够使用输出的目标，操作一些值或执行一些操作.

另一方面，当使用带有`.should()` 或 `.and()`的回调函数时, 有一个特殊的逻辑可以重新运行回调函数，直到其中没有抛出断言为止. 你应该注意`.should()` 或 `.and()`回调函数中不希望被多次执行的副作用。

## 规则

### 要求 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Chains-of-Commands)

<List><li>`.then()` 需要链接到一个命令.</li></List>

### 断言 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Assertions)

<List><li>`.then()` 将只运行您链接过的断言一次，而不会[重试](/guides/core-concepts/retry-ability).</li></List>

### 超时 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Timeouts)

<List><li>`.then()` 可以等待 待解决的承诺.</li></List>

## 命令日志

- `.then()` _不会_ 在命令日志中显示

## History

| Version                                       | Changes                 |
| --------------------------------------------- | ----------------------- |
| [0.14.0](/guides/references/changelog#0-14-0) | Added `timeout` option  |
| [< 0.3.3](/guides/references/changelog#0-3-3) | `.then()` command added |

## 另请参阅

- [`.and()`](/api/commands/and)
- [`.each()`](/api/commands/each)
- [`.invoke()`](/api/commands/invoke)
- [`.its()`](/api/commands/its)
- [`.should()`](/api/commands/should)
- [`.spread()`](/api/commands/spread)
- [指南:使用闭包比较值](/guides/core-concepts/variables-and-aliases#Closures)
- [指南:命令链](/guides/core-concepts/introduction-to-cypress#Chains-of-Commands)
