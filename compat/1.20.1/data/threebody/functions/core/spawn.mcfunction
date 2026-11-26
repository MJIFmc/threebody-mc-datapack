# 生成位置优先级: pos(绝对坐标) > offset(相对玩家脚底) > 默认槽位(按场上实体数)
execute if data storage threebody:in pos run function threebody:core/summon_here
execute unless data storage threebody:in pos run execute if data storage threebody:in offset run execute at @p anchored eyes run function threebody:core/summon_here
execute unless data storage threebody:in pos run execute unless data storage threebody:in offset run function threebody:core/spawn_slot
