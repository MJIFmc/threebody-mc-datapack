# Threebody 三体引力模拟 · MC Java 1.20.1 兼容版

> 由 v2.1.0（MC 1.21.3 原版）移植：`pack_format = 15`，数据包目录为**复数**
> `data/<ns>/functions/`、`data/minecraft/tags/functions/{load,tick}.json`。
> 物理算法/默认参数/16 色快捷指令/默认槽位/质量·速度语义与 v2.1.0 **完全一致**（1.20.1 服务端实测与 1.21.3 逐位相同，见 §6）。

- 进游戏无任何变化，只有手动执行指令才会出现方块展示实体
- 一条指令生成 1 个方块展示实体（默认黑色混凝土，初始速度 0＝静止）
- 实时模拟实体之间的**相互牛顿引力**（Plummer 软化、整数定点、半隐式欧拉）
- 默认前 3 个生成位置 120° 对称、总动量为零
- 支持 16 种混凝土颜色快捷指令

安装：把 `threebody-1.20.1/`（或打成 zip）放进存档的 `datapacks/`（服务器 `<服务器目录>/world/datapacks/`），
进世界或控制台执行 `/reload`。

---

## 1. 和 v2.1.0（1.21.3 版）的接口差异 —— 必读

**MC 1.20.1 没有宏函数**（`/function ns:f {args}`、`$(...)` 是 1.20.2+），所以：
`add_custom` / `add_<color>_custom` / `config` 的 `{args:{...}}` 写法在 1.20.1 **不存在**，
改成 **storage 预设接口**（先 `data merge` 预设参数，再调用无参函数）：

| 功能 | v2.1.0（1.21.3）写法 | 1.20.1 写法 |
|---|---|---|
| 自定义生成 | `/function threebody:add_custom {args:{mass:3,speed:0.05}}` | `data merge storage threebody:in {mass:3,speed:0.05}`<br>然后 `/function threebody:add_custom` |
| 指定颜色+自定义 | `/function threebody:add_red_custom {args:{mass:2}}` | `data merge storage threebody:in {mass:2}`<br>然后 `/function threebody:add_red_custom` |
| 改物理参数 | `/function threebody:config {args:{g:0.125}}` | `data merge storage threebody:cfg {g:0.125}`<br>然后 `/function threebody:config` |
| 清空自定义参数 | （无，每次调用自己带 args） | `/function threebody:params/reset`（新增） |

参数语义与 v2.1.0 完全相同：`pos`（绝对坐标，优先）/ `offset`（相对玩家脚底）/ `vel`（绝对初速，优先）/
`speed`（朝玩家胸口速率，0＝静止）/ `mass`（整数 1..1000）/ `block`（方块 id，颜色版强制覆盖）。
**预设会保留**到下次 `data merge` 或 `params/reset`；`add` / `add_<color>` 等快捷指令内部会先清空预设，
所以预设不会影响普通指令。

`threebody:add` / `add_<color>`（16 色）/ `stop` / `resume` / `clear` / `help` 与 v2.1.0 用法完全一样。

### 1.20.1 写法的复制即用示例

```
# 红色方块，质量 3，朝玩家速率 0.05
data merge storage threebody:in {mass:3,speed:0.05}
function threebody:add_red_custom

# 完全自定义：绝对坐标 + 初速度 + 质量 + 方块
data merge storage threebody:in {pos:[100.5,82.0,200.5], vel:[0.0,0.05,0.0], mass:2, block:"minecraft:glowstone"}
function threebody:add_custom
function threebody:params/reset

# 相对玩家脚底偏移 3 格、指定质量/速度
data merge storage threebody:in {offset:[3.0,0.0,8.0], mass:2, speed:0.08}
function threebody:add_custom
function threebody:params/reset

# 物理参数：只改想改的键
data merge storage threebody:cfg {g:0.125}
function threebody:config

# 恢复默认参数
data merge storage threebody:cfg {g:0.0625,soft:1.5,speed:0.0d,mass:1}
function threebody:config
```

---

## 2. 实现差异（相对 /mnt/f/MC/threebody 仓库 v2.1.0）

| 项 | v2.1.0 (1.21.3) | 1.20.1 兼容版 |
|---|---|---|
| 数据包格式 | `pack_format 57`，单数目录 `function/`、`tags/function/` | `pack_format 15`，**复数** `functions/`、`tags/functions/` |
| 宏函数 | `add_custom`/`add_<color>_custom`/`config` 用 `$data merge ... $(args)` | 全部删除宏；改 storage 预设接口 |
| 提前返回 | `execute ... run return 0`（1.21.3 支持） | 不依赖 `/return`，守卫改为嵌套 `execute if ... if ... run function` 拆分子函数<br>（注：实测 1.20.1 **其实支持** `/return <value>`，但按任务要求不依赖它；`return run` 形式不支持） |
| display entity NBT | `teleport_duration:2` | **删除**该字段（1.20.1 无此字段，写入会被静默忽略；实测 `data get` 读回不存在）。`brightness:{sky:15,block:15}` 保留 |
| 自定义参数入口 | 宏参数 `{args:{...}}` | `storage threebody:in` 预设 + `/function threebody:params/reset` 清空 |
| 物理参数入口 | 宏参数 `{args:{...}}` | `storage threebody:cfg` 直接 merge + `/function threebody:config` 应用 |
| 新增文件 | — | `params/reset.mcfunction`、`core/aim_range.mcfunction`、`core/aim_dir.mcfunction`、`phys/pair_body.mcfunction`、`phys/pair_force.mcfunction` |
| 物理算法 | — | **逐字不变**（定点 P=64、V=2^20、isqrt 牛顿迭代、Plummer 软化、半隐式欧拉、速度钳制、floorDiv/floorMod） |

