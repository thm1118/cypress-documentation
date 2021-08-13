---
title: click
---

点击一个DOM元素.

## 语法

```javascript
.click()
.click(options)
.click(position)
.click(position, options)
.click(x, y)
.click(x, y, options)
```

### Usage

**<Icon name="check-circle" color="green"></Icon> 正确的用法**

```javascript
cy.get('.btn').click() //点击按钮
cy.focused().click() // 点击当前的焦点元素
cy.contains('Welcome').click() // 点击第一个包含“Welcome”的元素
```

**<Icon name="exclamation-triangle" color="red"></Icon> 不正确的用法**

```javascript
cy.click('.btn') // 错误，不能直接链接'cy'
cy.window().click() // 错误，'window'不输出DOM元素
```

### 参数

**<Icon name="angle-right"></Icon> position** **_(String)_**

点击的位置. `center` 位置是默认位置. 有效的位置是 `topLeft`, `top`, `topRight`, `left`, `center`, `right`, `bottomLeft`, `bottom`, 和 `bottomRight`.

<DocsImage src="/img/api/coordinates-diagram.jpg" alt="cypress-command-positions-diagram" ></DocsImage>

**<Icon name="angle-right"></Icon> x** **_(Number)_**

点击与元素左侧距离(以像素为单位).

**<Icon name="angle-right"></Icon> y** **_(Number)_**

点击与元素顶部距离(以像素为单位).

**<Icon name="angle-right"></Icon> options** **_(Object)_**

传入一个options对象来更改`.click()`的默认行为.

