---
title: 视觉测试
---

<Alert type="info">

## <Icon name="graduation-cap"></Icon> 你将学习

- 视觉测试如何补充功能测试
- 如何实现自己或使用第三方服务的视觉差异对比
- 如何确保应用程序在捕获图像之前处于一致的状态

</Alert>

## 功能测试vs视觉测试

Cypress是一个**功能测试**运行器。。它以用户的方式驱动web应用程序，并检查应用程序是否如预期的那样运行:如果预期的消息出现，删除一个元素，或者在适当的用户操作之后添加一个CSS类。 
例如，一个典型的Cypress测试可以检查一个被切换状态的“待办事项”项目是否在`.toggle`选中后，得到一个“completed” class :

```js
it('completes todo', () => {
  // 打开TodoMVC运行在“baseUrl"
  cy.visit('/')
  cy.get('.new-todo').type('write tests{enter}')
  cy.contains('.todo-list li', 'write tests').find('.toggle').check()

  cy.contains('.todo-list li', 'write tests').should('have.class', 'completed')
})
```

<DocsImage src="/img/guides/visual-testing/completed-test.gif" alt="Passing Cypress functional test" ></DocsImage>

Cypress并没有实际看到页面。例如，Cypress将不会看到CSS类`completed`是否将标签元素变成灰色并添加一条删除线。

<DocsImage src="/img/guides/visual-testing/completed-item.png" alt="Completed item style" ></DocsImage>