`phys/pair` 拆法（保持完全等价）：
```
pair.mcfunction:      execute if score @s threebody_id > #iid threebody_tmp run function threebody:phys/pair_body
pair_body.mcfunction: 算 #dx/#dy/#dz; execute if 三轴都在 -20000..20000 run function threebody:phys/pair_force
pair_force.mcfunction: r2/isqrt/g/三轴受力（v2.1.0 pair 的后半段原样）
```
`core/aim` 拆法：
```
aim.mcfunction:       execute if #dx/#dy/#dz 都在 -25000..25000 run function threebody:core/aim_range
aim_range.mcfunction: 算 #r2; execute unless #r2 == 0 run function threebody:core/aim_dir
aim_dir.mcfunction:   isqrt + 三轴速度（v2.1.0 aim 的后半段原样）
```

---

## 3. 1.20.1 实测确认的底层语义（决定移植是否逐位一致）

在同版本无头服务端（Java 17，官方 server.jar，sha1 84194a2f…）实测：

| 语义 | 1.20.1 实测 | 与 1.21.3 一致? |
|---|---|---|
| `scoreboard ... /=` 负数 | `-7/2 = -4`、`7/-2 = -4`、`-7/-2 = 3`（floorDiv） | ✅ 与 1.21.3 相同（技术说明记录一致） |
| `scoreboard ... %=` 负数 | `-7%2 = 1`、`7%-2 = -1`、`-7%-2 = -1`（floorMod） | ✅ |
| `data get storage <path> <scale>` 取整 | `3.7*64 = 236`、`-0.1*64 = -7`（向下取整 floor） | ✅ |
| `execute store result entity @e Pos[0] double 0.015625` | 精确写入（100 → 1.5625，-7 → -0.109375） | ✅ |
| `data merge storage` | 支持 | ✅ |
| 宏函数 | 不支持：`/function ns:f {args:{a:1}}` → `Incorrect argument for command`；文件里 `$...` 行 → **函数加载失败**（`Failed to load function`） | — |
| `/return` | **支持 `/return <value>`**（`Function 'x' returned 0`；`execute ... run return 0` 也有效）；不支持 `return run` 形式 | ⚠️ 与任务前提不同（1.21.3 也只有 `/return <value>`） |
| `/tick` | 不存在（`tick sprint` → `Unknown or incomplete command`）；1.20.2+ 才有 | — |
| display entity | `block_display` 存在；`block_state`/`brightness`/`Tags`/`interpolation_duration` 有效；**`teleport_duration` 不存在**（summon 时静默丢弃，不报错） | — |
| 数据包格式 | `pack_format 15` + 复数目录 + `data/minecraft/tags/functions/{load,tick}.json` 正常加载/执行 | — |

---

## 4. 默认参数（与 v2.1.0 相同）

| 参数 | 默认值 | 说明 |
|---|---|---|
| `g` | `0.0625`（1/16） | 引力常数，可调 0~0.5 |
| `soft` | `1.5` | Plummer 软化半径（格），钳制 0.25~4.0 |
| `mass` | `1` | 默认质量（整数 1~1000） |
| `speed` | `0`（静止） | 默认初速；>0 时方向朝玩家胸口（脚底+39/64） |

默认槽位（相对玩家眼睛，`^左 ^上 ^前`）：前 3 个 120° 对称 `^ ^ ^4.0`、`^3.464 ^ ^-2.0`、`^-3.464 ^ ^-2.0`；
第 4 个 `^ ^ ^-4.0`，第 5 个 `^ ^2.5 ^3.5`，第 6 个起 `^ ^ ^7.0`。

---

## 5. 验收记录（1.20.1 无头服务端实测）

### 5.1 加载
- 全新世界首次加载 + `/reload`：日志 **0 条 `Failed to load` / 0 条 `Unknown`**；15 个计分板目标创建成功；
  默认配置 `threebody:cfg = {g:0.0625d,soft:1.5d,speed:0.0d,mass:1}`；
  常量 `#G_F=65536`、`#C=268435456(=2^28)`、`#softr=96`、`#soft2=9216`、`#speed=0`、`#mass=1`。
- load/tick 标签生效：`data/minecraft/tags/functions/{load,tick}.json` 正常执行。

