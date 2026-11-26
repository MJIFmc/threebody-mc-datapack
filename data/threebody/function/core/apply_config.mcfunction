# 由 threebody:cfg 存储中的物理配置计算常量(内部使用,勿直接调用)
# G_F = g * 2^20 (整数); C = G_F * 64^2 = G_F*4096 (引力常数定点)
execute store result score #G_F threebody_tmp run data get storage threebody:cfg g 1048576
execute if score #G_F threebody_tmp matches 524288.. run scoreboard players set #G_F threebody_tmp 524287
execute if score #G_F threebody_tmp matches ..0 run scoreboard players set #G_F threebody_tmp 0
scoreboard players operation #C threebody_c = #G_F threebody_tmp
scoreboard players operation #C threebody_c *= #s4096 threebody_c
# 软化半径软: softr = ε*64, soft2 = softr^2 (限制 0.25..4.0)
execute store result score #softr threebody_c run data get storage threebody:cfg soft 64
execute if score #softr threebody_c matches ..15 run scoreboard players set #softr threebody_c 16
execute if score #softr threebody_c matches 257.. run scoreboard players set #softr threebody_c 256
scoreboard players operation #soft2 threebody_c = #softr threebody_c
scoreboard players operation #soft2 threebody_c *= #softr threebody_c
# 默认初速(定点)与默认质量
execute store result score #speed threebody_c run data get storage threebody:cfg speed 1048576
execute if score #speed threebody_c matches ..0 run scoreboard players set #speed threebody_c 1
execute if score #speed threebody_c matches 2097153.. run scoreboard players set #speed threebody_c 2097152
execute store result score #mass threebody_c run data get storage threebody:cfg mass 1
execute if score #mass threebody_c matches ..0 run scoreboard players set #mass threebody_c 1
execute if score #mass threebody_c matches 1001.. run scoreboard players set #mass threebody_c 1000
