# 默认槽位: 前 3 个 120° 对称(总动量为零, 不会整体漂走), 之后依次换位置避免重叠
# 槽位是相对玩家眼睛的局部坐标(^左 ^上 ^前)
scoreboard players operation #slot threebody_tmp = #count threebody_state
execute if score #slot threebody_tmp matches 0 run execute at @p anchored eyes positioned ^ ^ ^4.0 run function threebody:core/summon_here
execute if score #slot threebody_tmp matches 1 run execute at @p anchored eyes positioned ^3.464 ^ ^-2.0 run function threebody:core/summon_here
execute if score #slot threebody_tmp matches 2 run execute at @p anchored eyes positioned ^-3.464 ^ ^-2.0 run function threebody:core/summon_here
execute if score #slot threebody_tmp matches 3 run execute at @p anchored eyes positioned ^ ^ ^-4.0 run function threebody:core/summon_here
execute if score #slot threebody_tmp matches 4 run execute at @p anchored eyes positioned ^ ^2.5 ^3.5 run function threebody:core/summon_here
execute if score #slot threebody_tmp matches 5.. run execute at @p anchored eyes positioned ^ ^ ^7.0 run function threebody:core/summon_here
