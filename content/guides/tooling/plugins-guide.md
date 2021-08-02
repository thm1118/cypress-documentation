---
title: 插件
---

插件可以让你进入，修改，或扩展Cypress的内部行为。

通常，作为用户，您的所有测试代码、应用程序和Cypress命令都在浏览器中执行。但是Cypress也是一个可以使用插件的Node进程。

> 插件使您能够进入浏览器外运行的Node进程。

插件是一个“接缝”，你可以编写自己的自定义代码，在Cypress生命周期的特定阶段执行. 当[nodeVersion](/guides/references/configuration#Node-version) 在配置中被设置时，它还允许你在自己的Node版本中执行代码。

<Alert type="info">

<strong class="alert-header">This is a brief overview</strong>

如果你想了解更多关于如何编写插件的细节，我们已经编写了API文档，告诉你如何处理每个插件事件.

你可以[在这里查看API文档](/api/plugins/writing-a-plugin).

</Alert>

## 使用案例

### 配置

有了插件，你可以通过编程方式改变配置文件中的[配置(默认`cypress.json` )](/guides/references/configuration)和环境变量 ,如 [`cypress.env.json`](/guides/guides/environment-variables#Option-2-cypress-env-json),  [ 命令行](/guides/guides/command-line), 或系统环境变量.

这使你能够做如下事情:

- 使用具有自己配置的多个环境
- 根据环境交换环境变量
- 使用内置的 `fs` lib读取配置文件
- 更改用于测试的浏览器列表
- 在 `yml`中编写配置

请查看我们的[配置API文档](/api/plugins/configuration-api)，它描述了如何使用这个事件。

### 预处理

事件`file:preprocessor`用于自定义测试代码如何被编译并发送到浏览器. 默认情况下，Cypress会处理ES2015+、TypeScript和CoffeeScript，并使用webpack将其打包以供浏览器使用。

你可以使用`file:preprocessor`事件来做如下事情:

- 添加最新的ES\*支持。
- 用ClojureScript编写测试代码.
- 自定义Babel设置以添加您自己的插件.
- 定制编译TypeScript的选项.
- 将webpack替换为Browserify或其他任何东西.

请查看我们的[文件预处理器API文档](/api/plugins/preprocessors-api)，它描述了如何使用这个事件.

### 运行生命周期

事件[`before:run`](/api/plugins/before-run-api) 和 [`after:run`](/api/plugins/after-run-api) 分别在运行之前和之后发生。

你可以使用[`before:run`](/api/plugins/before-run-api) 来做类似的事情:

- 设置运行报告
- 启动一个计时器来计算运行所需的时间

你可以使用[`after:run`](/api/plugins/after-run-api) 来做类似的事情:

- 完成在`before:run`中设置的运行报告
- 停止在`before:run`中设置的运行计时器

### Spec 生命周期

事件[`before:spec`](/api/plugins/before-spec-api) 和 [`after:spec`](/api/plugins/after-spec-api) 分别在单个spec运行之前和之后运行.

你可以使用[`before:spec`](/api/plugins/before-spec-api)来做类似的事情:

- 建立spec运行的报告
- 为spec启动一个计时器来计时所需的时间

你可以使用[`after:spec`](/api/plugins/after-spec-api) 来做如下事情:

- 在`before:spec`中完成报告设置
- 停止在`before:spec`中设置的spec的计时器
- 删除为spec录制的视频. 这可以防止压缩和上传视频所需的时间和计算资源。 您可以根据spec的结果有条件地这样做，比如如果它通过了(因此为调试目的保留失败测试的视频)。

查看[Before Spec API doc](/api/plugins/before-spec-api) 和 [After Spec API doc](/api/plugins/after-spec-api)，它们描述了如何使用这些事件。

### 浏览器启动

事件`before:browser:launch`可用于修改每个特定浏览器的启动参数。

你可以使用`before:browser:launch`事件来做如下事情:

- 加载一个Chrome扩展
- 启用或禁用实验性的chrome功能
- 控件加载了哪些Chrome组件

看看我们的[浏览器启动API文档](/api/plugins/browser-launch-api) ，里面描述了如何使用这个事件.

### 截屏处理

事件`after:screenshot`在截图被获取并保存到磁盘后被调用.

你可以使用`after:screenshot`事件来做如下事情:

- 保存截图的详细信息
- 重命名的截图
- 通过调整大小或裁剪来操作截图图像

查看我们的[After Screenshot API文档](/api/plugins/after-screenshot-api)，它描述了如何使用这个事件。

### cy.task

事件`task`与[`cy.task()`](/api/commands/task) 命令一起使用。 它允许您在Node中编写任意代码来完成在浏览器中不可能完成的任务. 当[nodeVersion](/guides/references/configuration#Node-version) 在配置中被设置时，它还允许你在自己的Node版本中执行代码。

你可以使用`task`事件来做如下事情:

- 操作数据库(播种、读取、写入等)
- 在Node中存储想要持久化的状态(因为驱动程序在访问时完全刷新)
- 执行并行任务(比如在Cypress外发出多个http请求)
- 运行外部进程(比如旋转另一个浏览器(如Safari或puppeteer)的Webdriver实例)

##### <Icon name="graduation-cap"></Icon> 真实世界的例子

[Real World App (RWA)](https://github.com/cypress-io/cypress-realworld-app) 使用[tasks](/api/commands/task) 重新种子它的数据库，并为各种测试场景过滤找到测试数据。

<Alert type="warning">

⚠️ 此代码是[plugins文件](/guides/core-concepts/writing-and-organizing-tests.html#Plugin-files) 的一部分，因此在Node环境中执行. 您不能在这个文件中调用`Cypress` 或 `cy`命令，但您可以直接访问文件系统和操作系统的其余部分。

</Alert>

```ts
// cypress/plugins/index.ts

  on("task", {
    async "db:seed"() {
      // 用测试数据填充数据库
      const { data } = await axios.post(`${testDataApiEndpoint}/seed`);
      return data;
    },

    // 从数据库中获取测试数据(MySQL, PostgreSQL, etc...)
    "filter:database"(queryPayload) {
      return queryDatabase(queryPayload, (data, attrs) => _.filter(data.results, attrs));
    },
    "find:database"(queryPayload) {
      return queryDatabase(queryPayload, (data, attrs) => _.find(data.results, attrs));
    },
  });
  // ..
};
```

> _<Icon name="github"></Icon> 源码: [cypress/plugins/index.ts](https://github.com/cypress-io/cypress-realworld-app/blob/develop/cypress/plugins/index.ts)_

查看[Real World App test suites](https://github.com/cypress-io/cypress-realworld-app/tree/develop/cypress/tests/ui)，查看这些任务的运行情况.

## 插件列表

Cypress维护了一个由我们和社区创建的插件列表。你可以`npm install`下面列出的任何插件:

[我们的展示的Cypress插件列表。](/plugins/directory)

## 安装插件

来自我们[官方列表](/plugins/directory)的插件都是npm模块. 这使得它们可以单独进行版本控制和更新，而不需要更新Cypress本身。

你可以使用NPM安装任何已发布的插件:

```shell
npm install <plugin name> --save-dev
```

## 使用一个插件

无论你是安装一个npm模块，还是想要编写自己的代码，你都应该在这个文件中完成:

```text
cypress/plugins/index.js
```

<Alert type="info">

默认情况下，Cypress为新项目创建该文件，但如果您有一个现有的项目，则自己创建该文件。

</Alert>

在这个文件中，您将导出一个函数。Cypress将调用这个函数，将项目的配置传递给您，并使您能够绑定到公开的事件。

```javascript
// cypress/plugins/index.js

// export a function
module.exports = (on, config) => {
  // bind to the event we care about
  on('<event>', (arg1, arg2) => {
    // plugin stuff here
  })
}
```

有关编写插件的更多信息，请[查看我们的API文档这里](/api/plugins/writing-a-plugin).
