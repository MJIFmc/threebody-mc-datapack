# 清除所有展示实体并重置(注意: 只清得掉已加载区块里的实体)
kill @e[type=minecraft:block_display,tag=threebody_body]
scoreboard players set #running threebody_state 0
scoreboard players set #count threebody_state 0
scoreboard players set #next threebody_state 0
function threebody:core/reset_in
