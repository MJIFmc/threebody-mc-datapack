# 输入: #dx,#dy,#dz (1/64 方块单位), #spd (速度 2^20 单位/方块/tick)
# 输出: 给 @s 设置 threebody_vx/vy/vz = 朝 (#dx,#dy,#dz) 方向, 速率 #spd
# MC 1.20.1 没有 `return run` 形式; 守卫用嵌套 execute if 判断, 命中才进子函数(替代 return 0)
execute if score #dx threebody_tmp matches -25000..25000 if score #dy threebody_tmp matches -25000..25000 if score #dz threebody_tmp matches -25000..25000 run function threebody:core/aim_range
