---
title: debug
---

设置一个 `debugger`，从而日志输出上一个命令产生的结果.

<Alert type="warning">

你需要为`.debug()`打开浏览器开发者工具以在断点暂停.

</Alert>

## 语法

```javascript
.debug()
.debug(options)

// ---或---

cy.debug()
cy.debug(options)
```

### 用法

**<Icon name="check-circle" color="green"></Icon> 正确的用法**

```javascript
cy.debug().getCookie('app') // 在命令开始时暂停以调试
cy.get('nav').debug() // 调试`get` 命令的输出
```

### 参数

**<Icon name="angle-right"></Icon> options** **_(Object)_**

传入一个options对象来改变`.debug()`的默认行为.

| 选项    | 默认值  | 描述                                                                              |
| ------ | ------- | ---------------------------------------------------------------------------------------- |
| `log`  | `true`  | 在[命令日志](/guides/core-concepts/test-runner#Command-Log) 中显示命令 |

### Yields 输出[<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Subject-Management)

<List><li>`.debug()`输出与前一个命令相同的目标.</li></List>

## 例子

### 调试

#### 在`.get()`后暂停调试

```javascript
cy.get('a').debug().should('have.attr', 'href')
```

## 规则

### 要求 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Chains-of-Commands)

<List><li>`.debug()`可以关闭`cy`或关闭另一个命令.</li></List>

### 断言 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Assertions)

<List><li>`.debug()`是一个实用程序命令.</li><li>`.debug()`不会运行断言. 断言将会像这个命令不存在一样通过.</li></List>

### 超时 [<Icon name="question-circle"/>](/guides/core-concepts/introduction-to-cypress#Timeouts)

<List><li>`.debug()` 没有超时概念.</li></List>

## 命令日志

**_输出当前目标的日志，进行调试_**

```javascript
cy.get('.ls-btn').click({ force: true }).debug()
```

上面的命令将在命令日志中显示为:

<DocsImage src="/img/api/debug/how-debug-displays-in-command-log.png" alt="Command Log debug" ></DocsImage>

当单击命令日志中的 `debug`命令时，控制台输出如下内容:

<DocsImage src="/img/api/debug/console-gives-all-debug-info-for-command.png" alt="console.log debug" ></DocsImage>

## 另请参阅

- [Dashboard](https://on.cypress.io/dashboard)
- [`.pause()`](/api/commands/pause)
- [`cy.log()`](/api/commands/log)
- [`cy.screenshot()`](/api/commands/screenshot)
