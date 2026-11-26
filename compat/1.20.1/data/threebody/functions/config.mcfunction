# 修改物理参数(保存在世界里, MC 1.20.1 storage 预设接口)
# 用法: 先 data merge storage threebody:cfg {g:0.125} 再 /function threebody:config
# 可只写想改的键; g=引力常数(0~0.5), soft=软化半径(格), speed=默认初速(格/tick,0=静止), mass=默认质量(整数)
# 例: data merge storage threebody:cfg {g:0.0625,soft:1.5,speed:0.0d,mass:1} 然后 /function threebody:config
function threebody:core/apply_config
tellraw @s {"text":"[Threebody] 物理参数已更新","color":"green"}
