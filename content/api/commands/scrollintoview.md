---
title: scrollIntoView
---

将元素滚动到视图中.

## 语法

```javascript
.scrollIntoView()
.scrollIntoView(options)
```

### 用法

**<Icon name="check-circle" color="green"></Icon> 正确的用法**

```javascript
cy.get('footer').scrollIntoView() // 将footer滚动到视图中
```

**<Icon name="exclamation-triangle" color="red"></Icon> 不正确的用法**

```javascript
cy.scrollIntoView('footer') // 错误，不能链接到'cy'
cy.window().scrollIntoView() // 错误，'window'不输出DOM元素
```

### 参数

**<Icon name="angle-right"></Icon> options** **_(Object)_**

传入一个options对象来改变`.scrollIntoView()`的默认行为.

| 选项        | 默认值                                                               | 描述                                                                              |
| ---------- | -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| `duration` | `0`                                                                  | 滚动持续时间(单位毫秒)                                                       |
| `easing`   | `swing`                                                              | 滚动使用动画的缓动程度                                                    |
| `log`      | `true`                                                               | 在[命令日志](/guides/core-concepts/test-runner#Command-Log) 中显示命令 |
| `offset`   | `{top: 0, left: 0}`                                                  | 元素被滚动到视图后要滚动的数量                           |
| `timeout`  | [`defaultCommandTimeout`](/guides/references/configuration#Timeouts) | 等待`.scrollIntoView()`在[超时](#Timeouts)之前解决的时间           |

### 输出 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Subject-Management)

<List><li>'`.scrollIntoView()`输出与前一个命令相同的目标。</li></List>

## Examples

### Scrolling

```javascript
cy.get('button#checkout').scrollIntoView().should('be.visible')
```

### 选项

#### 使用线性缓和动画滚动

```javascript
cy.get('.next-page').scrollIntoView({ easing: 'linear' })
```

#### 滚动元素持续2000ms

```javascript
cy.get('footer').scrollIntoView({ duration: 2000 })
```

#### 滚动到元素下到方150px

```js
cy.get('#nav').scrollIntoView({ offset: { top: 150, left: 0 } })
```

## Notes

### 快照

#### 快照不反映滚动行为

_柏树不反映快照中任何元素的精确滚动位置._ 如果你想看到实际的滚动行为, 我们建议使用[`.pause()`](/api/commands/pause) 遍历每个命令， 或者[观看测试运行的视频](/guides/guides/screenshots-and-videos#Videos).

## 规则

### 需要 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Chains-of-Commands)

<List><li>`.scrollIntoView()`需要链接在输出DOM元素的命令链之后。</li></List>

### 断言 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Assertions)

<List><li>`.scrollIntoView()`将自动等待已链接的断言传递</li></List>

### 超时 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Timeouts)

<List><li>`.scrollIntoView()`在等待添加的断言时可能超时.</li></List>

## 命令日志

#### 断言元素在滚动到视图后是可见的

```javascript
cy.get('#scroll-horizontal button').scrollIntoView().should('be.visible')
```

上面的命令将在命令日志中显示为:

<DocsImage src="/img/api/scrollintoview/command-log-for-scrollintoview.png" alt="command log scrollintoview" ></DocsImage>

当单击命令日志中的`scrollintoview` 命令时，控制台输出如下内容:

<DocsImage src="/img/api/scrollintoview/console-log-for-scrollintoview.png" alt="console.log scrollintoview" ></DocsImage>

## 另请参阅

- [`cy.scrollTo()`](/api/commands/scrollto)
