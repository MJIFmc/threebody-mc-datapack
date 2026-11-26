# 在当前位置生成 1 个方块展示实体(默认黑色混凝土, init 里会按参数换方块/质量/速度), 然后初始化
summon minecraft:block_display ~ ~ ~ {block_state:{Name:"minecraft:black_concrete"},Tags:["threebody_body","threebody_new"],teleport_duration:2,brightness:{sky:15,block:15}}
execute as @e[type=minecraft:block_display,tag=threebody_new,limit=1] run function threebody:core/init
