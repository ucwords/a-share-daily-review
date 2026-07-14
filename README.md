# A股双时报：盘后 + 早盘

| 任务 | 时间（北京） | 指令文件 | 报告 |
|------|--------------|----------|------|
| 盘后复盘 + 明日策略 | 如 22:00 | `AUTOMATION_INSTRUCTIONS.md` | `reports/YYYY-MM-DD.md` |
| 集合竞价后开盘策略 | **09:25 工作日** | `AUTOMATION_INSTRUCTIONS_MORNING.md` | `reports/YYYY-MM-DD-morning.md` |

都不绑定读者实时仓位；策略写「计划新开 / 若已持有」。

**非交易日（周末/法定休市）：跳过总结与飞书发送**，Agent 仅回复一行说明后结束。  
触发器若设「每天」，仍靠指令判断休市；更省费用可把 Trigger 设为周一至五。

## 部署第二条（早盘）

1. Automations → **New**（不要改盘后那条）
2. Name：`A股早盘竞价`
3. Trigger：周一至五 **09:25 GMT+8**
4. Repo：同一个 `a-share-daily-review`
5. 粘贴 `AUTOMATION_INSTRUCTIONS_MORNING.md` 粘贴区
6. Active → 下一个交易日再验证（或交易日早上 Run now）

飞书标题：
- 盘后：`【A股简报】`
- 早盘：`【A股早盘】`

## 本地文件

- 盘后：`PROMPT.md` / `TEMPLATE.md`
- 早盘：`PROMPT_MORNING.md` / `TEMPLATE_MORNING.md`
