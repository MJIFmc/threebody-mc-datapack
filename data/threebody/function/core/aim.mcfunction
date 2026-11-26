# 输入: #dx,#dy,#dz (1/64 方块单位), #spd (速度 2^20 单位/方块/tick)
# 输出: 给 @s 设置 threebody_vx/vy/vz = 朝 (#dx,#dy,#dz) 方向, 速率 #spd
execute unless score #dx threebody_tmp matches -25000..25000 run return 0
execute unless score #dy threebody_tmp matches -25000..25000 run return 0
execute unless score #dz threebody_tmp matches -25000..25000 run return 0
scoreboard players operation #r2 threebody_tmp = #dx threebody_tmp
scoreboard players operation #r2 threebody_tmp *= #dx threebody_tmp
scoreboard players operation #q threebody_tmp = #dy threebody_tmp
scoreboard players operation #q threebody_tmp *= #dy threebody_tmp
scoreboard players operation #r2 threebody_tmp += #q threebody_tmp
scoreboard players operation #q threebody_tmp = #dz threebody_tmp
scoreboard players operation #q threebody_tmp *= #dz threebody_tmp
scoreboard players operation #r2 threebody_tmp += #q threebody_tmp
execute if score #r2 threebody_tmp matches 0 run return 0
function threebody:phys/isqrt
scoreboard players operation #u threebody_tmp = #dx threebody_tmp
scoreboard players operation #u threebody_tmp *= #s1024 threebody_c
scoreboard players operation #u threebody_tmp /= #r threebody_tmp
scoreboard players operation #w threebody_tmp = #u threebody_tmp
scoreboard players operation #w threebody_tmp *= #spd threebody_tmp
scoreboard players operation #w threebody_tmp /= #s1024 threebody_c
scoreboard players operation @s threebody_vx = #w threebody_tmp
scoreboard players operation #u threebody_tmp = #dy threebody_tmp
scoreboard players operation #u threebody_tmp *= #s1024 threebody_c
scoreboard players operation #u threebody_tmp /= #r threebody_tmp
scoreboard players operation #w threebody_tmp = #u threebody_tmp
scoreboard players operation #w threebody_tmp *= #spd threebody_tmp
scoreboard players operation #w threebody_tmp /= #s1024 threebody_c
scoreboard players operation @s threebody_vy = #w threebody_tmp
scoreboard players operation #u threebody_tmp = #dz threebody_tmp
scoreboard players operation #u threebody_tmp *= #s1024 threebody_c
scoreboard players operation #u threebody_tmp /= #r threebody_tmp
scoreboard players operation #w threebody_tmp = #u threebody_tmp
scoreboard players operation #w threebody_tmp *= #spd threebody_tmp
scoreboard players operation #w threebody_tmp /= #s1024 threebody_c
scoreboard players operation @s threebody_vz = #w threebody_tmp
