# ccproxy client installer (Windows / PowerShell)
# Одной командой из PowerShell:
#   iex "& { $(irm https://raw.githubusercontent.com/Shooa/ccproxy-client/main/install.ps1) } '<твой-ключ>'"
param([Parameter(Mandatory=$true)][string]$Token)

$ErrorActionPreference = 'Stop'
$BaseUrl = if ($env:CCPROXY_URL) { $env:CCPROXY_URL } else { 'https://cprox.konyaev.me:8787' }

if ($Token -notlike 'sk-ant-oat01-*') {
    Write-Host "install: ключ должен начинаться с sk-ant-oat01- (получи у администратора)" -ForegroundColor Red
    exit 1
}

# Пользовательские переменные окружения (действуют для всех новых терминалов)
[Environment]::SetEnvironmentVariable('ANTHROPIC_BASE_URL', $BaseUrl, 'User')
[Environment]::SetEnvironmentVariable('ANTHROPIC_AUTH_TOKEN', $Token, 'User')

# Ключ на диске — для переустановок/справки
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.ccproxy" | Out-Null
@"
export CCPROXY_URL="$BaseUrl"
export CCPROXY_TOKEN="$Token"
"@ | Set-Content -Encoding ascii "$env:USERPROFILE\.ccproxy\client.env"

Write-Host ""
Write-Host "Готово. Открой НОВОЕ окно терминала и запусти: claude" -ForegroundColor Green
Write-Host "Переменные пользовательские: чтобы временно ходить с личным логином,"
Write-Host "запусти в сессии:  `$env:ANTHROPIC_BASE_URL=''; `$env:ANTHROPIC_AUTH_TOKEN=''; claude"
