---
title: 疑难解答
---

有时您会遇到错误或Cypress本身的意外行为. 在这种情况下，我们建议**首先** 检查这些支持资源.

## 支持渠道

- 在[Gitter](https://gitter.im/cypress-io/cypress)中连接我们的社区
- 搜索现有的[GitHub问题](https://github.com/cypress-io/cypress/issues)
- 搜索这些文档 (搜索在右上角) 😉
- 搜索[Stack Overflow](https://stackoverflow.com/questions/tagged/cypress) 获取相关答案
- 如果您的组织注册了我们的[付费计划](https://www.cypress.io/pricing/)，您可以得到我们团队提供的专门的电子邮件支持。
- 如果你仍然没有找到一个解决方案，[打开一个问题](https://github.com/cypress-io/cypress/issues/new/choose)，提供一个 **可重新问题** 的例子。

### 常见的GitHub问题

下面是一些常见的问题主题，用户通过链接到主要问题，以及链接到主题中的开放和关闭问题。也许您可以找到一个开放或封闭的问题匹配您的问题。即使是公开的问题也可能暗示一个解决方法，或透露更多关于问题的信息。

| 标签                  | 描述                                                               | 问题                                                                                                                                                                                                                                                               |
| --------------------- | ----------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 浏览器检测             | 未检测到本地浏览器                                                  | [open](https://github.com/cypress-io/cypress/labels/topic%3A%20browser%20detection), [closed](https://github.com/cypress-io/cypress/issues?q=label%3A%22topic%3A+browser+detection%22+is%3Aclosed)                                                                   |
| 跨域                  | 获得跨源误差                                                        | [open](https://github.com/cypress-io/cypress/labels/topic%3A%20cross-origin%20%E2%A4%AD), [closed](https://github.com/cypress-io/cypress/issues?q=label%3A%22topic%3A+cross-origin+%E2%A4%AD%22+is%3Aclosed)                                                         |
| cy.request            | 与 [`cy.request()`](/api/commands/request)命令相关的问题            | [open](https://github.com/cypress-io/cypress/labels/topic%3A%20cy.request), [closed](https://github.com/cypress-io/cypress/issues?q=label%3A%22topic%3A+cy.request%22+is%3Aclosed)                                                                                   |
| fixtures              | 夹具装载和使用                                                      | [open](https://github.com/cypress-io/cypress/labels/topic%3A%20fixtures), [closed](https://github.com/cypress-io/cypress/issues?q=label%3A%22topic%3A+fixtures%22+is%3Aclosed)                                                                                       |
| 钩子                  | 钩子相关问题                                                        | [open](https://github.com/cypress-io/cypress/labels/topic%3A%20hooks%20%E2%86%AA), [closed](https://github.com/cypress-io/cypress/issues?q=label%3A%22topic%3A+hooks+%E2%86%AA%22+is%3Aclosed)                                                                       |
| iframes               | 使用iframes                                                        | [open](https://github.com/cypress-io/cypress/labels/topic%3A%20iframes), [closed](https://github.com/cypress-io/cypress/issues?q=label%3A%22topic%3A+iframes%22+is%3Aclosed)                                                                                         |
| 安装                  | 无法下载或安装Cypress                                               | [open](https://github.com/cypress-io/cypress/labels/topic%3A%20installation), [closed](https://github.com/cypress-io/cypress/issues?q=label%3A%22topic%3A+installation%22+is%3Aclosed)                                                                               |
| 网络                  | 控制网络请求                                                        | [open](https://github.com/cypress-io/cypress/labels/topic%3A%20network), [closed](https://github.com/cypress-io/cypress/issues?q=label%3A%22topic%3A+network%22+is%3Aclosed)                                                                                         |
| 性能                  | 加载慢，网络慢等等                                                   | [open](https://github.com/cypress-io/cypress/labels/type%3A%20performance%20%F0%9F%8F%83%E2%80%8D%E2%99%80%EF%B8%8F), [closed](https://github.com/cypress-io/cypress/issues?q=label%3A%22type%3A+performance+%F0%9F%8F%83%E2%80%8D%E2%99%80%EF%B8%8F%22+is%3Aclosed) |
| 截屏                  | 执行截屏                                                            | [open](https://github.com/cypress-io/cypress/labels/topic%3A%20screenshots%20%F0%9F%93%B8), [closed](https://github.com/cypress-io/cypress/issues?q=label%3A%22topic%3A+screenshots+%F0%9F%93%B8%22+is%3Aclosed)                                                     |
| 滚动                  | 将元素滚动到视图中                                                   | [open](https://github.com/cypress-io/cypress/labels/topic%3A%20scrolling%20%E2%86%95%EF%B8%8F), [closed](https://github.com/cypress-io/cypress/issues?q=label%3A%22topic%3A+scrolling+%E2%86%95%EF%B8%8F%22+is%3Aclosed)                                             |
| spec 执行             | 运行所有或过滤的spec                                                 | [open](https://github.com/cypress-io/cypress/labels/topic%3A%20spec%20execution), [closed](https://github.com/cypress-io/cypress/issues?q=label%3A%22topic%3A+spec+execution%22+is%3Aclosed)                                                                         |
| test 执行             | 在单个spec中运行测试                                                 | [open](https://github.com/cypress-io/cypress/labels/topic%3A%20test%20execution), [closed](https://github.com/cypress-io/cypress/issues?q=label%3A%22topic%3A+test+execution%22+is%3Aclosed)                                                                         |
| TypeScript            | 编译或绑定TypeScript                                                | [open](https://github.com/cypress-io/cypress/labels/topic%3A%20typescript), [closed](https://github.com/cypress-io/cypress/issues?q=label%3A%22topic%3A+typescript%22+is%3Aclosed)                                                                                   |
| 视频                  |视频记录的问题                                                        | [open](https://github.com/cypress-io/cypress/labels/topic%3A%20video%20%F0%9F%93%B9), [closed](https://github.com/cypress-io/cypress/issues?q=label%3A%22topic%3A+video+%F0%9F%93%B9%22+is%3Aclosed)                                                                 |
| 文件下载               | 文件下载无法工作                                                     | [open](https://github.com/cypress-io/cypress/labels/topic%3A%20downloads%20%E2%AC%87%EF%B8%8F), [closed](https://github.com/cypress-io/cypress/issues?q=label%3A%22topic%3A+downloads+%E2%AC%87%EF%B8%8F%22+is%3Aclosed)                                             |
| 拦截                  | 使用[cy.intercept](/api/commands/intercept)进行网络模拟               | [open](https://github.com/cypress-io/cypress/labels/pkg%2Fnet-stubbing), [closed](https://github.com/cypress-io/cypress/issues?q=label%3Apkg%2Fnet-stubbing+is%3Aclosed)                                                                                             |
| SIG\* 错误            | 崩溃时出现如下错误`SIGSEGV`                                          | [open](https://github.com/cypress-io/cypress/labels/topic%3A%20SIG%20errors), [closed](https://github.com/cypress-io/cypress/issues?q=label%3A%22topic%3A+SIG+errors%22+is%3Aclosed)                                                                                 |
| 环境变量              | 解析和使用环境变量                                                   | [open](https://github.com/cypress-io/cypress/labels/topic%3A%20environment%20variables), [closed](https://github.com/cypress-io/cypress/issues?q=label%3A%22topic%3A+environment+variables%22+is%3Aclosed)                                                           |

## 隔离问题

在调试失败的测试时，遵循这些通用原则来隔离问题:

- 查看[视频记录和截图](/guides/guides/screenshots-and-videos).
- 将大spec文件分割成小spec文件.
- 将长测试分割成较小的测试.
- 使用[--browser chrome](/guides/guides/command-line#cypress-run-browser-lt-browser-name-or-path-gt)运行相同的测试. 这个问题可能与Electron浏览器无关.
- 如果孤立到Electron浏览器。在Electron和Chrome上运行相同的测试, 然后比较屏幕截图和视频. 查找并隔离命令日志中的任何差异。

## 下载特定的Chrome版本

Chrome浏览器是常青的——这意味着它会自动更新自己，有时会在你的自动化测试中造成破坏性的变化. 我们托管[chromium.cypress.io](https://chromium.cypress.io)，并为每个平台提供下载特定发布版本Chrome (dev、Canary和stable)的链接。

## 清理 Cypress 缓存

如果您在安装Cypress期间遇到问题，请尝试删除Cypress缓存的内容。

这将清除所有已安装的Cypress版本，可能是缓存在您的机器上。

```shell
cypress cache clear
```

运行此命令后，您将需要运行`cypress install` ，然后再运行cypress.

```shell
npm install cypress --save-dev
```

## 启动浏览器

Cypress试图[自动为您找到安装的Chrome版本](/guides/guides/launching-browsers). 然而，跨不同环境探测浏览器可能很容易出错. 如果Cypress找不到浏览器，但你知道你已经安装了它，有办法确保Cypress可以“看到”它.

<Alert type="info">

<strong class="alert-header">使用`--browser`命令行参数</strong>

您还可以提供`--browser`命令行参数来从已知的文件系统路径启动浏览器，从而绕过浏览器的自动检测。 [更多信息请参见“启动浏览器”](/guides/guides/launching-browsers#Launching-by-a-path)

</Alert>

你可以在测试运行器的设置选项卡的[解析的配置](/guides/references/configuration#Resolved-Configuration)中看到找到的浏览器的完整列表和它们的属性。

另一种记录Cypress发现的内容的方法是运行Cypress与[DEBUG环境变量](#Print-DEBUG-logs)设置为`cypress:launcher`. 这将把找到的浏览器及其属性的信息打印到终端。

**提示:**使用[cypress info](/guides/guides/command-line#cypress-info) 命令查看所有本地检测到的浏览器.

### Mac

在Mac上，Cypress试图通过捆绑标识符找到已安装的浏览器。如果不成功，它将退回到Linux浏览器检测方法.

| 浏览器的名称     | 期望的包标识符               | 预计可执行文件                   |
| --------------- | -------------------------- | ------------------------------------- |
| `chrome`        | `com.google.Chrome`        | `Contents/MacOS/Google Chrome`        |
| `chromium`      | `org.chromium.Chromium`    | `Contents/MacOS/Chromium`             |
| `chrome:canary` | `com.google.Chrome.canary` | `Contents/MacOS/Google Chrome Canary` |

有关当前列表，请参见[packages/launcher](https://github.com/cypress-io/cypress/blob/develop/packages/launcher/lib/darwin/index.ts) 文件.

### Linux

在Linux上，Cypress会扫描你的`PATH`，以找到许多不同的二进制名称.如果您试图使用的浏览器在预期的二进制名称下不存在，Cypress将无法找到它.

| 浏览器的名称     | 期望的二进制的名字(s)                              |
| --------------- | ---------------------------------------------------- |
| `chrome`        | `google-chrome`, `chrome`, or `google-chrome-stable` |
| `chromium`      | `chromium-browser` or `chromium`                     |
| `chrome:canary` | `google-chrome-canary`                               |

这些二进制名称应该适用于大多数Linux发行版. 如果您的发行版包使用不同的二进制名称访问浏览器，您可以使用预期的二进制名称添加符号链接，以便Cypress能够检测到它。

例如，如果你的发行包谷歌Chrome作为“Chrome”，你可以添加一个符号链接到“google-chrome”，像这样:

```shell
sudo ln `which chrome` /usr/local/bin/google-chrome
```

### Windows

在Windows上，Cypress扫描以下位置，试图找到每个浏览器:

| 浏览器的名称     | 预期路径                                                |
| --------------- | ------------------------------------------------------------- |
| `chrome`        | `C:/Program Files (x86)/Google/Chrome/Application/chrome.exe` |
| `chromium`      | `C:/Program Files (x86)/Google/chrome-win32/chrome.exe`       |
| `chrome:canary` | `%APPDATA%/../Local/Google/Chrome SxS/Application/chrome.exe` |

有关当前列表，请参见[packages/launcher](https://github.com/cypress-io/cypress/blob/develop/packages/launcher/lib/windows/index.ts) 文件.

为了使安装在不同路径的浏览器被自动检测，在Cypress希望找到你的浏览器的位置使用`mklink`创建一个符号链接。

[阅读更多关于在Windows上创建符号链接的信息](https://www.howtogeek.com/howto/16226/complete-guide-to-symbolic-links-symlinks-on-windows-or-linux/)

Cypress偶尔会在检测Windows环境中的浏览器类型时出现问题。若要手动检测浏览器类型，请将浏览器类型附加到路径的末尾:

```shell
cypress open --browser C:/User/Application/browser.exe:chrome
```

## 允许Cypress Chrome扩展

Cypress在测试运行器中利用了一个Chrome扩展，以便正确运行. 如果你或你的公司阻止特定的Chrome扩展，这可能会导致运行Cypress的问题。您需要请求管理员允许下面的Cypress扩展ID:

```sh
caljajdfkjjjdehjdoimjkkakekklcck
```

## 允许在vpn上使用cypress url

将测试的数据和结果发送到[dashboard](https://on.cypress.io/dashboard-introduction), Cypress需要自由访问一些url.

如果您在一个受限的VPN中运行测试，则需要允许一些url，以便Cypress能够与Dashboard进行有效的通信。

**需要通过的url如下所示:**

- `https://api.cypress.io` - **Cypress API**
- `https://assets.cypress.io` - **Asset CDN** (Org logos, icons, videos, screenshots, etc.)
- `https://authenticate.cypress.io` - **Authentication API**
- `https://dashboard.cypress.io` - **Dashboard app**
- `https://docs.cypress.io` - **Cypress documentation**
- `https://download.cypress.io` - **CDN download of Cypress binary**
- `https://on.cypress.io` - **URL shortener for link redirects**

## 清理 应用数据

Cypress维护一些本地应用程序数据，以保存用户首选项和更快地启动. 有时这些数据会被破坏。你可以通过清除这个应用程序数据来解决问题。

### 如何清理应用数据

1. 通过 `cypress open`打开Cypress
2. 点击 `File` -> `View App Data`
3. 这将把你带到文件系统中存放App Data的目录.如果不能打开Cypress，在文件系统中搜索名为`cy`的目录，其内容应该如下所示:

```text
📂 production
  📄 all.log
  📁 browsers
  📁 bundles
  📄 cache
  📁 projects
  📁 proxy
  📄 state.json
```

4. 删除`cy`文件夹中的所有内容
5. 关闭Cypress，再打开它

## 打印调试日志

Cypress是使用[debug](https://github.com/visionmedia/debug) 模块构建的. 这意味着您可以通过打开此开关运行Cypress来接收有用的调试输出. **注意:** 当运行`DEBUG=...` 的设置时，会看到大量日志信息.

**在Mac或Linux上:**

```shell
DEBUG=cypress:* cypress run
```

**在Windows上:**

在Windows上，您需要在命令提示符终端(不是Powershell)中运行该命令。

```shell
set DEBUG=cypress:*
cypress run
```

如果日志无法打印，可能是在终端中设置环境变量的权限问题. 您可能需要在管理模式下运行终端或检查权限设置。

阅读更多[关于CLI选项](/guides/guides/command-line#Debugging-commands) 以及 [良好的日志](https://glebbahmutov.com/blog/good-logging/) 的博客.

### 详细的日志

有几个级别的`DEBUG`消息

```shell
## 打印很少的顶级消息
DEBUG=cypress:server ...
## 从服务包打印所有消息
DEBUG=cypress:server* ...
## 仅从配置解析打印消息
DEBUG=cypress:server:config ...
```

这允许您更好地隔离问题

### 日志源

Cypress由多个包构建而成，每个包负责自己的日志记录:服务、报告程序、驱动程序、命令行等等. 每个包在不同的源下写入调试日志。 下面是一些常见的日志源，以及您可能希望启用它们的时间

| 设置 `DEBUG` 的值                | 来启用调试                                                   |
| ------------------------------- | --------------------------------------------------------------------- |
| `cypress:cli`                   | 顶层命令行解析问题                           |
| `cypress:server:args`           | 解析的命令行参数不正确                              |
| `cypress:server:specs`          | 没有找到预期的specs                                        |
| `cypress:server:project`        | 打开项目                                                 |
| `cypress:server:browsers`       | 找到安装浏览器                                            |
| `cypress:launcher`              | 启动找到的浏览器                                           |
| `cypress:server:video`          | 视频录制                                                     |
| `cypress:network:*`             | 添加网络拦截器                                           |
| `cypress:net-stubbing*`         | 代理层的网络拦截                               |
| `cypress:server:reporter`       | 测试报告的问题                                          |
| `cypress:server:preprocessor`   | 处理spec                                                    |
| `cypress:server:plugins`        | 运行插件文件和绑定spec                           |
| `cypress:server:socket-e2e`     | 看spec文件                                                 |
| `cypress:server:task`           | 调用`cy.task()` c命令                                    |
| `cypress:server:socket-base`    | 调试的`cy.request()`的命令                                    |
| `cypress:webpack`               | 使用webpack捆绑spec                                        |
| `cypress:server:fixture`        | 加载夹具文件                                                 |
| `cypress:server:record:ci-info` | Git提交和CI信息时记录到Cypress Dashboard |

可以使用逗号字符将几个区域组合在一起。例如，要调试未找到的spec，请使用:

```shell
## 查看CLI参数是如何解析的
## 以及Cypress如何定位spec文件
DEBUG=cypress:cli,cypress:server:specs npx cypress run --spec ...
```

也可以使用`-`字符排除日志源. 例如，要查看所有的`cypress:server*`消息而不使用嘈杂的浏览器消息:

```shell
DEBUG=cypress:server*,-cypress:server:browsers* npx cypress run
```

#### 调试日志深度

有时记录的对象有深度嵌套的属性，并显示为`[Object]` 而不是完整的序列化.

```shell
DEBUG=cypress:server:socket-base npx cypress run

cypress:server:socket-base backend:request { eventName: 'http:request', args:
  [ { url: 'http://localhost:7065/echo', method: 'POST', body: [Object], auth: [Object],
  json: true, encoding: 'utf8', gzip: true, timeout: 30000, followRedirect: true,
  failOnStatusCode: true, retryOnNetworkFailure: true,
  retryOnStatusCodeFailure: false } ] } +5ms
```

可以使用DEBUG_DEPTH`环境变量增加打印对象的深度

```shell
DEBUG=cypress:server:socket-base DEBUG_DEPTH=3 npx cypress run

cypress:server:socket-base backend:request { eventName: 'http:request', args:
  [ { url: 'http://localhost:7065/echo', method: 'POST', body: { text: 'ping!' },
  auth: { username: 'jane.lane', password: 'password123' }, json: true, encoding: 'utf8',
  gzip: true, timeout: 30000, followRedirect: true, failOnStatusCode: true,
  retryOnNetworkFailure: true, retryOnStatusCodeFailure: false } ] } +4ms
```

#### 第三方模块

一些第三方模块，如[@cypress/request](https://github.com/cypress-io/request)通过检查`NODE_DEBUG`环境变量输出额外的日志消息. 例如，调试网络拦截和`@cypress/request`发出的请求:

```shell
DEBUG=cypress:net-stubbing:server:intercept-request \
  NODE_DEBUG=request npx cypress run
```

### 浏览器中的调试日志

如果问题是在`cypress open`期间看到的，你也可以在浏览器中打印调试日志.打开浏览器的开发工具，并设置一个`localStorage`属性:

```javascript
localStorage.debug = 'cypress*'

// 禁用调试消息
delete localStorage.debug
```

重新加载浏览器并打开'Verbose'日志以查看Developer Tools控制台中的调试消息. 你只会看到在浏览器中运行的"cypress:driver"包日志，如下所示。

<DocsImage src="/img/api/debug/debug-driver.jpg" alt="Debug logs in browser" ></DocsImage>

## 输出内存和CPU使用率日志

您可以通过启用`cypress:server:util:process_profiler` 调试流，让Cypress定期输出其自身和任何子进程的内存和CPU使用情况摘要，如下所示:

**在Mac或Linux上:**

```shell
DEBUG=cypress:server:util:process_profiler cypress run
```

**在Windows上:**

```shell
set DEBUG=cypress:server:util:process_profiler
cypress run
```

在结果输出中，流按名称分组。

<DocsImage src="/img/guides/troubleshooting-cypress-process-profiler-cli.jpg" alt="Process printout of Cypress in CLI" ></DocsImage>

默认情况下，每10秒收集并打印一次进程信息汇总. 您可以通过将`CYPRESS_PROCESS_PROFILER_INTERVAL`环境变量设置为所需的间隔(以毫秒为单位)来覆盖这个间隔。

您还可以通过启用详细的`cypress-verbose:server:util:process_profiler` 调试流来获取更详细的进程信息.

## 禁用命令日志

在某些情况下，[命令日志](/guides/core-concepts/test-runner#Command-Log)负责在测试运行器中显示测试命令、断言和状态，可能会导致性能问题，导致测试变慢或浏览器崩溃。

为了隔离这些问题，你可以通过在`cypress open` 或 `cypress run`期间传递下面的环境变量来隐藏命令日志。

```shell
CYPRESS_NO_COMMAND_LOG=1 cypress run
```

## 额外信息

### 向终端写入命令日志

你可以在你的测试中包含插件[cypress-failed-log](https://github.com/bahmutov/cypress-failed-log). 如果测试失败，该插件将向终端写入Cypress命令列表以及JSON文件.

<DocsImage src="/img/api/debug/failed-log.png" alt="cypress-failed-log terminal output" ></DocsImage>

## 黑入Cypress

如果您想深入Cypress并自己编辑代码，您可以这样做. Cypress代码是开源的，并根据[MIT许可证](https://github.com/cypress-io/cypress/blob/develop/LICENSE)进行许可。 下面列出了一些关于如何开始的建议.

### 贡献

如果你想直接贡献到Cypress代码，我们很乐意得到你的帮助!请查看我们的[贡献指南](https://github.com/cypress-io/cypress/blob/develop/CONTRIBUTING.md)，了解你可以贡献的许多方式。

### 运行Cypress应用程序自己

Cypress附带了一个npm CLI模块，用于解析参数，启动Xvfb服务器(如果需要)，然后打开构建在[Electron](https://electronjs.org/)之上的Test Runner应用程序。.

为什么你想要运行Cypress应用程序本身的一些常见情况是:

- 调试Cypress未启动或挂起
- 与npm CLI模块解析CLI参数的方式相关的调试问题

下面是如何在没有npm CLI模块的情况下直接启动Cypress应用程序。首先，使用 [cypress缓存路径](/guides/guides/command-line#cypress-cache-path) 命令找到二进制文件的安装位置。

例如，在Linux机器上:

```shell
npx cypress cache path
/root/.cache/Cypress
```

其次，尝试冒烟测试，以验证应用程序在主机上有所有必需的依赖项:

```shell
/root/.cache/Cypress/3.3.1/Cypress/Cypress --smoke-test --ping=101
101
```

如果缺少依赖项，应用程序应该打印一条错误消息.您可以通过设置[环境变量ELECTRON_ENABLE_LOGGING(https://www.electronjs.org/docs/api/command-line-switches)]来查看Electron详细日志消息。:

```shell
ELECTRON_ENABLE_LOGGING=true DISPLAY=10.130.4.201:0 /root/.cache/Cypress/3.3.1/Cypress/Cypress --smoke-test --ping=101
[809:0617/151243.281369:ERROR:bus.cc(395)] Failed to connect to the bus: Failed to connect to socket /var/run/dbus/system_bus_socket: No such file or directory
101
```

如果冒烟测试未能执行，请检查共享库是否缺失(在没有所有Cypress依赖项的Linux机器上，这是一个常见问题)。

```shell
ldd /home/person/.cache/Cypress/3.3.1/Cypress/Cypress
  linux-vdso.so.1 (0x00007ffe9eda0000)
  libnode.so => /home/person/.cache/Cypress/3.3.1/Cypress/libnode.so (0x00007fecb43c8000)
  libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007fecb41ab000)
  libgtk-3.so.0 => not found
  libgdk-3.so.0 => not found
  ...
```

**提示:** 使用[Cypress Docker image](/examples/examples/docker) 或通过从我们的官方Docker映像复制它们来安装依赖项.

**注意:** Electron日志可能显示警告，但仍然允许Cypress正常工作.例如，尽管下面有可怕的输出，Cypress Test Runner还是正常打开:

```shell
ELECTRON_ENABLE_LOGGING=true DISPLAY=10.130.4.201:0 /root/.cache/Cypress/3.3.1/Cypress/Cypress
[475:0617/150421.326986:ERROR:bus.cc(395)] Failed to connect to the bus: Failed to connect to socket /var/run/dbus/system_bus_socket: No such file or directory
[475:0617/150425.061526:ERROR:bus.cc(395)] Failed to connect to the bus: Could not parse server address: Unknown address type (examples of valid types are "tcp" and on UNIX "unix")
[475:0617/150425.079819:ERROR:bus.cc(395)] Failed to connect to the bus: Could not parse server address: Unknown address type (examples of valid types are "tcp" and on UNIX "unix")
[475:0617/150425.371013:INFO:CONSOLE(73292)] "%cDownload the React DevTools for a better development experience: https://fb.me/react-devtools
You might need to use a local HTTP server (instead of file://): https://fb.me/react-devtools-faq", source: file:///root/.cache/Cypress/3.3.1/Cypress/resources/app/packages/desktop-gui/dist/app.js (73292)
```

您还可以在运行Test Runner二进制文件时看到详细的Cypress日志

```shell
DEBUG=cypress* DISPLAY=10.130.4.201:0 /root/.cache/Cypress/3.3.1/Cypress/Cypress --smoke-test --ping=101
cypress:ts Running without ts-node hook in environment "production" +0ms
cypress:server:cypress starting cypress with argv [ '/root/.cache/Cypress/3.3.1/Cypress/Cypress', '--smoke-test', '--ping=101' ] +0ms
cypress:server:args argv array: [ '/root/.cache/Cypress/3.3.1/Cypress/Cypress', '--smoke-test', '--ping=101' ] +0ms
cypress:server:args argv parsed: { _: [ '/root/.cache/Cypress/3.3.1/Cypress/Cypress' ], smokeTest: true, ping: 101, cwd: '/root/.cache/Cypress/3.3.1/Cypress/resources/app/packages/server' } +7ms
cypress:server:args options { _: [ '/root/.cache/Cypress/3.3.1/Cypress/Cypress' ], smokeTest: true, ping: 101, cwd: '/root/.cache/Cypress/3.3.1/Cypress/resources/app/packages/server', config: {} } +2ms
cypress:server:args argv options: { _: [ '/root/.cache/Cypress/3.3.1/Cypress/Cypress' ], smokeTest: true, ping: 101, cwd: '/root/.cache/Cypress/3.3.1/Cypress/resources/app/packages/server', config: {}, pong: 101 } +1ms
cypress:server:appdata path: /root/.config/Cypress/cy/production +0ms
cypress:server:cypress starting in mode smokeTest +356ms
101
cypress:server:cypress about to exit with code 0 +4ms
```

如果冒烟测试没有显示特定的错误，尝试打印Electron崩溃堆栈，也许可以更好地查明问题:

```shell
ELECTRON_ENABLE_STACK_DUMPING=1 npx cypress verify
...
Received signal 11 SEGV_MAPERR ffffffb27e8955bb
#0 0x55c6389f83d9 (/root/.cache/Cypress/3.8.2/Cypress/Cypress+0x35d13d8)
r8: 0000000000000000  r9: 00007ffcf0387c80 r10: 00007ffcf0387bd8 r11: 000000000000000e
r12: 00007ffcf0387d2c r13: 00007f3ea737b720 r14: ffffffb27e89558b r15: 00007f3ea8974200
di: 0000000000000000  si: 0000000000000020  bp: 0000000000000000  bx: 0000004f2f375580
dx: 0000000000000001  ax: 0000000000000030  cx: 0000000000000001  sp: 00007ffcf0387d00
ip: 00007f3ea89582dd efl: 0000000000010246 cgf: 002b000000000033 erf: 0000000000000005
trp: 000000000000000e msk: 0000000000000000 cr2: ffffffb27e8955bb
[end of stack trace]
Calling _exit(1). Core file will not be generated.
```

### 给Cypress打补丁

Cypress附带了一个npm CLI模块，用于解析参数，启动Xvfb服务器(如果需要)，然后打开构建在[Electron](https://electronjs.org/)之上的Test Runner应用程序。.

如果您在Cypress的当前版本中遇到bug，您可以通过在您自己的项目中修补Cypress来实现临时修复. 下面是一个如何做到这一点的例子。

1. 安装 [patch-package](https://github.com/ds300/patch-package).
2. 在安装npm包之后，向CI配置中添加一个补丁步骤.

```yaml
- run: npm ci
- run: npx patch-package
```

或者，您可以在安装后阶段应用补丁。在你的`package.json`，例如，您可以添加以下内容:

```json
{
  "scripts": {
    "postinstall": "patch-package"
  }
}
```

3. 在`node_modules/cypress`中的本地node_modules文件夹中编辑导致问题的行.
4. 执行`npx patch-package cypress` 命令。 这个命令将创建一个新文件'`patches/cypress+3.4.1.patch`.

```shell
npx patch-package cypress
patch-package 6.1.2
• Creating temporary folder
• Installing cypress@3.4.1 with npm
• Diffing your files with clean files
✔ Created file patches/cypress+3.4.1.patch
```

5. 提交新的`patches`文件夹到git。

<Alert type="info">

如果你发现一个错误的补丁，请添加评论，解释你的解决方案相关的Cypress GitHub问题.它将帮助我们更快地发布官方修复.

</Alert>

### 编辑已安装的Cypress代码

安装的Test Runner附带了完整的、清晰的JavaScript源代码，您可以对其进行修改。 您可能希望直接将安装的Test Runner代码修改为:

- 调查发生在您的机器上的一个难以重新创建的错误
- 在打开一个PR之前改变Cypress的运行时行为
- 玩得开心 🎉

首先，使用[cypress缓存路径](/guides/guides/command-line#cypress-cache-path)命令打印二进制文件安装的位置.

例如，在Mac上:

```shell
npx cypress cache path
/Users/jane/Library/Caches/Cypress
```

其次，在任何代码编辑器中按以下路径打开源代码。确保用`3.3.1` 替换您想要编辑的测试运行器的期望版本.

```text
/Users/jane/Library/Caches/Cypress/3.3.1/Cypress.app/Contents/Resources/app/packages/
```

你可以修改JavaScript代码中的任何内容:

<DocsImage src="/img/guides/source-code.png" alt="Source code of the Test Runner in a text editor" ></DocsImage>

完成后，如果有必要，删除编辑过的Test Runner版本并重新安装Cypress官方版本以返回官方发布的代码。

```shell
rm -rf /Users/jane/Library/Caches/Cypress/3.3.1
npm install cypress@3.3.1
```
