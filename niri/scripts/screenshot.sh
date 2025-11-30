#!/bin/bash

# 读取传入的参数
ACTION="$1"

# 检查参数是否有效，如果无效则设置为默认值
if [ "$ACTION" != "screenshot" ] && [ "$ACTION" != "screenshot-window" ] && [ "$ACTION" != "screenshot-screen" ]; then
  ACTION="screenshot"
fi

# 获取当前剪贴板的 SHA-256 校验和
CLIPNOW=$(wl-paste | shasum)

# 执行截屏操作
niri msg action "$ACTION"

# 等待剪贴板内容发生变化
while [ "$(wl-paste | shasum)" = "$CLIPNOW" ]; do
  sleep .05
done

# 将新的剪贴板内容（截屏图片）传递给 satty
wl-paste | satty -f -
