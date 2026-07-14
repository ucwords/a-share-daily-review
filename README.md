# A股每日简报（精简版 + 飞书推送）

每晚：大盘 → 热点 → 盘后信息 → 每热点 1～2 只票 → 仓位建议 → **飞书群通知**。

## 你怎么拿到结果

1. **飞书群**：机器人推送「手机精简版」（到点直接看）
2. **仓库**：`reports/YYYY-MM-DD.md`（完整版）
3. **Automations Runs**：运行历史里的 Agent 输出

## 配置飞书（约 3 分钟）

```bash
cd a-share-daily-review
cp config/feishu.example.env config/feishu.local.env
# 把群机器人 Webhook 写入 feishu.local.env
chmod +x scripts/send_feishu.sh
echo "【A股简报】连通性测试" | bash scripts/send_feishu.sh
```

群内应出现一条测试消息。`feishu.local.env` 已在 `.gitignore`，**不要发给别人、不要 commit**。

Cloud Automation 请把同一 Webhook 配成环境变量 **`FEISHU_WEBHOOK_URL`**（云端读不到你电脑上的 local 文件）。

## Automations

1. 本目录 push 成独立 git 仓库  
2. [Automations](https://cursor.com/automations) → New  
3. 粘贴 `AUTOMATION_INSTRUCTIONS.md` 文案  
4. Secrets 里加 `FEISHU_WEBHOOK_URL`  
5. 定时工作日 21:00，先 Run now 试跑  

把 Webhook 给我时：可只发「已配到 local 文件」；若必须粘贴，配好后请立刻当作敏感信息保管，避免进公开仓库。
