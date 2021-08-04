---
title: 截屏和录屏
---

<Alert type="info">

## <Icon name="graduation-cap"></Icon> 你将学习

- Cypress如何自动捕获测试失败的屏幕截图
- 如何手动捕捉自己的截图
- Cypress如何录制整个过程的视频
- 关于如何处理截图和视频工件的一些参数选项

</Alert>

## 截屏

Cypress具有截屏的能力，无论你是通过 `cypress open` 或 `cypress run`运行，即使在CI也可以。

要手动截图，可以使用[`cy.screenshot()`](/api/commands/screenshot) 命令.

此外，当在`cypress run`期间发生失败时，Cypress会自动捕捉屏幕截图。 在`cypress open`期间，失败的截图 _不会_ 被自动捕获.

可以完全关闭测试失败时自动捕捉屏幕截图，在[配置](/guides/references/configuration)文件里设置[`screenshotOnRunFailure`](/guides/references/configuration#Screenshots) 为`false`，或者 在[Cypress.Screenshot.defaults()](/api/cypress-api/screenshot-api)设置 `screenshotOnRunFailure` 为 `false` .

截图存储在[`screenshotsFolder`](/guides/references/configuration#Screenshots) 配置的目录里，默认是 `cypress/screenshots`。

Cypress在`cypress run`之前清除所有现有截图. 如果你不想在运行之前清除你的截图文件夹，你可以设置[`trashAssetsBeforeRuns`](/guides/references/configuration#Screenshots) 为 `false`。

## 录屏

在`cypress run`期间运行测试时，Cypress可以为每个spec文件录制视频. `cypress open`期间视频不会自动录制.

视频录制可以通过在你的配置中设置[`video`](/guides/references/configuration#Videos) 为 `false`完全关闭.

视频存储在[`videosFolder`](/guides/references/configuration#Videos) 指定目录，默认是`cypress/videos`.

`cypress run`完成后，cypress自动压缩视频，以节省文件大小. 默认情况下，它压缩率为`32 CRF`，但这是可配置的[`videoCompression`](/guides/references/configuration#Videos) 属性.

当你在运行测试时使用`--record`标记时，每个spec文件运行后，视频都会被处理、压缩并上传到[Dashboard 服务](/guides/dashboard/introduction), 无论是否测试通过. 要将此行为更改为仅在测试失败的情况下处理视频，请将[`videoUploadOnPasses`](/guides/references/configuration#Videos)配置选项设置为`false`。

Cypress在`cypress run`之前清除所有现有视频. 如果你不想在运行之前清除你的视频文件夹，你可以设置[`trashAssetsBeforeRuns`](/guides/references/configuration#Videos) 为`false`。

### 视频编码

如果你的spec文件有一个很长的运行持续时间，你可能会注意到在`cypress run`期间，完成的spec和开始的新spec之间有一个时间间隔。 在此期间，Cypress正在对捕获的视频进行编码，并将其上传到Dashboard.

如果机器编码视频很慢(通常是使用单核虚拟机的情况), 编码可能需要很长时间. 在这种情况下，你可以修改[`videoCompression`](/guides/references/configuration#Videos) 配置，使编码速度稍微快一点. 以下是一些常见的场景:

**使用最小的压缩**

```json
{
  "videoCompression": 0
}
```

压缩步骤将被完全跳过，因此视频会变大，但处理速度会更快.

**禁用压缩**

```json
{
  "videoCompression": false
}
```

<Alert type="info">

如果您是FFmpeg专业人士，并希望查看编码期间的所有设置和调试消息，请使用以下环境变量运行Cypress: `DEBUG=cypress:server:video cypress run`

</Alert>

### 控制哪些视频保存和上传到Dashboard

你可能想要更多的控制哪些视频你想要保留和上传到Dashboard。运行后删除视频可以节省机器上的资源空间，并跳过用于处理、压缩和上传视频到[Dashboard服务](/guides/dashboard/introduction)的时间。.

为了只在测试失败的情况下处理视频，你可以设置[`videoUploadOnPasses`](/guides/references/configuration#Videos)配置选项为`false`.

对于更细粒度的控制，您可以使用Cypress的[`after:spec`](/api/plugins/after-spec-api)事件监听器，该监听器在每个spec文件运行后触发，并在满足某些条件时删除视频.

#### 仅上传视频spec失败或重试的测试

下面的示例显示了如何删除在使用Cypress时,没有重试尝试或失败的spec的录制视频[测试重试](/guides/guides/test-retries).

```js
// plugins/index.js

// 需要安装这些依赖项
// npm i lodash del --save-dev
const _ = require('lodash')
const del = require('del')

module.exports = (on, config) => {
  on('after:spec', (spec, results) => {
    if (results && results.video) {
      // 我们是否有失败的重试尝试?
      const failures = _.some(results.tests, (test) => {
        return _.some(test.attempts, { state: 'failed' })
      })
      if (!failures) {
        // 如果spec通过, 且没有重试测试，则删除视频
        return del(results.video)
      }
    }
  })
}
```

## 又该做什么?

你正在捕捉屏幕截图并录制测试运行的视频，又该做什么呢?

### 与你的团队共享

<!-- Line breaks removed to prevent random br elements -->

今天你可以利用的是[Cypress Dashboard 服务](/guides/dashboard/introduction): 我们的配套企业服务，为您存储工件，并允许您从任何web浏览器查看它们，以及与您的团队共享它们。

### 视觉回归测试 / 截屏对比

另一种可能是视觉回归测试:将过去运行的截图与当前运行的截图进行比较，以确保没有任何更改. [阅读如何实现视觉测试.](/guides/tooling/visual-testing)

## 另请参阅

- [After Screenshot API](/api/plugins/after-screenshot-api)
- [Cypress.Screenshot](/api/cypress-api/screenshot-api)
- [Dashboard 服务](/guides/dashboard/introduction)
- [`cy.screenshot()`](/api/commands/screenshot)
- [视觉测试](/guides/tooling/visual-testing)
