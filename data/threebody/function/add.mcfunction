# 生成 1 个默认展示实体(黑色混凝土)并开始/继续模拟
# 例: /function threebody:add
execute unless score #count threebody_state matches -2147483648.. run function threebody:load
function threebody:core/reset_in
function threebody:core/spawn
scoreboard players set #running threebody_state 1
