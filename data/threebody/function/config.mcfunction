# 修改物理参数(保存在世界里): /function threebody:config {args:{g:0.0625,soft:1.5,speed:0.046875,mass:1}}
# 可只写想改的键; g=引力常数(0~0.5), soft=软化半径(格), speed=默认朝玩家初速(格/tick), mass=默认质量(整数)
$data merge storage threebody:cfg $(args)
function threebody:core/apply_config
tellraw @s {"text":"[Threebody] 物理参数已更新","color":"green"}
