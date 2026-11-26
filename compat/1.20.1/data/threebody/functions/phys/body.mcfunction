# 外循环: 实体 i (作为 @s)
scoreboard players operation #iid threebody_tmp = @s threebody_id
scoreboard players operation #ipx threebody_tmp = @s threebody_px
scoreboard players operation #ipy threebody_tmp = @s threebody_py
scoreboard players operation #ipz threebody_tmp = @s threebody_pz
scoreboard players operation #im threebody_tmp = @s threebody_m
scoreboard players set #iax threebody_tmp 0
scoreboard players set #iay threebody_tmp 0
scoreboard players set #iaz threebody_tmp 0
# 内循环: 找 id 更大的实体 j,计算 i-j 之间的引力(j 立刻加到自己的速度,i 的加速度先累积)
execute as @e[type=minecraft:block_display,tag=threebody_body] run function threebody:phys/pair
# 把累积的加速度加回 i 的速度
scoreboard players operation @s threebody_vx += #iax threebody_tmp
scoreboard players operation @s threebody_vy += #iay threebody_tmp
scoreboard players operation @s threebody_vz += #iaz threebody_tmp
execute if score @s threebody_vx matches 1073741824.. run scoreboard players set @s threebody_vx 1073741823
execute if score @s threebody_vx matches ..-1073741824 run scoreboard players set @s threebody_vx -1073741823
execute if score @s threebody_vy matches 1073741824.. run scoreboard players set @s threebody_vy 1073741823
execute if score @s threebody_vy matches ..-1073741824 run scoreboard players set @s threebody_vy -1073741823
execute if score @s threebody_vz matches 1073741824.. run scoreboard players set @s threebody_vz 1073741823
execute if score @s threebody_vz matches ..-1073741824 run scoreboard players set @s threebody_vz -1073741823
function threebody:phys/integrate
function threebody:phys/render
