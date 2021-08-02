---
title: 代码覆盖率
---

<Alert type="info">

## <Icon name="graduation-cap"></Icon> 你将学习

- 如何插装应用程序代码----可被检测
- 如何保存端到端测试和单元测试期间收集的覆盖率信息
- 如何使用代码覆盖报告来指导编写测试

</Alert>

<!-- textlint-disable -->

<DocsVideo src="https://youtube.com/embed/C8g5X4vCZJA"></DocsVideo>

<!-- textlint-enable -->

## 介绍

当您编写越来越多的端到端测试时，您会发现自己在想——我是否需要编写更多的测试? 应用程序中还有未测试的部分吗? 应用程序的某些部分是否测试过多?这些问题的一个答案是找出在端到端测试期间执行了应用程序源代码的哪些行. 如果有应用程序逻辑的重要部分没有从测试中执行，那么应该添加一个新的测试，以确保测试了应用程序逻辑的一部分。

通过**代码覆盖率**来计算在测试期间执行的源代码行. 代码覆盖要求在运行源代码之前插入额外的计数器.这个步骤称为**插装**.插装采用如下代码...

```javascript
// add.js
function add(a, b) {
  return a + b
}
module.exports = { add }
```

...并对其进行解析以找到所有函数、语句和分支，然后将计数器插入代码中. 对于上面的代码，它可能是这样的:

```javascript
// 该对象计算每个函数和每个语句执行的次数
const c = (window.__coverage__ = {
  // "f"表示每个函数被调用的次数，我们在源代码中只有一个函数，因此它从[0]开始
  f: [0],
  // "s"表示每条语句被调用的次数
  // 我们有三条语句，它们都是从0开始的
  s: [0, 0, 0],
})

// 原代码+ 增量语句使用“c”别名"window.__coverage__"。对象的第一个语句定义了函数,
// 让我们增加它
c.s[0]++
function add(a, b) {
  // 函数被调用，然后执行第二条语句
  c.f[0]++
  c.s[1]++

  return a + b
}
// 第三个语句即将被调用
c.s[2]++
module.exports = { add }
```

想象一下，我们从测试spec文件中加载了上面测试过的源文件. 一些计数器将立即增加!

```javascript
// add.spec.js
const { add } = require('./add')
// JavaScript引擎已经分析和评估了“add.js”源代码，运行了一些增量语句
// __coverage__ 现在已经
// f: [0] - 函数add没有执行
// s: [1, 0, 1] - 第一和第三个计数器增加1
// 但是函数“add”中的语句还没有执行
```

我们希望确保文件`add.js`中的每个语句和函数至少被我们的测试执行过一次. 因此，我们编写了一个测试:

```javascript
// add.spec.js
const { add } = require('./add')

it('adds numbers', () => {
  expect(add(2, 3)).to.equal(5)
})
```

当测试调用`add(2, 3)`时, 执行“add”函数中的计数器增量，覆盖对象变成:

```javascript
{
  // "f"记录每个函数被调用的次数
  // 我们在源代码中只有一个函数
  // 因此它从[0]开始
  f: [1],
  // "s"记录每条语句被调用的次数
  // 我们有三个表述，它们都是从0开始的
  s: [1, 1, 1]
}
```

这个测试已经实现了100%的代码覆盖率——每个函数和每个语句都至少执行了一次. 但是，在实际应用程序中，实现100%的代码覆盖率需要多次测试.

一旦测试完成，覆盖对象就可以被序列化并保存到磁盘，这样就可以生成一个人性化的报告。 收集的覆盖信息也可以发送给外部服务，并在PR代码评审期间提供帮助.

<Alert type="info">

