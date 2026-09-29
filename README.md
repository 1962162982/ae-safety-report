# 临床试验不良事件安全性汇总分析（SAS）

## 项目简介

本项目基于模拟的临床试验不良事件数据（AE）和受试者人口学数据（DM），使用 Base SAS 完成从数据导入、质量检查、数据清洗、数据集合并，到安全性汇总报表自动化的完整流程。

项目使用 SAS Macro 封装报表逻辑，结合 `PROC SQL`、`PROC FREQ`、`PROC REPORT` 和 `ODS RTF`，按治疗组自动生成不良事件安全性汇总报表。

> 说明：本项目为个人模拟项目，数据为模拟生成，不涉及真实患者，仅用于 SAS 技能展示与作品集。

---

## 数据集说明

### `ae.csv`

| 变量 | 含义 |
|---|---|
| USUBJID | 受试者编号 |
| TRT01A | 治疗组 |
| AETERM | 不良事件原始术语 |
| AEDECOD | 不良事件首选术语 |
| AEBODSYS | 系统器官分类 SOC |
| AESEV | 严重程度：MILD / MODERATE / SEVERE |
| AESER | 是否严重不良事件：Y / N |
| AESTDTC | 开始日期 |
| AEENDTC | 结束日期，可能缺失 |
| AEREL | 与药物关系 |

### `dm.csv`

| 变量 | 含义 |
|---|---|
| USUBJID | 受试者唯一编号 |
| TRT01A | 治疗组：Drug A / Placebo |
| AGE | 年龄 |
| SEX | 性别 |

---

## 任务要求

### 必做任务

1. **导入数据**
   - 使用 `PROC IMPORT` 或 DATA 步导入 `dm.csv` 和 `ae.csv`。
   - 生成 `WORK.DM` 和 `WORK.AE`。

2. **数据质量检查**
   - 检查 AE 中是否有完全重复记录。
   - 检查 `USUBJID`、`TRT01A`、`AETERM`、`AESTDTC` 是否有缺失。
   - 检查 `AE.TRT01A` 与 `DM.TRT01A` 是否一致。

3. **数据清洗**
   - 按 `USUBJID + AETERM + AESTDTC` 去重，保留唯一 AE 记录。
   - 将 `AESTDTC`、`AEENDTC` 从字符转换为 SAS 日期。
   - 计算 AE 持续时间：`AE_DUR = AEENDTC - AESTDTC + 1`。
   - 如果 `AEENDTC` 缺失，则 `AE_DUR` 设为缺失，并创建 `AE_ONGOING = 'Y'`。
   - 创建严重 AE 标志：`AESER_FL = (AESER = 'Y')`。

4. **合并数据**
   - 使用 `PROC SQL` 或 `DATA MERGE` 将 `AE_CLEAN` 与 `DM` 合并。
   - 输出分析数据集 `WORK.AE_ADSL`。

5. **汇总分析**

   生成以下汇总表：

   **表 1：按治疗组总体 AE 汇总**
   - 治疗组
   - 受试者总数
   - AE 事件数
   - 至少发生 1 个 AE 的受试者数
   - 严重 AE 事件数
   - 严重 AE 受试者数
   - 严重 AE 发生率

   **表 2：按治疗组 + SOC + PT 汇总**
   - 治疗组
   - `AEBODSYS`
   - `AEDECOD`
   - AE 事件数
   - 发生该 AE 的受试者数
   - 发生率 = 受试者数 / 组内总受试者数 × 100%

   **表 3：严重程度分布**
   - 治疗组
   - `AESEV`
   - 事件数
   - 百分比

6. **宏与报表自动化**
   - 写一个 SAS Macro，例如 `%AE_REPORT(TRT=Drug A)`。
   - 按治疗组循环输出报表。
   - 使用 `ODS RTF` 输出至少 2 份 RTF 报表。

7. **输出交付物**
   - `WORK.AE_CLEAN`
   - `WORK.AE_ADSL`
   - `WORK.AE_SUMMARY_TRT`
   - `WORK.AE_SUMMARY_SOCPT`
   - `AE_REPORT_DRUGA.RTF`
   - `AE_REPORT_PLACEBO.RTF`
   - SAS 代码、日志和结果截图。

### 加分任务

- 用 `PROC REPORT` 美化汇总表。
- 用 `PROC FREQ` 做严重 AE 与治疗组的卡方检验，仅作演示。
- 检查 SAS 日志中是否有 ERROR 或 WARNING。
- 把代码和输出放到 GitHub，简历附链接。

---

## 技术栈

- Base SAS
- SAS Macro
- `PROC IMPORT` / `PROC SQL` / `PROC FREQ` / `PROC REPORT`
- `ODS RTF`
- 数据清洗、去重、日期转换、变量派生、数据集合并
- 临床安全性汇总报表自动化

---

## 项目结构

```text
ae-safety-report/
├── README.md
├── .gitignore
├── code/
│   ├── 01_import.sas
│   ├── 02_check.sas
│   ├── 03_clean.sas
│   ├── 04_merge.sas
│   ├── 05_summary.sas
│   └── 06_report.sas
├── data/
│   ├── dm.csv
│   └── ae.csv
├── output/
│   ├── AE_REPORT_DRUGA.RTF
│   └── AE_REPORT_PLACEBO.RTF
├── log/
│   └── run.log
└── screenshot/
    ├── table1.png
    ├── table2.png
    └── table3.png
```

---

## 输出交付物

| 交付物 | 含义 |
|---|---|
| `WORK.AE_CLEAN` | 清洗后的 AE 数据集 |
| `WORK.AE_ADSL` | AE 与 DM 合并后的分析数据集 |
| `WORK.AE_SUMMARY_TRT` | 按治疗组的总体 AE 汇总表 |
| `WORK.AE_SUMMARY_SOCPT` | 按 SOC / PT 的 AE 明细汇总表 |
| `AE_REPORT_DRUGA.RTF` | Drug A 组安全性汇总报表 |
| `AE_REPORT_PLACEBO.RTF` | Placebo 组安全性汇总报表 |
| SAS 代码 / 日志 / 截图 | 运行过程与结果佐证 |

---

## 如何运行

1. 将 `dm.csv` 和 `ae.csv` 放入 `data/` 目录。
2. 按顺序运行 `code/` 下的 SAS 程序：
   - `01_import.sas`
   - `02_check.sas`
   - `03_clean.sas`
   - `04_merge.sas`
   - `05_summary.sas`
   - `06_report.sas`
3. 检查 `log/run.log` 中是否有 ERROR 或 WARNING。
4. 在 `output/` 目录查看生成的 RTF 报表。

---

## 说明

- 本项目为个人模拟项目，数据为模拟生成，不涉及真实患者。
- 卡方检验仅用于演示，不代表真实临床结论。
- 报表中的发生率分母为该治疗组受试者总数。