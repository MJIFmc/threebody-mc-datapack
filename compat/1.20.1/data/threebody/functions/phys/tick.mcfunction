# 每个模拟 tick:对每个实体计算它与其他实体的引力并积分位置
execute as @e[type=minecraft:block_display,tag=threebody_body] run function threebody:phys/body
