# 每 tick 只做一次判断:没有启动时什么都不做(进游戏无变化)
execute if score #running threebody_state matches 1 run function threebody:phys/tick
