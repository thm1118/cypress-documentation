---
title: 配置
---

## cypress.json

当您第一次打开Cypress Test Runner时，它创建了`cypress.json`配置文件。这个JSON文件用于存储您提供的任何配置值. 如果您[配置您的测试记录](/guides/dashboard/projects#Setup)结果输出到[Cypress Dashboard](https://on.cypress.io/dashboard-introduction) ， `projectId`也将写入该文件。

<Alert type="warning">

<strong class="alert-header">改变配置文件</strong>

您可以使用[`--config-file` flag](/guides/guides/command-line#cypress-open-config-file-lt-config-file-gt)更改配置文件或关闭配置文件的使用.

</Alert>

## 选项

可以通过提供下列任何配置选项来修改Cypress的默认行为。下面是可用选项及其默认值的列表。

### 全局选项

| 选项                   | 默认值                             | 描述                                                                                                                                                                                  |
| ---------------------- | --------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `baseUrl`              | `null`                            | 作为[`cy.visit()`](/api/commands/visit) 后面 [`cy.request()`](/api/commands/request)命令的URL前缀                                                                         |
| `clientCertificates`   | `[]`                              | 可选的[客户端证书](/guides/references/client-certificates)数组                                                                                                           |
| `env`                  | `{}`                              | 设置为[环境变量](/guides/guides/environment-variables)的值                                                                                                    |
| `includeShadowDom`     | `false`                           | 是否遍历阴影DOM边界并在查询命令(比如：[`cy.get()`](/api/commands/get))的结果中包含阴影DOM中的元素                                 |
| `numTestsKeptInMemory` | `50`                              | 将快照和命令数据保存在内存中的测试的次数。如果在测试运行期间浏览器的内存消耗很高，请减少这个数字。|
| `port`                 | `null`                            | 用于承载Cypress的端口。通常这是一个随机生成的端口                                                                                                                        |
| `redirectionLimit`     | `20`                              | 被测试应用程序在发生错误之前可以重定向的次数.                                                                                                            |
| `reporter`             | `spec`                            | `cypress run `期间使用的[报表](/guides/tooling/reporters)                                                                                                                       |
| `reporterOptions`      | `null`                            | 使用的[报表选项](guidestoolingreportersReporter-Options)。支持的选项取决于具体报表.                                                                           |
| `retries`              | `{ "runMode": 0, "openMode": 0 }` | 重试失败的测试的次数。可以单独配置到`cypress run`或`cypress open`. 更多信息请参见[测试重试](/guides/guides/test-retries) . |
| `watchForFileChanges`  | `true`                            | Cypress是否会监视测试文件更改并重新启动测试                                                                                                                            |

### 超时

<Alert type="success">

<strong class="alert-header">核心概念</strong>

你应该充分理解[超时是一个核心概念](/guides/core-concepts/introduction-to-cypress#Timeouts)。这里列出的默认值有特定意义。

</Alert>

| 选项                    | 默认值   | 默认                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ----------------------- | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `defaultCommandTimeout` | `4000`  | 等待大多数基于DOM的命令超时的时间(以毫秒为单位)                                                                                                                                                                                                                                                                                                                                                                                             |
| `execTimeout`           | `60000` | 在[`cy.exec()`](/api/commands/exec) 命令执行期间等待系统命令执行完毕的时间，以毫秒为单位                                                                                                                                                                                                                                                                                                                                                        |
| `taskTimeout`           | `60000` | 在 [`cy.task()`](/api/commands/task)命令中等待任务完成的时间，以毫秒为单位                                                                                                                                                                                                                                                                                                                                                               |
| `pageLoadTimeout`       | `60000` | 等待`age transition events`或 [`cy.visit()`](/api/commands/visit), [`cy.go()`](/api/commands/go), [`cy.reload()`](/api/commands/reload) 命令触发其页面`load`事件的时间，以毫秒为单位. 网络请求受底层操作系统的限制，如果这个值增加，仍然可能超时.                                                                                                                                           |
| `requestTimeout`        | `5000`  | 在[`cy.wait()`](/api/commands/wait)命令中等待请求发出的时间，以毫秒为单位                                                                                                                                                                                                                                                                                                                                                                            |
| `responseTimeout`       | `30000` | 时间,以毫秒为单位,等到一个响应[`cy.request()`](/api/commands/request), [`cy.wait()`](/api/commands/wait), [`cy.fixture()`](/api/commands/fixture), [`cy.getCookie()`](/api/commands/getcookie), [`cy.getCookies()`](/api/commands/getcookies), [`cy.setCookie()`](/api/commands/setcookie), [`cy.clearCookie()`](/api/commands/clearcookie), [`cy.clearCookies()`](/api/commands/clearcookies), 以及 [`cy.screenshot()`](/api/commands/screenshot) 的命令|

###  文件夹 /  文件

|  选项               | 默认值                      | 描述                                                                                                                                                                                                                                                                                |
| ------------------- | -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `downloadsFolder`   | `cypress/downloads`        | 保存测试期间下载的文件的文件夹路径                                                                                                                                                                                                                             |
| `fileServerFolder`  | root project folder        | 应用程序文件将试图从其中提供服务的文件夹路径                                                                                                                                                                                                                      |
| `fixturesFolder`    | `cypress/fixtures`         | 包含fixture文件的文件夹路径(通过' false '禁用)                                                                                                                                                                                                                      |
| `ignoreTestFiles`   | `*.hot-update.js`          | glob模式表达的字符串或数组，用于忽略的测试文件，否则将显示在测试列表中. Cypress使用`minimatch`时的选项:`{dot: true, matchBase: true}`. 我们建议使用[https://globster.xyz](https://globster.xyz)来测试哪些文件会匹配. |
| `integrationFolder` | `cypress/integration`      | 包含集成测试文件的文件夹路径                                                                                                                                                                                                                                           |
| `pluginsFile`       | `cypress/plugins/index.js` | 插件文件的路径。(`false`是禁用)                                                                                                                                                                                                                                           |
| `screenshotsFolder` | `cypress/screenshots`      | [`cy.screenshot()`](/api/commands/screenshot)命令或在`cypress run`期间测试失败时，屏幕截图将被保存的文件夹路径                                                                                                                                     |
| `supportFile`       | `cypress/support/index.js` | 加载测试文件之前要加载的文件的路径。这个文件被编译和捆绑。(`false`是禁用)                                                                                                                                                                                  |
| `testFiles`         | `**/*.*`                   | 要加载的测试文件，用glob模式表达的字符串或数组                                                                                                                                                                                                                             |
| `videosFolder`      | `cypress/videos`           | `cypress run`期间视频将被保存的文件夹路径                                                                                                                                                                                                                            |

### 截屏

| 选项                     | 默认值                 | 描述                                                                                                                                          |
| ------------------------ | --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| `screenshotOnRunFailure` | `true`                | Cypress是否会在`Cypress运行`期间, 在测试失败时自动截图。                                                                       |
| `screenshotsFolder`      | `cypress/screenshots` | [`cy.screenshot()`](/api/commands/screenshot)命令或在`cypress run`期间测试失败后，屏幕截图将被保存的文件夹路径 |
| `trashAssetsBeforeRuns`  | `true`                | 在使用`Cypress run`运行测试之前，Cypress是否会清理`downloadsFolder`, `screenshotsFolder`, 以及 `videosFolder`中的资产.         |

更多关于屏幕截图的选项，查看[Cypress截图API](/api/cypress-api/screenshot-api).

### 录屏

| 选项                    | 默认值            | 描述                                                                                                                                                                                                                                                                                                              |
| ----------------------- | ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `trashAssetsBeforeRuns` | `true`           | 在使用`Cypress run`运行测试之前，Cypress是否会清理`downloadsFolder`, `screenshotsFolder`, 以及 `videosFolder`中的资产                                                                                                                                                                             |
| `videoCompression`      | `32`             | 视频压缩的质量设置，是常数率因子(CRF). 该值可以是`false`以禁用压缩，也可以是' 0 '和' 51 '之间的值，值越低质量越好(以文件大小为代价)。.                                                                     |
| `videosFolder`          | `cypress/videos` | Cypress通过`Cypress run`运行测试时，自动保存测试运行的视频的目录.                                                                                                                                                                                                                       |
| `video`                 | `true`           | Cypress是否会捕捉`Cypress run`运行测试的视频.                                                                                                                                                                                                                                                |
| `videoUploadOnPasses`   | `true`           | spec文件中的所有测试通过时，Cypress是否会处理、压缩和上传视频到[Dashboard](/guides/dashboard/introduction). 这仅适用于将您的运行记录到Dashboard时的情况. 如果您只想在测试失败时上传spec文件的视频，请关闭此选项. |

###  下载

| 选项                     | 默认值              | 描述                                                                                                                                  |
| ----------------------- | ------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| `downloadsFolder`       | `cypress/downloads` | 保存测试期间下载的文件的文件夹路径                                                                                |
| `trashAssetsBeforeRuns` | `true`              | 在使用`Cypress run`运行测试之前，Cypress是否会清理`downloadsFolder`, `screenshotsFolder`, 以及 `videosFolder`中的资产.   . |

### 浏览器

| 选项                    | 默认值                                | 描述                                                                                                                                                                                                                                                                                                                                                        |
| ----------------------- | ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `chromeWebSecurity`     | `true`                               | 是否启用基于chrome的浏览器的Web安全同源策略和不安全的混合内容。[了解更多关于网络安全的信息](/guides/guides/web-security).                                                                                                                                                                                            |
| `blockHosts`            | `null`                               | 希望阻塞流量的主机的字符串或数组。[请阅读使用这个的例子注释](#blockHosts)                                                                                                                                                                                                                                    |
| `firefoxGcInterval`     | `{ "runMode": 1, "openMode": null }` | (仅适用于Firefox 79及以下版本)控制Cypress是否强制Firefox运行垃圾收集(GC)清理以及频率. 在 [cypress run](/guides/guides/command-line#cypress-run)期间,默认值是 `1`. 在 [cypress open](/guides/guides/command-line#cypress-open)期间, 默认值是 `null`.在[这里](#firefoxGcInterval)参阅完整细节. |
| `modifyObstructiveCode` | `true`                               | Cypress是否会搜索和替换`.js`或`.html`文件中的阻塞JS代码. [请阅读注释了解更多关于这个设置的信息.](#modifyObstructiveCode)                                                                                                                                                                                   |
| `userAgent`             | `null`                               | 允许您覆盖浏览器发送的所有请求头中的默认用户代理. 服务器通常使用用户代理值来帮助识别操作系统、浏览器, 以及浏览器版本. 参见[User-Agent MDN Documentation](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/User-Agent) 中用户代理值的例子.              |

### 视口

| 选项             | 默认值   | 描述                                                                                                                          |
| ---------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `viewportHeight` | `660`   | 测试视口中应用程序的默认高度(以像素为单位)(使用[`cy.viewport()`](/api/commands/viewport)命令覆盖) |
| `viewportWidth`  | `1000`  | 测试视图下应用程序的默认宽度(以像素为单位). (使用[`cy.viewport()`](/api/commands/viewport)命令覆盖) |

### 可操作性

| 选项                         | 默认值   | 描述                                                                                                                                                                      |
| ---------------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `animationDistanceThreshold` | `5`     | 一个元素的像素距离必须超过一定的时间才能被认为是动画                                                                                               |
| `waitForAnimations`          | `true`  | 是否等待元素动画完成后再执行命令                                                                                                      |
| `scrollBehavior`             | `top`   | 在执行命令之前，元素应该滚动到的视口位置。可以是 `'center'`, `'top'`, `'bottom'`, `'nearest'`, 或 `false`. `false` 禁用滚动. |

有关更多信息，请参阅[可操作性](/guides/core-concepts/interacting-with-elements#Actionability)文档。.

### Node 版本

| 选项           | 默认值    | 描述                                                                                                                                                                                                         |
| ------------- | --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `nodeVersion` | `bundled` | 如果设置为`system`， Cypress将尝试在您的路径上找到一个Node可执行文件，以在执行您的[插件](/guides/tooling/plugins-guide)时使用。否则，Cypress将使用与Cypress绑定的Node版本. |

Node.js版本面板中打印的Node版本，被Cypress用于:

- 在[integrationFolder](/guides/references/configuration#Folders-Files)中构建文件.
- 在[supportFile](/guides/references/configuration#Folders-Files)中构建文件.
- 执行[pluginsFile](/guides/references/configuration#Folders-Files)中的代码.

默认情况下，Cypress自动与设置的Node版本绑定. 您可以通过运行[`cypress version`](/guides/guides/command-line#cypress-version) 命令查看绑定版本，例如:

```shell
npx cypress version
Cypress package version: 6.2.1
Cypress binary version: 6.2.1
Electron version: 11.1.1
Bundled Node version: 12.18.3
```

如果从插件文件执行的代码需要在与Cypress绑定的Node版本不同的Node版本中提供的特性，您可能希望使用不同的Node版本. 你可以通过设置[nodeVersion](/guides/references/configuration#Node-version) 配置为`system`来使用系统上检测到的Node版本。. 例如，如果你想从你的插件文件加载`node-sass` 或 `sqlite3`等需要使用的系统模块.

<DocsImage src="/img/guides/test-runner-settings-nodejs-version.jpg" alt="测试运行器中的设置中的Node版本" ></DocsImage>

### 体验功能

配置可能包括当前正在测试的实验性选项. 看到[体验](/guides/references/experiments) 页面.

## 覆盖选项

Cypress为您提供了动态更改配置值的选项. 当在多个环境和多个开发人员机器上运行Cypress时，这是很有帮助的.

这样你就可以选择覆盖`baseUrl`或环境变量.

###  命令行

当[从命令行运行Cypress](/guides/guides/command-line)时 ，你可以传递一个`--config`标志。

#### 样例:

```shell
cypress open --config pageLoadTimeout=30000,baseUrl=https://myapp.com
```

```shell
cypress run --config integrationFolder=tests,videoUploadOnPasses=false
```

```shell
cypress run --browser firefox --config viewportWidth=1280,viewportHeight=720
```

对于更复杂的配置对象，您可能想要考虑传递一个单引号包围的[JSON.stringified](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/stringify)对象。

```shell
cypress open --config '{"watchForFileChanges":false,"testFiles":["**/*.js","**/*.ts"]}'
```

### 运行器特定的覆盖Runner Specific Overrides

你可以使用`e2e`和`Component`选项覆盖`e2e`或[组件测试](/guides/component-testing/introduction/) 运行器的配置.

#### 示例

组件测试配置文件中的特定视图(默认是`cypress.json`):

```json
{
  "viewportHeight": 600,
  "viewportWidth": 1000,
  "component": {
    "viewportHeight": 500,
    "viewportWidth": 500
  }
}
```

配置文件中的e2e的特定超时 (默认是`cypress.json`):

```json
{
  "defaultCommandTimeout": 5000,
  "e2e": {
    "defaultCommandTimeout": 10000
  }
}
```

### 插件

在运行spec文件的浏览器启动之前，Cypress插件文件在Node环境中运行，为您设置配置值提供了最大的灵活性。这使您能够做类似的事情:

- 使用`fs` 读取配置值并动态更改它们.
- 编辑Cypress默认发现的浏览器列表
- 通过读取任何自定义环境变量来设置配置值

虽然这可能比其他选项需要更多的工作，但它为您提供了最大的灵活性和管理配置的能力.

```js
// cypress/plugins/index.js
module.exports = (on, config) => {
  // 修改配置值
  config.defaultCommandTimeout = 10000

  // 读取环境变量和
  // 将其值传递给spec
  config.env.userName = process.env.TEST_USER || 'Joe'
  // spec 能够访问上述值
  // 通过 Cypress.env('userName')

  // 重要：返回更新的配置对象
  return config
}
```

我们已经完全记录了如何从插件文件中设置配置值，[这里](/api/plugins/configuration-api).

### 环境变量

你也可以使用[环境变量](/guides/guides/environment-variables)来覆盖配置值. 这在[持续集成](/guides/continuous-integration/introduction)或本地工作时特别有用。这使您能够在不修改任何代码或构建脚本的情况下更改配置选项.

默认情况下，任何与相应配置键匹配的环境变量都将覆盖配置文件(默认是`cypress.json`)。

```shell
export CYPRESS_VIEWPORT_WIDTH=800
```

```shell
export CYPRESS_VIEWPORT_HEIGHT=600
```

我们自动规范化键和值。Cypress将剥离`CYPRESS_`开头，驼峰大小写的任何键，并自动转换值为`Number`或`Boolean`. 请确保在环境变量前加上` CYPRESS_ `前缀，否则它们将被忽略.

#### 下面两个选项都是有效的

```shell
export CYPRESS_pageLoadTimeout=100000
```

```shell
export CYPRESS_PAGE_LOAD_TIMEOUT=100000
```

<Alert type="warning">

与配置键不匹配的环境变量将被设置为常规环境变量，以便使用`Cypress.env()`进行测试。.

你可以[阅读更多环境变量](/guides/guides/environment-variables).

</Alert>

### `Cypress.config()`

您还可以在测试中使用[`Cypress.config()`](/api/cypress-api/config).

<Alert type="warning">

<strong class="alert-header">范围</strong>

使用`Cypress.config` 的设置。只在当前spec文件的范围内有效。

</Alert>

```javascript
Cypress.config('pageLoadTimeout', 100000)

Cypress.config('pageLoadTimeout') // => 100000
```

### 测试配置

要将特定的Cypress [配置](/guides/references/configuration)值应用到测试集或单个测试，将一个配置对象作为第二个参数传递给 单个测试函数或测试集函数。

传入的配置值仅在设置它们的测试集或测试期间生效. 在套件或测试完成后，这些值将重置为以前的默认值。

<Icon name="exclamation-triangle" color="red"></Icon> **注意:** 有些配置值是只读的，不能通过测试配置更改。下面的配置值可以通过每个测试配置来**更改**:

- `animationDistanceThreshold`
- `baseUrl`
- `browser` **注意:** 根据当前浏览器筛选是否运行测试或一组测试
- `defaultCommandTimeout`
- `execTimeout`
- `env` **注意:** 所提供的环境变量将与当前环境变量合并。
- `includeShadowDom`
- `requestTimeout`
- `responseTimeout`
- `retries`
- `scrollBehavior`
- `viewportHeight`
- `viewportWidth`
- `waitForAnimations`

#### 测试集配置

如果在`cypress run`和`cypress open`期间测试失败，您可以分别配置重试一组测试的次数.

```js
describe(
  'login',
  {
    retries: {
      runMode: 3,
      openMode: 2,
    },
  },
  () => {
    it('是否应该将未经身份验证的用户重定向到登录页面', () => {
      // ...
    })

    it('允许用户登录', () => {
      // ...
    })
  }
)
```

您可以为单个测试设置`baseUrl`值:

```js
it('在选项卡中导航',
  { baseUrl: Cypress.env('APP_AT') },
  () => {
    ...
  }
)
```

#### 单个测试配置

如果您希望在特定的浏览器中运行或排除测试，您可以在测试配置中覆盖`browser`配置。`browser`选项接受与[Cypress.isBrowser()](/api/cypress-api/isbrowser)相同的参数.

```js
it('显示不在Chrome内的警告', { browser: '!chrome' }, () => {
  cy.get('.browser-warning').should(
    'contain',
    '要获得最佳浏览效果，请使用Chrome浏览器'
  )
})
```

## 解析配置

当你打开一个Cypress项目，点击**Settings**选项卡将显示解析的配置. 这可以帮助你理解和看到不同来源的值. 突出显示每个设置的值，以显示值的来源:

- 默认值
- [配置文件](/guides/references/configuration)
- [Cypress环境文件](/guides/guides/environment-variables#Option-2-cypress-env-json)
- 系统[环境变量](/guides/guides/environment-variables#Option-3-CYPRESS)
- [命令行参数](/guides/guides/command-line)
- [插件文件](/api/plugins/configuration-api)

<DocsImage src="/img/guides/configuration/see-resolved-configuration.jpg" alt="查看解析的配置" ></DocsImage>

## 注意

### 阻拦主机

通过传递字符串或字符串数组，可以阻止向一个或多个主机发出的请求.

要看这个工作的例子，请查看我们的[谷歌Analytics桩的菜谱](/examples/examples/recipes#Stubbing-and-spying).

阻拦策略:

- <Icon name="check-circle" color="green"></Icon> 允许通过
- <Icon name="check-circle" color="green"></Icon> 使用通配符`*`模式
- <Icon name="check-circle" color="green"></Icon> `80`和`443`以外的端口
- <Icon name="exclamation-triangle" color="red"></Icon> **不**包含协议: `http://` 或 `https://`

<Alert type="info">

不确定主机是URL的哪一部分? [请参考本指南.](https://nodejs.org/api/url.html#url_url_strings_and_url_objects)

当阻拦主机时，我们使用[`minimatch`](/api/utilities/minimatch)来检查主机。当你有疑问的时候，你可以测试某样东西是否适合你自己.

</Alert>

给定以下url:

```text
https://www.google-analytics.com/ga.js

http://localhost:1234/some/user.json
```

这将匹配以下被阻拦的主机:

```text
www.google-analytics.com
*.google-analytics.com
*google-analytics.com

localhost:1234
```

因为`localhost:1234`使用的端口不是`80`和`443`，所以必须包含它。

<Alert type="warning">

<strong class="alert-header">子域</strong>

注意没有子域名的URL。

例如，给定一个URL: `https://google.com/search?q=cypress`

- <Icon name="check-circle" color="green"></Icon> 匹配 `google.com`
- <Icon name="check-circle" color="green"></Icon> 匹配 `*google.com`
- <Icon name="exclamation-triangle" color="red"></Icon> 不匹配 `*.google.com`

</Alert>

当Cypress阻止向匹配主机发出的请求时，它将自动发送一个`503`状态码. 为了方便，它还设置了一个`x-cypress-matched-blocked-host`头，这样你就可以看到它匹配的是哪个规则.

<DocsImage src="/img/guides/blocked-host.png" alt="在dev工具的Network选项卡中选择analytics.js请求，并突出显示响应头 " ></DocsImage>

### modifyObstructiveCode

启用这个选项- Cypress将搜索从您的服务器上的`.html`和`.js`文件的响应流，并替换匹配通常在帧破坏中发现的模式的代码。

这些脚本模式是用来防止点击劫持和帧破坏的过时和不受欢迎的安全技术. 它们是过去的遗迹，在现代浏览器中不再必要. 然而，仍然有许多站点和应用程序实现它们.

这些技术阻止Cypress工作，并且可以在不改变应用程序任何行为的情况下安全地删除它们.

Cypress在网络级别修改这些脚本，因此在响应流中搜索这些模式的性能成本很小。

如果您正在测试的应用程序或站点**没有实现**这些安全措施，则可以关闭此选项. 另外，我们搜索的模式可能会意外地重写有效的JS代码。如果是这种情况，请禁用此选项.

### firefoxGcInterval

<Alert type="warning">

以下部分仅适用于使用Firefox 80之前版本的情况。 `firefoxGcInterval`对使用Firefox 80或更新版本的用户没有影响，因为Firefox 80已经修复了垃圾收集错误。建议升级您的Firefox版本以避免这种解决方法。

</Alert>

Firefox 79及更早版本有一个[bug](https://bugzilla.mozilla.org/show_bug.cgi?id=1608501)，它没有足够快地运行内部垃圾收集(GC)，这可能会消耗所有可用的系统内存并导致崩溃。

Cypress通过强制Firefox在测试之间运行它的GC清理例程来防止Firefox崩溃。

运行GC是一个昂贵且**阻塞**的例程。 它为整个运行增加了大量时间，并导致Firefox在GC清理期间“冻结”。这将导致浏览器不响应任何用户输入.

Cypress在[cypress run](/guides/guides/command-line#cypress-run)期间运行GC清理，这只是因为我们不期望用户与浏览器交互——因为这通常在CI中运行。我们已经禁用了在[cypress open](/guides/guides/command-line#cypress-open)期间运行GC，因为用户通常会与浏览器交互。

因为GC在总体运行中增加了额外的时间，所以我们增加了这个例程在测试运行器中的命令日志底部所花费的时间。

<DocsImage src="/img/guides/firefox-gc-interval-in-command-log.jpg" alt="GC时间显示"></DocsImage>

#### 配置

你可以通过`firefoxGcInterval`配置值来控制GC清理运行的频率。

`firefoxGcInterval`控制Cypress是否强制Firefox运行GC清理以及运行频率.

默认情况下，我们强制在[cypress运行](/guides/guides/command-line#cypress-run)期间的每个测试之间进行GC清理。, 但是在 [cypress open](/guides/guides/command-line#cypress-open) 期间不要使用下面的配置值运行任何GC清理:

```json
{
  "firefoxGcInterval": {
    "runMode": 1,
    "openMode": null
  }
}
```

你可以通过设置`firefoxGcInterval`的配置值来覆盖Cypress运行GC清理的频率:

- `null`, [cypress run](/guides/guides/command-line#cypress-run) 和 [cypress open](/guides/guides/command-line#cypress-open)都禁用
- 一个 `number`, 同时为[cypress run](/guides/guides/command-line#cypress-run)和[cypress open](/guides/guides/command-line#cypress-open)设置间隔
- 一个 `object` 为每个模式设置不同的间隔

**例子**

关闭所有GC清理模式

```json
{
  "firefoxGcInterval": null
}
```

在[cypress Run](/guides/guides/command-line#cypress-run) 一级 [cypress open](/guides/guides/command-line#cypress-open)期间，在每个其他测试之前运行GC清理

```json
{
  "firefoxGcInterval": 2
}
```

在[cypress Run](/guides/guides/command-line#cypress-run) 期间每3次测试之前运行GC清理，并在[cypress open](/guides/guides/command-line#cypress-open)期间禁用GC清理.

```json
{
  "firefoxGcInterval": {
    "runMode": 3,
    "openMode": null
  }
}
```

### 互动

您可以通过`Cypress open`命令打开Cypress使用互动模式，通过`Cypress run`命令使用运行模式. To detect the mode from your test code you can query the `isInteractive` property on [Cypress.config](/api/cypress-api/config).

```javascript
if (Cypress.config('isInteractive')) {
  // 互动的`Cypress open`模式!
} else {
  // `cypress run` 模式
}
```

### 智能代码补全

在编辑您的配置文件时，Cypress可以使用智能感知。[学习如何设置智能代码补全](/guides/tooling/IDE-integration#Intelligent-Code-Completion)

## 常见问题

#### <Icon name="angle-right"></Icon> 没有设置 `baseUrl`

确保您没有意外地将<code>baseUrl<code>或其他顶级配置变量放到<code>env<code>块中。下面的配置是<i>不正确<i> 无效的:

```javascript
// ⛔️ 行不通
{
  "env": {
    "baseUrl": "http://localhost:3030",
    "FOO": "bar"
  }
}
```

解决方案:将 `baseUrl` 属性放在顶层，在`env` 对象之外.

```javascript
// ✅ 正确方法
{
  "baseUrl": "http://localhost:3030",
  "env": {
    "FOO": "bar"
  }
}
```

你也可以在这个简短的[视频](https://www.youtube.com/watch?v=f5UaXuAc52c)中找到一些设置 `baseUrl` 的技巧。.

#### <Icon name="angle-right"></Icon> 当使用`spec`参数时，没有找到测试文件

当使用`--spec <path or mask>` 参数时, 使它相对于项目的文件夹. 如果规范仍然缺失，使用[DEBUG logs](/guides/references/troubleshooting#Print-DEBUG-logs)运行Cypress，设置如下，看看测试运行器是如何查找规范文件的:

```shell
DEBUG=cypress:cli,cypress:server:specs
```

## History

| Version                                      | Changes                                                 |
| -------------------------------------------- | ------------------------------------------------------- |
| [8.0.0](/guides/references/changelog#8-0-0)  | Added `clientCertificates` option                       |
| [7.0.0](/guides/references/changelog#7-0-0)  | Added `e2e` and `component` options.                    |
| [7.0.0](/guides/references/changelog#7-0-0)  | Added `redirectionLimit` option.                        |
| [6.1.0](/guides/references/changelog#6-1-0)  | Added `scrollBehavior` option.                          |
| [5.2.0](/guides/references/changelog#5-2-0)  | Added `includeShadowDom` option.                        |
| [5.0.0](/guides/references/changelog#5-0-0)  | Added `retries` configuration.                          |
| [5.0.0](/guides/references/changelog#5-0-0)  | Renamed `blacklistHosts` configuration to `blockHosts`. |
| [4.1.0](/guides/references/changelog#4-12-0) | Added `screenshotOnRunFailure` configuration.           |
| [4.0.0](/guides/references/changelog#4-0-0)  | Added `firefoxGcInterval` configuration.                |
| [3.5.0](/guides/references/changelog#3-5-0)  | Added `nodeVersion` configuration.                      |

## See also

- [Cypress.config()](/api/cypress-api/config) and [Cypress.env()](/api/cypress-api/env)
- [环境变量](/guides/guides/environment-variables)
- [环境变量的食谱](/examples/examples/recipes#Fundamentals)
- [扩展Cypress配置文件](https://www.cypress.io/blog/2020/06/18/extending-the-cypress-config-file/) blog post and [@bahmutov/cypress-extends](https://github.com/bahmutov/cypress-extends) package.
- 博客 [在端到端加密测试中对密码保密](https://glebbahmutov.com/blog/keep-passwords-secret-in-e2e-tests/)
