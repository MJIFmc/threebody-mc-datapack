# Changelog

## v2.2.0 — 2026-11-26

- **新增多版本支持**：同一套源码构建 6 个 MC 版本 —— 1.20.1 / 1.21.1 / 1.21.3 / 1.21.11 / 26.3 / 26.4-pre-1；`dist/` 下每版本一个 zip，GitHub Release v2.2.0 附带全部版本。
- **1.20.1**：新增 `compat/1.20.1/` 专用源码（复数目录 `functions/`）；因 1.20.1 无宏函数，`add_custom` / `add_<颜色>_custom` / `config` 改为 **storage 预设两步接口**（`data merge storage threebody:in {...}` → `function threebody:add_custom`），新增 `threebody:params/reset`；1.20.1 无 `teleport_duration`（仅影响客户端插值）。物理与 1.21.3 **逐位一致**（default3 / explicit3 / two_body 三个场景各 600 tick 6/6 快照 0 差异）。说明见 `docs/README-1.20.1.md`。
- **1.21.11**：内容与 1.21.3 相同，仅 `pack.mcmeta` 改为 `min_format/max_format: 94`。
- **26.3 / 26.4-pre-1**：展示实体 `block_state` 改为新格式（方块 id 字符串 / `{id:...}`），通过 `overrides/` 改两处（`core/summon_here`、`core/init`）适配；其余命令/NBT 兼容。
- **构建系统**：新增 `versions.json` + `build.py` 多版本构建（自动写 pack.mcmeta、处理 1.20.1 复数目录、合并 overrides、生成确定性 zip + `SHA256SUMS.txt`）；`build.sh` / `build.ps1` 改为包装脚本；GitHub Actions 更新为构建全部版本。
- 文档更新：README 增加版本支持/下载矩阵与 1.20.1 差异说明；技术说明增加多版本构建与验证记录。

## v2.1.0 — 2026-11-26

- **默认初始速度改为 0（静止）**：所有方块生成后静止悬空；总动量为零，系统整体不再漂移（之前默认速度 3/64 在非三体对称场景/自定义数量下会带来总动量，可能越飞越远）。
  - 单方块时没有引力对象，会一直静止；加第 2、3 个后开始互相引力塌缩、混沌缠斗，质心保持不动。
  - 想恢复"朝玩家飞来"：给 `speed`/`vel` 参数，或 `/function threebody:config {args:{speed:0.046875}}`。
- 旧版默认配置（g=0.0625/soft=1.5/speed=0.046875/mass=1，未改过任何参数）在加载 `/reload` 时自动把 speed 迁移为 0；改过配置的存档不受影响。
- 文档同步更新（默认行为/参数/FAQ/验证记录）。

## v2.0.0 — 2026-11-26

- 数据包命名空间 `santi` → **`threebody`**；仓库/文件名/实体标签/计分板目标同步更新。
- **合并 `start` 与 `add`** 为 `threebody:add`（两者功能本来就相同，现在统一为一个入口；自定义版本合并为 `threebody:add_custom`）。
- 新增 `threebody:stop` / `threebody:resume`：暂停与继续（继续不生成新实体）。
- 新增 **16 种混凝土颜色快捷指令** `threebody:add_<颜色>`（white/orange/magenta/light_blue/yellow/lime/pink/gray/light_gray/cyan/purple/blue/brown/green/red/black）。
- 新增 `threebody:add_<颜色>_custom {args:{...}}`：指定颜色的同时可按需配置质量、速度、位置、初速。
- 默认三体布局的瞄准高度与生成高度对齐到 39/64 格，**竖直方向净动量严格为 0**（v1 曾有 +576 微小残差）。
- 仓库化：新增 README / 技术说明 / CHANGELOG / 构建脚本（`build.sh`、`build.ps1`）/ `dist/` 打包产物。

## v1.0.0 — 2026-11-25（初版，命名空间 `santi`）

- 单实体生成 + 实体间牛顿引力模拟（整数定点、Plummer 软化、半隐式欧拉）。
- 默认 120° 对称三体布局（总动量为零，不漂走）。
- `/function` 自定义参数（pos / offset / vel / speed / mass / block）。
- 对应世界生成数据包 `santi_bigvoid`（后拆分为独立仓库 `threebody-bigvoid`）。
