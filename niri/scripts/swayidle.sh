#!/bin/sh

# 查找关键命令的绝对路径 (如果 'which' 命令失败，则使用默认值)
QS_PATH=$(which qs || echo "/usr/bin/qs")
NIRI_PATH=$(which niri || echo "/usr/bin/niri")
SYSTEMCTL_PATH=$(which systemctl || echo "/usr/bin/systemctl")

# -w: 等待事件，不要立即退出
# 所有指令都在一行上以避免 shell 解析错误
swayidle -w timeout 600 "$QS_PATH -c noctalia-shell ipc call lockScreen lock" timeout 660 "$NIRI_PATH msg action power-off-monitors" resume "$NIRI_PATH msg action power-on-monitors" timeout 1800 "$SYSTEMCTL_PATH hibernate" before-sleep "$QS_PATH -c noctalia-shell ipc call lockScreen lock"
