# 自定义参数生成 1 个展示实体: /function threebody:add_custom {args:{...}}
# 可省略的键: pos 绝对坐标 / offset 相对玩家 / vel 初速度 / speed 朝玩家速率 / mass 质量(整数) / block 方块id
execute unless score #count threebody_state matches -2147483648.. run function threebody:load
function threebody:core/reset_in
$data merge storage threebody:in $(args)
function threebody:core/spawn
scoreboard players set #running threebody_state 1
