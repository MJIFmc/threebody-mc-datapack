# 快捷生成 1 个橙色混凝土方块(默认质量/速度/槽位)
# 例: /function threebody:add_orange
# 想改质量/速度: /function threebody:add_orange_custom {args:{mass:2,speed:0.05}}
execute unless score #count threebody_state matches -2147483648.. run function threebody:load
function threebody:core/reset_in
data modify storage threebody:in block set value "minecraft:orange_concrete"
function threebody:core/spawn
scoreboard players set #running threebody_state 1
