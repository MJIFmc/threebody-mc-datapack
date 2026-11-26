# 初始化自定义实体(作为新实体执行,读取 threebody:in)
tag @s remove threebody_new
scoreboard players add #next threebody_state 1
scoreboard players operation @s threebody_id = #next threebody_state
scoreboard players add #count threebody_state 1
# ---- 位置 ----
execute if data storage threebody:in pos run execute store result score @s threebody_px run data get storage threebody:in pos[0] 64
execute if data storage threebody:in pos run execute store result score @s threebody_py run data get storage threebody:in pos[1] 64
execute if data storage threebody:in pos run execute store result score @s threebody_pz run data get storage threebody:in pos[2] 64
execute if data storage threebody:in offset run execute store result score #ppx threebody_tmp run data get entity @p Pos[0] 64
execute if data storage threebody:in offset run execute store result score #ppy threebody_tmp run data get entity @p Pos[1] 64
execute if data storage threebody:in offset run execute store result score #ppz threebody_tmp run data get entity @p Pos[2] 64
execute if data storage threebody:in offset run execute store result score #q threebody_tmp run data get storage threebody:in offset[0] 64
execute if data storage threebody:in offset run scoreboard players operation @s threebody_px = #ppx threebody_tmp
execute if data storage threebody:in offset run scoreboard players operation @s threebody_px += #q threebody_tmp
execute if data storage threebody:in offset run execute store result score #q threebody_tmp run data get storage threebody:in offset[1] 64
execute if data storage threebody:in offset run scoreboard players operation @s threebody_py = #ppy threebody_tmp
execute if data storage threebody:in offset run scoreboard players operation @s threebody_py += #q threebody_tmp
execute if data storage threebody:in offset run execute store result score #q threebody_tmp run data get storage threebody:in offset[2] 64
execute if data storage threebody:in offset run scoreboard players operation @s threebody_pz = #ppz threebody_tmp
execute if data storage threebody:in offset run scoreboard players operation @s threebody_pz += #q threebody_tmp
execute unless data storage threebody:in pos run execute unless data storage threebody:in offset run execute store result score @s threebody_px run data get entity @s Pos[0] 64
execute unless data storage threebody:in pos run execute unless data storage threebody:in offset run execute store result score @s threebody_py run data get entity @s Pos[1] 64
execute unless data storage threebody:in pos run execute unless data storage threebody:in offset run scoreboard players remove @s threebody_py 64
execute unless data storage threebody:in pos run execute unless data storage threebody:in offset run execute store result score @s threebody_pz run data get entity @s Pos[2] 64
scoreboard players set @s threebody_rx 0
scoreboard players set @s threebody_ry 0
scoreboard players set @s threebody_rz 0
# ---- 质量 ----
scoreboard players operation @s threebody_m = #mass threebody_c
execute if data storage threebody:in mass run execute store result score @s threebody_m run data get storage threebody:in mass 1
execute if score @s threebody_m matches ..0 run scoreboard players set @s threebody_m 1
execute if score @s threebody_m matches 1001.. run scoreboard players set @s threebody_m 1000
# ---- 方块类型 ----
execute if data storage threebody:in block run data modify entity @s block_state.Name set from storage threebody:in block
# ---- 初速度 ----
execute if data storage threebody:in vel run execute store result score @s threebody_vx run data get storage threebody:in vel[0] 1048576
execute if data storage threebody:in vel run execute store result score @s threebody_vy run data get storage threebody:in vel[1] 1048576
execute if data storage threebody:in vel run execute store result score @s threebody_vz run data get storage threebody:in vel[2] 1048576
# 没给 vel 时:朝玩家方向,速率取 speed 参数或默认 #speed
execute unless data storage threebody:in vel run execute store result score #ppx threebody_tmp run data get entity @p Pos[0] 64
execute unless data storage threebody:in vel run execute store result score #ppy threebody_tmp run data get entity @p Pos[1] 64
execute unless data storage threebody:in vel run scoreboard players add #ppy threebody_tmp 39
execute unless data storage threebody:in vel run execute store result score #ppz threebody_tmp run data get entity @p Pos[2] 64
execute unless data storage threebody:in vel run scoreboard players operation #spd threebody_tmp = #speed threebody_c
execute if data storage threebody:in speed run execute store result score #spd threebody_tmp run data get storage threebody:in speed 1048576
execute unless data storage threebody:in vel run scoreboard players operation #dx threebody_tmp = #ppx threebody_tmp
execute unless data storage threebody:in vel run scoreboard players operation #dx threebody_tmp -= @s threebody_px
execute unless data storage threebody:in vel run scoreboard players operation #dy threebody_tmp = #ppy threebody_tmp
execute unless data storage threebody:in vel run scoreboard players operation #dy threebody_tmp -= @s threebody_py
execute unless data storage threebody:in vel run scoreboard players operation #dz threebody_tmp = #ppz threebody_tmp
execute unless data storage threebody:in vel run scoreboard players operation #dz threebody_tmp -= @s threebody_pz
execute unless data storage threebody:in vel run function threebody:core/aim
function threebody:phys/render
