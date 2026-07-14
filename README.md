# A股每日简报

定时任务目标：**AI 收集信息 → 今日复盘 → 明日推荐策略**（不绑定读者当前仓位）。

## 飞书精简版应包含
定性、较昨日、主攻/备选、明日一句话、买/不做、置顶

## 配置
1. 仓库 push 后，在 Automations 粘贴 `AUTOMATION_INSTRUCTIONS.md`
2. Webhook 已写在 Instructions 内
3. 触发：你已设的每日时间（如 22:00 GMT+8）
4. Active + Run now 验证

本地文件：`PROMPT.md` / `TEMPLATE.md` / `scripts/send_feishu.sh`
