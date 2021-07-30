---
layout: toc-top
title: 错误信息
---

## 测试文件错误

### <Icon name="exclamation-triangle" color="red"></Icon> No tests found 没有找到测试

此消息意味着Cypress无法在指定文件中找到测试。如果您有一个空的测试文件，并且还没有编写任何测试，那么您可能会收到此消息。

<DocsImage src="/img/guides/no-tests-found.png" alt="No tests found" ></DocsImage>

### <Icon name="exclamation-triangle" color="red"></Icon> We found an error preparing your test file 我们在准备测试文件时发现了一个错误

此消息意味着Cypress在编译或绑定您的测试文件时遇到了错误。Cypress会自动编译和打包你的测试代码，这样你就可以使用ES2015, CoffeeScript，模块等等。

#### 你收到这条消息，通常原因如下:

- 文件不存在
- 文件或其依赖项中的一个语法错误
- 依赖缺失

当您的测试文件中的错误被修复后，您的测试将自动重新运行.

## 支持文件错误

### <Icon name="exclamation-triangle" color="red"></Icon> Support file missing or invalid 支持文件丢失或无效

`supportFolder`选项已从Cypress版本[' 0.18.0 '](guidesreferenceschangelog0-18-0)中移除，
并被模块支持和[`supportFile`](/guides/references/configuration#Folders-Files)配置选项替换。

Cypress习惯于在测试文件之前自动将任何脚本包含在`supportFolder`中。但是，自动包含某个目录中的所有文件有些不可思议，而且不直观，需要为实用程序函数创建全局变量。

#### 使用模块作为工具函数

Cypress同时支持ES2015模块和CommonJS模块。你可以导入npm模块和本地模块:

```javascript
import _ from 'lodash'
import util from './util'

it('使用模块', () => {
  expect(_.kebabCase('FooBar')).to.equal('foo-bar')
  expect(util.secretCode()).to.equal('1-2-3-4')
})
```

#### 使用supportFile在测试代码之前加载脚本

在测试代码之前加载安装文件仍然很有用。如果您正在设置Cypress默认值或使用自定义Cypress命令，
而不需要在每个测试文件中导入这些命令，您可以使用[`supportFile`](/guides/references/configuration#Folders-Files)配置选项。

要在测试文件之前包含代码，请设置[`supportFile`](/guides/references/configuration#Folders-Files)路径。
默认情况下，[`supportFile`](/guides/references/configuration#Folders-Files)设置为查找以下文件之一:

- `cypress/support/index.js`
- `cypress/support/index.ts`
- `cypress/support/index.coffee`

就像你的测试文件一样，[`supportFile`](/guides/references/configuration#Folders-Files)可以使用ES2015+， 
[TypeScript](/guides/tooling/typescript-support)或CoffeeScript和模块，所以你可以`import`或`require`其他文件。

## 命令错误

### <Icon name="exclamation-triangle" color="red"></Icon> Cypress cannot execute commands outside a running test. Cypress不能在正在运行的测试之外执行命令

<DocsImage src="/img/guides/cypress-cannot-execute.png" alt="Cannot execute commands" ></DocsImage>

此消息意味着您试图在当前运行的测试之外执行一个或多个Cypress命令。Cypress必须能够将命令与特定的测试关联起来。

这通常是偶然发生的，就像下面的情况。

```javascript
describe('一些测试', () => {
  it('是 true', () => {
    expect(true).to.be.true // yup, fine
  })

  it('是 false', () => {
    expect(false).to.be.false // yup, also fine
  })

  context('一些嵌套测试', () => {
    // 哦，你忘记在这里写it了!
    // 下面这些cypress命令在测试之外运行，cypress抛出一个错误
    cy.visit('http://localhost:8080')
    cy.get('h1').should('contain', 'todos')
  })
})
```

将那些Cypress命令移到一个 `it(...)` 代码块中，一切都会正常。

如果您有意在测试之外编写命令，那么可能有更好的方法来完成您正在尝试做的事情。通读[示例](/examples/examples/recipes),
[在我们的聊天室内沟通](https://gitter.im/cypress-io/cypress), or
[打开一个问题](https://github.com/cypress-io/cypress/issues/new/choose).

### <Icon name="exclamation-triangle" color="red"></Icon> `cy...()` failed because the element you are chaining off of has become detached or removed from the dom。失败原因是链接的元素已经从dom中分离或移除

得到这个错误意味着您试图与一个`死掉`的DOM元素交互——这意味着它已经从DOM中分离或完全移除。
·
<!--
重现对下面的截图
describe('从dom分离的例子', () => {
  beforeEach(() => {
    cy.get('body').then(($body) => {
      const $outer = Cypress.$('<div />').appendTo($body)
      Cypress.$('<button />').on('click', () => { $outer[0].remove() }).appendTo($outer)
    })
  })
  it('从dom分离', () => {
    cy.get('button')
    .click()
    .parent()
    .should('have.text', 'Clicked')
  })
})
-->

<!--
To reproduce the following screenshot:
describe('detachment example', () => {
  beforeEach(() => {
    cy.get('body').then(($body) => {
      const $outer = Cypress.$('<div />').appendTo($body)
      Cypress.$('<button />').on('click', () => { $outer[0].remove() }).appendTo($outer)
    })
  })
  it('detaches from dom', () => {
    cy.get('button')
    .click()
    .parent()
    .should('have.text', 'Clicked')
  })
})
-->

<DocsImage src="/img/guides/cy-method-failed-element-is-detached.png" alt="cy.method() failed because element is detached" ></DocsImage>

Cypress错误是因为它不能与`死掉`的元素交互——就像一个真正的用户也不能这样做。了解这是如何发生的非常重要——而且这通常是可以预防的。
让我们看一下下面的例子。

#### 应用程序的HTML

```html
<body>
  <div id="parent">
    <button>删除</button>
  </div>
</body>
```

#### Application JavaScript

```javascript
$('button').click(() => {
  // 当<button>被单击时
  // 我们从DOM中移除按钮
  $(this).remove()
})
```

#### 导致错误的测试代码

```javascript
cy.get('button').click().parent()
```

我们已经在上面对应用程序进行了编程，这样一旦`click`事件发生，按钮就会从DOM中删除。
当Cypress开始处理上面测试中的下一个命令([`.parent()`](/api/commands/parent))时，它检测到输出的目标(按钮)与DOM分离，并抛出错误。

我们可以通过重写测试代码来防止Cypress抛出这个错误。

#### 修复测试代码

```javascript
cy.get('button').click()
cy.get('#parent')
```

上面的例子过于简单化了。让我们看一个更复杂的例子。

在现代JavaScript框架中，DOM元素经常被重新呈现——这意味着旧元素被丢弃，新元素被替换。
因为这发生得太快了，用户可能会觉得好像什么都没有发生。
但如果您正在执行测试命令，则可能与您交互的元素已经`死亡`。要处理这种情况，你必须:

- 了解应用程序何时重新呈现
- 重新查询新添加的DOM元素
- 在满足特定条件之前，**阻止**Cypress运行命令

当我们说_阻止_时，这通常意味着:

- 编写一个断言
- 等待一个XHR完成

#### 更多信息

阅读博客文章[Do Not Get Too Detached](https://www.cypress.io/blog/2020/07/22/do-not-get-too-detached/)，了解这个错误的另一个例子，以及如何解决它.

### <Icon name="exclamation-triangle" color="red"></Icon> `cy....()` failed because the element cannot be interacted with 。失败是因为无法与元素交互

你可能会看到这个消息的变体，有4个不同的原因:

1. 元素是不可见的
2. 该元素被另一个元素覆盖
3. 元素的中心隐藏在视图中
4. 元素被禁用

Cypress进行了几次计算，以确保一个元素可以像真正的用户那样进行交互。如果您看到这个错误，可能需要阻止您的命令(由于时间或动画问题)。

在某些情况下，Cypress不允许您正确地与一个应该是可交互的元素进行交互。如果是这样，[提出一个问题](https://github.com/cypress-io/cypress/issues/new/choose).

如果你想覆盖这些内置的检查，为动作本身提供`{force: true}`选项。请参阅每个命令以了解它们的可用选项、其他用例和参数用法。

#### 忽略内置错误检查

```javascript
cy.get('[disabled]').click({force: true}).
```

_小心这个选项。当元素在应用程序中实际上不可交互时，可以强制测试通过._

### <Icon name="exclamation-triangle" color="red"></Icon> `cy....()` failed because the element is currently animating.失败是因为元素当前正在动画

<!--
To reproduce the following screenshot:
describe('animating example', () => {
  beforeEach(() => {
    cy.get('body').then(($body) => {
      Cypress.$('<input style="position: absolute;" />').appendTo($body)
      .animate({ left: '+=1000000' }, 10)
    })
  })
  it('is animating', () => {
    cy.get('input')
    .type('some text', { timeout: 20 })
  })
})
-->

<DocsImage src="/img/guides/cy-method-failed-element-is-animating.png" alt="cy.method() failed because element is animating" ></DocsImage>

默认情况下，Cypress会检测你想要交互的元素是否动画过程汇总。这个检查确保元素的动画速度不会太快，不会让真正的用户与元素交互。
这也防止了一些边缘情况，例如[`.type()`](/api/commands/type)或[`.click()`](/api/commands/click)在动画过渡过程中发生得太快。

Cypress将不断尝试与元素互动，直到它最终失效。如果你想强迫Cypress与元素交互，有几个选项:

- 传参 `{force: true}`. 这将禁用 __所有__ 错误检查
- 传参 `{waitForAnimations: false}` 禁用动画错误检查
- 传参 `{animationDistanceThreshold: 20}` 降低检测一个元素是否动画的灵敏度。通过增加阈值，可以使元素在页面上移动得更远，而不会导致Cypress连续重试。

```javascript
cy.get('#modal button').click({ waitForAnimations: false })
```

您可以全局禁用动画错误检查，或者通过修改[配置](/guides/references/configuration)来增加阈值。.

####  配置文件(默认是`cypress.json` )

```json
{
  "waitForAnimations": false,
  "animationDistanceThreshold": 50
}
```

### <Icon name="exclamation-triangle" color="red"></Icon> The test has finished but Cypress still has commands in its queue。测试已经完成，但Cypress的队列中仍然有命令

让我们检查几种可能得到此错误消息的方法。在每种情况下，您都需要更改测试代码中的某些内容，以防止出现错误.

<DocsImage src="/img/guides/the-test-has-finished.png" alt="The test has finished but Cypress still has commands" ></DocsImage>

<Alert type="warning">

<strong class="alert-header">下面的脆弱测试!</strong>

其中一些测试依赖于竞争条件。在这些测试实际失败之前，您可能必须多次运行这些测试。您还可以尝试调整一些延迟.

</Alert>

#### 简短的例子

下面的第一个测试将通过，并向您显示Cypress在每次测试中都试图防止在队列中留下命令。

即使我们在测试中返回一个字符串，Cypress也会自动计算出您已经对上面的命令进行了排队，并且直到所有的cy命令都完成后才会结束测试。

```javascript
// 这个测试会通过!
it('Cypress是智能的，不会失败', () => {
  cy.get('body').children().should('not.contain', 'foo') // <-这里没有返回

  return 'foobarbaz' // <- 在这里返回
})
```

下面的示例将会失败，因为您已经使用mocha的`done`强制提前终止了测试。

```javascript
// 这个测试会错误!
it('但是您可以强制提前结束测试，这会失败', (done) => {
  cy.get('body')
    .then(() => {
      done() // 强制结束测试，即使下面有命令
    })
    .children()
    .should('not.contain', 'foo')
})
```

#### 复杂的异步例子

在这个例子中，因为我们 __没有__ 告诉Mocha这是一个异步测试，所以这个测试会 __立即__ 通过，进入下一个测试。
然后，当`setTimeout`回调函数运行时，新的命令将在错误的测试上排队。Cypress会察觉到这一点，并让下一次测试失败。
```javascript
describe('一个复杂的异步代码示例', function () {
  it('您可以使命令传入下一个测试', function () {
    // 这个测试会通过。。。。。。但是。。。。。。
    setTimeout(() => {
      cy.get('body').children().should('not.contain', 'foo')
    }, 10)
  })

  it('由于之前的破测试，这个测试会失败', () => {
    // 这个测试会错误!
    cy.wait(10)
  })
})
```

编写上述测试代码的正确方法是使用Mocha的`done`来表示它是异步的。

```javascript
it('不会导致命令渗入到下一个测试中', (done) => {
  setTimeout(() => {
    cy.get('body')
      .children()
      .should('not.contain', 'foo')
      .then(() => {
        done()
      })
  }, 10)
})
```

#### 复杂的Promise例子

在下面的例子中，我们忘记在测试中返回`Promise` 。这意味着测试同步通过，但是我们的`Promise` 会在下一次测试中解析。
这也会导致命令在错误的测试上排队。我们将在下一次测试中得到错误，Cypress检测到它的命令队列中有命令。

```javascript
describe('另一个使用被遗忘的“return”的复杂示例', () => {
  it('忘记返回一个 promise', () => {
    // 这个测试会通过。。。。。。但是。。。。。。
    Cypress.Promise.delay(10).then(() => {
      cy.get('body').children().should('not.contain', 'foo')
    })
  })

  it('由于之前的破测试，这个测试会失败', () => {
    // 这个测试会错误!
    cy.wait(10)
  })
})
```

编写上述测试代码的正确方法是返回我们的`Promise`:

```javascript
it('别忘了返回一个promise', () => {
  return Cypress.Promise.delay(10).then(() => {
    return cy.get('body').children().should('not.contain', 'foo')
  })
})
```

### <Icon name="exclamation-triangle" color="red"></Icon> `cy.visit()` failed because you are attempting to visit a second unique domain。失败是因为您正试图访问第二个唯一域

请参阅我们的[Web安全](/guides/guides/web-security#Limitations)文档.

### <Icon name="exclamation-triangle" color="red"></Icon> `cy.visit()` failed because you are attempting to visit a different origin domain。失败是因为您正在尝试访问一个不同的源域名

如果两个url的`protocol`, `port`(如果指定)和`host`都是相同的，那么这两个url就是相同的来源。
您只能在单个测试中访问同源的域。您可以在[这里](https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy) 阅读更多关于同源策略的常规内容


你可以在不同的测试中访问不同来源的url，所以你可以考虑将不同来源域的`cy.visit()` 分割成单独的测试。

请参阅我们的[Web安全](/guides/guides/web-security#Limitations)文档
获取更多信息和解决方法。

### <Icon name="exclamation-triangle" color="red"></Icon> `Cypress.addParentCommand()` / `Cypress.addDualCommand()` / `Cypress.addChildCommand()` has been removed and replaced by `Cypress.Commands.add()`。`Cypress.addParentCommand()` / `Cypress.addDualCommand()` / `Cypress.addChildCommand()` 已被删除并被`Cypress.Commands.add()`替换

在[0.20.0](/guides/references/changelog)版本中，我们删除了用于添加自定义命令的命令，并将它们替换为我们认为更简单的界面。

现在您可以使用同一个命令[Cypress.Commands.add()](/api/cypress-api/custom-commands)创建父命令、双命令和子命令。

请阅读我们的[编写自定义命令的新文档](/api/cypress-api/custom-commands).

### <Icon name="exclamation-triangle" color="red"></Icon> Cypress detected that you invoked one or more `cy` commands in a custom command but returned a different value.  Cypress检测到您在自定义命令中调用了一个或多个`cy`命令，但返回了不同的值

因为`cy`命令是异步的，并且被排队等待稍后运行，所以返回任何其他命令都没有意义。

为了方便，您还可以省略任何返回值或返回`undefined`，这样Cypress就不会出错。
在Cypress [0.20.0](/guides/references/changelog)之前的版本中，我们自动检测到这一点，并强制返回`cy`命令。为了让事情变得不那么神奇和清晰，我们现在抛出一个错误。

### <Icon name="exclamation-triangle" color="red"></Icon> Cypress detected that you invoked one or more `cy` commands but returned a different value. Cypress检测到您调用了一个或多个`cy`命令，但返回了不同的值

因为`cy`命令是异步的，并且被排队等待稍后运行，所以返回任何其他命令都没有意义。

为了方便，您还可以省略任何返回值或返回 `undefined`，这样Cypress就不会出错。
在Cypress [0.20.0](/guides/references/changelog)之前的版本中，我们自动检测到这一点，并强制返回`cy`命令。为了让事情变得不那么神奇和清晰，我们现在抛出一个错误。

### <Icon name="exclamation-triangle" color="red"></Icon> Cypress detected that you returned a promise from a command while also invoking one or more cy commands in that promise. Cypress检测到您从一个命令中返回了一个promise，同时还在该promise中调用了一个或多个`cy`命令。

因为Cypress命令已经是类似promise，所以您不需要包装它们或返回您自己的promise。

Cypress会用最后的Cypress命令所产生的任何结果来解决你的命令。

这是一个错误而不是警告的原因是，Cypress在内部连续地队列命令，而promise则在调用时立即执行。试图调和这一点将会阻止Cypress解决问题。

### <Icon name="exclamation-triangle" color="red"></Icon> Cypress detected that you returned a promise in a test, but also invoked one or more `cy` commands inside of that promise. Cypress检测到您在测试中返回了一个promise，但也在该promise中调用了一个或多个`cy`命令。

虽然这在实践中是可行的，但它通常表明是反模式。几乎不需要同时返回promise和调用`cy`命令。

`cy`命令本身就像promise一样，你可以避免使用单独的promise。

### <Icon name="exclamation-triangle" color="red"></Icon> Cypress detected that you returned a promise in a test, but also invoked a done callback.  Cypress检测到您在测试中返回了一个promise，但也调用了done回调。

Mocha的版本是用Cypress 4.0升级的。Mocha 3+不再允许返回promise和调用done回调。更多信息请参阅[4.0迁移指南](/guides/references/migration-guide#Mocha-upgrade).

### <Icon name="exclamation-triangle" color="red"></Icon> Passing `cy.route({stub: false})` or `cy.server({stub: false})` is now deprecated.  `cy.route({stub: false})` 或 `cy.server({stub: false})`的这个参数已经废弃

你可以安全地移除: `{stub: false}`.

### <Icon name="exclamation-triangle" color="red"></Icon> CypressError: Timed out retrying: Expected to find element: ‘…’, but never found it. Queried from element: <…>  。CypressError: 重试超时: 期望找到匀速: '…'，但从未找到它。从元素:<…>查询

如果在元素在DOM中明确可见的情况下出现此错误，则文档可能包含格式错误的HTML。在这种情况下，`document.querySelector()`将找不到出现在HTML格式错误点之后的任何元素。即使您确信HTML在任何地方都没有变形，也要检查它(在开发工具中逐行检查)。尤其是当你已经穷尽了所有其他可能性的时候。

## 命令行错误

### <Icon name="exclamation-triangle" color="red"></Icon> You passed the `--record` flag but did not provide us your Record Key. 您指定了 `--record`选项标志，但没有提供“记录密钥”

当尝试在[持续集成](/guides/continuous-integration/introduction)中运行Cypress测试时，可能会收到此错误. 
这意味着您没有传递特定的记录秘钥:[cypress run -record](/guides/guides/command-line#cypress-run).

由于没有传递记录秘钥，Cypress会检查名为`CYPRESS_RECORD_KEY`的任何环境变量。在这个案例中，也没有发现.

你可以在测试运行器或[Dashboard服务](https://on.cypress.io/dashboard)的设置选项卡中找到你的项目的记录密钥。.

然后，您需要[将密钥添加到配置文件或作为环境变量](/guides/continuous-integration/introduction#Record-tests).

### <Icon name="exclamation-triangle" color="red"></Icon> The `cypress ci` command has been deprecated。`cypress ci`命令已被废弃

从版本[`0.19.0`](/guides/references/changelog#0-19-0)和CLI版本`0.13.0`开始，`cypress ci`命令已弃用。我们这样做是为了更清楚地了解常规测试运行和记录测试运行之间的区别。

之前，要记录运行，你有环境变量:`CYPRESS_CI_KEY`或你写:

```shell
cypress ci abc-key-123
```

你需要将其重写为:

```shell
cypress run --record --key abc-key-123
```

如果您正在使用环境变量`CYPRESS_CI_KEY`，将其重命名为`cypress_record_key`。

现在你可以运行并省略`--key`标志:

```shell
cypress run --record
```

我们将自动应用记录密钥环境变量。

### <Icon name="exclamation-triangle" color="red"></Icon> A Cached Cypress Binary Could not be found。找不到缓存的Cypress二进制文件

当使用`cypress run`而系统上没有安装有效的cypress二进制缓存(在linux上是`~/. cachecypress`)时，此错误发生在CI中。

要修复这个错误，请遵循关于[在CI中缓存柏树二进制文件](指南持续集成介绍缓存)的说明，然后检查您的CI缓存版本，以确保一个干净的构建.

### <Icon name="exclamation-triangle" color="red"></Icon> Incorrect usage of `--ci-build-id` flag 。错误使用了  `--ci-build-id`标志

您传递了`--ci-build-id`标志，但没有提供[--group](/guides/guides/command-line#cypress-run-group-lt-name-gt) 或
[--parallel](/guides/guides/command-line#cypress-run-parallel) 标志.

`--ci-build-id`标志用于并发运行进行分组或并行化。

查看我们的[关于并行化运行的指南](/guides/guides/parallelization)和何时使用[--ci-build-id](/guides/guides/command-line#cypress-run-ci-build-id-lt-id-gt)选项.

### <Icon name="exclamation-triangle" color="red"></Icon> The `--ci-build-id`, `--group`, or `--parallel` flags can only be used when recording。`--ci-build-id`, `--group`, 或 `--parallel`标记只能在记录时使用

传递了`--ci-build-id`,
[--group](/guides/guides/command-line#cypress-run-group-lt-name-gt), or
[--parallel](/guides/guides/command-line#cypress-run-parallel) 标志，但没有传递`--record`标志。

这些标志只能在记录到[Dashboard服务](/guides/dashboard/introduction)时使用.

请查看我们的[并行化](/guides/guides/parallelization)文档以了解更多信息。

### <Icon name="exclamation-triangle" color="red"></Icon> We could not determine a unique CI build ID。我们无法确定唯一的CI构建ID

您传递了[--group](/guides/guides/command-line#cypress-run-group-lt-name-gt) 或
[--parallel](/guides/guides/command-line#cypress-run-parallel) 标志，但我们无法自动确定或生成`ciBuildId`。

为了使用这些参数中的任何一个，必须确定一个`ciBuildId`。

如果您在主流[CI提供商](/guides/continuous-integration/introduction#Examples)中运行Cypress， `ciBuildId`将被自动检测到. 请查看[本地识别的环境变量](/guides/guides/parallelization#CI-Build-ID-environment-variables-by-provider)
查看CI provider.

您可以通过将ID手动传递给[--ci-build-id](/guides/guides/command-line#cypress-run-ci-build-id-lt-id-gt)标志来避免将来进行此检查。

请查看我们的[并行化](/guides/guides/parallelization)文档以了解更多信息。

### <Icon name="exclamation-triangle" color="red"></Icon> Group name has already been used for this run。 此运行的组名已被使用了

您传递了[--group](/guides/guides/command-line#cypress-run-group-lt-name-gt)标志，但是这个组名已经被用于这次运行。

如果您试图并行执行此运行，则还需要传递[--parallel](/guides/guides/command-line#cypress-run-parallel)标志，并传递一个不同的组名。

请查看[分组运行测试](/guides/guides/parallelization#Grouping-test-runs)文档以了解更多信息。

### <Icon name="exclamation-triangle" color="red"></Icon> Cannot parallelize tests across environments。无法跨环境并行化测试

您通过了[--parallel](/guides/guides/command-line#cypress-run-parallel)标志，但我们没有跨不同环境并行测试。

这台机器发送的环境参数与启动并行运行的第一台机器不同。

为了以并行模式运行，每台机器必须发送相同的环境参数，如:

- Specs
- 操作系统名称
- 操作系统版本
- 浏览器的名字
- 浏览器主版本

请查看我们的[并行化](/guides/guides/parallelization)文档以了解更多信息。

### <Icon name="exclamation-triangle" color="red"></Icon> Cannot parallelize tests in this group。无法并行化该组中的测试

您传递了`--parallel`标志，但这个运行组最初创建时没有`--parallel`标志。

不能使用[--parallel](/guides/guides/command-line#cypress-run-parallel) 标志。

请查看我们的[分组运行测试](/guides/guides/parallelization#Grouping-test-runs)文档以了解更多信息。

### <Icon name="exclamation-triangle" color="red"></Icon> Run must pass `--parallel` flag 。运行必须传递`--parallel`标志

您传递了`--parallel`标志，但这个运行组最初创建时没有`--parallel`标志。

必须使用[--parallel](/guides/guides/command-line#cypress-run-parallel)标志。

请查看我们的[并行化](/guides/guides/parallelization)文档以了解更多信息。

### <Icon name="exclamation-triangle" color="red"></Icon> Cannot parallelize tests on a stale run 无法在过期运行上并行化测试

当您试图将[--parallel](/guides/guides/command-line#cypress-run-parallel) 标志传递给Cypress检测到的超过24小时前已完成的运行时，会抛出此错误.

为了在`cypress run`,期间唯一地标识每一次运行，cypress尝试从您的CI提供商读取一个唯一标识符，如我们的[并行化文档](/guides/guides/parallelization#CI-Build-ID-environment-variables-by-provider)所述。(/guides/guides/parallelization#CI-Build-ID-environment-variables-by-provider).

如果Cypress在超过24小时前完成的一次运行中检测到与之前的CI Build ID完全相同的CI Build ID，则可能会遇到此错误。您无法在已完成那么长时间的运行中运行测试.
通过查看[Dashboard](https://on.cypress.io/dashboard)中运行顶部的详细信息部分，您可以看到为每次完成运行检测到的CI构建ID​ ​Y。. ​ ​您可以生成并传递您自己的惟一CI Build ID，如[此处](/guides/guides/command-line#cypress-run-ci-build-id-lt-id-gt)所述。.

请查看我们的[并行化](/guides/guides/parallelization)文档以了解更多信息。

### <Icon name="exclamation-triangle" color="red"></Icon> Run is not accepting any new groups。Run不接受任意新组

您正在尝试访问的运行已经完成，并且将不接受新组。

当运行完成它的所有组时，它会等待一组可配置的时间，然后才最终完成。您必须在该时间段内添加更多的组。

请查看我们的[并行化](/guides/guides/parallelization)文档以了解更多信息。

## 页面加载错误

### <Icon name="exclamation-triangle" color="red"></Icon> Cypress detected a cross-origin error happened on page load。Cypress检测到页面加载时发生了一个跨站错误

<Alert type="info">

对于Cypress的Web安全模型的更全面的解释，[请阅读我们的专门指南](/guides/guides/web-security).

</Alert>

此错误意味着您的应用程序导航到一个Cypress没有绑定到的超级域。最初当您[`cy.visit()`](/api/commands/visit)时，
Cypress更改浏览器的URL以匹配传递给[`cy.visit()`](/api/commands/visit)的`URL`. 
这使得Cypress能够与您的应用程序通信，从而绕过所有同源安全策略.

当您的应用程序导航到当前源策略之外的超级域时，Cypress无法与它通信，因此失败.

#### 对于这些常见情况，有一些变通方法:

1. 不要在导航到应用程序之外的测试中单击`<a>`链接。这可能不值得测试。
   你应该问问自己: _点击并切换到另一个应用程序有什么意义_?
   可能您所关心的只是`href`属性是否与您所期望的匹配。所以对此做一个断言。
   你可以看到更多测试锚点链接的策略[在我们的“标签处理和链接”示例配方中](/examples/examples/recipes#Testing-the-DOM).

2. 您正在测试一个使用单点登录(SSO)的页面。在这种情况下，你的网络服务器可能会在超级域之间重定向你，所以你收到这个错误消息。
   您可以通过使用[`cy.request()`](/api/commands/request) 手动处理会话来绕过这个重定向问题。

如果你发现自己被困,无法解决这些问题.在Chrome家族浏览器中运行(这个设置不会工作在其他浏览器）时，你可以在你的[配置文件(默认是cypress.json)](/guides/references/configuration)中设置`chromeWebSecurity`为`false` 。
在这样做之前，你应该真正理解和[阅读这里的推理](/guides/guides/web-security).

```json
{
  "chromeWebSecurity": false
}
```

### <Icon name="exclamation-triangle" color="red"></Icon> Cypress detected that an uncaught error was thrown from a cross-origin script. Cypress检测到跨站脚本抛出一个未捕获的错误

在开发人员工具控制台可以看到实际错误输出。

可以通过添加`crossorigin`属性和设置`CORS`头来启用调试这些脚本。

## 浏览器错误

<!-- keep old hash -->

<a name='The-Chromium-Renderer-process-just-crashed'></a>

### <Icon name="exclamation-triangle" color="red"></Icon> The browser process running your tests just exited unexpectedly .运行测试的浏览器进程刚刚意外退出

当Cypress检测到启动的浏览器在测试完成运行之前退出或崩溃时，就会发生此错误。

出现这种情况的原因有很多，包括:

- 通过点击“退出”按钮或其他方式手动退出浏览器
- 您的测试套件或待测应用程序正在耗尽浏览器的资源，例如运行一个无限循环
- Cypress是在内存匮乏的环境中运行的
- 浏览器正在测试一个内存密集型应用程序
- Cypress正在Docker中运行(有一个简单的修复方法:参见[此issue](https://github.com/cypress-io/cypress/issues/350))
- GPU驱动程序有问题
- 浏览器中有一个涉及内存管理的错误
- Cypress有内存泄漏

如果运行Cypress测试的浏览器崩溃，目前，Cypress将中止任何剩余的测试并打印此错误.

有一个[打开的issue](https://github.com/cypress-io/cypress/issues/349),讨论从浏览器崩溃到自动恢复，让测试可以继续运行。

## 测试运行器错误

### <Icon name="exclamation-triangle" color="red"></Icon> Whoops, we can't run your tests。 我们无法运行你的测试

这个错误发生时，Cypress检测到浏览器自动化没有连接，或Cypress的内部代理被绕过。这是由下列原因之一引起的:

**策略设置阻止Cypress代理服务器或浏览器扩展**

- 请参阅[Cypress在您的计算机上检测到可能导致问题的策略设置](#Cypress-detected-policy-settings-on-your-computer-that-may-cause-issues).

**`--proxy-server` 或 `--load-extension` 参数已经更改**

- 当使用[浏览器启动API](/api/plugins/browser-launch-api)添加插件时, 可以修改必要的命令行参数. 
  如果你遇到这个错误，你可以通过在插件运行之前和之后检查`args`来排除故障，
  或者使用`console.log()`或者通过`DEBUG=cypress:server:plugins,cypress:server:plugins:*`[打印调试日志](/guides/references/troubleshooting#Print-DEBUG-logs)

**您访问Cypress代理URL外的一个Cypress浏览器.**

- 不要复制从Test Runner启动Cypress浏览器并在非Cypress浏览器中打开它时看到的URL。
  如果您想在不同的浏览器中运行测试，请遵循[跨浏览器测试](/guides/guides/cross-browser-testing)指南中的说明。

### <Icon name="exclamation-triangle" color="red"></Icon> Cannot connect to API server. 无法连接到API服务

登录、查看运行和设置要记录的新项目都需要连接到外部API服务器。当我们无法连接到API服务器时，将显示此错误。

出现此错误可能是因为:

1. 你没有互联网。请确保已连接，然后再试一次。
2. 您是一个开发人员，已经fork了我们的代码库，并没有访问我们的本地API。请阅读我们的[贡献文档](https://on.cypress.io/contributing).

### <Icon name="exclamation-triangle" color="red"></Icon> Cypress detected policy settings on your computer that may cause issues。 Cypress在您的计算机上检测到可能导致问题的策略设置

当Cypress启动Chrome时，它试图启动它与自定义代理服务器和浏览器扩展。Windows上的某些组策略(GPOs)可能会阻止此功能正常工作，从而导致测试中断。

如果您的管理员设置了以下任何一个Chrome GPOs，它会阻止您的测试在Chrome中运行:

- 代理策略:
  `ProxySettings, ProxyMode, ProxyServerMode, ProxyServer, ProxyPacUrl, ProxyBypassList`
- 扩展策略:
  `ExtensionInstallBlacklist, ExtensionInstallWhitelist, ExtensionInstallForcelist, ExtensionInstallSources, ExtensionAllowedTypes, ExtensionAllowInsecureUpdates, ExtensionSettings, UninstallBlacklistedExtensions`

以下是一些潜在的变通方法:

1. 请您的管理员禁用这些策略，以便您可以在Chrome中使用Cypress。
2. 使用内置的Electron浏览器进行测试，因为它不受这些策略的影响。[更多信息请参见启动浏览器指南。](/guides/guides/launching-browsers#Electron-Browser)
3. 尝试使用Chromium代替谷歌Chrome进行测试，因为它可能不受GPO的影响。你可以[在这里下载最新的Chromium版本](https://download-chromium.appspot.com)
4. 如果您有本地管理员访问您的计算机，您可能能够删除注册表项，这会影响Chrome。以下是一些说明:
   1. 打开注册表编辑器：按WinKey+R和输入`regedit.exe`
   2. 查看以下位置以获得上面列出的策略设置:
      - `HKEY_LOCAL_MACHINE\Software\Policies\Google\Chrome`
      - `HKEY_LOCAL_MACHINE\Software\Policies\Google\Chromium`
      - `HKEY_CURRENT_USER\Software\Policies\Google\Chrome`
      - `HKEY_CURRENT_USER\Software\Policies\Google\Chromium`
   3. 删除或重命名找到的任何策略键. _在进行任何更改之前，请确保备份您的注册表._

### <Icon name="exclamation-triangle" color="red"></Icon> Uncaught exceptions from your application。应用程序未捕获的异常

当Cypress在您的应用程序中检测到一个未捕获的异常时，它将使当前运行的测试失败。

你可以通过`uncaught:exception`事件全局或有条件地关闭此行为。请参阅[事件目录](/api/events/catalog-of-events#Uncaught-Exceptions) 的示例。

从技术上讲，Cypress认为未捕获异常是应用程序未捕获的任何错误，无论它们是`标准`错误还是未处理的promise拒绝。
如果错误触发了窗口的全局`error`处理器或其`unhandledrejection`处理器，Cypress将检测到它并失败测试.
