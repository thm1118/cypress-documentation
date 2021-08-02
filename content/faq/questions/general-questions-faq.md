---
layout: toc-top
title: 常规问题
containerClass: faq
---

## <Icon name="angle-right"></Icon> Cypress是免费和开源的吗?

[Test Runner](/guides/core-concepts/test-runner)是一个免费的、可下载的开源(MIT许可)应用程序。这是免费使用的。 我们的[Dashboard 服务](/guides/dashboard/introduction)是一个web应用程序，当你想要在CI中记录你的测试运行时，它提供了各种计费计划(包括免费的开源计划)。

详情请参阅我们的[定价页面](https://www.cypress.io/pricing).

## <Icon name="angle-right"></Icon> 你支持什么操作系统?

您可以[安装Cypress](/guides/getting-started/installing-cypress)在Mac, Linux，和Windows.如需更多信息，请参阅我们的[系统要求](/guides/getting-started/installing-cypress#System-requirements).

## <Icon name="angle-right"></Icon> 你们是否支持原生手机应用?

Cypress永远无法运行在本地手机应用上，但我们可以测试手机网页浏览器的一些功能，并测试在浏览器上开发的手机应用，例如[Ionic框架](https://ionicframework.com/).

目前你可以用[`cy.viewport()`](/api/commands/viewport) 命令控制viewport来测试网站或web应用程序中的响应性、移动视图. 您还可以使用[自定义命令](/api/cypress-api/custom-commands)模拟某些行为，如滑动。.

你可以阅读关于测试移动应用ionic和Cypress[这里](https://www.cypress.io/blog/2020/07/08/end-to-end-testing-mobile-apps-with-ionic-and-cypress/) 以及看看我们如何在[Cypress Real World App](https://github.com/cypress-io/cypress-realworld-app) 中管理测试移动视口.

## <Icon name="angle-right"></Icon> 这与“X” 测试工具有何不同?

Cypress Test Runner是一个混合的应用框架服务. 它需要一些其他的测试工具，将它们组合在一起并对它们进行改进.

#### Mocha

Mocha是一个JavaScript测试框架. [Mocha](http://mochajs.org/))提供了“it”、“describe”、“beforeEach”方法。 Cypress和Mocha没有什么**不同**, 它实际上在底层使用Mocha. 所有测试都将在Mocha的`bdd`界面上编写.

#### Karma

JavaScript的单元测试运行器[Karma](http://karma-runner.github.io/)可以与[Jasmine](https://jasmine.github.io/)、[Mocha](http://mochajs.org/)或任何其他JavaScript测试框架一起工作。

Karma还会监视你的JavaScript文件，当它们改变时实时重新加载，并且它还是你测试失败的`reporter` 。它从命令行运行。

Cypress本质上取代了Karma，因为它已经做了所有这些，甚至更多.

#### Capybara

允许你为你的web应用程序编写集成测试的`Ruby` 专用工具是[Capybara](http://teamcapybara.github.io/capybara/). 在Rails世界中，这是测试应用程序的首选工具. 它使用[Sauce Labs](https://SauceLabs.com/)(或另一个无头驱动程序)与浏览器进行交互。 它的API由查询DOM元素、执行用户操作、导航等命令组成。

Cypress基本上取代了Capybara，因为它做了所有这些事情，甚至更多. 不同之处在于，您不是在一个无gui的控制台中测试应用程序，而是在任何时候都可以看到您的应用程序. 调试时不需要截屏，因为所有命令在运行时都会立即提供应用程序的状态. 在任何命令失败时，您都会看到一个易于理解的错误，解释它失败的原因. 在调试时不需要“猜测”.

通常情况下，Capybara在复杂的JavaScript应用程序中不能很好地工作. 此外，尝试TDD应用程序通常很困难. 通常必须首先编写应用程序代码(通常是在更改后手动刷新浏览器)，直到使其工作为止. 在此基础上编写测试，但却失去了TDD的全部价值.

#### Protractor

使用[Protractor](http://www.protractortest.org/) 在Selenium上提供了一个很好的基于promise的界面，这使得处理异步代码变得不那么复杂。protractor带有capybara的所有功能，本质上也存在同样的问题。

Cypress取代了Protractor，因为它做了所有这些事情，甚至更多. 一个主要的区别是，Cypress使您能够在同一工具中编写单元测试和集成测试，而不是在Karma和Protractor之间分割工作.

此外，Protractor非常专注于“AngularJS”，而Cypress被设计用于任何JavaScript框架。 量角器，因为它是基于Selenium的，仍然非常慢，并且在尝试TDD应用程序时令人望而却步. 另一方面，Cypress以您的浏览器和应用程序能够提供和呈现的速度运行;没有额外的膨胀.

## <Icon name="angle-right"></Icon> 你支持X语言 或 X框架 吗?

任何和所有。Ruby、Node、C、PHP——这些都不重要。Cypress测试所有在浏览器上下文中运行的内容. 它是后端、前端、语言和框架无关的.

您将用JavaScript编写测试，但除此之外，Cypress在任何地方都可以工作.

## <Icon name="angle-right"></Icon> 我可以在除Chrome以外的其他浏览器上运行Cypress吗?

你可以在[这里](/guides/guides/launching-browsers)阅读我们目前可用的浏览器.

## <Icon name="angle-right"></Icon> Cypress会在我的CI提供商上 工作吗?

Cypress在所有[CI提供商]工作(/guides/continuous-integration/introduction).

## <Icon name="angle-right"></Icon> Cypress 是否要求我更改已有的代码?

不。但是，如果您想测试应用程序中不容易测试的部分，则需要重构这些情况(就像您在任何测试中所做的那样)。.

## <Icon name="angle-right"></Icon> Cypress是否使用S elenium/Webdriver?

不。事实上，Cypress的构建方式在一些关键方面与Selenium差别很大:

- Cypress在浏览器的上下文中运行. 使用Cypress，可以更容易地查看浏览器中运行的内容，但与外部世界交流则更加困难. 而在Selenium中则恰恰相反. Selenium在您的应用程序运行的浏览器之外运行(尽管Cypress每天添加更多的命令，让您访问外部世界——比如['`cy.request()`](/api/commands/request), [`cy.exec()`](/api/commands/exec), 以及 [`cy.task()`](/api/commands/task)).
- 使用Selenium，你可以得到100%的模拟事件(使用Selenium RC)或100%的本机事件(使用Selenium WebDriver)。 而在赛普拉斯，两者都有。在大多数情况下，我们使用模拟事件. 然而，我们确实使用了自动化api，如cookie，我们扩展了JavaScript沙箱之外，并与底层浏览器api进行交互。这使我们能够灵活地决定在特定情况下使用哪种类型的事件. 原生事件支持在我们的[路线图](/guides/references/roadmap)中.

## <Icon name="angle-right"></Icon> 如果Cypress在浏览器中运行，这不就意味着它是沙箱吗?

是的,技术上它是沙盒浏览器，必须遵循与其他浏览器相同的规则. 这实际上是一件好事，因为它不需要浏览器扩展，而且它自然可以跨所有浏览器工作(这就支持跨浏览器测试)。

但Cypress实际上远远超出了在浏览器中运行的基本JavaScript应用程序. 它也是一个桌面应用程序，与后端web服务进行通信。

所有这些技术结合在一起，使Cypress能够工作，这将其功能扩展到浏览器沙箱之外. 没有这些，Cypress根本无法工作. 对于绝大多数的web开发，Cypress将工作得很好，并且已经有效了。

## <Icon name="angle-right"></Icon> 我们使用WebSockets;Cypress 能支持吗?

支持.

## <Icon name="angle-right"></Icon> 我们有有史以来最复杂最离谱的认证系统; Cypress 能支持吗?

如果你使用一些复杂的拇指指纹，视网膜扫描，基于时间的，按键改变，麦克风，声音，解码机制来登录你的用户，那么不行，Cypress不会支持. 但说真的，Cypress是一个 _开发_ 工具，它可以帮助你测试你的web应用程序. 如果你的应用程序做了100倍的事情，使得它非常难以访问，Cypress不会神奇地使它变得更容易.

因为Cypress是一个开发工具，所以您总是可以在开发环境中使应用程序更容易访问. 如果愿意，可以在测试环境中禁用身份验证系统中的复杂步骤. 毕竟，这就是为什么我们有不同的环境! 通常情况下，您已经有了一个开发环境、一个测试环境、一个预生产环境和一个生产环境.因此，要在每个适当的环境中公开您想要访问的系统部分.

在这样做的情况下，Cypress可能无法在不改变任何内容的情况下提供100%的覆盖率，但这没关系. 使用不同的工具来测试应用程序中较难访问的部分，并让Cypress测试其余99%.

请记住，Cypress不会让一个不可测试的应用程序突然变得可测试。 以可访问的方式构建代码是您的责任.

## <Icon name="angle-right"></Icon> 可以在`.jspa`上使用Cypress吗??

是的。Cypress可以处理任何呈现给浏览器的内容。

## <Icon name="angle-right"></Icon> 我可以使用Cypress在像`gmail.com`这样的外部网站上编写用户动作脚本吗??

不。已经有很多工具可以做到这一点. 使用Cypress对第三方应用程序进行测试并不是它的预期用途. 它可能会起作用，但会破坏创建它的目的。在开发应用程序时使用Cypress，它可以帮助您编写测试.

## <Icon name="angle-right"></Icon> 有代码覆盖率吗?

有一个插件和详细的文档，关于如何获得端到端测试，单元测试和完整的堆栈代码覆盖率.

- 阅读我们的[代码覆盖指南](https://on.cypress.io/code-coverage)
- 使用[@cypresscode-coverage](https://github.com/cypress-io/code-coverage) 插件

在编写端到端测试时，您可能还会发现以下资源很有帮助:

- [元素覆盖](https://glebbahmutov.com/blog/element-coverage/)
- [应用程序状态覆盖](https://glebbahmutov.com/blog/hyperapp-state-machine/)

## <Icon name="angle-right"></Icon> 有我的语言的驱动程序绑定吗?

Cypress不利用WebDriver进行测试，所以它不使用或没有任何驱动绑定的概念. 如果你的语言可以以某种方式翻译JavaScript,然后您可以配置[Cypress webpack 预处理器](https://github.com/cypress-io/cypress/tree/master/npm/webpack-preprocessor) 或[Cypress Browserify 预处理器](https://github.com/cypress-io/cypress-browserify-preprocessor) 来翻译成Cypress可以运行 JavaScript,。

## <Icon name="angle-right"></Icon> 在编写Cypress测试之前，你推荐哪些资源来学习JavaScript?

我们希望Cypress能让测试编写变得简单而有趣，即使对JavaScript了解很少的人也是如此. 如果你想发展你的JS技能，我们推荐以下免费在线资源:

- 在线教程[学习Javascript](https://gitbookio.gitbooks.io/JavaScript)与小练习
- 书[雄辩的JavaScript](https://eloquentjavascript.net/)
- 书[人类的JavaScript](http://read.humanjavascript.com/)
- 在[free Frontend](https://freefrontend.com/javascript-books/)网站上有一整套免费的JavaScript书籍
- [现代Javascript入门](https://javascript.info/) 教你JavaScript和HTML编程，有多种译本

你也可以通过观看这些视频来学习JavaScript:

- freeCodeCamp的[学习JavaScript -为初学者的完整课程](https://www.youtube.com/watch?v=PkZNo7MFNFg) 
- CodeAcademy的[学习JavaScript](https://www.codecademy.com/learn/introduction-to-javascript) 

## <Icon name="angle-right"></Icon> 那么，将单元测试从Karma或Jest转换为Cypress有什么好处呢?

单元测试并不是我们现在真正想解决的问题. 大多数的`cy`API命令在单元测试中是无用的。在Cypress中编写单元测试的最大好处是它们可以在浏览器中运行，而浏览器内置了调试器支持。

我们已经在Cypress内部进行了基于DOM的组件单元测试的实验——这有可能成为单元测试的最佳“甜点”. 您将获得完整的DOM支持、截图支持、快照测试，然后您可以使用其他`cy`命令(如果需要的话)。 但正如我提到的，这并不是我们积极推动的事情;如果我们想走这条路，这仍然是可能的.

也就是说，我们实际上认为在Cypress中最好的测试形式是“单元测试”和“端到端测试”的结合。. 我们不相信“放手”的方法. 我们希望你修改你的应用程序的状态，尽可能多地使用快捷方式(因为你可以访问包括你的应用程序在内的所有对象). 换句话说，我们希望您在编写集成测试时考虑单元测试。

## <Icon name="angle-right"></Icon> 什么时候应该编写单元测试，什么时候应该编写端到端测试?

我们相信单元测试和端到端测试有不同之处，这应该指导您的选择.

|  单元测试                               | 端到端测试                                                             |
| -------------------------------------- | ---------------------------------------------------------------------------- |
| 关注代码                                | 关注功能                                                        |
| 应该保持简短                            | 可能会很长                                                                  |
| 检查操作的返回结果                       | 检查操作的副作用:DOM、存储、网络、文件系统、数据库 |
| 对开发人员工作流很重要                    | 对最终用户的工作流程很重要                                             |

除了上面的区别之外，下面是一些决定何时编写单元测试和何时编写端到端测试的经验法则。

- 如果您要测试的代码是被其他代码调用的，则使用单元测试。
- 如果要从外部系统(比如浏览器)调用代码，请使用端到端测试.
- 如果一个单元测试需要大量的模拟，你必须使用`jsdom`, `enzyme`, 或 `sinon.js`等工具来模拟真实世界的环境，你可能想把它重写为端到端测试。
- 如果端到端测试不通过浏览器，而是直接调用代码，您可能希望将其重写为单元测试

最后，单元测试和端到端测试并没有太大的不同，它们有共同的特性。好的测试会:

- 只关注和测试一件事.
- 不会脆弱，不会随机失效.
- 让你有信心重构代码并添加新特性.
- 能够同时在本地和[持续集成服务](/guides/continuous-integration/introduction)上运行.

当然，单元测试和端到端测试并不是彼此对立的，而是工具箱中的互补工具。

## <Icon name="angle-right"></Icon> 我如何说服我的公司使用Cypress?

首先，对自己诚实- 对你的公司和你的项目,[Cypress是正确的工具](/guides/overview/why-cypress)吗? 我们相信最好的方法是“自下而上”的方法，您可以展示Cypress如何解决您公司的特殊需求。 为你的项目执行一个原型，看看效果如何. 测试几个常见的用户场景. 确定是否有任何技术障碍. 在进一步操作之前，先将原型展示给其他人. 如果您能向其他工程师演示使用Cypress作为开发工具的好处，那么Cypress可能会更快地被采用.

## <Icon name="angle-right"></Icon> 我怎样才能找到 Cypress的新版本?

我们在GitHub和Npm发布我们的发行版，在发布的同时，我们还发布了一个包含主要变更、修复和更新的更新日志.
你可以通过以下链接:

- [GitHub (Releases & changelog)](https://github.com/cypress-io/cypress/releases)
- [npm (Releases)](https://www.npmjs.com/package/cypress)
- [Changelog at Cypress Docs](/guides/references/changelog)

## <Icon name="angle-right"></Icon> Cypress Test Runner 多久发布一次新版本?

我们将测试运行器的发布安排在每两周的周一. 这个新版本包含了当时已经完成的所有bug修复和功能。 通过查看带有[stage: pending release](https://github.com/cypress-io/cypress/issues?q=label%3A%22stage%3A+pending+release%22+is%3Aclosed) 标签的问题，您可以看到所有问题合并到默认代码分支中，但尚未发布.

我们计划大约每3个月进行一次重大的变更。

如果在我们的发布计划之外存在重大漏洞，那么我们将尽快发布补丁.

## <Icon name="angle-right"></Icon> 在使用Cypress Test Runner时，捕获或传输什么信息?

Cypress Test Runner在本地运行，所以除了异常数据外，没有数据被发送到Cypress，可以使用说明[这里](https://docs.cypress.io/guides/getting-started/installing-cypress.html#Opt-out-of-sending-exception-data-to-Cypress) 禁用异常数据。

## <Icon name="angle-right"></Icon> 我可以使用Cypress编写API测试吗?

Cypress主要用于运行端到端测试，但如果您需要编写一些测试，使用[`cy.request()`](/api/commands/request)命令调用后端API…谁能阻止你?

```js
it('adds a todo', () => {
  cy.request({
    url: '/todos',
    method: 'POST',
    body: {
      title: 'Write REST API',
    },
  })
    .its('body')
    .should('deep.contain', {
      title: 'Write REST API',
      completed: false,
    })
})
```

看看我们的[Real World App (RWA)](https://github.com/cypress-io/cypress-realworld-app)，它使用了很多这样的测试来验证后端api.

您可以使用内置断言验证响应并执行多个调用. 您甚至可以根据需要编写将UI命令与API测试结合起来的端到端测试:

```js
it('adds todos', () => {
  // 通过UI驱动应用程序
  cy.visit('/')
  cy.get('.new-todo')
    .type('write E2E tests{enter}')
    .type('add API tests as needed{enter}')
  // 现在确认服务器已经 有2个 todo items
  cy.request('/todos')
    .its('body')
    .should('have.length', 2)
    .and((items) => {
      // 确认返回的 items
    })
})
```

看看[添加GUI到你的E2E API测试](https://www.cypress.io/blog/2017/11/07/add-gui-to-your-e2e-api-tests/)博客文章，然后在 [cy-api](https://github.com/bahmutov/cy-api) 插件，它将请求和响应对象管道到测试运行器的GUI中，以便更容易地调试。

编写有针对性的API测试的一个好策略是使用它们来访问其他测试没有覆盖的难以测试的代码.您可以使用[代码覆盖率](/guides/tooling/code-coverage)作为指南在代码中找到这样的位置. 看看 [更安全的代码和Cypress Codecov](https://www.cypress.io/blog/2021/01/22/webcast-recording-ship-safer-code-with-cypress-and-codecov/) 网络研讨会,我们显示如何应用这一策略，并通过主要E2E fullstack代码覆盖率达到100%测试和一些有针对性的API和单元测试。
