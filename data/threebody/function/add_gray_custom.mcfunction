# 自定义参数生成 1 个灰色混凝土方块(方块颜色固定为灰色, 其它可配置)
# 例: /function threebody:add_gray_custom {args:{mass:2,speed:0.05}}
# 可省略的键: pos / offset / vel / speed / mass
execute unless score #count threebody_state matches -2147483648.. run function threebody:load
function threebody:core/reset_in
$data merge storage threebody:in $(args)
data modify storage threebody:in block set value "minecraft:gray_concrete"
function threebody:core/spawn
scoreboard players set #running threebody_state 1
