#!/usr/bin/env bash
# 向飞书自定义机器人群推送文本
# 用法：
#   ./scripts/send_feishu.sh "消息正文"
#   echo "消息" | ./scripts/send_feishu.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="${ROOT}/config/feishu.local.env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "缺少 ${ENV_FILE}，请先：cp config/feishu.example.env config/feishu.local.env 并填入 Webhook" >&2
  exit 1
fi

# shellcheck disable=SC1090
source "$ENV_FILE"

if [[ -z "${FEISHU_WEBHOOK_URL:-}" ]]; then
  echo "FEISHU_WEBHOOK_URL 为空" >&2
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

if [[ "$TEXT" != *"A股简报"* ]]; then
  TEXT="【A股简报】
${TEXT}"
fi

JSON_TEXT="$(printf '%s' "$TEXT" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')"

if [[ -n "${FEISHU_SECRET:-}" ]]; then
  TS="$(date +%s)"
  # 飞书：string_to_sign = timestamp + "\n" + secret；再用 secret 做 HMAC-SHA256 后 Base64
  SIGN="$(printf '%s\n%s' "$TS" "$FEISHU_SECRET" | openssl dgst -sha256 -hmac "$FEISHU_SECRET" -binary | base64)"
  PAYLOAD=$(printf '{"timestamp":"%s","sign":"%s","msg_type":"text","content":{"text":%s}}' "$TS" "$SIGN" "$JSON_TEXT")
else
  PAYLOAD=$(printf '{"msg_type":"text","content":{"text":%s}}' "$JSON_TEXT")
fi

curl -sS -X POST "${FEISHU_WEBHOOK_URL}" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD"
echo
