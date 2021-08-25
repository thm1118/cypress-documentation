---
title: type
---

在DOM元素上输入。

## Syntax

```javascript
.type(text)
.type(text, options)
```

### 用法

**<Icon name="check-circle" color="green"></Icon> 正确的用法**

```javascript
cy.get('input').type('Hello, World') // 在'input'内输入'Hello, World'
```

**<Icon name="exclamation-triangle" color="red"></Icon> 不正确的用法**

```javascript
cy.type('Welcome') // 错误，不能直接链接'cy'
cy.url().type('www.cypress.io') //错误，'url'不输出DOM元素
```

### 参数

**<Icon name="angle-right"></Icon> text** **_(String)_**

要输入到DOM元素中的文本。

传递给`.type()`的文本可以包括下面的任何特殊字符序列. 这些字符将向`.type()`期间发出的任何事件传递正确的`keyCode`, `key`, 何 `which`代码。. 一些特殊字符序列可能在键入过程中执行操作，如`{movetoend}`, `{movetostart}`, 或 `{selectall}`。

<Alert type="info">

若要禁用解析特殊字符序列，请将`parseSpecialCharSequences`选项设置为`false`。

</Alert>

| 序列            | 注释                                            |
| --------------- | ------------------------------------------------ |
| `{{}`           | 键入文字`{`键                        |
| `{backspace}`   | 删除光标左侧的字符      |
| `{del}`         | 删除光标右侧的字符     |
| `{downarrow}`   | 移动光标向下                               |
| `{end}`         | 将光标移动到行尾             |
| `{enter}`       | 输入回车键                              |
| `{esc}`         | 键入Escape键                           |
| `{home}`        | 将光标移到行首            |
| `{insert}`      | 向光标右侧插入字符     |
| `{leftarrow}`   | 向左移动光标                               |
| `{movetoend}`   | 将光标移动到可输入元素的末尾         |
| `{movetostart}` | 将光标移动到可输入元素的开头    |
| `{pagedown}`    | 向下滚动                                   |
| `{pageup}`      | 向上滚动                                     |
| `{rightarrow}`  | 向右移动光标                              |
| `{selectall}`   | 通过创建`selection range`选择所有文本 |
| `{uparrow}`     | 向上移动光标                                 |

传递给`.type()`的文本也可以包括这些修饰符字符序列中的任何一个:

| 序列      | 注释                                                           |
| --------- | --------------------------------------------------------------- |
| `{alt}`   | 激活`altKey`修饰符。别名:`{option}`                              |
| `{ctrl}`  | 激活 `ctrlKey`修饰符。别名:`{control}`          |
| `{meta}`  | 激活`metaKey`修饰符。命令别名:`{command}`, `{cmd}` |
| `{shift}` | 激活`shiftKey`修饰符.                              |

**<Icon name="angle-right"></Icon> options** **_(Object)_**

传入一个options对象来改变`.type()`的默认行为。

