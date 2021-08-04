---
title: 环境变量
---

<Alert type="warning">

<strong class="alert-header">操作系统级别和Cypress环境变量之间的差异</strong>

在Cypress中，“环境变量”是指通过“Cypress.env”访问的变量。这些与操作系统级别的环境变量不同. 然而, [可以从操作系统级别的环境变量设置Cypress环境变量](/guides/guides/environment-variables.html#Option-3-CYPRESS).

</Alert>

环境变量是有价值的:

- 不同开发人员的机器上的环境变量不相同.
- 不同环境的环境变量是不同的: _(开发环境，准备环境，质量环境，生产环境)_
- 经常变化，并且是高度动态的.

环境变量可以很容易地更改—特别是在CI中运行时.

#### 替换测试中的硬编码:

```javascript
cy.request('https://api.acme.corp') // 这会破坏其他环境
```

#### 我们可以把它移到Cypress环境变量中:

```javascript
cy.request(Cypress.env('EXTERNAL_API')) // 指向一个动态的环境变量
```

<Alert type="info">

<strong class="alert-header">使用 'baseUrl'</strong>

环境变量非常擅长指向外部服务和服务器，或者存储密码或其他凭据.

但是，您不需要使用环境变量来指向测试中的源和域（origin and domain）. 应该使用`baseUrl`.

[`cy.visit()`](/api/commands/visit) 和 [`cy.request()`](/api/commands/request)会自动以这个值作为前缀-从而在参数中避免指定它们.

`baseUrl`可以在配置文件中设置 (`cypress.json` 默认) -但是你可以在你的操作系统中设置一个环境变量来覆盖它，如下所示。

```shell
CYPRESS_BASE_URL=https://staging.app.com cypress run
```

</Alert>

## 设置

设置环境变量有5种不同的方法。每一个都有一个稍微不同的使用场景.

**_总结一下，你可以:_**

- [在配置文件中设置](#Option-1-configuration-file)
- [创建一个 `cypress.env.json`](#Option-2-cypress-env-json)
- [设置以 `CYPRESS_*`为前缀的环境变量](#Option-3-CYPRESS_)
- [传递给命令行的参数 `--env`](#Option-4-env)
- [用插件设置一个环境变量.](#Option-5-Plugins)
- [在测试配置中设置一个环境变量.](#Option-6-Test-Configuration)

不要觉得必须只选择一种方法. 在本地开发中使用一种策略，而在[CI](/guides/continuous-integration/introduction)中使用另一种策略是很常见的.

在运行测试时，可以使用[`Cypress.env`](/api/cypress-api/env)函数访问环境变量的值.

### 选项 #1: 配置文件

在[配置文件(`cypress.json` 默认)](/guides/references/configuration)中在`env` 键下的设置的任何键值都将成为环境变量。

```json
{
  "projectId": "128076ed-9868-4e98-9cef-98dd8b705d75",
  "env": {
    "login_url": "/login",
    "products_url": "/products"
  }
}
```

#### 测试文件

```javascript
Cypress.env() // {login_url: '/login', products_url: '/products'}
Cypress.env('login_url') // '/login'
Cypress.env('products_url') // '/products'
```

#### 总结

<Alert type="success">

<strong class="alert-header">优点</strong>

- 对于那些需要签入源代码控制并在所有机器上保持相同的值来说，这很好.

</Alert>

<Alert type="danger">

<strong class="alert-header">缺点</strong>

- 仅适用于所有机器上应该相同的值。

</Alert>

### 选项 #2: `cypress.env.json`

你可以创建自己的`cypress.env.json`文件，Cypress将自动检查. 这里的值将覆盖[配置文件中冲突的环境变量 (默认是`cypress.json`](/guides/references/configuration).

这种策略是非常有用的,因为如果您添加的`cypress.env.json`到你的`.gitignore`，这里的值对于每个开发人员的机器都可以不同.

```json
{
  "host": "veronica.dev.local",
  "api_server": "http://localhost:8888/api/v1/"
}
```

#### 在测试文件中

```javascript
Cypress.env() // {host: 'veronica.dev.local', api_server: 'http://localhost:8888/api/v1'}
Cypress.env('host') // 'veronica.dev.local'
Cypress.env('api_server') // 'http://localhost:8888/api/v1/'
```

#### 总结

<Alert type="success">

<strong class="alert-header">优点</strong>

- 仅用于环境变量的专用文件.
- 使您能够从其他构建过程生成此文件.
- 每台机器上的值可以不同 (如果没有签入源代码控制).
- 支持嵌套字段(对象)，例如. `{ testUser: { name: '...', email: '...' } }`.

</Alert>

<Alert type="danger">

<strong class="alert-header">缺点</strong>

- 你又要多处理一份文件.
- 对于1或2个环境变量来说，过度使用.

</Alert>

### 选项 #3: `CYPRESS_*`

您的机器上任何以`CYPRESS_` or `cypress_` 开头的系统级环境变量将自动添加到`Cypress`的环境变量并供您使用。

冲突的值将覆盖配置文件(`cypress.json` 默认) 和 `cypress.env.json`中的值.

在添加环境变量时，Cypress将去掉`CYPRESS_`前缀.

<Alert type="danger">

环境变量`CYPRESS_INTERNAL_ENV` 是保留的，不应该设置.

</Alert>

#### 从命令行设置cypress环境变量

```shell
export CYPRESS_HOST=laura.dev.local
```

```shell
export cypress_api_server=http://localhost:8888/api/v1/
```

#### 在测试文件里

在您的测试文件中，您应该省略 `CYPRESS_` 或 `cypress_`前缀

```javascript
Cypress.env() // {HOST: 'laura.dev.local', api_server: 'http://localhost:8888/api/v1'}
Cypress.env('HOST') // 'laura.dev.local'
Cypress.env('api_server') // 'http://localhost:8888/api/v1/'
```

#### 总结:

<Alert type="success">

<strong class="alert-header">优点</strong>

- 快速定义一些值.
- 可以存储在您的`bash_profile`中.
- 允许不同机器之间的动态值.
- 对于CI环境尤其有用。

</Alert>

<Alert type="danger">

<strong class="alert-header">缺点</strong>

- 和其他选项相比，这些值从何而来并不明显。
- 不支持嵌套字段。

</Alert>

### 选项 #4: `--env`

最后，当[使用CLI工具](/guides/guides/command-line#cypress-run)时，您可以将环境变量作为选项传入。.

这里的值将覆盖所有其他冲突的环境变量。

你可以在[cypress run](/guides/guides/command-line#cypress-run)中使用`--env` 参数.

<Alert type="warning">

多个值之间必须用逗号隔开，不能用空格。

</Alert>

#### 从命令行或CI 使用

```shell
cypress run --env host=kevin.dev.local,api_server=http://localhost:8888/api/v1
```

#### 测试文件:

```javascript
Cypress.env() // {host: 'kevin.dev.local', api_server: 'http://localhost:8888/api/v1'}
Cypress.env('host') // 'kevin.dev.local'
Cypress.env('api_server') // 'http://localhost:8888/api/v1/'
```

#### 总结 -

<Alert type="success">

<strong class="alert-header">优点</strong>

- 不需要对文件或配置进行任何更改.
- 更清楚环境变量的来源。
- 允许不同机器之间的动态值。
- 覆盖所有其他形式的设置的环境变量.

</Alert>

<Alert type="danger">

<strong class="alert-header">缺点</strong>

- 在使用Cypress的任何地方编写`--env` 选项都很痛苦.
- 不支持嵌套字段。

</Alert>

### 选项 #5: 插件

您可以使用插件通过Node代码动态地设置环境变量，而不是在文件中设置环境变量. 这使您能够使用`fs`读取配置值并动态更改它们。

例如，如果你使用[dotenv](https://github.com/motdotla/dotenv#readme)包读取`.env`文件，然后可以从`process.env`对象获取所需的环境变量，并将它们放入`config.env`中。使其在测试中可用:

```
// .env file
USER_NAME=aTester
```

```js
// plugins/index.js
require('dotenv').config()

module.exports = (on, config) => {
  // 从 process.env复制任何需要的变量到config.env
  config.env.username = process.env.USER_NAME

  // 不要忘记返回修改后的配置对象!
  return config
}

// integration/spec.js
it('has username to use', () => {
  expect(Cypress.env('username')).to.be.a('string')
})
```

[我们已经在这里详细说明了如何做到这一点.](/api/plugins/configuration-api)

#### 总结

<Alert type="success">

<strong class="alert-header">优点</strong>

- 最大限度的灵活性
- 能够以任何方式管理配置

</Alert>

<Alert type="danger">

<strong class="alert-header">缺点</strong>

- 需要使用Node编写的知识
- 更具挑战性的

</Alert>

### 选项 #6: 测试配置

通过将 `env` 值传递给[测试配置](/guides/references/configuration#Test-Configuration)，可以为特定套件或测试设置环境变量。.

#### 测试集配置

```js
// 为单个测试集更改环境变量
describe(
  'test against Spanish site',
  {
    env: {
      language: 'es',
    },
  },
  () => {
    it('displays Spanish', () => {
      cy.visit(`https://docs.cypress.io/${Cypress.env('language')}/`)
      cy.contains('¿Por qué Cypress?')
    })
  }
)
```

#### 单个测试的配置

```js
// 更改单个测试的环境变量
it(
  'smoke test develop api',
  {
    env: {
      api: 'https://dev.myapi.com',
    },
  },
  () => {
    cy.request(Cypress.env('api')).its('status').should('eq', 200)
  }
)

// 更改单个测试的环境变量
it(
  'smoke test staging api',
  {
    env: {
      api: 'https://staging.myapi.com',
    },
  },
  () => {
    cy.request(Cypress.env('api')).its('status').should('eq', 200)
  }
)
```

#### 总结

<Alert type="success">

<strong class="alert-header">Benefits</strong>

- 只在测试集或单个测试范围生效。
- 更清楚环境变量的来源。
- 允许测试之间的动态值

</Alert>

## 配置覆盖

如果您的环境变量匹配一个标准配置键，那么它们将覆盖配置值，而不是设置一个“环境变量”.

**_更改`baseUrl`配置值 /不会在 `Cypress.env()`设置环境变量_**

```shell
export CYPRESS_BASE_URL=http://localhost:8080
```

**_'foo'不匹配配置/ 在 `Cypress.env()`内设置环境变量_**

```shell
export CYPRESS_FOO=bar
```

您可以[阅读更多关于环境变量如何改变配置的信息](/guides/references/configuration).

## 另请参阅

- [Cypress.env()](/api/cypress-api/env)
- [配置 API](/api/plugins/configuration-api)
- [环境变量的配方](/examples/examples/recipes#Fundamentals)
- [测试配置](/guides/references/configuration#Test-Configuration)
- [传递环境变量:提示和技巧](https://glebbahmutov.com/blog/cypress-tips-and-tricks/#pass-the-environment-variables-correctly)
- [在端到端加密测试中对密码保密](https://glebbahmutov.com/blog/keep-passwords-secret-in-e2e-tests/)
