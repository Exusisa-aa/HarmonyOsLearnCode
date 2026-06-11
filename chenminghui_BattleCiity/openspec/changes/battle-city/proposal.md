## Why

Battle City（坦克大战）是1985年Namco发行的经典坦克射击游戏。本提案旨在使用HarmonyOS DevEco Studio和ArkTS语言完整复刻该游戏，作为鸿蒙应用开发课程工程化作业。项目将展示HarmonyOS原生Canvas 2D游戏开发能力，并实践OpenSpec规范驱动的工程化开发流程。

## What Changes

- 基于ArkTS实现完整的游戏引擎核心，支持稳定的60 FPS游戏循环
- 实现玩家坦克的8方向移动和射击系统，支持触摸/手势控制
- 实现至少3种不同类型的敌人AI坦克，具备智能寻路和避障能力
- 实现关卡系统，包含可破坏砖墙、不可破坏钢墙和玩家基地保护机制
- 实现高效的碰撞检测系统（坦克-子弹-地形），含边界检测和碰撞响应
- 实现完整的得分和生命值管理系统，支持关卡进度保存和游戏存档
- 实现至少4种能量提升道具（加速、护盾、增强火力、冰冻等），含生成、收集和过期机制
- 实现完整的UI系统（主菜单、设置、HUD、暂停/结束界面、触摸控制）
- 至少实现10个不同关卡，覆盖头三关以上的完整玩法
- 提供画布渲染的游戏场景和HarmonyOS原生风格的UI组件

## Capabilities

### New Capabilities

- `game-engine`: 游戏引擎核心 — 游戏循环（60 FPS）、状态管理（初始化/运行/暂停/结束）、Canvas 2D渲染管线、资源加载管理
- `player-control`: 玩家坦克控制 — 8方向移动、射击系统（冷却时间、子弹轨迹）、与障碍物和敌人的碰撞响应
- `enemy-ai`: 敌人AI系统 — 至少3种敌人类型、智能寻路与避障、基于难度的射击精度、敌人生成与重生机制
- `level-system`: 关卡系统 — 至少10个关卡、可破坏砖墙与不可破坏钢墙、基地保护、关卡加载与切换
- `collision-detection`: 碰撞检测系统 — 坦克-子弹-地形碰撞、边界检测、碰撞响应（伤害计算、地形破坏）
- `scoring-system`: 得分与进度系统 — 分数计算（按敌人类型）、生命值管理、关卡完成判定、游戏存档/读档
- `power-up-system`: 能量提升系统 — 至少4种道具（加速/护盾/增强火力/冰冻等）、生成与收集、临时效果与过期处理
- `ui-system`: UI系统 — 主菜单、设置界面、游戏HUD（分数/生命/关卡/能量状态）、暂停/结束界面、触摸十字键控制

### Modified Capabilities

<!-- No existing capabilities to modify -->

## Impact

- **ArkTS源码**: `entry/src/main/ets/` — 全部游戏逻辑、UI组件、游戏引擎模块
- **资源文件**: `entry/src/main/resources/` — 图片素材、音效文件、关卡配置文件
- **构建配置**: `build-profile.json5`、`oh-package.json5` — SDK版本配置（API 10）
- **OpenSpec规范**: `openspec/specs/` — 8个能力规范文档
- **外部依赖**: 无第三方游戏引擎，纯HarmonyOS原生Canvas 2D + ArkUI实现
