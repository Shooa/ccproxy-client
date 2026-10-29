#!/bin/sh
# ccproxy client installer — one-liner:
#   curl -fsSL https://raw.githubusercontent.com/Shooa/ccproxy-client/main/install.sh | sh -s -- <твой-ключ>
# Idempotent: повторный запуск обновляет шим и ключ.
set -eu

TOKEN="${1:-}"
BASE_URL="${CCPROXY_URL:-https://cprox.konyaev.me:8787}"
RAW="https://raw.githubusercontent.com/Shooa/ccproxy-client/main"
RC="${ZDOTDIR:-$HOME}/.zshrc"

if [ -z "$TOKEN" ]; then
  echo "usage: ... | sh -s -- <sk-ant-oat01-...-ключ>" >&2
  exit 1
fi
case "$TOKEN" in
  sk-ant-oat01-*) ;;
  *) echo "install: ключ должен начинаться с sk-ant-oat01- (получи у администратора)" >&2; exit 1 ;;
esac

mkdir -p "$HOME/.ccproxy/bin"

# шим (переживает авто-обновления Claude Code, находит свежий бинарник)
curl -fsSL "$RAW/claude" -o "$HOME/.ccproxy/bin/claude"
chmod +x "$HOME/.ccproxy/bin/claude"

# per-machine ключ
umask 077
{
  echo "export CCPROXY_URL=\"$BASE_URL\""
  echo "export CCPROXY_TOKEN=\"$TOKEN\""
} > "$HOME/.ccproxy/client.env"

# PATH (один раз)
touch "$RC"
grep -q '.ccproxy/bin' "$RC" || echo 'export PATH="$HOME/.ccproxy/bin:$PATH"' >> "$RC"

echo
echo "Готово. Перезапусти терминал (или: exec zsh), затем:"
echo "  claude    — через общий пул"
echo "  aclaude   — напрямую с личным логином (если есть)"
echo "Дальше — инструкция: https://github.com/Shooa/ccproxy-client (или у администратора)"