| 选项                          | 默认值                                                                         | 描述                                                                                                                                        |
| ---------------------------- | ------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| `altKey`                     | `false`                                                                        | 激活alt键(Mac的option键). 别名: <code>optionKey</code>.                                                                       |
| `animationDistanceThreshold` | [`animationDistanceThreshold`](/guides/references/configuration#Actionability) | 一个元素必须超过的像素距离[被认为是动画](/guides/core-concepts/interacting-with-elements#Animations).  |
| `ctrlKey`                    | `false`                                                                        | 激活control键。别名: <code>controlKey</code>.                                                                                       |
| `log`                        | `true`                                                                         | 在[命令日志](/guides/core-concepts/test-runner#Command-Log)中显示命令                                                           |
| `force`                      | `false`                                                                        | 强制执行动作，禁用 [等待可操作](#Assertions)                                                                               |
| `metaKey`                    | `false`                                                                        | 激活meta键(Windows键或Mac command键). 别名: <code>commandKey</code>, <code>cmdKey</code>.                                |
| `multiple`                   | `false`                                                                        | 连续单击多个元素                                                                                                                   |
| `scrollBehavior`             | [`scrollBehavior`](/guides/references/configuration#Actionability)             | 在执行命令之前，Viewport元素[应该滚动](/guides/core-concepts/interacting-with-elements#Scrolling) 的位置 |
| `shiftKey`                   | `false`                                                                        | 激活shift键.                                                                                                                           |
| `timeout`                    | [`defaultCommandTimeout`](/guides/references/configuration#Timeouts)           | 在[超时](#Timeouts) 之前等待`.click()`解决的时间                                                                              |
| `waitForAnimations`          | [`waitForAnimations`](/guides/references/configuration#Actionability)          | 是否在执行命令之前等待元素完成[动画](/guides/core-concepts/interacting-with-elements#Animations)。       |

### Yields [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Subject-Management)

<List><li>`.click()`输出与前一个命令相同的目标.</li></List>

## 示例

### 无参数

#### 单击导航中的链接

```javascript
cy.get('.nav > a').click()
```

### 位置

#### 指定要单击的元素角

单击按钮的右上角。

```javascript
cy.get('img').click('topRight')
```

### 坐标

#### 指定相对于左上角的显式坐标

下面的点击将在元素内部发出(从左边15px，从顶部40px)。

```javascript
cy.get('#top-banner').click(15, 40)
```

### 选项

#### 强制单击，不管其可操作状态如何

强制点击将覆盖Cypress应用，并将自动触发事件的[可操作的检查](/guides/core-concepts/interacting-with-elements#Forcing) .

```javascript
cy.get('.close').as('closeBtn')
cy.get('@closeBtn').click({ force: true })
```

#### 用position参数强制单击

```javascript
cy.get('#collapse-sidebar').click('bottomLeft', { force: true })
```

#### 用相对坐标强制单击

```javascript
cy.get('#footer .next').click(5, 60, { force: true })
```

#### 点击所有id以'btn'开头的元素

默认情况下，如果您试图单击多个元素，Cypress将报错. 通过传递`{ multiple: true }`， Cypress将迭代地将点击应用到每个元素，并多次记录到[Command log](/guides/core-concepts/test-runner#Command-Log)。

```javascript
cy.get('[id^=btn]').click({ multiple: true })
```

#### 用组合键单击

`.click()` 命令也可以使用键修饰符来触发，以模拟在单击时保持键组合, 比如 `ALT + click`.

<Alert type="info">

您还可以在[.type()](/api/commands/type) 期间使用组合键. 这提供了跨多个命令按住键的选项. 更多信息请参见[键组合](/api/commands/type#Key-Combinations) .

</Alert>

下面的键可以通过`options`与`.click()`组合。

| 选项        | 注意                                                                                                               |
| ---------- | ------------------------------------------------------------------------------------------------------------------- |
| `altKey`   | 激活alt键(Mac的option键). 别名: <code>optionKey</code>.                                        |
| `ctrlKey`  | 激活control键。别名: <code>controlKey</code>.                                                        |
| `metaKey`  | 激活meta键(Windows键或Mac command键). 别名: <code>commandKey</code>, <code>cmdKey</code>. |
| `shiftKey` | 激活shift键.                                                                                            |

#### Shift click

```js
// 在第一个 <li>上 执行  SHIFT + click 
cy.get('li:first').click({
  shiftKey: true,
})
```

## 注意

### 可操作性

#### 要素必须首先达到可操作性

`.click()`是一个“操作命令”，它遵循所有的规则[在这里定义](/guides/core-concepts/interacting-with-elements).

### Focus

#### 焦点被赋予第一个可聚焦的元素

例如，点击 `<button>`中的`<span>` 将焦点指向该按钮, 因为这是在真实的用户场景中会发生的。

然而，Cypress还处理了在可聚焦的父组件内单击子组件的情况, 但实际上并不是在父组件中(根据CSS对象模型). 在这些情况下，如果没有找到可聚焦的父对象，窗口将被赋予焦点(这符合实际的浏览器行为).

### 取消

#### 取消鼠标将不会引起焦点

如果mousedown事件有它的默认动作被阻止(`e.preventDefault()`)，那么元素将不会按照规范接收焦点.

## 规则

### 需要 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Chains-of-Commands)

<List><li>`.click()`需要被链接到一个输出DOM元素的命令.</li></List>

### 断言 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Assertions)

<List><li>`.click()`将自动等待元素达到[可操作状态](/guides/core-concepts/interacting-with-elements)</li><li>`.click()`将自动[重试](/guides/core-concepts/retry-ability) ，直到所有链接的断言都通过</li></List>

### Timeouts [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Timeouts)

<List><li>`.click()` 可能会超时，等待元素未达到[可操作状态](/guides/core-concepts/interacting-with-elements).</li><li>`.click()` 可能会在等待您添加的断言传递时超时.</li></List>

## 命令日志

**_点击该按钮_**

```javascript
cy.get('.action-btn').click()
```

上面的命令将在命令日志中显示为:

<DocsImage src="/img/api/click/click-button-in-form-during-test.png" alt="Command log for click" ></DocsImage>

当在命令日志中单击' click '时，控制台输出如下内容:

<DocsImage src="/img/api/click/click-coords-and-events-in-console.png" alt="console.log for click" ></DocsImage>

## History

| Version                                     | Changes                                                                                                             |
| ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| [6.1.0](/guides/references/changelog#6-1-0) | Added option `scrollBehavior`                                                                                       |
| [3.5.0](/guides/references/changelog#3-5-0) | Added sending `mouseover`, `mousemove`, `mouseout`, `pointerdown`, `pointerup`, and `pointermove` during `.click()` |

## See also

- [`.check()`](/api/commands/check)
- [`.click()` examples in kitchensink app](https://github.com/cypress-io/cypress-example-kitchensink/blob/master/cypress/integration/examples/actions.spec.js#L66)
- [`.dblclick()`](/api/commands/dblclick)
- [`.rightclick()`](/api/commands/rightclick)
- [`.select()`](/api/commands/select)
- [`.submit()`](/api/commands/submit)
- [`.type()`](/api/commands/type)
- ['When can the test click?' blog](https://www.cypress.io/blog/2019/01/22/when-can-the-test-click/)
