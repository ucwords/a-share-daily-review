# A股三时报：早盘 + 午盘 + 盘后

| 任务 | 时间（北京） | 指令文件 | 报告 | 飞书标题 |
|------|--------------|----------|------|----------|
| 集合竞价后开盘策略 | **09:25** | `AUTOMATION_INSTRUCTIONS_MORNING.md` | `reports/YYYY-MM-DD-morning.md` | 【A股早盘】 |
| 午前走势 + 午后建议 | **12:30** | `AUTOMATION_INSTRUCTIONS_MIDDAY.md` | `reports/YYYY-MM-DD-midday.md` | 【A股午盘】 |
| 全日复盘 + 明日策略 | 如 **22:00** | `AUTOMATION_INSTRUCTIONS.md` | `reports/YYYY-MM-DD.md` | 【A股复盘】 |

都不绑定读者实时仓位；策略写「计划新开 / 若已持有」。

**选股重心（成交额 Top100）**
- 早盘：09:15–09:25 **竞价**成交额 Top100
- 午盘：截至午前（约 09:30–11:30）成交额 Top100
- 盘后：当日全日成交额 Top100

**非交易日：跳过总结与飞书发送**（仅回复一行后结束）。Trigger 建议周一至五。

## 部署午盘（第三条）

1. Automations → **New**
2. Name：`A股午盘复盘`
3. Trigger：周一至五 **12:30 GMT+8**
4. Repo：`a-share-daily-review` / `main`
5. 粘贴 `AUTOMATION_INSTRUCTIONS_MIDDAY.md` 粘贴区
6. Active → 交易日 Run now 验证

若飞书机器人开了关键词，请增加：`A股午盘`（与 `A股早盘`、`A股复盘` 并列）。

## 本地文件

- 早盘：`PROMPT_MORNING.md` / `TEMPLATE_MORNING.md`
- 午盘：`PROMPT_MIDDAY.md` / `TEMPLATE_MIDDAY.md`
- 盘后：`PROMPT.md` / `TEMPLATE.md`
