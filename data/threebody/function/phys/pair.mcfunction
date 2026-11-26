# 内循环: 实体 j (作为 @s), 与 #iid 的实体 i 之间的引力
# 设 d = p_j - p_i, r = sqrt(d^2+soft2), g = C/r^2
# 加速度: a_i = + (g*m_j/r) * d,  a_j = - (g*m_i/r) * d
execute if score @s threebody_id <= #iid threebody_tmp run return 0
# 位置差 d (1/64 方块单位, 绝对值超过 312 格视为无引力)
scoreboard players operation #dx threebody_tmp = @s threebody_px
scoreboard players operation #dx threebody_tmp -= #ipx threebody_tmp
scoreboard players operation #dy threebody_tmp = @s threebody_py
scoreboard players operation #dy threebody_tmp -= #ipy threebody_tmp
scoreboard players operation #dz threebody_tmp = @s threebody_pz
scoreboard players operation #dz threebody_tmp -= #ipz threebody_tmp
execute unless score #dx threebody_tmp matches -20000..20000 run return 0
execute unless score #dy threebody_tmp matches -20000..20000 run return 0
execute unless score #dz threebody_tmp matches -20000..20000 run return 0
# r2 = d^2 + soft2
scoreboard players operation #r2 threebody_tmp = #dx threebody_tmp
scoreboard players operation #r2 threebody_tmp *= #dx threebody_tmp
scoreboard players operation #q threebody_tmp = #dy threebody_tmp
scoreboard players operation #q threebody_tmp *= #dy threebody_tmp
scoreboard players operation #r2 threebody_tmp += #q threebody_tmp
scoreboard players operation #q threebody_tmp = #dz threebody_tmp
scoreboard players operation #q threebody_tmp *= #dz threebody_tmp
scoreboard players operation #r2 threebody_tmp += #q threebody_tmp
scoreboard players operation #r2 threebody_tmp += #soft2 threebody_c
function threebody:phys/isqrt
# g = C / r2
scoreboard players operation #g threebody_tmp = #C threebody_c
scoreboard players operation #g threebody_tmp /= #r2 threebody_tmp
# x 轴
scoreboard players operation #u threebody_tmp = #g threebody_tmp
scoreboard players operation #u threebody_tmp *= #dx threebody_tmp
scoreboard players operation #u threebody_tmp /= #r threebody_tmp
scoreboard players operation #w threebody_tmp = #u threebody_tmp
scoreboard players operation #w threebody_tmp *= @s threebody_m
scoreboard players operation #iax threebody_tmp += #w threebody_tmp
scoreboard players operation #w threebody_tmp = #u threebody_tmp
scoreboard players operation #w threebody_tmp *= #im threebody_tmp
scoreboard players operation @s threebody_vx -= #w threebody_tmp
# y 轴
scoreboard players operation #u threebody_tmp = #g threebody_tmp
scoreboard players operation #u threebody_tmp *= #dy threebody_tmp
scoreboard players operation #u threebody_tmp /= #r threebody_tmp
scoreboard players operation #w threebody_tmp = #u threebody_tmp
scoreboard players operation #w threebody_tmp *= @s threebody_m
scoreboard players operation #iay threebody_tmp += #w threebody_tmp
scoreboard players operation #w threebody_tmp = #u threebody_tmp
scoreboard players operation #w threebody_tmp *= #im threebody_tmp
scoreboard players operation @s threebody_vy -= #w threebody_tmp
# z 轴
scoreboard players operation #u threebody_tmp = #g threebody_tmp
scoreboard players operation #u threebody_tmp *= #dz threebody_tmp
scoreboard players operation #u threebody_tmp /= #r threebody_tmp
scoreboard players operation #w threebody_tmp = #u threebody_tmp
scoreboard players operation #w threebody_tmp *= @s threebody_m
scoreboard players operation #iaz threebody_tmp += #w threebody_tmp
scoreboard players operation #w threebody_tmp = #u threebody_tmp
scoreboard players operation #w threebody_tmp *= #im threebody_tmp
scoreboard players operation @s threebody_vz -= #w threebody_tmp
