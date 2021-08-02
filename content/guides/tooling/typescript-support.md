---
title: TypeScript
---

Cypress附带[官方类型声明](https://github.com/cypress-io/cypress/tree/develop/cli/types) 用于 [TypeScript](https://www.typescriptlang.org/) 。这允许你用TypeScript编写测试。

### 安装TypeScript

你需要在你的项目中安装TypeScript 3.4+才能在Cypress中获得TypeScript支持.

#### 使用 npm

```shell
npm install --save-dev typescript
```

#### 使用 yarn

```shell
yarn add --dev typescript
```

### 设置开发环境

请参考你的代码编辑器 [TypeScript 编辑器支持文档](https://github.com/Microsoft/TypeScript/wiki/TypeScript-Editor-Support) ,按照说明对IDE支持TypeScript和[智能代码补全](/guides/tooling/IDE-integration#Intelligent-Code-Completion)配置。TypeScript支持内置在[Visual Studio Code](https://code.visualstudio.com/), [Visual Studio](https://www.visualstudio.com/), and [WebStorm](https://www.jetbrains.com/webstorm/)  -所有其他编辑器都需要额外的设置。

### 配置 tsconfig.json

我们建议在[`cypress` 文件夹](/guides/core-concepts/writing-and-organizing-tests#Folder-Structure)内的[`tsconfig.json`](http://www.typescriptlang.org/docs/handbook/tsconfig-json.html) 中进行以下配置。

```json
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["es5", "dom"],
    "types": ["cypress"]
  },
  "include": ["**/*.ts"]
}
```

`"types"`会告诉TypeScript编译器只包含来自Cypress的类型定义.这将解决项目也使用`@types/chai` 或 `@types/jquery`的实例。 由于[Chai](/guides/references/bundled-tools#Chai) 和 [jQuery](/guides/references/bundled-tools#Other-Library-Utilities) 是全局命名空间，不兼容的版本将导致包管理器(`yarn`或`npm`)嵌套，包括多个定义，并导致冲突。

<Alert type="warning">

如果上面的设置不奏效，你可能需要重新启动你的IDE的TypeScript服务。例如:

VS Code(在.ts或.js文件中):

- 打开命令面板(Mac: `cmd+shift+p`， Windows: `ctrl+shift+p`)
- 输入"restart ts"并选择"TypeScript: restart ts server."选项

如果这不起作用，尝试重新启动IDE。

</Alert>

### 自定义命令的类型

当添加[自定义命令](/api/cypress-api/custom-commands) 到`cy`对象时，你可以手动添加它们的类型以避免TypeScript错误。

例如，如果你添加命令`cy。dataCy`进入你的[supportFile](/guides/references/configuration#Folders-Files)，像这样:

```typescript
// cypress/support/index.ts
Cypress.Commands.add('dataCy', (value) => {
  return cy.get(`[data-cy=${value}]`)
})
```

然后你可以将`dataCy`命令添加到Cypress可链全局接口(之所以这么叫，是因为命令被链接在一起)到你的`cypress/support/index.ts`文件。

```typescript
// 在 cypress/support/index.ts
// 加载Cypress模块附带的类型定义
/// <reference types="cypress" />

declare namespace Cypress {
  interface Chainable {
    /**
     * Custom command to select DOM element by data-cy attribute.
     * @example cy.dataCy('greeting')
     */
    dataCy(value: string): Chainable<Element>
  }
}
```

<Alert type="info">

方法类型上面的漂亮详细的JSDoc注释将非常受自定义命令的任何用户的欢迎。

</Alert>

在您的spec中，您现在可以按预期使用自定义命令

```typescript
// 来自你的 cypress/integration/spec.ts
it('works', () => {
  cy.visit('/')
  // 智能感知和TS编译器不应该抱怨未知的方法
  cy.dataCy('greeting')
})
```

#### 例子

- 查找[独立示例](https://github.com/cypress-io/add-cypress-custom-command-in-typescript).
- 参见[添加自定义命令](https://github.com/cypress-io/cypress-example-recipes#fundamentals) 例子配方。
- 你可以找到一个使用TypeScript 编写的自定义命令的例子： [omerose/cypress-support](https://github.com/omerose/cypress-support) 代码库.
- 示例项目[cypress-example-todomvc custom commands](https://github.com/cypress-io/cypress-example-todomvc#custom-commands) 使用自定义命令来避免样板代码。

### 自定义断言的类型

如果扩展Cypress断言，就可以扩展断言类型，使TypeScript编译器理解这些新方法。 参见[配方: 添加 Chai 断言](/examples/examples/recipes#Fundamentals)。

### 类型插件

你可以在你的[plugins文件](/guides/tooling/plugins-guide) 中使用Cypress的类型声明，方法如下:

```javascript
// cypress/plugins/index.ts

/// <reference types="cypress" />

/**
 * @type {Cypress.PluginConfig}
 */
module.exports = (on, config) => {}
```

### 与Jest类型冲突

如果你在同一个项目中同时使用Jest和Cypress，那么两个测试运行器全局注册的TypeScript类型可能会发生冲突.例如，Jest和Cypress都为`describe` 和 `it`提供函数类型，导致冲突。 Jest和Expect(捆绑在Cypress中)都为`expect` 断言等提供了冲突类型.有两种解决方案可以解开这些类型:

1. 配置一个单独的`tsconfig.json`用于端到端测试.看到我们的例子 [cypress-io/cypress-and-jest-typescript-example](https://github.com/cypress-io/cypress-and-jest-typescript-example) .
2. 使用NPM包[local-cypress](https://github.com/bahmutov/local-cypress)删除Cypress全局变量. 详情请阅读博客文章[如何避免使用全局Cypress变量](https://glebbahmutov.com/blog/local-cypress/).

## 历史

| Version                                     | Changes                                                                                    |
| ------------------------------------------- | ------------------------------------------------------------------------------------------ |
| [5.0.0](/guides/references/changelog#5-0-0) | Raised minimum required TypeScript version from 2.9+ to 3.4+                               |
| [4.4.0](/guides/references/changelog#4-4-0) | Added support for TypeScript without needing your own transpilation through preprocessors. |

## 另请参阅

- [IDE集成](/guides/tooling/IDE-integration)
