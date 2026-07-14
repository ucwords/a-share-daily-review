#!/usr/bin/env bash
# 向飞书自定义机器人群推送文本
# 用法：
#   ./scripts/send_feishu.sh "消息正文"
#   echo "消息" | ./scripts/send_feishu.sh
#
# Webhook 查找顺序：
#   1) 环境变量 FEISHU_WEBHOOK_URL
#   2) config/feishu.local.env（本机，勿提交）
#   3) config/feishu.cloud.env（私有仓可选提交，供 Cloud Agent）
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

load_env_file() {
  local f="$1"
  if [[ -f "$f" ]]; then
    # shellcheck disable=SC1090
    set -a
    source "$f"
    set +a
  fi
}

# 已有环境变量则优先生效；否则尝试文件
if [[ -z "${FEISHU_WEBHOOK_URL:-}" ]]; then
  load_env_file "${ROOT}/config/feishu.local.env"
fi
if [[ -z "${FEISHU_WEBHOOK_URL:-}" ]]; then
  load_env_file "${ROOT}/config/feishu.cloud.env"
fi

if [[ -z "${FEISHU_WEBHOOK_URL:-}" ]]; then
  echo "未找到 FEISHU_WEBHOOK_URL。请设置环境变量，或配置 config/feishu.local.env / config/feishu.cloud.env" >&2
  exit 1
fi

if [[ $# -gt 0 ]]; then
  TEXT="$*"
else
  TEXT="$(cat)"
fi

MAX=3500
if [[ ${#TEXT} -gt $MAX ]]; then
  TEXT="${TEXT:0:$MAX}

……（已截断）完整版见仓库 reports/"
fi

# 飞书关键词：消息需含「A股复盘」或「A股早盘」（兼容旧词「A股简报」）
if [[ "$TEXT" != *"A股复盘"* && "$TEXT" != *"A股早盘"* && "$TEXT" != *"A股简报"* ]]; then
  TEXT="【A股复盘】
${TEXT}"
fi

JSON_TEXT="$(printf '%s' "$TEXT" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')"

if [[ -n "${FEISHU_SECRET:-}" ]]; then
  TS="$(date +%s)"
  SIGN="$(printf '%s\n%s' "$TS" "$FEISHU_SECRET" | openssl dgst -sha256 -hmac "$FEISHU_SECRET" -binary | base64)"
  PAYLOAD=$(printf '{"timestamp":"%s","sign":"%s","msg_type":"text","content":{"text":%s}}' "$TS" "$SIGN" "$JSON_TEXT")
else
  PAYLOAD=$(printf '{"msg_type":"text","content":{"text":%s}}' "$JSON_TEXT")
fi

curl -sS -X POST "${FEISHU_WEBHOOK_URL}" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD"
echo