| 选项                         | 默认值                                                                          | 描述                                                                                                                                        |
| ---------------------------- | ------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| `animationDistanceThreshold` | [`animationDistanceThreshold`](/guides/references/configuration#Actionability) | 一个元素必须超过的像素距离[被认为是动画](/guides/core-concepts/interacting-with-elements#Animations).  |
| `delay`                      | `10`                                                                           | 每次按键后延迟                                                                                                                          |
| `force`                      | `false`                                                                        | 强制执行动作，禁用[等待可操作性](#Assertions)                                                                               |
| `log`                        | `true`                                                                         | 在[命令日志](/guides/core-concepts/test-runner#Command-Log)中显示命令                                                           |
| `parseSpecialCharSequences`  | `true`                                                                         | 解析`{}`包围的字符串的特殊字符, 比如 `{esc}`. 设置为`false` 以输入文字字符                   |
| `release`                    | `true`                                                                         | 在命令之间保持一个激活的修饰符                                                                                                        |
| `scrollBehavior`             | [`scrollBehavior`](/guides/references/configuration#Actionability)             | 在执行命令之前，Viewport元素[应该滚动](/guides/core-concepts/interacting-with-elements#Scrolling)的位置 |
| `timeout`                    | [`defaultCommandTimeout`](/guides/references/configuration#Timeouts)           | 等待 `.type()`在[超时](#Timeouts) 之前解决的时间                                                                              |
| `waitForAnimations`          | [`waitForAnimations`](/guides/references/configuration#Actionability)          | 是否在执行命令之前等待元素[完成动画](/guides/core-concepts/interacting-with-elements#Animations) .       |

### Yields 输出 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Subject-Management)

<List><li>`.type()`输出与前一个命令相同的目标.</li></List>

## 例子

### Input/Textarea

#### 在 textarea 内输入.

```javascript
cy.get('textarea').type('Hello world') // 输出 <textarea>
```

#### 在登录表单中输入

<Alert type="info">

[看看我们的例子配方：在HTML网页表单输入用户名和密码登录](/examples/examples/recipes#Logging-In)

</Alert>

#### 模拟用户输入行为

默认情况下，每个按键延迟10毫秒，以模拟用户快速键入的方式!

```javascript
cy.get('[contenteditable]').type('some text!')
```

#### 从datalist中'selecting' 一个选项

要'selecting'一个选项，只需将它输入。

```html
<input list="fruit" />
<datalist id="fruit">
  <option>Apple</option>
  <option>Banana</option>
  <option>Cantaloupe</option>
</datalist>
```

```javascript
cy.get('input').type('Apple')
```

### Tabindex

#### 使用`tabindex`在非input或非textarea元素中键入

```html
<body>
  <div id="el" tabindex="1">这个div可以接收焦点!</div>
</body>
```

```javascript
cy.get('#el').type('supercalifragilisticexpialidocious')
```

### 日期 Inputs

在日期input(`<input type="date">`)上使用`.type()`需要指定一个有效的日期，格式如下:

- `yyyy-MM-dd` (比如. `1999-12-31`)

这并不是用户在日期输入中输入的确切方式，但这是一种变通方法，因为日期输入支持在不同的浏览器之间有所不同，格式也因地区而异. `yyyy-MM-dd`是[W3规范](https://www.w3.org/TR/html/infrastructure.html#dates-and-times)所要求的格式，并且是input 将被设置的 `value`，与浏览器或地区无关。

特殊字符(`{leftarrow}`, `{selectall}`等)是不允许的。

### 月份 Inputs

在月 input (`<input type="month">`) 上使用 `.type()` 需要指定有效的月份，格式如下:

- `yyyy-MM` (比如. `1999-12`)

这并不是用户输入月输入的确切方式，但这是一种解决办法，因为月输入支持在不同的浏览器之间有所不同，格式也因地区而异. `yyyy-MM` 是[W3规范](https://www.w3.org/TR/html/infrastructure.html#months) 所要求的格式，并且是input 将被设置的 `value`，与浏览器或地区无关。

特殊字符(`{leftarrow}`, `{selectall}`等)是不允许的。

### 周 Inputs

使用`.type()`对 周 input (`<input type="week">`)需要指定有效的 周 ，格式如下:

- `yyyy-Www` (比如. `1999-W23`)

其中，`W`是字面字符`W`， `ww`是第几周(01-53)。

这并不是用户输入周输入的确切方式，但这是一种解决方案，因为周输入支持在不同的浏览器之间有所不同，格式也因地区而异。 `yyyy-Www` 是[W3规范](https://html.spec.whatwg.org/multipage/common-microsyntaxes.html#valid-week-string)所要求的格式，并且是input 将被设置的 `value`，与浏览器或地区无关

特殊字符(`{leftarrow}`, `{selectall}`等)是不允许的。

### 时间 Inputs

在时间input (`<input type="time">`)上使用`.type()`需要指定有效的时间，格式如下:

- `HH:mm` (比如. `01:30` 或 `23:15`)
- `HH:mm:ss` (比如. `10:00:30`)
- `HH:mm:ss.SSS` (比如. `12:00:00.384`)

其中，`HH`为00-23, `mm`为00-59,`ss`为00-59, `SSS`为000-999。

特殊字符(`{leftarrow}`, `{selectall}`等)是不允许的。

### 组合键

当使用特殊字符序列时，可以激活修改键和键入组合键，如`CTRL+R` or `SHIFT+ALT+b`. 单个键组合可以用`{modifier+key}`语法指定.

当一个修饰符被激活时触发一个 `keydown`事件，当它被释放时触发一个`keyup`事件。

<Alert type="info">

您还可以在 [.click()](/api/commands/click#Click-with-key-combinations), [.rightclick()](/api/commands/rightclick#Right-click-with-key-combinations) and [.dblclick()](/api/commands/dblclick#Double-click-with-key-combinations) 通过选项中使用键组合.更多信息请参阅对应文档.

</Alert>

#### 键入组合键

```javascript
// 这与用户按住SHIFT和ALT，然后按b是相同的
// 修饰符在输入'hello'之前被释放
cy.get('input').type('{shift+alt+b}hello')
```

当一个修饰符单独指定时，它将在 `.type()`命令期间保持激活状态，并在键入所有后续字符时释放. 然而，[{release: false}](#Options)可以作为[option](#Key-Combinations)传递。

```javascript
// 这和用户按住SHIFT和ALT键，然后输入hello是一样的
// 修饰符在命令执行期间被保留。
cy.get('input').type('{shift}{alt}hello')
```

#### 输入字面量`{` 或 `}`字符

若要禁用解析特殊字符序列，请将`parseSpecialCharSequences`选项设置为`false`。

```js
cy.get('#code-input')
  // 不会转移 { } 字符
  .type('function (num) {return num * num;}', {
    parseSpecialCharSequences: false,
  })
```

#### 按住修饰键并键入一个单词

```javascript
// {ctrl}后面的所有字符都有'ctrlKey'
// 在事件上设置为“true”
cy.get('input').type('{ctrl}test')
```

#### 释放行为

默认情况下，修饰符在每个type命令之后被释放。

```javascript
// 当键入'test'时，'ctrlKey'始终是按下
// 但当键入'everything'时已释放
cy.get('input').type('{ctrl}test').type('everything')
```

要在命令之间保留一个修饰符，请在选项中指定`{release: false}`。

```javascript
// 'altKey'将在键入'foo' 保持按下
cy.get('input').type('{alt}foo', { release: false })
// 'altKey'在'get'和'click'命令中也保持按下
cy.get('button').click()
```

即使使用`{release: false}`，修饰符也会在测试之间自动释放。

```javascript
it('has modifiers activated', () => {
  // 'altKey'将在键入'foo'时保持按下
  cy.get('input').type('{alt}foo', { release: false })
})

it('does not have modifiers activated', () => {
  // 键入bar时'altKey'已释放
  cy.get('input').type('bar')
})
```

要在使用`{release: false}`之后在测试中手动释放修饰符，请使用另一个`type`命令，修饰符将在它之后释放。

```javascript
// 'altKey'将在键入'foo'时 按下
cy.get('input').type('{alt}foo', { release: false })
// 'altKey'将在'get'和'click'命令期间保持按下
cy.get('button').click()
// 'altKey'将在此命令之后释放
cy.get('input').type('{alt}')
// 'altKey'在'get'和'click'命令期间将为按下
cy.get('button').click()
```

### 全局快捷键

`.type()` 需要一个可聚焦的元素作为目标，因为它通常用于input或textarea。 尽管在一些情况下，它是有效的“输入”到其他东西，而不是一个input或textarea:

- 键盘快捷键，监听器在`document` or `body`上.
- 按住修饰符键并单击任意元素.

为了支持这一点，'`body`可以用作输入的DOM元素 (即使它不是一个可聚焦的元素).

#### 在body使用键盘快捷键

```javascript
// 所有类型事件都在body上触发
cy.get('body').type(
  '{uparrow}{uparrow}{downarrow}{downarrow}{leftarrow}{rightarrow}{leftarrow}{rightarrow}ba'
)
```

#### 实现 shift + click

```javascript
// 执行SHIFT + click在 第一个<li> 上
// {release: false} 是必要的，
// SHIFT不会在type命令之后被释放
cy.get('body').type('{shift}', { release: false }).get('li:first').click()
```

### 选项

#### 强制输入，不管它的可操作状态

强制输入将覆盖[可操作的检查](/guides/core-concepts/interacting-with-elements#Forcing)  Cypress应用并自动触发事件。

```javascript
cy.get('input[type=text]').type('Test all the things', { force: true })
```

## 注意

### 支持的元素

- ^HTML `<body>` 以及 `<textarea>` 元素.
- 定义了`tabindex`属性的元素。
- 定义了`contenteditable`属性的元素。
- ^HTML 定义了`type` 属性的`<input>` 元素，其`type` 属性如下所示之一:
  - `text`
  - `password`
  - `email`
  - `number`
  - `date`
  - `week`
  - `month`
  - `time`
  - `datetime-local`
  - `search`
  - `url`
  - `tel`

### 可操作性

`.type()`是一个“操作命令”，它遵循[在这里定义](/guides/core-concepts/interacting-with-elements)的所有规则。.

### 事件

#### 当元素不是焦点时

如果元素当前不在焦点中，在发出任何击键之前，Cypress将首先向元素发出[`.click()`](/api/commands/click) 以使其进入焦点.

#### 触发事件

一旦元素被聚焦，Cypress将开始触发键盘事件。

以下事件将根据按下的键触发，与事件规范相同:

- `keydown`
- `keypress`
- `beforeinput`\*
- `textInput`
- `input`
- `keyup`

\* Firefox 不支持 `beforeinput` 事件 [MDN](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/beforeinput_event)

此外，`change`事件将在按下`{enter}` 键时触发(自上次焦点事件以来，该值已发生变化)，或元素失去焦点时触发。 这与浏览器行为相匹配.

不会在非input类型元素上触发事件，比如带有`tabindex`的元素，不会触发它们的`textInput` 或 `input` 事件。 只有在导致实际值或文本更改的元素中输入元素才会触发这些事件。

#### 事件触发

下面的规则已经实现，以匹配真实的浏览器行为(和规范):

1. 如果之前的事件被取消，Cypress 就不触发后续事件。
2. Cypress会 _只_ 触发`keypress`，如果这个键应该实际触发`keypress`.
3. 只有在键入该键时插入了一个实际字符时，Cypress _才_ 会触发`textInput`.
4. 只有当输入的键修改或改变了元素的值时，Cypress _才会_ 触发`input`。

#### 事件取消

当事件被取消时，Cypress尊重所有默认的浏览器行为。

```javascript
// 通过取消keydown, keypress, 或 textInput来阻止字符插入
$('#username').on('keydown', (e) => {
  e.preventDefault()
})

// 如果keydown、keypress或textInput被取消，Cypress 将不会插入任何字符 - 匹配默认的浏览器行为
cy.get('#username').type('bob@gmail.com').should('have.value', '') // true
```

#### 阻止`mousedown` 并不能阻止输入

在真正的浏览器中，阻止`mousedown` 表单字段将阻止它接收焦点，从而阻止它被输入. 目前，Cypress还没有考虑到这一点。 [打开一个问题](https://github.com/cypress-io/cypress/issues/new/choose) 如果你需要这个被修复.

#### 按键事件表

Cypress打印出一个键事件表，详细说明了当在[命令日志](#Command-Log)中type时按下的键。每个字符都将包含`which`字符代码和按下该键后发生的事件。

`defaultPrevented`的事件可能会阻止其他事件的触发，这些事件将显示为空。 For instance, 取消`keydown`就不会触发 `keypress` 或 `textInput` 或 `input`, 但会触发`keyup`(符合规范).

此外，触发`change`事件的事件(例如键入`{enter}`)将会让 `change`事件列显示为`true`。

为事件激活的任何修饰符也列在 `modifiers`列中。

<DocsImage src="/img/api/type/key-events-table-shown-in-console-for-testing-typing.png" alt="Cypress .type() key events table" ></DocsImage>

### Tabbing

#### 键入`tab`键不起作用

同时，您可以使用实验性的[cypress-plugin-tab](https://github.com/Bkucera/cypress-plugin-tab) ，并可以点[这个问题](https://github.com/cypress-io/cypress/issues/299).

### 修饰符

#### 修饰符的影响

在真正的浏览器中，如果用户按住`SHIFT`并输入`a`，则会输入大写的 `A`。目前，Cypress还没有模拟这种行为。

通过将按键和点击事件的相应值设置为`true`来模拟修饰符. 例如，激活`{shift}`修饰符将为所有健事件设置`event.shiftKey`为true， 比如 `keydown`.

```javascript
// 应用程序代码
document.querySelector('input:first').addEventListener('keydown', (e) => {
  // e.shiftKey === true
})

// 测试代码
cy.get('input:first').type('{shift}a')
```

在上面的例子中，将输入小写的`a`，因为这是指定的文字字符.要键入大写的`A`，你可以使用 `.type('{shift}A')` (或`.type('A')`，如果你不关心任何键事件的`shiftKey`属性).

这也适用于其他特殊的键组合(可能是特定于操作系统的). 例如，在OSX上，键入`ALT + SHIFT + K`将创建特殊字符 ``. 与大写一样，`.type()`不会输出 ``, 除了字符 `k`.

类似地，修改器不会影响方向键或删除键。 例如`{ctrl}{backspace}`将不会删除整个单词. 如果你需要修改效果被实现，[打开一个问题](https://github.com/cypress-io/cypress/issues/new).

### 表单提交

#### 隐式表单提交行为

当input属于`<form>`时，Cypress自动匹配按`{enter}`键的规范和浏览器行为。

这个行为定义在这里:[表单隐式提交](https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#implicit-submission).

例如，下面将提交表单.

```html
<form action="/login">
  <input id="username" />
  <input id="password" />
  <button type="submit">Log In</button>
</form>
```

```javascript
cy.get('#username').type('bob@burgers.com')
cy.get('#password').type('password123{enter}')
```

因为有多个`inputs` 以及一个`submit`按钮，Cypress提交表单(并触发提交事件)以及一个合成的`click` 事件到`button`。.

规范将`submit`按钮定义为表单内的第一个 `input[type=submit]` 或 `button[type!=button]` 按钮。

此外，Cypress还处理了规范中定义的其他4种情况:

1. 如果有多个输入且没有`submit`按钮，则不提交表单。
2. 如果`submit`按钮被禁用，不提交表单.
3. 提交表单，但如果有1个`input`而没有`submit`按钮，则不触发合成的`click`事件
4. 提交表单，并在`submit`存在时触发一个合成的`click`事件。

如果表单的`submit`事件是 `preventedDefault`，表单实际上就不会被提交。

## 规则

### 要求 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Chains-of-Commands)

<List><li>`.type()`需要链接一个命令，该命令输出DOM元素.</li></List>

### 断言 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Assertions)

<List><li>`.type()` 将自动等待元素达到[可操作状态](/guides/core-concepts/interacting-with-elements)</li><li>`.type()` 将自动[重试](/guides/core-concepts/retry-ability) 直到所有链式断言都通过</li></List>

### 超时 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Timeouts)

<List><li>`.type()` 在元素达到[可操作状态](/guides/core-concepts/interacting-with-elements) 的超时设定.</li><li>`.type()` 在等待添加的断言通过时会超时.</li></List>

## 命令日志

**在 input 上输入**

```javascript
cy.get('input[name=firstName]').type('Jane Lane')
```

上面的命令将在命令日志中显示为:

<DocsImage src="/img/api/type/type-in-input-shown-in-command-log.png" alt="Command Log type" ></DocsImage>

当点击命令日志中的`type`时，控制台输出如下:

<DocsImage src="/img/api/type/console-log-of-typing-with-entire-key-events-table-for-each-character.png" alt="Console Log type" ></DocsImage>

## History

| Version                                       | Changes                                                                                                                   |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| [6.1.0](/guides/references/changelog#6-1-0)   | Added option `scrollBehavior`                                                                                             |
| [5.6.0](/guides/references/changelog#5.6.0)   | Support single key combination syntax                                                                                     |
| [5.5.0](/guides/references/changelog#5.5.0)   | Support `beforeinput` event                                                                                               |
| [3.4.1](/guides/references/changelog#3-4-1)   | Added `parseSpecialCharSequences` option                                                                                  |
| [3.3.0](/guides/references/changelog#3-3-0)   | Added `{insert}`, `{pageup}` and `{pagedown}` character sequences                                                         |
| [3.2.0](/guides/references/changelog#3-2-0)   | Added `{home}` and `{end}` character sequences                                                                            |
| [0.20.0](/guides/references/changelog#0-20-0) | Supports for typing in inputs of type `date`, `time`, `month`, and `week`                                                 |
| [0.17.1](/guides/references/changelog#0-17-1) | Added `ctrl`, `cmd`, `shift`, and `alt` keyboard modifiers                                                                |
| [0.16.3](/guides/references/changelog#0-16-3) | Supports for typing in elements with `tabindex` attribute                                                                 |
| [0.16.2](/guides/references/changelog#0-16-2) | Added `{downarrow}` and `{uparrow}` character sequences                                                                   |
| [0.8.0](/guides/references/changelog#0-8-0)   | Outputs Key Events Table to console on click                                                                              |
| [0.8.0](/guides/references/changelog#0-8-0)   | Added `{selectall}`, `{del}`, `{backspace}`, `{esc}`, `{{}`, `{enter}`, `{leftarrow}`, `{rightarrow}` character sequences |
| [0.8.0](/guides/references/changelog#0-8-0)   | Added small delay (10ms) between each keystroke during `cy.type()`                                                        |
| [0.6.12](/guides/references/changelog#0-6-12) | Added option `force`                                                                                                      |

## 另请参阅

- [`.blur()`](/api/commands/blur)
- [`.clear()`](/api/commands/clear)
- [`.click()`](/api/commands/click)
- [`.focus()`](/api/commands/focus)
- [`.submit()`](/api/commands/submit)
- [`Cypress.Keyboard`](/api/cypress-api/keyboard-api)
