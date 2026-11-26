# 位置差 d (1/64 方块单位, 绝对值超过 312 格视为无引力)
scoreboard players operation #dx threebody_tmp = @s threebody_px
scoreboard players operation #dx threebody_tmp -= #ipx threebody_tmp
scoreboard players operation #dy threebody_tmp = @s threebody_py
scoreboard players operation #dy threebody_tmp -= #ipy threebody_tmp
scoreboard players operation #dz threebody_tmp = @s threebody_pz
scoreboard players operation #dz threebody_tmp -= #ipz threebody_tmp
# 距离守卫: 三轴都在 -20000..20000 才计算引力(替代 return 0)
execute if score #dx threebody_tmp matches -20000..20000 if score #dy threebody_tmp matches -20000..20000 if score #dz threebody_tmp matches -20000..20000 run function threebody:phys/pair_force
