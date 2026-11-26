# 清空 storage threebody:in 里的自定义参数预设(add_custom / add_<color>_custom 的输入)
# 用法: /function threebody:params/reset
function threebody:core/reset_in
tellraw @s {"text":"[Threebody] 自定义参数已清空(恢复默认)","color":"green"}
