# 自定义参数生成 1 个黄绿色混凝土方块 (MC 1.20.1 storage 预设接口; 方块颜色固定为黄绿色)
# 用法: 先 data merge storage threebody:in {mass:2,speed:0.05,...} 再 /function threebody:add_lime_custom
# 可预设的键: pos / offset / vel / speed / mass (block 会被强制为 minecraft:lime_concrete)
# 参数会保留到下次修改; 想恢复默认请执行 /function threebody:params/reset
execute unless score #count threebody_state matches -2147483648.. run function threebody:load
data modify storage threebody:in block set value "minecraft:lime_concrete"
function threebody:core/spawn
scoreboard players set #running threebody_state 1
