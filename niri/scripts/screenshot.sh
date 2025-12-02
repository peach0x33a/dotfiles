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

#!/bin/bash

EDIT_ACTION_KEY="editScreenshot"
# 发送通知，并捕获用户点击的动作 KEY
# notify-send 会将用户点击的动作 KEY 输出到标准输出
clicked_action=$(notify-send "截图成功" \
    "图片已复制到剪贴板" \
    --urgency=low \
    --expire-time=10000 \
--action="$EDIT_ACTION_KEY=编辑截图")

if [ "$clicked_action" = "$EDIT_ACTION_KEY" ]; then
    # echo "will send to satty" > /tmp/satty-log.log
    # 如果点击了，则将剪贴板内容（截屏图片）传递给 satty
    wl-paste | satty --action-on-enter save-to-clipboard --actions-on-right-click exit --copy-command wl-copy --early-exit -f -
fi

