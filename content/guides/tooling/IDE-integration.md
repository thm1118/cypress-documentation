---
title: IDE集成
---

## 文件打开的偏好设置

当在 [Test Runner](/guides/core-concepts/test-runner)中 [命令日志](/guides/core-concepts/test-runner#Open-files-in-your-IDE)或[error](/guides/guides/debugging#Errors)中单击文件路径时，Cypress将尝试打开系统上的文件。如果编辑器支持文件的内联高亮显示，则文件将在光标位于感兴趣的行和列时打开。

<DocsImage src="/img/guides/file-opener-ide-go-to-line.gif" alt="Open file at line in VS Code" ></DocsImage>

当你第一次点击文件路径时，Cypress会提示你选择打开文件的位置。您可以选择在您的:

- 文件系统(例如MacOS上的Finder, Windows上的文件浏览器)
- 位于系统上的IDE
- 指定的应用程序路径

<Alert type="warning">

Cypress试图在您的系统中找到可用的文件编辑器，并将其显示为选项. 如果没有列出首选编辑器，可以通过选择**Other**指定它的(完整)路径. Cypress将尽一切努力打开文件，_但不能保证对每个应用程序都有效_.

</Alert>

在设置你的文件启动器首选项后，任何文件将在你选择的应用程序中自动打开而不提示你选择. 如果您想更改您的选择，您可以在Cypress测试运行器的设置选项卡中单击文件启动器首选项下进行。

<DocsImage src="/img/guides/file-opener-preference-settings-tab.png" alt="screenshot of Test Runner settings tab with file opener preference panel" ></DocsImage>

## 扩展和插件

有许多第三方IDE扩展和插件可以帮助您将IDE与Cypress集成.

### Visual Studio Code

- [Cypress Fixture-IntelliSense](https://marketplace.visualstudio.com/items?itemName=JosefBiehler.cypress-fixture-intellisense): 支持您的[cy.fixture()](/api/commands/fixture) 和 [`cy.route(..., "fixture:")`](/api/commands/route) 命令，为现有的fixture提供智能感知。
- [Cypress Helper](https://marketplace.visualstudio.com/items?itemName=Shelex.vscode-cy-helper): 与Cypress集成的各种助手和命令.
- [Cypress Snippets](https://marketplace.visualstudio.com/items?itemName=andrew-codes.cypress-snippets): 有用的 Cypress代码片段.
- [Open Cypress](https://marketplace.visualstudio.com/items?itemName=tnrich.vscode-extension-open-cypress): 允许你直接从VS Code打开Cypress的 spec和单一的`it()`块。
- [Test Utils](https://marketplace.visualstudio.com/items?itemName=chrisbreiding.test-utils): 轻松添加或删除`.only` 和 `.skip`。跳过使用键盘快捷键或命令面板的“修改器”.

### IntelliJ Platform

兼容IntelliJ IDEA, AppCode, CLion, GoLand, PhpStorm, PyCharm, Rider, RubyMine，和WebStorm.

- [Cypress Support](https://plugins.jetbrains.com/plugin/13819-intellij-cypress): 在通用Intellij测试框架下集成Cypress.
- [Cypress Support Pro](https://plugins.jetbrains.com/plugin/13987-cypress-pro): Cypress Support插件的一个改进版本，具有从IDE调试，高级自动完成，内置记录器和其他功能。

## Intelligent 代码自动完成

### 编写测试

#### 特征

Cypress可以使用智能感知。 它在编写测试时直接在IDE中提供智能代码建议. 典型的智能感知弹出窗口显示命令定义、代码示例和完整文档页面的链接。

##### 当键入Cypress命令时自动完成

<DocsVideo src="/img/snippets/intellisense-cypress-assertion-matchers.mp4"></DocsVideo>

##### 编写Cypress命令，以及鼠标悬停在命令上时，提供显著的帮助

<DocsVideo src="/img/snippets/intellisense-method-signature-examples.mp4"></DocsVideo>

##### 在键入断言链时自动完成，包括仅在测试DOM元素时显示DOM断言.

<DocsVideo src="/img/snippets/intellisense-assertion-chainers.mp4"></DocsVideo>

#### 设置你的开发环境

本文档假定您已[安装Cypress](/guides/getting-started/installing-cypress).

Cypress附带TypeScript的[类型声明](https://github.com/cypress-io/cypress/tree/develop/cli/types) 。 现代文本编辑器可以使用这些类型声明来显示spec文件中的智能感知.

##### 三斜杠指令

当键入Cypress命令或断言时，看到智能感知的最简单方法是在JavaScript或TypeScript测试文件的头部添加[三斜杠指令](http://www.typescriptlang.org/docs/handbook/triple-slash-directives.html) . 这将在每个文件的基础上开启智能感知。复制下面的注释行并将其粘贴到您的spec文件中.

```js
/// <reference types="Cypress" />
```

<DocsVideo src="/img/snippets/intellisense-setup.mp4"></DocsVideo>

如果你编写[自定义命令](/api/cypress-api/custom-commands)并为它们提供TypeScript定义，你可以使用三斜杠指令来显示智能感知，即使你的项目只使用JavaScript。例如，如果你的自定义命令是用`cypress/support/commands.js`编写的，而你用 `cypress/support/index.d.ts`描述它们，使用:

```js
// Cypress对象“cy”的类型定义
/// <reference types="cypress" />

// 自定义命令(如“createDefaultTodos”)的类型定义
/// <reference types="../support" />
```

参见[`cypress-example-todomvc`](https://github.com/cypress-io/cypress-example-todomvc#cypress-intellisense)库获取一个可工作示例.

如果三重斜杠指令不起作用，请参考你的代码编辑器[TypeScript的编辑器支持文档](https://github.com/Microsoft/TypeScript/wiki/TypeScript-Editor-Support)，并按照你的IDE的说明获得 [TypeScript支持](/guides/tooling/typescript-support) 和智能代码完成，首先在你的开发人员环境中配置。TypeScript支持内置在[Visual Studio Code](https://code.visualstudio.com/), [Visual Studio](https://www.visualstudio.com/), 和 [WebStorm](https://www.jetbrains.com/webstorm/)  -所有其他编辑器都需要额外的设置。

##### 通过`jsconfig`引用类型声明

可以不用在每个JavaScript spec 文件中添加三斜杠指令，一些ide(比如VS Code)理解一个通用的项目的根目录下的`jsconfig`文件. 在该文件中，可以包含Cypress模块和测试文件夹。

```json
{
  "include": ["./node_modules/cypress", "cypress/**/*.js"]
}
```

智能代码完成现在应该显示在常规JavaScript  spec 文件中的`cy` 命令的帮助。

##### 通过`tsconfig`引用类型声明

在你的[`cypress` folder](/guides/core-concepts/writing-and-organizing-tests#Folder-Structure)文件夹中添加一个[' tsconfig.json '](http://www.typescriptlang.org/docs/handbook/tsconfig-json.html) ，使用以下配置应该可以让智能代码完成工作。

```json
{
  "compilerOptions": {
    "allowJs": true,
    "types": ["cypress"]
  },
  "include": ["**/*.*"]
}
```

### 配置

#### 特征:

当编辑[配置文件(默认`cypress.json`)](/guides/references/configuration)时， 你能通过[json schema file](https://on.cypress.io/cypress.schema.json)在IDE中为每个配置属性获取智能工具提示。

##### 属性帮助时，写入和悬停的配置键

<DocsVideo src="/img/snippets/intellisense-cypress-config-tooltips.mp4"></DocsVideo>

##### 具有智能提示的默认属性列表

<DocsVideo src="/img/snippets/intellisense-config-defaults.mp4"></DocsVideo>

#### 设置你的开发环境:

[Visual Studio Code](https://code.visualstudio.com/) 和 [Visual Studio](https://www.visualstudio.com/)默认支持使用JSON模式的智能代码完成.所有其他编辑器都需要额外的配置或插件来支持JSON模式.

要在[Visual Studio Code](https://code.visualstudio.com/)中设置，你可以打开 `Preferences / Settings / User Settings` 并添加 `json.schemas`.如果`cypress.json`不是默认配置文件，一定要更换。

```json
{
  "json.schemas": [
    {
      "fileMatch": ["cypress.json"],
      "url": "https://on.cypress.io/cypress.schema.json"
    }
  ]
}
```

或者你可以直接在你的Cypress配置文件中添加一个`$schema`键，这是一个与项目的所有合作者共享schema的好方法。

```json
"$schema": "https://on.cypress.io/cypress.schema.json",
```

### 另请参阅

- [用正确的TypeScript类型向全局`window` 添加自定义属性](https://github.com/bahmutov/test-todomvc-using-app-actions#intellisense)
