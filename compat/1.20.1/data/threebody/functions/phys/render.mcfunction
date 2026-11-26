# 把定点位置同步到展示实体的 Pos (1/64 方块精度, 数值精确)
execute store result entity @s Pos[0] double 0.015625 run scoreboard players get @s threebody_px
execute store result entity @s Pos[1] double 0.015625 run scoreboard players get @s threebody_py
execute store result entity @s Pos[2] double 0.015625 run scoreboard players get @s threebody_pz
