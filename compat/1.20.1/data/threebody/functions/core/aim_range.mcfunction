# 守卫通过: 计算 #r2 = |d|^2, 为 0 时无方向(直接结束, 等价 v2.1.0 的 return 0)
scoreboard players operation #r2 threebody_tmp = #dx threebody_tmp
scoreboard players operation #r2 threebody_tmp *= #dx threebody_tmp
scoreboard players operation #q threebody_tmp = #dy threebody_tmp
scoreboard players operation #q threebody_tmp *= #dy threebody_tmp
scoreboard players operation #r2 threebody_tmp += #q threebody_tmp
scoreboard players operation #q threebody_tmp = #dz threebody_tmp
scoreboard players operation #q threebody_tmp *= #dz threebody_tmp
scoreboard players operation #r2 threebody_tmp += #q threebody_tmp
execute unless score #r2 threebody_tmp matches 0 run function threebody:core/aim_dir
