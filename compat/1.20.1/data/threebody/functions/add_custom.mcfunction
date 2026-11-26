# 自定义参数生成 1 个展示实体 (MC 1.20.1: 没有宏函数, 参数改为 storage 预设接口)
# 用法: 先 data merge storage threebody:in {mass:3,speed:0.05,...} 再 /function threebody:add_custom
# 可预设的键: pos 绝对坐标 / offset 相对玩家 / vel 初速度 / speed 朝玩家速率 / mass 质量(整数) / block 方块id
# 参数会保留到下次修改; 想恢复默认请执行 /function threebody:params/reset
execute unless score #count threebody_state matches -2147483648.. run function threebody:load
function threebody:core/spawn
scoreboard players set #running threebody_state 1
