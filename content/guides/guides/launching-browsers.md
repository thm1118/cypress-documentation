---
title: 启动浏览器
---

当你在Cypress中运行测试时，我们会为你启动一个浏览器。这使我们能够:

1. 创建一个干净的、原始的测试环境.
2. 为自动化访问特权浏览器api.

## 浏览器

当Cypress最初从Test Runner运行时，您可以选择在选定的几个浏览器中运行Cypress，包括:

- [Chrome](https://www.google.com/chrome/)
- [Chrome Beta](https://www.google.com/chrome/beta/)
- [Chrome Canary](https://www.google.com/chrome/canary/)
- [Chromium](https://www.chromium.org/Home)
- [Edge](https://www.microsoft.com/edge)
- [Edge Beta](https://www.microsoftedgeinsider.com/download)
- [Edge Canary](https://www.microsoftedgeinsider.com/download)
- [Edge Dev](https://www.microsoftedgeinsider.com/download)
- [Electron](https://electron.atom.io/)
- [Firefox](https://www.mozilla.org/firefox/)
- [Firefox Developer Edition](https://www.mozilla.org/firefox/developer/)
- [Firefox Nightly](https://www.mozilla.org/firefox/nightly/)

Cypress会自动检测你操作系统上可用的浏览器。您可以使用右上角的下拉菜单在Test Runner中切换浏览器:

<DocsImage src="/img/guides/browser-list-dropdown.png" alt="Select a different browser" ></DocsImage>

### 浏览器版本支持

Cypress支持以下浏览器版本:

- Chrome 64 及以上.
- Edge 79 及以上.
- Firefox 86 及以上.

### 下载特定的Chrome版本

Chrome浏览器是常青的——这意味着它会自动更新自己，有时会在你的自动化测试中造成破坏性的变化. 
我们托管[chromium.cypress.io](https://chromium.cypress.io)，为每个平台提供下载特定发布版本Chrome (dev、Canary和stable)的链接.

### Electron 浏览器

除了在您的系统中可以找到的浏览器之外，您还会注意到Electron是一个可用的浏览器. Electron浏览器是 [Electron](https://electron.atom.io/) 自带的Chromium版本 .

Electron浏览器的优势在于它与Cypress融为一体，不需要单独安装.

默认情况下，当从CLI运行[cypress run](/guides/guides/command-line#cypress-run)时，我们将无头启动浏览器.

#### 你也可以启动无头Electron:

```shell
cypress run --headed
```

因为Electron是默认浏览器——它通常在CI中运行. 如果您在CI中看到失败，为了方便地调试它们，您可能需要使用`--headed` 选项在本地运行.

### Chrome 浏览器

所有Chrome\* 家族的浏览器都将被检测到，并在Chrome 64以上得到支持。

你可以像这样启动Chrome:

```shell
cypress run --browser chrome
```

要在CI中使用此命令，需要安装所需的浏览器 - 或者使用我们的[docker映像](/examples/examples/docker).

默认情况下，我们将在`cypress run`期间无头地启动Chrome. 要运行有界面的Chrome，你可以将--headed`参数传递给`cypress run`.

你也可以启动Chromium:

```shell
cypress run --browser chromium
```

或者Chrome beta版:

```shell
cypress run --browser chrome:beta
```

或 Chrome 的金丝雀版:

```shell
cypress run --browser chrome:canary
```

或者微软Edge(基于Chromium):

```shell
cypress run --browser edge
```

或者微软Edge Canary(基于Chromium):

```shell
cypress run --browser edge:canary
```

### Firefox 浏览器

Cypress支持火狐系列浏览器.

你可以像这样启动Firefox:

```shell
cypress run --browser firefox
```

或者Firefox Developer/Nightly版:

```shell
cypress run --browser firefox:dev
cypress run --browser firefox:nightly
```

要在CI中使用此命令，您需要安装这些其他浏览器 - 或者使用我们的[docker映像](/examples/examples/docker).

默认情况下，我们将在`cypress run`期间无头启动Firefox. 要有界面运行Firefox，你可以将`--headed`参数传递给`cypress run`.

### 通过路径启动

您可以通过指定二进制文件的路径来启动任何受支持的浏览器:

```shell
cypress run --browser /usr/bin/chromium
```

```shell
cypress open --browser /usr/bin/chromium
```

Cypress将自动检测提供的浏览器类型，并为您启动它。

[有关`--browser`参数的更多信息，请参阅命令行指南](/guides/guides/command-line#cypress-run-browser-lt-browser-name-or-path-gt)

[无法启动浏览器?查看我们的故障排除指南](/guides/references/troubleshooting#Launching-browsers)

### 自定义可用的浏览器

有时，您可能想要修改在运行测试之前找到的浏览器列表。

例如，你的web应用程序可能只能在Chrome浏览器中运行，而不能在Electron浏览器中运行.

在插件文件中，您可以过滤在`config`对象中传递的浏览器列表，并返回您想要的浏览器列表，以便在`cypress open`期间进行选择。.

```javascript
// cypress/plugins/index.js
module.exports = (on, config) => {
  // 在 config.browsers 数组内，每个对象的信息类似如下所示
  // {
  //   name: 'chrome',
  //   channel: 'canary',
  //   family: 'chromium',
  //   displayName: 'Canary',
  //   version: '80.0.3966.0',
  //   path:
  //    '/Applications/Canary.app/Contents/MacOS/Canary',
  //   majorVersion: 80
  // }
  return {
    browsers: config.browsers.filter((b) => b.family === 'chromium'),
  }
}
```

当你在一个使用上述修改的插件文件的项目中打开Test Runner时，只有在系统中找到的Chrome浏览器才会显示在可用浏览器列表中.

<DocsImage src="/img/guides/plugins/chrome-browsers-only.png" alt="Filtered list of Chrome browsers" ></DocsImage>

<Alert type="info">

如果你返回一个空的浏览器列表或`browsers: null`，默认列表将自动恢复。

</Alert>

如果你已经安装了一个基于chrome的浏览器，比如[Brave](https://brave.com/),
[Vivaldi](https://vivaldi.com/) ，你可以将它们添加到返回的浏览器列表中。下面是一个插件文件，它将本地Brave浏览器插入到返回的列表中。

```javascript
// cypress/plugins/index.js
const execa = require('execa')
const findBrowser = () => {
  // 为简单起见，该路径是硬编码的
  const browserPath =
    '/Applications/Brave Browser.app/Contents/MacOS/Brave Browser'

  return execa(browserPath, ['--version']).then((result) => {
    // STDOUT将 类似这样的"Brave Browser 77.0.69.135"
    const [, version] = /Brave Browser (\d+\.\d+\.\d+\.\d+)/.exec(result.stdout)
    const majorVersion = parseInt(version.split('.')[0])

    return {
      name: 'Brave',
      channel: 'stable',
      family: 'chromium',
      displayName: 'Brave',
      version,
      path: browserPath,
      majorVersion,
    }
  })
}

module.exports = (on, config) => {
  return findBrowser().then((browser) => {
    return {
      browsers: config.browsers.concat(browser),
    }
  })
}
```

<DocsImage src="/img/guides/plugins/brave-browser.png" alt="List of browsers includes Brave browser" ></DocsImage>

一旦选定，Brave浏览器就会被检测，检测方法与其他`chromium` 系列浏览器相同.

<DocsImage src="/img/guides/plugins/brave-running-tests.png" alt="Brave browser executing end-to-end tests" ></DocsImage>

如果您修改浏览器列表，您可以在Test Runner的Settings选项卡中看到[resolved configuration](/guides/references/configuration#Resolved-Configuration).

### 不受支持的浏览器

目前不支持某些浏览器，如Safari和Internet Explorer。对更多浏览器的支持在我们的路线图上.

## 浏览器环境

Cypress以一种不同于普通浏览器环境的方式启动浏览器。但我们认为，它的启动方式使测试 _更可靠_、更 _容易实现_。

### 启动浏览器

当Cypress去启动您的浏览器时，它将给您一个机会来修改用于启动浏览器的参数.

这使您能够做类似的事情:

- 加载自己的扩展
- 启用或禁用实验特性

[这里记录了API的这一部分.](/api/plugins/browser-launch-api)

### Cypress Profile

Cypress生成它自己的独立配置文件，除了您的正常浏览器配置文件。这意味着像完整`浏览历史记录`, `cookies`, 以及
`第三方扩展` 等你的常规浏览会话，不会影响你在Cypress的测试。

<Alert type="warning">

<strong class="alert-header">等等，我需要我的开发人员扩展!</strong>

这是没有问题的-你必须重新安装他们一旦Cypress启动浏览器。我们将在后续的启动中继续使用这个Cypress测试配置文件，因此您的所有配置将被保留。

</Alert>

### Disabled 障碍

Cypress自动禁用Cypress启动的浏览器中的某些功能，这往往会妨碍自动化测试.

#### Cypress自动启动浏览器:

- 忽略证书错误.
- 允许被阻止的弹窗.
- 禁用“保存密码”.
- 禁用“自动填写表格和密码”.
- 禁用请求成为您的主要浏览器.
- 禁用设备发现通知.
- 禁用语言翻译.
- 禁用恢复会话.
- 禁用后台网络流量.
- 禁用背景和渲染器节流.
- 禁用请求许可使用相机或麦克风等设备的提示
- 为自动播放视频禁用用户手势要求.

你可以在[这里](https://github.com/cypress-io/cypress/blob/develop/packages/server/lib/browsers/chrome.ts#L36) 看到所有我们发送的默认的chrome命令行开关.

## 浏览器图标

您可能会注意到，如果您已经打开了浏览器，您将在dock中看到两个相同的浏览器图标。

<DocsVideo src="/img/snippets/switching-between-cypress-and-other-chrome-browser.mp4"></DocsVideo>

我们理解，当Cypress在自己的配置文件中运行时，很难区分你的正常浏览器和Cypress。

出于这个原因，您可能会发现下载和使用浏览器的发布通道版本(Dev、Canary等)非常有用。 
这些浏览器的图标与标准稳定的浏览器不同，这使得它们更容易区分. 您也可以使用捆绑的，没有图标的[Electron浏览器](#Electron-Browser).

<DocsVideo src="/img/snippets/switching-cypress-browser-and-canary-browser.mp4"></DocsVideo>

此外，在基于chrome的浏览器中，我们让Cypress生成的浏览器看起来与常规会话不同. 你会看到浏览器的chrome周围有一个较暗的主题。你总能从视觉上分辨出来.

<DocsImage src="/img/guides/cypress-browser-chrome.png" alt="Cypress Browser with darker chrome" ></DocsImage>

## 故障排除

[启动已安装的浏览器有问题?阅读有关浏览器启动故障排除的更多信息](/guides/references/troubleshooting#Launching-browsers)
