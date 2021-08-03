---
title: 配方
containerClass: examples
---

配方向您展示Cypress如何实现一些常见测试场景。

<Icon name="github"></Icon> [https://github.com/cypress-io/cypress-example-recipes](https://github.com/cypress-io/cypress-example-recipes)

## 基础

| 配方                                                                                                                                            | 描述                                                                                     |
| ----------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| [Node 模块](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/fundamentals__node-modules)                              |导入自己的Node模块                                                                    |
| [环境变量](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/server-communication__env-variables)                       | 将环境变量传递给测试                                                          |
| [处理异常](https://github.com/cypress-io/cypress-example-recipes/blob/master/examples/fundamentals__errors)                                      | 处理抛出的异常和未处理的被拒绝promise                                         |
| [动态测试](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/fundamentals__dynamic-tests)                               | 从JSON数据动态创建测试                                                         |
| [基于CSV的动态测试](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/fundamentals__dynamic-tests-from-csv)             | 从CSV文件动态创建测试                                                          |
| [基于 API 的动态测试](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/fundamentals__dynamic-tests-from-api)           | 通过调用外部API动态创建测试                                            |
| [夹具（挡板）](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/fundamentals__fixtures)                                | 装载单个或多个夹具                                                          |
| [添加自定义命令](https://github.com/cypress-io/cypress-example-recipes/blob/master/examples/fundamentals__add-custom-command)                    | 用正确类型的JavaScript编写你自己的自定义命令，让智能感知工作     |
| [添加自定义命令 (TS)](https://github.com/cypress-io/cypress-example-recipes/blob/master/examples/fundamentals__add-custom-command-ts)            | 使用TypeScript编写自己的自定义命令                                                 |
| [添加 Chai 断言](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/extending-cypress__chai-assertions)                  | 添加新的或自定义的chai断言                                                              |
| [Cypress 模块API](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/fundamentals__module-api)                          | 通过Cypress模块API运行Cypress                                                                 |
| [封装 Cypress 模块 API](https://github.com/cypress-io/cypress-example-recipes/blob/master/examples/fundamentals__module-api-wrap)                | 编写“cypress run”命令行解析的包装器                                   |
| [自定义浏览器](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/fundamentals__custom-browsers)                         | 控制项目可以使用哪些浏览器，或者甚至向列表中添加一个自定义浏览器          |
| [使用Chrome远程接口](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/fundamentals__chrome-remote-debugging)           | 使用Chrome调试器协议触发悬停状态和打印媒体风格                       |
| [开箱即用的TypeScript](https://github.com/cypress-io/cypress-example-recipes/blob/master/examples/fundamentals__typescript)                      | 在TypeScript中编写测试而不设置预处理器                                      |
| [每个测试的 timeout](https://github.com/cypress-io/cypress-example-recipes/blob/master/examples/fundamentals__timeout)                           | 如果测试运行的时间超过指定的时间限制，则测试失败                                    |
| [Cypress 事件](https://github.com/cypress-io/cypress-example-recipes/blob/master/examples/fundamentals__cy-events)                              | 使用的`Cypress.on` 和 `cy.on`监听Cypress的活动，比如`before:window:load`            |
| [Video 分辨率](https://github.com/cypress-io/cypress-example-recipes/blob/master/examples/fundamentals__window-size)                             | 增加浏览器窗口的大小，以记录高质量的视频和捕捉详细的屏幕截图 |

## 测试DOM

| 配方                                                                                                                                        | 描述                                                                  |
| ------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| [标签页处理和链接](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/testing-dom__tab-handling-links)               | 打开新标签页的链接                                               |
| [悬停和隐藏元素](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/testing-dom__hover-hidden-elements)              | 测试需要鼠标悬停的隐藏元素                                         |
| [表单交互](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/testing-dom__form-interactions)                        | 测试表单元素，如input类型`range`                                   |
| [拖放功能](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/testing-dom__drag-drop)                                |使用'`.trigger()`测试拖放                                       |
| [影子DOM](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/testing-dom__shadow-dom)                                | 测试阴影DOM中的元素                                             |
| [等待静态资源](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/testing-dom__wait-for-resource)                     | 演示如何等待CSS、图像或任何其他静态资源加载       |
| [CSV加载和表测试](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/testing-dom__csv-table)                          | 加载CSV文件并将对象与表中的单元格进行比较                |
| [评价性能指标](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/testing-dom__performance-metrics)                   | 利用Cypress来监控网站                                         |
| [根样式](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/testing-dom__root-style)                                 | 触发修改CSS变量的输入颜色变化                       |
| [选择 widgets](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/testing-dom__select2)                              | 使用`<select>`元素和 [Select2](https://select2.org/)小部件 |
| [Lit 元素](https://github.com/cypress-io/cypress-example-recipes/blob/master/examples/testing-dom__lit-element)                              | 使用Shadow DOM测试Lit元素                                         |
| [文件下载](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/testing-dom__download)                                  | 下载和验证CSV, Excel，文本，Zip和图像文件                 |
| [页面重新加载](https://github.com/cypress-io/cypress-example-recipes/blob/master/examples/testing-dom__page-reloads)                          | 在处理随机性时避免`while`循环                           |
| [分页](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/testing-dom__pagination)                                   |  点击“Next”链接，直到我们到达最后一页                        |
| [剪贴板](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/testing-dom__clipboard)                                  | 从测试中复制并粘贴文本到剪贴板中                         |

## 登录

| 配方                                                                                                                            | 描述                                 |
| ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------- |
| [基本认证](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/logging-in__basic-auth)                    | 使用基本身份验证登录           |
| [单点登录](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/logging-in__single-sign-on)                | 跨多个服务或提供商登录 |
| [HTML Web表单](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/logging-in__html-web-forms)           | 使用基本的HTML表单登录               |
| [XHR Web表单](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/logging-in__xhr-web-forms)             | 使用XHR登录                        |
| [CSRF令牌](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/logging-in__csrf-tokens)                  | 使用必需的CSRF令牌登录           |
| [Json Web 令牌](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/logging-in__jwt)                     | 使用JWT登录                            |
| [使用应用程序代码](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/logging-in__using-app-code)         |通过调用应用程序代码进行登录      |

参见[认证插件](/plugins/directory#authentication) 以及观看 [组织测试、登录、控制状态](https://www.youtube.com/watch?v=5XQOK0v_YRE)

## 预处理器

| 配方                                                                                                                                          | 描述                                         |
| --------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------- |
| [Grep 测试](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/preprocessors__grep)                                   | 使用类似mocha的`grep`语法按名称过滤测试 |
| [Typescript 以及 Browserify](https://github.com/cypress-io/cypress-example-recipes/blob/master/examples/preprocessors__typescript-browserify) | 在browserify中添加typescript支持              |
| [Typescript 以及 Webpack](https://github.com/cypress-io/cypress-example-recipes/blob/master/examples/preprocessors__typescript-webpack)       | 在webpack中添加typescript支持                |
| [流与Browserify](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/preprocessors__flow-browserify)                   | 使用Browserify添加流支持                  |

## 博客

来自[Cypress blog](https://www.cypress.io/blog) 博客文章的配方演示.

| 配方                                                                                                                                    | 描述                                                                                                       |
| --------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| [应用程序行为](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/blogs__application-actions)                    | 用应用程序行为 代替 页面对象                                                            |
| [直接控制AngularJS](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/blogs__direct-control-angular)            | 绕过DOM，控制AngularJS                                                                              |
| [E2E API测试](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/blogs__e2e-api-testing)                        | 使用GUI运行API测试                                                                                    |
| [E2E 快照](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/blogs__e2e-snapshots)                             | 端到端快照测试                                                                                      |
| [Element 覆盖](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/blogs__element-coverage)                      | 跟踪测试覆盖元素                                                                                   |
| [Codepen.io 测试](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/blogs__codepen-demo)                       | 测试混合App Codepen演示                                                                                      |
| [测试Redux Store](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/blogs__testing-redux-store)                | 测试使用中央Redux数据存储的应用程序                                                            |
| [Vue + Vuex + REST 测试](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/blogs__vue-vuex-rest)               |  测试使用集中式Vuex数据存储的应用程序                                                            |
| [A11y 测试](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/blogs__a11y)                                     | 使用[cypress-axe](https://github.com/avanslaars/cypress-axe) 进行易用性测试                               |
| [React 开发者工具](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/blogs__use-react-devtools)                 | 自动加载 react DevTools Chrome 扩展                                                            |
| [期望 N 断言](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/blogs__assertion-counting)                      | 如何在测试中期望一定数量的断言                                                           |
| [浏览器通知](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/blogs__notification)                             | 如何测试使用[`Notification`](https://developer.mozilla.org/en-US/docs/Web/API/notification) 的应用程序 |
| [测试iframes](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/blogs__iframes)                                 | 访问第三方iframe中的元素，从iframe 监听和 挡板网络调用                                    |
| [类的修饰符](https://github.com/cypress-io/cypress-example-recipes/blob/master/examples/blogs__class-decorator)                          | 使用JavaScript类装饰器公开应用程序创建的对象，以便从测试中访问它们   |
| [表单提交](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/blogs__form-submit)                                | 从表单提交后重新加载页面的测试中删除脆弱因素                                      |
| [用 Day.js 替代 Moment.js](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/blogs__dayjs)                      | 使用 [day.js](https://day.js.org/) 替代废弃的 `Cypress.moment`                            |

## 桩和间谍

| 配方                                                                                                                                           | 描述                                                           |
| ---------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| [模拟函数](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/stubbing-spying__functions)                               | 使用`cy.stub()` 来测试函数调用                                |
| [模拟`window.fetch`](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/stubbing-spying__window-fetch)                  | 使用`cy.stub()` 来控制获取请求                             |
| [使用`cy.intercept`做挡板](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/stubbing-spying__intercept)               | 使用`cy.intercept` API控制网络                             |
| [模拟 `window.open` 和 `console.log`](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/stubbing-spying__window)       | 使用`cy.stub()` 和 `cy.spy()`来测试应用程序的行为           |
| [模拟 `window.print`](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/stubbing-spying__window-print)                 | 使用`cy.stub() `来测试 从应用程序发出的调用`window.print` |
| [模拟 Google Analytics](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/stubbing-spying__google-analytics)           | 使用`cy.stub()` 和 `cy.intercept()`来测试谷歌Analytics调用  |
| [模拟 `console`上的调用](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/stubbing-spying__console)                    | 使用`cy.stub()`'来测试和控制`console`调用的方法        |
| [模拟响应加载](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/stubbing__resources)                                   | Use `MutationObserver` to stub resource loading like `img` tags       |
| [模拟 `navigator.cookieEnabled` 属性](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/stubbing__navigator)           | Use `cy.stub()` to mock the `navigator.cookieEnabled` property        |

## 单元测试

| 配方                                                                                                                           | 描述                               |
| ----------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------- |
| [应用程序代码](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/unit-testing__application-code)       | 导入并测试您自己的应用程序代码 |
| [在React中上传文件](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/file-upload-react)               | 在React应用程序中上传测试文件     |

**注意:** 正在寻找React/Vue组件测试配方? 阅读[介绍Cypress组件测试运行器-新的7.0.0](https://www.cypress.io/blog/2021/04/06/introducing-the-cypress-component-test-runner/) 博客文章.

## 服务通信

| 配方                                                                                                                                                       | 描述                                                                                                                  |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| [引导你的应用](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/server-communication__bootstrapping-your-app)                     | 在应用程序中添加测试数据                                                                                         |
| [在Node中对数据库造数](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/server-communication__seeding-database-in-node)            | 在数据库中添加测试数据                                                                                            |
| [XHR 断言](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/server-communication__xhr-assertions)                                 | 监视和断言应用程序的网络调用                                                                                |
| [访问第二域](https://github.com/cypress-io/cypress-example-recipes/tree/master/examples/server-communication__visit-2nd-domain)                             | 从两个不同的测试访问两个不同的域，并将值从一个测试传递到另一个测试                          |
| [在spec之间传递值](https://github.com/cypress-io/cypress-example-recipes/blob/master/examples/server-communication__pass-value-between-specs)                | 通过`cy.task`使用插件文件 在spec之间传递一个值                                                           |
| [流测试结果](https://github.com/cypress-io/cypress-example-recipes/blob/master/examples/server-communication__stream-tests)                                  | 将每个测试结果从浏览器流到插件，并通过IPC流到外部进程                                      |
| [离线](https://github.com/cypress-io/cypress-example-recipes/blob/master/examples/server-communication__offline)                                            | 在网络离线时测试web应用程序                                                                           |
| [服务器时间](https://github.com/cypress-io/cypress-example-recipes/blob/master/examples/server-communication__server-timing)                                 | 报告来自Cypress测试的服务器计时结果                                                                               |
| [等待API完成](https://github.com/cypress-io/cypress-example-recipes/blob/master/examples/server-communication__wait-for-api)                                 | 使用`cy.request`调用后端请求，直到它响应                                                                        |
| [发起HTTP请求](https://github.com/cypress-io/cypress-example-recipes/blob/master/examples/server-communication__request)                                     | 如何使用`cy.request`, `window.fetch`, 和 `cy.task` 命令向服务器发出HTTP请求，无论是否使用cookie |

## 其他Cypress配方

| 配方                                                                                                                    | 描述                                                                                |
| ---------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| [视觉检测](/guides/tooling/visual-testing)                                                                              | 官方Cypress指南的视觉测试                                                   |
| [代码覆盖率](/guides/tooling/code-coverage)                                                                             |官方Cypress指南的代码覆盖                                                    |
| [检测页面重载](https://glebbahmutov.com/blog/detect-page-reload/)                                                       | 如何从Cypress测试中检测使用对象属性断言重新加载页面       |
| [容器中运行](https://www.cypress.io/blog/2019/05/02/run-cypress-with-a-single-docker-command/)                          | 用一个Docker命令运行Cypress                                                   |
| [SSR E2E](https://glebbahmutov.com/blog/ssr-e2e/)                                                                      | 服务器端呈现页面的端到端测试                                          |
| [采用TS别名](https://glebbahmutov.com/blog/using-ts-aliases-in-cypress-tests/)                                          | 在Cypress测试中使用TypeScript别名                                                 |
| [模拟导航 API](https://glebbahmutov.com/blog/stub-navigator-api/)                                                       | 在端到端测试中的模拟导航器API                                                     |
| [可读的 Cypress.io 测试](https://glebbahmutov.com/blog/readable-tests/)                                                  | 如何使用自定义命令和自定义Chai断言编写可读的测试               |
| [有条件的并行化](https://glebbahmutov.com/blog/parallel-or-not/)                                                         | 根据环境变量在CircleCI上以并行模式运行Cypress                |
| [`.should()` 回调](https://glebbahmutov.com/blog/cypress-should-callback/)                                              | `.should(cb)`断言的例子                                                       |
| [React 组件测试](https://glebbahmutov.com/blog/cypress-jump/)                                                           S| 使用JSX创建React组件，并从Cypress测试中将其注入到实时应用程序中 |
| [对Vuex数据存储进行单元测试](https://dev.to/bahmutov/unit-testing-vuex-data-store-using-cypress-io-test-runner-3g4n)      | 演练对数据存储进行单元测试                          |
| [三重测试静态站点](https://glebbahmutov.com/blog/triple-tested/)                                                         | 如何在部署到GitHub页面之前和之后测试三次静态站点           |

## 社区的配方

| 配方                                                                              | 描述                                 |
| -------------------------------------------------------------------------------- | ------------------------------------------- |
| [视觉回归测试](https://github.com/mjhea0/cypress-visual-regression)               | 向Cypress添加视觉回归测试 |
| [代码覆盖率](https://github.com/paulfalgout/cypress-coverage-example)             | Cypress覆盖率报告               |
| [Cucumber](https://github.com/TheBrainFamily/cypress-cucumber-example)           | Cypress 与 Cucumber的例子      |
| [Jest](https://github.com/TheBrainFamily/jest-runner-cypress-example)            |  the jest-runner-cypress例子         |
