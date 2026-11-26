# 内循环: 实体 j (作为 @s), 与 #iid 的实体 i 之间的引力
# MC 1.20.1 没有 `return run` 形式; id 排序守卫改成嵌套 execute if + 子函数(替代 return 0)
execute if score @s threebody_id > #iid threebody_tmp run function threebody:phys/pair_body