从技术上讲，你可以使用[`have.css` assertion](/guides/references/assertions#CSS)编写一个断言CSS属性的功能测试，但这些可能很快就会变得很麻烦，特别是当视觉样式依赖于大量CSS样式时。

```js
cy.get('.completed').should('have.css', 'text-decoration', 'line-through')
cy.get('.completed').should('have.css', 'color', 'rgb(217,217,217)')
```

您的视觉样式还可能依赖于更多CSS，也许您想要确保SVG或图像已正确呈现，或者图形已正确绘制到画布上。

幸运的是，Cypress为[编写插件](/guides/tooling/plugins-guide)提供了一个稳定的平台，_可以执行可视化测试_.

通常，这样的插件会获取整个测试应用程序或特定元素的图像快照，然后将该图像与之前批准的基线图像进行比较。
如果图像是相同的(在设定的像素公差范围内)，那么用户就可以确定web应用程序看起来是相同的。
如果存在差异，则说明DOM布局、字体、颜色或其他视觉属性发生了一些变化，需要进行调查。

例如，你可以使用[cypress-plugin-snapshots](https://github.com/meinaart/cypress-plugin-snapshots) 插件捕获以下可视化回归:

```css
.todo-list li.completed label {
  color: #d9d9d9;
  /* removed the line-through */
}
```

```js
it('completes todo', () => {
  cy.visit('/')
  cy.get('.new-todo').type('write tests{enter}')
  cy.contains('.todo-list li', 'write tests').find('.toggle').check()

  cy.contains('.todo-list li', 'write tests').should('have.class', 'completed')

  // 运行 'npm i cypress-plugin-snapshots -S'
  //捕获元素截图并与基线图像进行比较
  cy.get('.todoapp').toMatchImageSnapshot({
    imageConfig: {
      threshold: 0.001,
    },
  })
})
```

这个开源插件比较基线和当前图像并排在Cypress Test Runner中，如果像素差异高于阈值;注意基线图像(预期结果)是如何有贯穿线的标签文本的，而新图像(实际结果)没有。

<DocsImage src="/img/guides/visual-testing/diff.png" alt="Baseline vs current image" ></DocsImage>

像大多数图像比较工具，插件也显示一个不同的观点，鼠标悬停:

<DocsImage src="/img/guides/visual-testing/diff-2.png" alt="Highlighted changes" ></DocsImage>

## 工具

在[Visual Testing plugins](/plugins/directory#visual-testing) 一节中列出了一些已发布的开源插件，一些商业公司已经在下面列出的Cypress Test Runner之上开发了可视化测试解决方案。

### 开源

在[可视化测试插件](/plugins/directory#Visual%20Testing)章节中列出 .

### Applitools

首次与applittools联合举办网络研讨会

<!-- textlint-disable -->

<DocsVideo src="https://youtube.com/embed/qVRjhABuyG0"></DocsVideo>

<!-- textlint-enable -->

第二场与applittools的联合网络研讨会，重点关注[组件测试](/guides/component-testing/introduction)

<!-- textlint-disable -->

<DocsVideo src="https://youtube.com/embed/Bxh_ebMk1aM"></DocsVideo>

<!-- textlint-enable -->

<Icon name="external-link-alt"></Icon>
[https://applitools.com](https://applitools.com/)

| 资源                                                                         | 描述                                                                                                                                                   |
| ---------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [官方文档](https://applitools.com/cypress)                                    | Applitools的Cypress文档                                                                                                                             |
| [入门](https://applitools.com/tutorials/cypress.html)                         | Applitools的 Cypress 入门                                                                                                                                  |
| [在线会议](https://applitools.com/blog/cypress-applitools-end-to-end-testing) | _创建完美的用户体验，端到端，从功能到视觉-实践的实践环节_, 与Cypress和applittools一起录制的网络研讨会 |
| [博客](https://glebbahmutov.com/blog/testing-a-chart/)                        | 用Cypress和applittools测试图表                                                                                                                   |

### Percy

<!-- textlint-disable -->

<DocsVideo src="https://youtube.com/embed/MXfZeE9RQDw"></DocsVideo>

<!-- textlint-enable -->

<Icon name="external-link-alt"></Icon> [https://percy.io](https://percy.io/)

<Alert type="info">

##### <Icon name="graduation-cap"></Icon> 真实世界的例子 <Badge type="success">新鲜的</Badge>

Cypress的
[Real World App (RWA)](https://github.com/cypress-io/cypress-realworld-app) 使用[Cypress Percy插件](https://github.com/percy/percy-cypress)提供的`cy.percySnapshot()`命令在整个用户旅程端到端测试中拍摄可视快照

查看
[Real World App test suites](https://github.com/cypress-io/cypress-realworld-app/tree/develop/cypress/tests/ui)
Percy 和 Cypress 实战.

</Alert>

| 资源                                                                                                                                    | 描述                                                                                                                     |
| --------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| [官方文档](https://docs.percy.io/docs/cypress)                                                                                           | Percy的Cypress 文档                                                                                                  |
| [入门](https://docs.percy.io/docs/cypress-tutorial)                                                                                     | Percy的Cypress指南                                                                                                        |
| [在线会议](https://www.youtube.com/watch?v=MXfZeE9RQDw)                                                                                  | _Cypress + Percy = web的端到端功能和可视化测试_, 与Cypress和Percy.io一起录制的网络研讨会 |
| [博客](https://www.cypress.io/blog/2019/04/19/webinar-recording-cypress-io-percy-end-to-end-functional-and-visual-testing-for-the-web/) | Cypress + Percy网络研讨会的同伴博客                                                                              |
| [幻灯片](https://slides.com/bahmutov/visual-testing-with-percy)                                                                         | Cypress + Percy网络研讨会的配套幻灯片                                                                            |
| [博客](https://glebbahmutov.com/blog/testing-visually/)                                                                                 | 测试应用程序如何使用Cypress和Percy渲染绘图                                                             |

### Happo

<!-- textlint-disable -->

<DocsVideo src="https://youtube.com/embed/C_p12IvN5HU"></DocsVideo>

<!-- textlint-enable -->

<Icon name="external-link-alt"></Icon> [https://happo.io/](https://happo.io/)

| 资源                                                                                 | 描述                                                                                                                                 |
| ------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------- |
| [官方文档](https://docs.happo.io/docs/cypress)                                        | Happo的Cypress 文档                                                                                                               |
| [在线会议](https://www.youtube.com/watch?v=C_p12IvN5HU)                               | _保持你的UI清晰:确保Cypress的功能和视觉质量。Cypress.io + Happo.io_, 与Cypress和Happo共同录制的网络研讨会 |
| [博客](https://www.cypress.io/blog/2020/05/27/webcast-recording-keep-your-ui-sharp/) | Cypress + Happo网络研讨会的配套博客                                                                                         |
| [幻灯片](https://cypress.slides.com/cypress-io/cypress-and-happo)                    | Cypress + Happo网络研讨会的配套幻灯片                                                                                       |

### 自己动手

即使您决定跳过使用第三方图像存储和比较服务，您仍然可以执行可视化测试。遵循这些例子

- [用Cypress和Cypress图像快照进行视觉回归测试](https://medium.com/norwich-node-user-group/visual-regression-testing-with-cypress-io-and-cypress-image-snapshot-99c520ccc595)
  指南.
- [使用开源工具对React组件进行可视化测试](https://glebbahmutov.com/blog/open-source-visual-testing-of-components/)
  与同伴
  [视频](https://www.youtube.com/playlist?list=PLP9o9QNnQuAYhotnIDEUQNXuvXL7ZmlyZ).

<Alert type="warning">

您需要考虑自己实现可视化测试工具与使用外部第三方供应商的开发成本。存储、查看和分析图像差异不是一件简单的任务，当使用DIY解决方案时，它们很快就会变成一件苦差事.

</Alert>

## 最佳实践

一般来说，在进行可视化测试时，有一些最佳实践。

### 认识到视觉测试的必要性

**<Icon name="exclamation-triangle" color="red"></Icon> 验证样式属性的断言**

```js
cy.get('.completed').should('have.css', 'text-decoration', 'line-through')
  .and('have.css', 'color', 'rgb(217,217,217)')
cy.get('.user-info').should('have.css', 'display', 'none')
...
```

如果端到端测试充斥着检查可见性、颜色和其他样式属性的断言，那么可能是时候开始使用视觉差异来验证页面外观了。

### DOM 状态

<Alert type="success">

<Icon name="check-circle" color="green"></Icon> **最佳实践:** 在确认页面更改完成后进行快照。

</Alert>

例如，如果快照命令是`cy.mySnapshotCommand`:

**<Icon name="exclamation-triangle" color="red"></Icon> 不正确的使用**

```js
//web应用程序需要时间来添加新项,
// 有时它会在新项出现之前获取快照
cy.get('.new-todo').type('write tests{enter}')
cy.mySnapshotCommand()
```

**<Icon name="check-circle" color="green"></Icon> 正确的用法**

```js
// 使用函数断言来确保
// web应用程序已重新呈现页面
cy.get('.new-todo').type('write tests{enter}')
cy.contains('.todo-list li', 'write tests')
// 太好了，新项目显示出来了，
// 现在我们可以拍快照了
cy.mySnapshotCommand()
```

### 时间戳

<Alert type="success">

<Icon name="check-circle" color="green"></Icon> **最佳实践:** 控制被测应用程序中的时间戳.

</Alert>

下面我们使用[cy.clock()](/api/commands/clock)将操作系统的时间冻结到“2018年1月1日”，以确保所有显示日期和时间的图像匹配。

```js
const now = new Date(2018, 1, 1)

cy.clock(now)
// ... test
cy.mySnapshotCommand()
```

### 应用程序状态

<Alert type="success">

<Icon name="check-circle" color="green"></Icon> **最佳实践:** 使用[cy.fixture()](/api/commands/fixture) 和网络模拟来设置应用程序的状态。

</Alert>

下面我们使用[cy.intercept()](/api/commands/intercept)模拟网络调用，为每个XHR请求返回相同的响应数据。这确保了应用程序映像中显示的数据不会改变。

```js
cy.intercept('/api/items', { fixture: 'items' }).as('getItems')
// ... action
cy.wait('@getItems')
cy.mySnapshotCommand()
```

### 视觉diff元素

<Alert type="success">

<Icon name="check-circle" color="green"></Icon> **最佳实践:** 使用视觉差异检查单个DOM元素，而不是整个页面.

</Alert>

瞄准特定的DOM元素将有助于避免在其他不相关的组件中组件“X”破坏测试的可视化变更。

### 组件测试

<Alert type="success">

<Icon name="check-circle" color="green"></Icon> **最佳实践:** 除了端到端和可视化测试之外，使用[组件测试插件](/plugins/directory) 来测试单个组件的功能.

</Alert>

如果你正在使用React组件，请阅读[使用开源工具对React组件进行可视化测试](https://glebbahmutov.com/blog/open-source-visual-testing-of-components/),
浏览[幻灯片](https://slides.com/bahmutov/i-see-what-is-going-on), 观看[相关视频](https://www.youtube.com/playlist?list=PLP9o9QNnQuAYhotnIDEUQNXuvXL7ZmlyZ).

## 另请参阅

- [截图后API](/api/plugins/after-screenshot-api)
- [cy.screenshot()](/api/commands/screenshot)
- [Cypress.Screenshot](/api/cypress-api/screenshot-api)
- [插件](/guides/tooling/plugins-guide)
- [视觉测试插件](/plugins/directory#visual-testing)
- [编写一个插件](/api/plugins/writing-a-plugin)
- <Icon name="github"></Icon>
  [Cypress Real World App (RWA)](https://github.com/cypress-io/cypress-realworld-app)
  是一个全栈示例应用程序，演示了在实际和现实的场景中使用Cypress的最佳实践和可伸缩策略。-阅读博客文章
  [调试不稳定的视觉回归测试](https://www.cypress.io/blog/2020/10/02/debug-a-flaky-visual-regression-test/)
- 阅读博客文章
  [Canvas可视化测试与重试](https://glebbahmutov.com/blog/canvas-testing/)
