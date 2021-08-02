---
title: 报表
---

因为Cypress是建在Mocha之上的，这意味着任何为Mocha而建的报表都可以和Cypress一起使用。这里是Mocha内置报表的清单.

- [Mocha的内置报表](https://mochajs.org/#reporters)

默认情况下，Cypress使用`spec`报告器将信息输出到`STDOUT`。

我们还为Mocha添加了两个最常见的第三方报表，内置在cypress，你可以使用他们而无需再安装.

- [`teamcity`](https://github.com/cypress-io/mocha-teamcity-reporter)
- [`junit`](https://github.com/michaelleeallen/mocha-junit-reporter)

最后，我们支持创建您自己的自定义报表或使用任何类型的第三方报表.

<Alert>

一旦你阅读下面的文档,我们邀请你通过开源 [Cypress测试工作坊](https://github.com/cypress-io/testing-workshop-cypress)的 [第9节](https://github.com/cypress-io/testing-workshop-cypress/blob/master/slides/09-reporters/PITCHME.md) ，体验的Cypress报表的强大。。

</Alert>

## 自动以报表

### 本地安装

您可以通过相对或绝对路径加载[自定义Mocha报表](https://mochajs.org/api/tutorial-custom-reporter.html) . 这些可以在您的配置文件中指定(`cypress.Json`)或通过[命令行](/guides/guides/command-line).

例如，如果你有以下目录结构:

```txt
> my-project
  > cypress
  > src
  > reporters
    - custom.js
```

您可以用下面两种方式之一指定自定义报告程序的路径。

#### 配置文件

```json
{
  "reporter": "reporters/custom.js"
}
```

####  命令行

```shell
cypress run --reporter reporters/custom.js
```

### 通过npm安装

当通过npm使用自定义报表时，指定包名。

#### 配置文件

```json
{
  "reporter": "mochawesome"
}
```

####  命令行

```shell
cypress run --reporter mochawesome
```

## 报表选项

一些报表接受定制他们行为的选项。 这些可以在您的配置文件中指定(`cypress.Json`)或通过[命令行](/guides/guides/command-line) 选项.

报表程序选项根据报表程序的不同而不同(可能根本不支持)。有关支持哪些选项的详细信息，请参阅正在使用的报表程序的文档。

下面的配置将把JUnit报告输出到 `STDOUT`并将其保存到一个XML文件中.

#### 配置文件

```json
{
  "reporter": "junit",
  "reporterOptions": {
    "mochaFile": "results/my-test-output.xml",
    "toConsole": true
  }
}
```

####  命令行

```shell
cypress run --reporter junit \
  --reporter-options "mochaFile=results/my-test-output.xml,toConsole=true"
```

## 合并跨spec文件的报告

在每次`cypress run`执行期间，每个spec文件都被完全单独地处理。 因此，每次spec运行都会覆盖以前的报告文件. 要为每个spec 文件保存唯一的报告，请使用`mochaFile`文件名中的`[hash]`.

下面的配置将在`results` 文件夹中创建单独的XML文件. 然后，您可以使用第三方工具在单独的步骤中合并报表的输出. 例如，对于[Mochawesome](https://github.com/adamgruber/mochawesome) 报表，你可以使用[Mochawesome -merge](https://github.com/antontelesh/mochawesome-merge) 工具.

#### 配置文件

```json
{
  "reporter": "junit",
  "reporterOptions": {
    "mochaFile": "results/my-test-output-[hash].xml"
  }
}
```

####  命令行

```shell
cypress run --reporter junit \
  --reporter-options "mochaFile=results/my-test-output-[hash].xml"
```

## 多报表

我们经常看到用户希望能够使用多种报表.当在CI中运行时，您可能希望为“ `junit`生成一个报表，也可能生成一个`json`报表. 这很好，但通过设置此报告器，您将不会在测试运行时收到任何额外的反馈!

这里的解决方案是使用多个报表。你将从两个世界中受益。

我们建议使用npm模块: <Icon name="github"></Icon> [https://github.com/you54f/cypress-multi-reporters](https://github.com/you54f/cypress-multi-reporters)

我们的每一个内部项目都使用多报表。

下面的例子是在[https://github.com/cypress-io/cypress-example-circleci-orb](https://github.com/cypress-io/cypress-example-circleci-orb)中实现的.

### 例子

#### Spec 报表输出到 `STDOUT`, 保存 JUnit XML 文件

我们想要输出一个`spec`报告到`STDOUT`，同时为每个spec文件保存一个JUnit XML文件.

我们需要安装额外的依赖项:

- [`cypress-multi-reporters`](https://github.com/you54f/cypress-multi-reporters): 使用多报表
- [`mocha-junit-reporter`](https://github.com/michaelleeallen/mocha-junit-reporter) 实际的 `junit`报告，因为我们不能使用Cypress自带的 `junit`报告

```shell
npm install --save-dev cypress-multi-reporters mocha-junit-reporter
```

在配置文件(`cypress.json`)或通过[命令行](/guides/guides/command-line)指定reporter和reporterOptions 

#### 配置文件

```json
{
  "reporter": "cypress-multi-reporters",
  "reporterOptions": {
    "configFile": "reporter-config.json"
  }
}
```

####  命令行

```shell
cypress run --reporter cypress-multi-reporters \
  --reporter-options configFile=reporter-config.json
```

然后添加单独的`reporter-config.json`文件(在您的配置中定义)，以启用 `spec` 和 `junit`报告器，并指示`junit` 报告器保存单独的XML文件。

```json
{
  "reporterEnabled": "spec, mocha-junit-reporter",
  "mochaJunitReporterReporterOptions": {
    "mochaFile": "cypress/results/results-[hash].xml"
  }
}
```

我们建议在运行此命令之前删除`cypress/results`文件夹中的所有文件，因为每次运行都会输出新的XML文件.例如，你可以将下面的npm脚本命令添加到`package.json` 中，。然后调用npm run report.

```json
{
  "scripts": {
    "delete:reports": "rm cypress/results/* || true",
    "prereport": "npm run delete:reports",
    "report": "cypress run --reporter cypress-multi-reporters --reporter-options configFile=reporter-config.json"
  }
}
```

如果您想将生成的XML文件合并成一个单独的文件，可以添加[junit-report-merger](https://www.npmjs.com/package/junit-report-merger). 例如，要将所有文件合并到`cypress/results/combined-report.xml` 中，可以添加`combine:reports`脚本.

```json
{
  "scripts": {
    "delete:reports": "rm cypress/results/* || true",
    "combine:reports": "jrm cypress/results/combined-report.xml \"cypress/results/*.xml\"",
    "prereport": "npm run delete:reports",
    "report": "cypress run --reporter cypress-multi-reporters --reporter-options configFile=reporter-config.json",
    "postreport": "npm run combine:reports"
  }
}
```

#### Spec 输出到 `STDOUT`, 生成一个 Mochawesome JSON文件

这个例子显示在[https://github.com/cypress-io/cypress-example-circleci-orb](https://github.com/cypress-io/cypress-example-circleci-orb)的`spec-and-single-mochawesome-json`分支中. 我们想要输出一个“spec”报告到`STDOUT`，为每个测试文件保存一个单独的Mochawesome JSON文件，然后将所有JSON报告合并成一个单独的报告。
我们需要安装一些额外的依赖项。

```shell
npm install --save-dev mochawesome mochawesome-merge mochawesome-report-generator
```

我们需要在您的[配置文件(默认`cypress.json`)](/guides/references/configuration)中配置报告程序，跳过HTML报告生成，并将每个单独的json文件保存在`cypress/results` 文件夹中。

#### 配置文件

```json
{
  "reporter": "mochawesome",
  "reporterOptions": {
    "reportDir": "cypress/results",
    "overwrite": false,
    "html": false,
    "json": true
  }
}
```

#### 命令行

```shell
cypress run --reporter mochawesome \
  --reporter-options reportDir="cypress/results",overwrite=false,html=false,json=true
```

Our run will generate files `cypress/results/mochawesome.json, cypress/results/mochawesome_001.json, ...`. Then we can combine them using the [mochawesome-merge](https://github.com/antontelesh/mochawesome-merge) utility.

```shell
npx mochawesome-merge "cypress/results/*.json" > mochawesome.json
```

我们现在可以从`mochawesome.json`生成一个合并的HTML报告，使用 [https://github.com/adamgruber/mochawesome-report-generator](https://github.com/adamgruber/mochawesome-report-generator):

```shell
npx marge mochawesome.json
```

它生成漂亮的独立HTML报告文件 `mochawesome-report/mochawesome.html`，如下所示.如您所见，所有测试结果、计时信息，甚至测试主体都包括在内.

<DocsImage src="/img/guides/mochawesome-report.png" alt="Mochawesome HTML report" ></DocsImage>

欲了解更多信息，请参见[整合Cypress的Mochawesome报表](http://antontelesh.github.io/testing/2019/02/04/mochawesome-merge.html)

## 历史

| 版本                                  | 变更                                                                                                                                         |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| [4.4.2](/guides/references/changelog) | Custom Mocha reporters updated to use the version of Mocha bundled with Cypress. No need to install `mocha` separately to use custom reporters. |
