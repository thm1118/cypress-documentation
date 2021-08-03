---
title: 分析
---

Cypress Dashboard提供了分析功能，可以洞察诸如随时间的运行、运行持续时间和测试集大小随时间的可见性等指标。

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-overview.png" alt="Dashboard Analytics Screenshot" ></DocsImage>

## 运行状态

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-runs-over-time.png" alt="Dashboard Analytics Runs Over Time Screenshot" ></DocsImage>

此报告显示您的组织已记录到Cypress Dashboard的运行次数，并按运行的最终状态进行分解. 无论是在CI中还是在本地机器上，每次运行都表示此项目的`cypress run --record`的单个调用。

### 过滤器

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-runs-over-time-filters.png" alt="Dashboard Analytics Runs Over Time Filters Screenshot" ></DocsImage>

结果可能会以下条件被过滤:

- 分支
- 时间范围
- 时间间隔 (每小时，每天，每周，每月，每季度)

### 结果

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-runs-over-time-graph.png" alt="Dashboard Analytics Runs Over Time Graph Screenshot" ></DocsImage>

分别显示所选筛选器的通过、失败、运行、超时和错误测试的总运行时间.

结果可以作为逗号分隔值(CSV)文件下载，以供进一步分析.

这可以通过过滤器右边的下载图标来完成.

### 关键性能指标

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-runs-over-time-kpi.png" alt="Dashboard Analytics Runs Over Time KPI Screenshot" ></DocsImage>

每天的总运行数、通过的运行数和失败的运行数分别是所选过滤器的计算结果。

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-runs-over-time-table.png" alt="Dashboard Analytics Runs Over Time Table Screenshot" ></DocsImage>

将显示时间范围筛选器按日期分组的结果表，其中包括通过、失败、运行、超时和错误列。

## 运行持续时间

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-run-duration.png" alt="Dashboard Analytics Run Duration Screenshot" ></DocsImage>

该报告显示了项目Cypress运行的平均持续时间，包括测试并行化是如何影响总运行时间的. 注意，这里我们只包含通过的运行——失败或错误的运行会影响平均运行时间.

### 过滤器

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-run-duration-filters.png" alt="Dashboard Analytics Run Duration Filters Screenshot" ></DocsImage>

结果可能以下条件被过滤:

- 分支
- 时间范围
- 时间间隔 (每小时，每天，每周，每月，每季度)

### 结果

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-run-duration-graph.png" alt="Dashboard Analytics Run Duration Graph Screenshot" ></DocsImage>

分别显示所选筛选器的平均运行持续时间。

结果可以作为逗号分隔值(CSV)文件下载，以供进一步分析。
这可以通过过滤器右边的下载图标来完成。

### 关键性能指标

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-run-duration-kpi.png" alt="Dashboard Analytics Run Duration KPI Screenshot" ></DocsImage>

分别计算所选过滤器的平均并行度、平均运行持续时间和从并行度节省的时间。

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-run-duration-table.png" alt="Dashboard Analytics Run Duration Table Screenshot" ></DocsImage>

时间范围筛选器按日期分组的结果表将显示平均运行时间、并发性和从并行化列节省的时间.

## 测试集的大小

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-test-suite-size.png" alt="Dashboard Analytics Test Suite Size Screenshot" ></DocsImage>

这个报告显示了您的测试集是如何随时间增长的。它计算给定时间段内每天每次运行执行的测试用例的平均数量。它排除了发生错误或超时的运行，因为它们不能准确地表示测试集的大小.

### 过滤器

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-test-suite-size-filters.png" alt="Dashboard Analytics Test Suite Size Filters Screenshot" ></DocsImage>

结果可能以下条件被过滤:

- 分支
- 时间范围
- 时间间隔 (每小时，每天，每周，每月，每季度)

### 结果

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-test-suite-size-graph.png" alt="Dashboard Analytics Test Suite Size Graph Screenshot" ></DocsImage>

分别显示所选过滤器的测试套件随时间的平均大小。

结果可以作为逗号分隔值(CSV)文件下载，以供进一步分析。
这可以通过过滤器右边的下载图标来完成。

### 关键性能指标

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-test-suite-size-kpi.png" alt="Dashboard Analytics Test Suite Size KPI Screenshot" ></DocsImage>

分别计算所选过滤器的独特测试和spec文件的数量。

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-test-suite-size-table.png" alt="Dashboard Analytics Test Suite Size Table Screenshot" ></DocsImage>

使用唯一的测试和spec文件显示时间范围筛选器按日期分组的结果表。

## 失败排名

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-top-failures.png" alt="Dashboard Analytics Top Failures Screenshot" ></DocsImage>

该报告显示了测试集中最主要的失败。

### 过滤器和视图

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-top-failures-filters.png" alt="Dashboard Analytics Top Failures Filters Screenshot" ></DocsImage>

结果可以通过使用“View by”下拉框进行自定义分组。它可以被分组:

- 测试用例
- spec文件
- 标签
- 分支

结果也能被以下条件过滤:

- 分支
- 标签
- 时间范围
- 运行组
- 提交者
- Spec 文件
- 浏览器
- Cypress 版本
- 操作系统

### 结果

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-top-failures-graph.png" alt="Dashboard Analytics Top Failures Graph Screenshot" ></DocsImage>

分别显示所选筛选器的失败率测试数.

结果可以作为逗号分隔值(CSV)文件下载，以供进一步分析.

这可以通过过滤器右边的下载图标来完成.

### 关键性能指标

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-top-failures-kpi.png" alt="Dashboard Analytics Top Failures KPI Screenshot" ></DocsImage>

跟踪的主要主要绩效指标有:

- 平均故障率
- 失败的数量(由测试用例度量)

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-top-failures-table.png" alt="Dashboard Analytics Top Failures Table Screenshot" ></DocsImage>

一个按失败率分组的结果表显示了spec文件和总运行数。

## 最慢的测试

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-slowest-tests.png" alt="Dashboard Analytics Slowest Tests Screenshot" ></DocsImage>

该报告显示了测试集中最慢的测试。

### 过滤器和视图

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-slowest-tests-filters.png" alt="Dashboard Analytics Slowest Tests Filters Screenshot" ></DocsImage>

结果可以通过使用“View by”下拉框进行自定义分组。它可以被分组:

- 测试用例
- spec文件
- 标签
- 分支

结果也能被以下条件过滤:

- 分支
- 标签
- 时间范围
- 运行组
- 提交者
- Spec 文件
- 浏览器
- Cypress 版本
- 操作系统

### 结果

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-slowest-tests-graph.png" alt="Dashboard Analytics Slowest Tests Graph Screenshot" ></DocsImage>

最慢的测试按时间持续时间显示。

结果可以作为逗号分隔值(CSV)文件下载，以供进一步分析。
这可以通过过滤器右边的下载图标来完成。

### 关键性能指标

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-slowest-tests-kpi.png" alt="Dashboard Analytics Slowest Tests KPI Screenshot" ></DocsImage>

跟踪的主要主要绩效指标有:

- 中位数时间
- 测试用例的总数

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-slowest-tests-table.png" alt="Dashboard Analytics Slowest Tests Table Screenshot" ></DocsImage>

按中位数持续时间和总运行次数分组的结果表。

## 最常见的错误

该报告显示了测试集中最常见的错误类型的影响。

<DocsImage src="/img/dashboard/analytics/dashboard-analytics-common-errors.png" alt="Dashboard Analytics Slowest Tests Table Screenshot" ></DocsImage>
