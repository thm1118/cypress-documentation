---
title: trigger
---

在DOM元素上触发事件.

## 语法

```javascript
.trigger(eventName)
.trigger(eventName, position)
.trigger(eventName, options)
.trigger(eventName, x, y)
.trigger(eventName, position, options)
.trigger(eventName, x, y, options)
```

### 用法

**<Icon name="check-circle" color="green"></Icon> 正确的用法**

```javascript
cy.get('a').trigger('mousedown') // 在链接上触发mousedown事件
```

**<Icon name="exclamation-triangle" color="red"></Icon> 不正确的使用**

```javascript
cy.trigger('touchstart') // 错误，不能链接自'cy'
cy.location().trigger('mouseleave') // 错误，'location'不输出DOM元素
```

### 参数

**<Icon name="angle-right"></Icon> eventName** **_(String)_**

要在DOM元素上触发的事件名称.

**<Icon name="angle-right"></Icon> position** **_(String)_**

应触发事件的位置. `center`位置是默认位置. 有效的位置是`topLeft`, `top`, `topRight`, `left`, `center`, `right`, `bottomLeft`, `bottom`, 和  `bottomRight`。

<DocsImage src="/img/api/coordinates-diagram.jpg" alt="cypress-command-positions-diagram" ></DocsImage>

**<Icon name="angle-right"></Icon> x** **_(Number)_**

从元素左侧触发事件的距离(以像素为单位).

**<Icon name="angle-right"></Icon> y** **_(Number)_**

从元素顶部触发事件的距离(以像素为单位)。

**<Icon name="angle-right"></Icon> options** **_(Object)_**

传入一个options对象来改变`.trigger()`.的默认行为。

