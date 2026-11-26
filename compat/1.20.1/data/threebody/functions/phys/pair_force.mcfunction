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