如果你对代码覆盖不熟悉，或者想了解更多，请查看“理解JavaScript代码覆盖”博客文章[第1部分](https://www.semantics3.com/blog/understanding-code-coverage-1074e8fccce0/) 和 [第2部分](https://www.semantics3.com/blog/understanding-javascript-code-coverage-part-2-9aedaa5119e5/).

</Alert>

本指南解释如何使用常用工具插装应用程序源代码.然后，我们将展示如何使用[`@cypresscode-coverage`](https://github.com/cypress-io/code-coverage) Cypress 插件保存覆盖率信息并生成报告。在阅读了本指南之后，您应该能够使用代码覆盖信息更好地精准您的测试。

本指南解释了如何找到Cypress测试覆盖了应用程序代码的哪些部分，以便您可以100%确信测试没有遗漏应用程序的关键部分. 收集的信息可以发送到外部服务，在pull请求审查期间自动运行，并集成到CI中。

<Alert type="info">

本指南的完整源代码可以在[cypress-iocypress-example-todomvc-redux](https://github.com/cypress-io/cypress-example-todomvc-redux) 代码库中找到。

</Alert>

## 插装代码

Cypress不插装你的代码——你需要自己做. JavaScript代码插装的黄金标准是久经沙场的[Istanbul](https://istanbul.js.org)，幸运的是，它与Cypress Test Runner配合得非常好. 您可以通过以下两种方法中的一种将代码作为构建步骤来插装:

- 使用[nyc](https://github.com/istanbuljs/nyc) 模块 - [Istanbul](https://istanbul.js.org)库的命令行界面
- 使用[`babel-plugin-istanbul`](https://github.com/istanbuljs/babel-plugin-istanbul) 工具作为代码转译管道的一部分。

### 使用 NYC

要插装位于`src`文件夹中的应用程序代码，并将其保存在`instrumented`文件夹中，使用以下命令:

```shell
npx nyc instrument --compact=false src instrumented
```

我们传递了`--compact=false`标志以生成人类友好的输出。

该插装工具采用如下代码片段的原始代码。..

```js
const store = createStore(reducer)

render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('root')
)
```

...并用额外的计数器包装每个语句，这些计数器跟踪JavaScript运行时执行每个源行的次数.

```javascript
const store = (cov_18hmhptych.s[0]++, createStore(reducer))
cov_18hmhptych.s[1]++
render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('root')
)
```

注意对`cov_18hmhptych.s[0]++` 和 `cov_18hmhptych.s[1]++`的调用使语句计数器增加. 所有计数器和其他簿记信息都存储在一个附加到浏览器的`window`对象的对象中。 如果我们使用`instrumented`文件夹而不是`src`，然后打开应用程序，就可以看到计数器.

<DocsImage src="/img/guides/code-coverage/coverage-object.png" alt="Code coverage object" ></DocsImage>

如果我们深入到覆盖率对象中，我们可以看到每个文件中执行的语句. 例如，文件`src/index.js`包含以下信息:

<DocsImage src="/img/guides/code-coverage/coverage-statements.png" alt="Covered statements counters in a from the index file" ></DocsImage>

我们用绿色突出显示了该文件中的4条语句. 前三条语句各执行一次，最后一条语句从未执行 (它可能在`if`语句中). 通过使用该应用程序，我们既可以增加计数器，也可以将一些零计数器转换为正数.

### 使用代码转译管道

代替使用`npx instrument`命令，我们可以使用[`babel-plugin-istanbul`](https://github.com/istanbuljs/babel-plugin-istanbul)来插装代码，作为其转译的一部分。将这个插件添加到`.babelrc`文件。

```json
{
  "presets": ["@babel/preset-react"],
  "plugins": ["transform-class-properties", "istanbul"]
}
```

我们现在可以在没有中间文件夹的情况下为应用程序提供服务，并获得插装代码，但结果是浏览器加载相同的插装代码，使用相同的`window.__coverage__` 跟踪原始语句的对象。

<Alert type="info">

查看[`@cypress/code-coverage#examples`](https://github.com/cypress-io/code-coverage#examples) ，了解显示不同代码覆盖设置的完整示例项目。

</Alert>

<DocsImage src="/img/guides/code-coverage/source-map.png" alt="Bundled code and source mapped originals" ></DocsImage>

[nyc](https://github.com/istanbuljs/nyc) 和 [`babel-plugin-istanbul`](https://github.com/istanbuljs/babel-plugin-istanbul) 有一个共同棒的功能是自动生成 source maps, 允许我们收集代码覆盖率信息，但也可以在开发人员工具中与原始的、非插装的代码交互. 在上面的截图中，bundle(绿色箭头)有覆盖计数器, 同时在绿框内的 source mapped files 显示原始代码.

<Alert type="info">

`nyc` and `babel-plugin-istanbul`只插装应用程序代码，而不会对`node_modules`内的第三方依赖库插装。

</Alert>

## E2E代码覆盖率

为了处理在每次测试期间收集的代码覆盖率，我们创建了一个[`@cypress/code-coverage`](https://github.com/cypress-io/code-coverage) Cypress插件. 它合并每个测试的覆盖率并保存合并的结果. 它还调用`nyc`(它的对等依赖)来生成供人类使用的静态HTML报告。

### 安装插件

<Alert type="info">

请参考[`@cypress/code-coverage`](https://github.com/cypress-io/code-coverage) 文档获取最新的安装说明.

</Alert>

```shell
npm install -D @cypress/code-coverage
```

然后将下面的代码添加到[supportFile](/guides/references/configuration#Folders-Files) 以及 [pluginsFile](/guides/references/configuration#Folders-Files) 中.

```js
// cypress/support/index.js
import '@cypress/code-coverage/support'
```

```js
// cypress/plugins/index.js
module.exports = (on, config) => {
  require('@cypress/code-coverage/task')(on, config)
  // include any other plugin code...

  // It's IMPORTANT to return the config object
  // with any changed environment variables
  return config
}
```

当您现在运行Cypress测试时，您应该会在测试完成后看到一些命令。我们用下面的绿色矩形突出显示了这些命令。

<DocsImage src="/img/guides/code-coverage/coverage-plugin-commands.png" alt="coverage plugin commands" ></DocsImage>

测试完成后，最终的代码覆盖被保存到`.nyc_output` 文件夹中。 它是一个JSON文件，我们可以从中生成各种格式的报告. [`@cypress/code-coverage`](https://github.com/cypress-io/code-coverage) 插件自动生成HTML报告 - 测试完成后，您可以在本地打开`coverage/index.html`页面. 您还可以调用 `nyc report`来生成其他报告, 比如，将覆盖信息发送给第三方服务.

### 参见代码覆盖摘要

要查看测试运行后的代码覆盖率摘要，请运行下面的命令。

```shell
npx nyc report --reporter=text-summary

========= Coverage summary =======
Statements   : 76.3% ( 103/135 )
Branches     : 65.31% ( 32/49 )
Functions    : 64% ( 32/50 )
Lines        : 81.42% ( 92/113 )
==================================
```

<Alert type="info">

**提示:** 将`coverage`文件夹作为构建工件存储在持续集成服务器上. 因为报告是一个静态的HTML页面，一些CI可以直接在他们的web应用程序中显示它. 下面的截图显示了存储在circlici上的覆盖率报告. 点击`index.html`就会在浏览器中显示报告.

</Alert>

<DocsImage src="/img/guides/code-coverage/circleci-coverage-report.png" alt="coverage HTML report on CircleCI" ></DocsImage>

## 以代码覆盖率为指导

即使是一个单一的端到端测试也可以涵盖大量的应用程序代码. 例如，让我们运行下面的测试，添加一些项目，然后将其中一个标记为已完成。

```javascript
it('添加和完成待办事项', () => {
  cy.visit('/')
  cy.get('.new-todo')
    .type('write code{enter}')
    .type('write tests{enter}')
    .type('deploy{enter}')

  cy.get('.todo').should('have.length', 3)

  cy.get('.todo').first().find('.toggle').check()

  cy.get('.todo').first().should('have.class', 'completed')
})
```

在运行测试并打开HTML报告之后，我们看到应用程序的代码覆盖率达到了76%。

<DocsImage src="/img/guides/code-coverage/single-test.png" alt="Coverage report after a single test" ></DocsImage>

更好的是，我们可以深入到各个源文件中，查看我们遗漏了哪些代码。 在我们的示例应用程序中，主要的状态逻辑在`src/reducers/todos.js` 文件中。 让我们看看这个文件中的代码覆盖率:

<DocsImage src="/img/guides/code-coverage/todos-coverage.png" alt="Main application logic coverage" ></DocsImage>

注意**ADD_TODO**动作是如何执行3次的- 因为我们的测试添加了3个todo项，并且COMPLETE_TODO操作只执行了一次 - 因为我们的测试把1 todo项目标记为已完成.

用黄色(测试错过的切换用例)和红色(常规语句)标记的未覆盖的源代码行是编写更多端到端测试的很好的指南. 我们需要删除待办事项的测试, 编辑它们，将它们全部标记为已完成，并清除已完成的项目. 当我们覆盖`src/reducers/todos.js`中的每个switch语句时，我们可能会达到接近100%的代码覆盖率. 更重要的是，我们将介绍用户期望使用的应用程序的主要特性.

我们可以编写更多的端到端测试。

<DocsImage src="/img/guides/code-coverage/more-tests.png" alt="Cypress Test Runner passed more tests" ></DocsImage>

生成的HTML报告显示代码覆盖率为99%

<DocsImage src="/img/guides/code-coverage/almost-100.png" alt="99 percent code coverage" ></DocsImage>

除1外的所有源文件都被100%覆盖。我们可以对我们的应用程序有很大的信心，并且在知道我们有一组健壮的端到端测试的情况下安全地重构代码。

如果可能的话，我们建议在Cypress功能测试之外实施[视觉测试][visual testing](/guides/tooling/visual-testing) ，以避免CSS和视觉回归.

## 合并来自并行测试的代码覆盖

如果[并行](/guides/guides/parallelization)执行Cypress测试, 每台机器最后都有一个代码覆盖报告，该报告只显示执行的代码的一部分. 通常，外部代码覆盖服务会为您合并这些部分报告。如果你想自己合并报表:

- 在每台运行Cypress测试的机器上，将生成的代码覆盖报告以唯一名称复制到一个通用文件夹中，以避免覆盖它
- 在所有端到端测试完成后，使用`nyc merge`命令合并报表

你可以在我们的[cypress-iocypress-example-conduit-app](https://github.com/cypress-io/cypress-example-conduit-app) 中找到合并部分报告的示例。

## 端到端加密和单元代码覆盖

让我们看看一个有“遗漏”行的文件。它是`src/selectors/index.js`文件，如下所示。

<DocsImage src="/img/guides/code-coverage/selectors.png" alt="Selectors file with a line not covered by end-to-end tests" ></DocsImage>

未被端到端测试覆盖的源代码行显示了从UI不可达的边缘情况. 然而，这种开关案例绝对值得检验 - 至少可以避免在将来的重构过程中意外地改变其行为。

我们可以直接从Cypress spec文件中导入`getVisibleTodos`函数来测试这段代码. 从本质上说，我们使用Cypress Test Runner作为单元测试工具(在[这里](https://github.com/cypress-io/cypress-example-recipes#unit-testing) 找到更多的单元测试配方).

下面是我们用来确认抛出错误的测试。

```javascript
// cypress/integration/selectors-spec.js
import { getVisibleTodos } from '../../src/selectors'

describe('getVisibleTodos', () => {
  it('为未知的可见性过滤器抛出一个错误', () => {
    expect(() => {
      getVisibleTodos({
        todos: [],
        visibilityFilter: 'unknown-filter',
      })
    }).to.throw()
  })
})
```

即使没有访问web应用程序，测试也会通过.

<DocsImage src="/img/guides/code-coverage/unit-test.png" alt="Unit test for selector" ></DocsImage>

之前我们插装了应用程序代码(使用构建步骤或在Babel管道中插入插件).在上面的例子中，我们没有加载应用程序，相反，我们只是运行测试文件本身.

如果我们想从单元测试中收集代码覆盖率，我们需要插装spec文件的源代码. 最简单的方法就是用一样的 `.babelrc`与[`babel-plugin-istanbul`](https://github.com/istanbuljs/babel-plugin-istanbul) ，并告诉Cypress内置bundle使用`.babelrc` 绑定 spec . 你可以使用[`@cypress/code-coverage`](https://github.com/cypress-io/code-coverage)  插件通过将下面的代码添加到你的[pluginsFile](/guides/references/configuration#Folders-Files)来再次做到这一点。

```javascript
// cypress/plugins/index.js
module.exports = (on, config) => {
  require('@cypress/code-coverage/task')(on, config)
  // 告诉Cypress使用.babelrc文件
  // 并插装 spec 文件
  // 只有额外的应用程序文件将被 插装
  // 而不是spec 文件本身
  on('file:preprocessor', require('@cypress/code-coverage/use-babelrc'))

  return config
}
```

作为参考，`.babelrc`文件在示例应用程序和spec 文件之间共享，因此Cypress测试的编译方式与应用程序代码的编译方式相同。

```json
{
  "presets": ["@babel/preset-react"],
  "plugins": ["transform-class-properties", "istanbul"]
}
```

当我们运行Cypress [`babel-plugin-istanbul`](https://github.com/istanbuljs/babel-plugin-istanbul) ，并在**spec iframe**中检查 `window.__coverage__` 对象，我们应该看到应用程序源文件的覆盖率信息。

<DocsImage src="/img/guides/code-coverage/code-coverage-in-unit-test.png" alt="Code coverage in the unit test" ></DocsImage>

单元测试和端到端测试中的代码覆盖信息具有相同的格式; [`@cypress/code-coverage`](https://github.com/cypress-io/code-coverage)插件自动抓取两者并保存合并的报告. 因此，我们可以在运行测试后从`cypress/integration/selectors-spec.js` 文件中看到代码覆盖率.

<DocsImage src="/img/guides/code-coverage/unit-test-coverage.png" alt="Selectors code coverage" ></DocsImage>

我们的单元测试达到了端到端测试无法达到的水平，如果我们执行所有的spec文件——我们将获得100%的代码覆盖率。

<DocsImage src="/img/guides/code-coverage/100percent.png" alt="Full code coverage" ></DocsImage>

## 全堆栈代码覆盖

一个复杂的应用程序可能有一个具有自己复杂逻辑的Node后端. 在前端web应用程序中，对API的调用要经过几层代码. 跟踪在Cypress端到端测试期间执行的后端代码是很好的.

我们的端到端测试在覆盖web应用程序代码的同时也覆盖了后端服务器代码吗?

**长话短说: 是.** 你可以从后端收集代码覆盖率，并让`@cypress/code-coverage`插件将其与前端覆盖率合并，创建一个完整的堆栈报告。

<Alert type="info">

这个部分的完整源代码可以在[cypress-io/cypress-example-conduit-app](https://github.com/cypress-io/cypress-example-conduit-app) 存储库中找到。

</Alert>

您可以运行您的Node服务器并使用nyc实时检测它。 除了使用"常规的"服务器启动命令，你还可以使用`package.json`中定义的命令`npm run start:coverage`:

```json
{
  "scripts": {
    "start": "node server",
    "start:coverage": "nyc --silent node server"
  }
}
```

在你的服务器，从`@cypress/code-coverage`插入另一个中间件。 如果您使用Express服务，请包含`middleware/express`:

```javascript
const express = require('express')
const app = express()

require('@cypress/code-coverage/middleware/express')(app)
```

如果你的服务使用hapi，包括' middlewarehapi '

```javascript
if (global.__coverage__) {
  require('@cypress/code-coverage/middleware/hapi')(server)
}
```

**提示:** 只有当存在全局代码覆盖对象时，才可以有条件地注册端点，并且可以[从覆盖号中排除中间件代码](https://github.com/gotwarlost/istanbul/blob/master/ignoring-code-for-coverage.md):

```javascript
/* istanbul ignore next */
if (global.__coverage__) {
  require('@cypress/code-coverage/middleware/hapi')(server)
}
```

对于任何其他服务器类型，定义一个 `GET /__coverage__`端点并返回`global.__coverage__`对象。

```javascript
if (global.__coverage__) {
  // handle "GET __coverage__" requests
  onRequest = (response) => {
    response.sendJSON({ coverage: global.__coverage__ })
  }
}
```

为了让`@cypress/code-coverage`插件知道它应该请求后端覆盖数据，请将新端点添加到`cypress.json`的环境设置 `env.codeCoverage.url`。例如，如果应用程序的后端运行在端口3000，并且我们使用默认的"GET /**coverage**"端点，设置如下:

```json
{
  "env": {
    "codeCoverage": {
      "url": "http://localhost:3000/__coverage__"
    }
  }
}
```

从现在开始，在端到端测试期间收集的前端代码覆盖率将与测试后端的代码覆盖率合并，并保存在单个报告中。以下是来自[cypress-iocypress-example-conduit-app](https://github.com/cypress-io/cypress-example-conduit-app) 的示例报告:

<DocsImage src="/img/guides/code-coverage/full-coverage.png" alt="Combined code coverage report from front and back end code" ></DocsImage>

您可以在[coveralls.iogithubcypress-iocypress-example-conduit-app](https://coveralls.io/github/cypress-io/cypress-example-conduit-app) dashboard中探索上述组合的全堆栈覆盖报告。 你也可以在我们的[RealWorld App](https://github.com/cypress-io/cypress-realworld-app) 中找到全栈代码覆盖。.

即使您只想测量后端代码覆盖率，Cypress也可以提供帮助。阅读博客文章[Cypress API测试的后端代码覆盖](https://glebbahmutov.com/blog/backend-coverage/) 获得完整的教程.

## 未来的工作

我们目前正在探索两个在端到端测试期间用于代码覆盖的额外特性。 首先，我们希望避免使用`istanbull.js`库的“手动”检测步骤，而是捕获可以由Chrome浏览器的V8引擎收集的本地代码覆盖率. 你可以在[bahmutovcypress-native-chrome-code-coverage-example](https://github.com/bahmutov/cypress-native-chrome-code-coverage-example) 代码库中找到一个概念证明示例。

其次，我们希望从本地运行的后端服务器获取代码覆盖率，该后端服务器服务于前端web应用程序，并处理来自测试中的web应用程序的API请求。 我们相信，Cypress能够执行的带有附加[API测试](https://www.cypress.io/blog/2017/11/07/add-gui-to-your-e2e-api-tests/) 的端到端测试能够有效地覆盖大量后端代码。

## 视频

我们录制了一系列视频，展示了Cypress的代码覆盖率

#### 如何插装react 脚本web应用程序，以获得代码覆盖率

<!-- textlint-disable terminology -->

<DocsVideo src="https://youtube.com/embed/edgeQZ8UpD0"></DocsVideo>

#### 从Cypress测试获得代码覆盖率报告

<DocsVideo src="https://youtube.com/embed/y8StkffYra0"></DocsVideo>

#### 从代码覆盖报告中排除代码

<DocsVideo src="https://youtube.com/embed/DlceMpRpbAw"></DocsVideo>

#### 使用第三方工具检查代码覆盖率

<DocsVideo src="https://youtube.com/embed/dwU5gUG2"></DocsVideo>

#### 向项目中添加代码覆盖标记

<DocsVideo src="https://youtube.com/embed/bNVRxb-MKGo"></DocsVideo>

#### 在提交状态检查中显示代码覆盖率

<DocsVideo src="https://youtube.com/embed/AAl4HmJ3YuM"></DocsVideo>

#### 检查PR的代码覆盖范围

<DocsVideo src="https://youtube.com/embed/9Eq_gIshK0o"></DocsVideo>

<!-- textlint-enable -->

## 例子

您可以在以下存储库中找到显示不同代码覆盖设置的完整示例:

- [cypress-io/cypress-realworld-app](https://github.com/cypress-io/cypress-realworld-app) 即 RWA是一个全栈示例应用程序，演示了在实际和现实的场景中使用Cypress的最佳实践和可伸缩策略. RWA通过[跨多个浏览器](/guides/guides/cross-browser-testing)以及[多设备尺寸](/api/commands/viewport)的端到端测试实现了完整的代码覆盖。
- [cypress-io/cypress-example-todomvc-redux](https://github.com/cypress-io/cypress-example-todomvc-redux) 本指南中使用了示例代码.
- [cypress-io/cypress-example-conduit-app](https://github.com/cypress-io/cypress-example-conduit-app) 演示如何从后台和前端代码收集覆盖率信息并将其合并到单个报告中.
- [bahmutov/code-coverage-webpack-dev-server](https://github.com/bahmutov/code-coverage-webpack-dev-server) 演示如何从使用webpack-dev-server的应用程序中收集代码覆盖率。
- [bahmutov/code-coverage-vue-example](https://github.com/bahmutov/code-coverage-vue-example) 为Vue.js单文件组件收集代码覆盖率.
- [lluia/cypress-typescript-coverage-example](https://github.com/lluia/cypress-typescript-coverage-example) 显示了使用TypeScript的React应用的覆盖率。
- [bahmutov/cypress-and-jest](https://github.com/bahmutov/cypress-and-jest) 演示如何运行Jest单元测试和Cypress单元测试，从两个测试运行程序收集代码覆盖率，然后生成合并报告。
- [rootstrap/react-redux-base](https://github.com/rootstrap/react-redux-base) 展示了一个真实的webpack配置的例子。在测试期间使用`babel-plugin-istanbul`插装源代码。
- [skylock/cypress-angular-coverage-example](https://github.com/skylock/cypress-angular-coverage-example) 展示了一个Angular 8 + TypeScript应用，它使用`ngx-build-plus`完成插装。
- [bahmutov/testing-react](https://github.com/bahmutov/testing-react) 演示了如何在不弹出`react-scripts`的情况下获得使用`CRA v3`创建的React应用程序的代码覆盖率。
- [bahmutov/next-and-cypress-example](https://github.com/bahmutov/next-and-cypress-example) 演示了如何获取Next.js项目的后端和前端覆盖。`middleware/nextjs.js`。

找到[cypress-iocode-coverageexternal-examples](https://github.com/cypress-io/code-coverage#external-examples) 中链接的完整示例列表

## 另请参阅

- 官方 [@cypress/code-coverage](https://github.com/cypress-io/code-coverage) 插件
- [结合端到端和单元测试覆盖率](https://glebbahmutov.com/blog/combined-end-to-end-and-unit-test-coverage/)
- [打包绑定的代码覆盖](https://glebbahmutov.com/blog/code-coverage-by-parcel/)
- [端到端测试的代码覆盖率](https://glebbahmutov.com/blog/code-coverage-for-e2e-tests/)