| 选项对象                      | 默认值                                                                         | 描述                                                                                                                                        |
| ---------------------------- | ------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| `animationDistanceThreshold` | [`animationDistanceThreshold`](/guides/references/configuration#Actionability) | 一个元素[被认为是动画](/guides/core-concepts/interacting-with-elements#Animations) 必须超过的像素距离.  |
| `bubbles`                    | `true`                                                                         | 事件是否冒泡                                                                                                                          |
| `cancelable`                 | `true`                                                                         | 事件是否可取消                                                                                                                    |
| `eventConstructor`           | `Event`                                                                        | 用于创建事件对象的构造函数 (例如. `MouseEvent`, `KeyboardEvent`)                                                                 |
| `force`                      | `false`                                                                        | 强制执行动作，禁用[等待可操作性](#Assertions)                                                                               |
| `log`                        | `true`                                                                         | 在[命令日志](/guides/core-concepts/test-runner#Command-Log) 中显示命令                                                        |
| `scrollBehavior`             | [`scrollBehavior`](/guides/references/configuration#Actionability)             | 在执行命令之前，Viewport元素[应该滚动](/guides/core-concepts/interacting-with-elements#Scrolling)的位置  |
| `timeout`                    | [`defaultCommandTimeout`](/guides/references/configuration#Timeouts)           | 在[超时](#Timeouts)之前等待 `.trigger()` 解决的时间                                                                            |
| `waitForAnimations`          | [`waitForAnimations`](/guides/references/configuration#Actionability)          | 是否在执行命令之前等待元素[完成动画](/guides/core-concepts/interacting-with-elements#Animations).       |

还可以包含需要附加到事件上的任意事件属性  (例如. `clientX`, `shiftKey`) . 传入坐标参数 (`clientX`, `pageX`, 等等)将覆盖位置坐标.

### Yields 输出[<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Subject-Management)

<List><li>`.trigger()` 输出与前一个命令相同的目标。</li></List>

## 例子

### 鼠标事件

#### 在按钮上触发 `mouseover`

在触发事件发生之前，DOM元素必须处于“可交互”状态(必须是可见的，不能被禁用)。

```javascript
cy.get('button').trigger('mouseover') // 输出 'button'
```

#### 模拟“长按”事件

```javascript
cy.get('.target').trigger('mousedown')
cy.wait(1000)
cy.get('.target').trigger('mouseup')
```

#### 从特定的鼠标按钮触发 `mousedown`

```js
// 主按钮按下 (通常是左键)
cy.get('.target').trigger('mousedown', { button: 0 })
// 辅助按钮按下 (通常是中间的按钮)
cy.get('.target').trigger('mousedown', { button: 1 })
//第二个按钮按下 (通常是右键)
cy.get('.target').trigger('mousedown', { button: 2 })
```

#### jQuery UI Sortable

在 jQuery UI sortable 中模拟拖放，需要`pageX` 和 `pageY`属性以及`which:1`。

```javascript
cy.get('[data-cy=draggable]')
  .trigger('mousedown', { which: 1, pageX: 600, pageY: 100 })
  .trigger('mousemove', { which: 1, pageX: 600, pageY: 600 })
  .trigger('mouseup')
```

#### 拖放

<Alert type="info">

[查看我们的示例配方：触发鼠标和拖动事件来测试拖放](/examples/examples/recipes#Testing-the-DOM)

</Alert>

### change 事件

#### 与一个 range input (slider) 交互

与一个 range input (slider) 交互, 我们需要设置它的值，然后触发适当的事件以表示它已经更改。

下面我们调用jQuery的`val()` 方法来设置值，然后触发`change`事件。

注意，有些实现可能依赖于`input`事件，当用户移动滑块时触发该事件，但有些浏览器不支持该事件。

```javascript
cy.get('input[type=range]').as('range').invoke('val', 25).trigger('change')

cy.get('@range').siblings('p').should('have.text', '25')
```

### 位置

#### 在按钮的右上方触发`mousedown`

```javascript
cy.get('button').trigger('mousedown', 'topRight')
```

### 坐标

#### 指定相对于左上角的显式坐标

```javascript
cy.get('button').trigger('mouseup', 15, 40)
```

### 选项

#### 指定事件不应该冒泡

默认情况下，该事件将沿DOM树冒泡。这将阻止事件冒泡。

```javascript
cy.get('button').trigger('mouseover', { bubbles: false })
```

#### 指定事件应该具有的确切的`clientX`和`clientY`

这将覆盖基于元素本身的默认自动定位。对于像`mousemove`这样的事件很有用，因为你需要位置在元素本身之外.

```javascript
cy.get('button').trigger('mousemove', { clientX: 200, clientY: 300 })
```

### 触发其他事件类型。

默认情况下，`cy.trigger()` 触发[`Event`](https://developer.mozilla.org/en-US/docs/Web/API/Event). 但你可能想触发其他事件比如 `MouseEvent` 或 `KeyboardEvent`.

在这种情况下，使用`eventConstructor`选项.

```js
cy.get('button').trigger('mouseover', { eventConstructor: 'MouseEvent' })
```

## 注意

### 可操作性

#### 要素必须首先达到可操作性

`.trigger()`是一个“动作命令”，它遵循[这里定义的](/guides/core-concepts/interacting-with-elements)的所有规则。

### 事件

#### 我应该触发什么事件?

`cy.trigger()` 是一种低级实用程序，它使触发事件比手动构造和分派事件更容易. 由于任何任意事件都可以被触发，Cypress尽量不去假设应该如何触发.这意味着您需要知道接收事件的事件处理程序的实现细节(可能在第三方库中)，并提供必要的属性.

#### 为什么要手动设置事件类型?

正如你可以看到的[`MouseEvent`](https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent) 的文档, 事件类实例的大多数属性是只读的。 正因如此，有时无法设置一些属性的值比如`pageX`, `pageY`. 在测试某些情况时，这可能会有问题.

### 区别

#### 触发和事件与调用相应的cypress命令有什么区别?

换句话说，两者的区别是什么:

```javascript
cy.get('button').trigger('focus')
cy.get('button').focus()

// ... 或 ...

cy.get('button').trigger('click')
cy.get('button').click()
```

这两种类型的命令都将首先验证元素的可操作性，但只有“真正的”操作命令将实现浏览器的所有默认操作，并额外执行低级操作来实现spec中定义的内容.

`.trigger()` _仅仅_ 触发相应的事件而不做其他事情.

这意味着您的事件监听回调将被调用，但不要期望浏览器实际为这些事件“做”任何事情. 在大多数情况下，这并不重要，这就是为什么如果您正在寻找的命令事件还没有实现，`.trigger()` 是一个非常好的临时方法。

## 规则

### 要求 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Chains-of-Commands)

<List><li>`.trigger()` 需要链接自一个输出DOM元素的命令.</li></List>

### 断言 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Assertions)

<List><li>`.trigger()` 将自动等待元素达到[可操作状态](/guides/core-concepts/interacting-with-elements)</li><li>`.trigger()` 会自动[重试](/guides/core-concepts/retry-ability)直到所有链式断言都通过</li></List>

### 超时 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Timeouts)

<List><li>`.trigger()` 在元素达到[可操作状态](/guides/core-concepts/interacting-with-elements) 时超时.</li><li>`.trigger()`在等待添加的断言通过时会超时.</li></List>

## 命令日志

**_在一个type='range'的input 上触发“change”事件_**

```javascript
cy.get('.trigger-input-range').invoke('val', 25).trigger('change')
```

上面的命令将在命令日志中显示为:

<DocsImage src="/img/api/trigger/command-log-trigger.png" alt="command log trigger" ></DocsImage>

当单击命令日志中的`trigger`时，控制台输出如下内容:

<DocsImage src="/img/api/trigger/console-log-trigger.png" alt="console log trigger" ></DocsImage>

## History

| Version                                       | Changes                                            |
| --------------------------------------------- | -------------------------------------------------- |
| [6.1.0](/guides/references/changelog#6-1-0)   | Added option `scrollBehavior`                      |
| [3.5.0](/guides/references/changelog#3-5-0)   | Added `screenX` and `screenY` properties to events |
| [0.20.0](/guides/references/changelog#0-20-0) | `.trigger()` command added                         |

## See also

- [`.blur()`](/api/commands/blur)
- [`.check()`](/api/commands/check)
- [`.click()`](/api/commands/click)
- [`.focus()`](/api/commands/focus)
- [`.rightclick()`](/api/commands/rightclick)
- [`.select()`](/api/commands/select)
- [`.submit()`](/api/commands/submit)
- [`.type()`](/api/commands/type)
- [`.uncheck()`](/api/commands/uncheck)
