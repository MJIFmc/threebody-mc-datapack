# Changelog

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
