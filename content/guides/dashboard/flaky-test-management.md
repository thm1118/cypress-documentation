---
title: 管理脆弱测试
---

通过启用[测试重试](/guides/guides/test-retries), Cypress Dashboard可以从您记录的Cypress测试运行中检测、标记和跟踪脆弱测试.

<Alert type="info">

<strong class="alert-header">什么是脆弱测试?</strong>

如果一个测试可以在没有任何代码更改的情况下通过或失败多次重试，那么它就被认为是脆弱的.

例如，执行了一个测试并失败了，然后再次执行测试，没有对代码进行任何更改，但这一次它通过了。

</Alert>

<Alert type="info">

<strong class="alert-header">什么是测试重试?</strong>

Cypress具有自动重试失败测试的能力，以减轻整个测试运行或CI构建失败导致的脆弱测试。

测试重试**默认禁用**，您可以[在您的Cypress配置中启用它](/guides/guides/test-retries#Configure-Test-Retries).

</Alert>

## 脆弱检测

<Alert type="success">

<strong class="alert-header"><Icon name="star"></Icon> 超值的Dashboard功能</strong>

通过[团队Dashboard付费计划](https://cypress.io/pricing)，用户可以使用脆弱测试检测.

</Alert>

对付脆弱测试的一种方法是，当它们以有组织和有系统的方式出现时，检测和监控它们，这样您就可以评估它们的严重性，以帮助确定修复的优先级.

<Alert type="warning">

<strong class="alert-header">测试重试和脆弱检测</strong>

测试重试是使Cypress Dashboard能够检测脆弱测试的基本机制. 因此，启用[测试重试](/guides/guides/test-retries#Configure-Test-Retries)需要利用Cypress Dashboard提供的脆弱测试管理特性。

</Alert>

### 标记脆弱测试

带有脆弱测试的测试运行将在仪表板“最新运行”页面中用脆弱测试的数量标记.脆弱的测试运行也可以通过此页中的“脆弱”过滤器进行过滤.

<DocsImage src="/img/dashboard/flaky-test-management/flaky-runs-view.png" alt="Flagging flaky tests runs in Cypress Dashboard" ></DocsImage>

由测试重试触发的多个测试运行尝试的任何失败都将导致给定的测试用例被标记为脆弱的.

### 脆弱测试分析

<Alert type="success">

<strong class="alert-header"><Icon name="star"></Icon> 超值的Dashboard功能</strong>

通过[团队Dashboard付费计划](https://cypress.io/pricing)，用户可以使用脆弱测试分析.

</Alert>

脆弱测试分析页面通过显示:

- 随时间变化的脆弱测试数量图.
- 整个项目的整体脆弱水平。
- 按严重程度分组的脆弱试验数.
- 根据严重性排序的所有脆弱测试用例的可过滤日志.

<Alert type="info">

<strong class="alert-header">Flake Severity</strong>

测试脆弱的严重程度是由给定测试的脆弱频率或脆弱率决定的.脆弱严重性级别可用于确定解决脆弱问题所需的工作的优先级.

</Alert>

<DocsImage src="/img/dashboard/flaky-test-management/flake-analytics.png" alt="Flaky tests analytics" ></DocsImage>

在分析页面中选择任何一个脆弱的测试用例，将显示一个测试用例详细信息面板，显示如下:

- 最新运行的历史日志
- 在测试用例运行过程中最常见的错误
- 相关的测试用例更新日志
- 随时间变化的失败率和脆弱率曲线图。

所有这些测试用例级别的细节都提供了关于随时间推移出现的脆弱的更深层次的上下文，以帮助调试根本原因。

<DocsImage src="/img/dashboard/flaky-test-management/flake-panel.png" alt="Flaky tests analytics details panel" ></DocsImage>

### 失败率vs脆弱率

当启用测试重试时，理解失败率和脆弱率之间的区别是很重要的. 在脆弱测试分析页面中，每个脆弱测试用例都会随着时间的推移跟踪这两个指标:

<DocsImage src="/img/dashboard/flaky-test-management/flake-v-fail-2.png" alt="flake rate vs fail rate" ></DocsImage>

标记为脆弱的测试用例在多次测试重试尝试后仍然可以通过. 单个测试重试尝试的测试结果状态与最终的测试状态是独立的且不同的.

例如，一个项目被配置为重试失败的测试最多3次。 前两次尝试失败，但最后一次和第三次尝试通过，导致最终状态的通过。

有了这个概念，就有可能永远有零的最终故障率，而显示脆弱，如下所示:

<DocsImage src="/img/dashboard/flaky-test-management/flake-v-fail-1.png" alt="flake rate vs fail rate" ></DocsImage>

## 脆弱报警

<Alert type="success">

<strong class="alert-header"><Icon name="star"></Icon> 超值的Dashboard功能</strong>

通过[团队Dashboard付费计划](https://cypress.io/pricing)，用户可以使用脆弱测试报警

</Alert>

Dashboard可以通过[GitHub](/guides/dashboard/github-integration) 和 [Slack integrations](/guides/dashboard/slack-integration)提供警报，以进一步帮助保持在脆弱事件的顶部.

### GitHub

通过GitHub PR评论和状态检查可以在项目的GitHub集成设置中启用 脆弱报警:

<DocsImage src="/img/dashboard/flaky-test-management/gh-flake.png" alt="GitHub flake alert settings" ></DocsImage>

启用GitHub催办警报后，GitHub PR评论将在测试摘要中显示与PR相关的脆弱测试的数量，并包括一个“脆弱”部分，突出显示特定的脆弱测试。

<DocsImage src="/img/dashboard/flaky-test-management/flake-pr-comment.png" alt="GitHub flake alert pr comment" ></DocsImage>

### Slack

通过Slack可以在Slack集成设置中启用脆弱警报:

<DocsImage src="/img/dashboard/flaky-test-management/slack-flake.png" alt="Slack flake alert settings" ></DocsImage>

启用Slack警报后，当检测到脆弱测试时，Dashboard会发送Slack消息:

<DocsImage src="/img/dashboard/flaky-test-management/flake-slack-alert.png" alt="Slack flake alert" ></DocsImage>

## 另请参阅

- 阅读我们关于对抗[脆弱测试](https://cypress.io/blog/tag/flake/) 的博客文章.
