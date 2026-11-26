# ============================================================
# Threebody Gravity 三体引力模拟 - 初始化
# 每次进入世界 / /reload 时执行(数据包装好静止不动,只有调用 add / add_* 才生成实体)
# ============================================================
scoreboard objectives add threebody_px dummy
scoreboard objectives add threebody_py dummy
scoreboard objectives add threebody_pz dummy
scoreboard objectives add threebody_vx dummy
scoreboard objectives add threebody_vy dummy
scoreboard objectives add threebody_vz dummy
scoreboard objectives add threebody_rx dummy
scoreboard objectives add threebody_ry dummy
scoreboard objectives add threebody_rz dummy
scoreboard objectives add threebody_m dummy
scoreboard objectives add threebody_id dummy
scoreboard objectives add threebody_state dummy
scoreboard objectives add threebody_c dummy
scoreboard objectives add threebody_tmp dummy
# 状态: running 是否在模拟; next 下一个实体 id; count 当前实体数
scoreboard players set #running threebody_state 0
execute unless score #next threebody_state matches -2147483648.. run scoreboard players set #next threebody_state 0
execute store result score #count threebody_state run execute if entity @e[type=minecraft:block_display,tag=threebody_body]
# 常量: 位置定点 1/64 方块(P=64), 速度/加速度定点 1/2^20 (V=1048576)
# K = V/P = 16384: 每 tick 位移(1/64方块单位) = 速度整数 / K
scoreboard players set #K threebody_c 16384
scoreboard players set #neg1 threebody_c -1
scoreboard players set #two threebody_c 2
scoreboard players set #three threebody_c 3
scoreboard players set #s1024 threebody_c 1024
scoreboard players set #s4096 threebody_c 4096
scoreboard players set #vmax threebody_c 1073741824
# 默认配置(可通过 /function threebody:config {args:{...}} 修改)
# 默认初始速度 = 0(静止): 总动量为零, 系统整体不会漂移
execute unless data storage threebody:cfg g run data merge storage threebody:cfg {g:0.0625d,soft:1.5d,speed:0.0d,mass:1}
# v2.1.0 迁移: 旧版默认配置(未改过任何参数)的 speed 从 0.046875 改为 0
execute if data storage threebody:cfg {g:0.0625d,soft:1.5d,speed:0.046875d,mass:1} run data modify storage threebody:cfg speed set value 0.0d
function threebody:core/apply_config