### 5.2 功能（假玩家 = 盔甲架，tag `threebody_fake`，位于 (0.5,100,0.5)）
> 1.20.1 实测：盔甲架的 `anchored eyes` 眼高为 **0**（"眼位"= 脚底），真实玩家眼高 1.62。测试副本把 `@p` 全部替换为
> `@e[type=minecraft:armor_stand,tag=threebody_fake,limit=1]`，因此下文位置是"盔甲架脚底坐标系"下的期望值。

- `threebody:add` ×3：`Pos` 定点 `b1=(32,6336,288)`→`(0.5,99,4.5)`、`b2=(253,6336,-97)`→`(3.953125,99,-1.515625)`、
  `b3=(-190,6336,-96)`→`(-2.96875,99,-1.5)`；`vx=vy=vz=0`；`m=1`；`block_state=black_concrete`；
  `#running=1, #count=3, #next=3`。位置与 1.21.3 版**逐整数相同**（b2/b3 的 1/64 取整差异来自 `3.464` 的 double 二进制表示，两版本一致）。
- 颜色快捷指令（抽样 red/light_blue/purple/black）：`block_state` 分别为对应颜色，质量 1、初速 0。
- storage 预设版 `data merge storage threebody:in {mass:3,speed:0.05}` + `add_custom`：质量 3、初速非 0、方向朝玩家胸口。
- 颜色 custom 强制颜色：预设 `block=glowstone` + `add_blue_custom` → `blue_concrete`。
- `pos` 预设 `[10.5,120.0,-3.5]` → 定点 `(672,7680,-224)`；`offset` 预设 `[3.0,0.625,8.0]` → `(224,6440,544)`。
- `params/reset` 清空 `threebody:in`；预设不影响普通 `add`（内部 reset_in）。
- 质量钳制：`mass:0 → 1`、`mass:2000 → 1000`（与 v2.1.0 一致）。
- `config` 接口：`g:0.125` → `#G_F=131072`、`#C=536870912`；恢复默认后 `#C=268435456`。
- `help` / `stop` / `resume` / `clear` / `params/reset` 均可执行。

### 5.3 物理与 1.21.3 逐位对比（关键结论：逐位一致）

在同一台机器上另跑一份 **MC 1.21.3 官方服务端 + v2.1.0 原包**（同样的 `@p`→盔甲架测试副本），
用同一批命令（相同初始定点坐标/速度/质量，相同 tick 调度）对比**计分板整数分数**：

| 场景（各跑 600 tick，每 100 tick 抓一次 6 个快照） | 初始状态 | 6 个快照逐字段对比 |
|---|---|---|
| `default3`：默认槽位 `add`×3（黑色/质量1/静止） | 完全一致 | **6/6 全部一致（0 差异）** |
| `explicit3`：3 体绝对 pos+初速+质量+方块（红/绿/蓝，m=1/1/2） | 完全一致 | **6/6 全部一致（0 差异）** |
| `two_body`：2 体对称初速（±4 格偏移，±0.05 初速） | 完全一致 | **6/6 全部一致（0 差异）** |
| `aim1`：单体积分 `speed:0.05,mass:3` 的朝玩家初速（core/aim 路径） | 完全一致（v=(0,19609,-48845)） | — |
| `figure8`：g=0.25/soft=0.5/±11.6 格/0.27 初速（彩蛋场景） | 完全一致 | ⚠️ 发散：见下 |

`figure8` 的发散**不是算术差异**：该场景初速 ~0.37 格/tick、600 tick 会跑出出生区块加载范围；
1.21.3 的快照里 b3 已因所在区块卸载而 `@e` 选择不到（dump 缺 b3），1.20.1 仍在加载范围内，
两版本生效的实体集合不同 → 后续受力不同。4 个受控场景 0 差异已经证明
1.20.1 与 1.21.3 的 `floorDiv/floorMod`、`data get` 缩放取整、整数定点物理**逐位相同**。
（如需复跑：`python3 /tmp/santi-team/legacy/compare_versions.py`，结果在 `results/compare_*.log`。）

---

## 6. 已知限制 / 注意

1. **没有宏参数**：所有自定义参数都必须走 storage 预设（见 §1）；这是 1.20.1 的硬限制。
2. **没有 `teleport_duration`**：展示实体每 tick 直接改 `Pos`，1.21.3 里 2 tick 的传送插值在 1.20.1 没有，
   视觉上更"瞬移"一点；物理/位置数值完全一致（该字段只影响客户端插值）。
3. 无 `/tick` 命令：想快进只能让服务器正常跑（20 tps）或用 `/schedule`。
4. 1.20.1 的 `scoreboard` 目标名最长 16 字符：本包目标名最长 `threebody_state`(15)，未超限。
5. 只清了"已加载区块里"的实体（`clear` 与 v2.1.0 相同）。
6. 1.20.1 服没有 `pause-when-empty-seconds`（1.21.2+ 才有的空服暂停），无人时服务器照常 20tps，无需特殊配置。
