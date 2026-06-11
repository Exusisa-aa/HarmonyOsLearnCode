## ADDED Requirements

### Requirement: AABB碰撞检测
系统MUST使用轴对齐包围盒（AABB）进行所有实体间的碰撞检测。

#### Scenario: 坦克与地形碰撞
- **WHEN** 坦克移动后的AABB与地形瓦片AABB重叠
- **THEN** 系统SHALL检测到碰撞，阻止坦克进入该瓦片区域，将坦克位置修正到碰撞前

#### Scenario: 子弹与坦克碰撞
- **WHEN** 子弹AABB与坦克AABB重叠
- **THEN** 系统SHALL检测到碰撞，触发伤害逻辑（坦克受到伤害，子弹消失）

#### Scenario: 子弹与地形碰撞
- **WHEN** 子弹AABB与地形瓦片AABB重叠
- **THEN** 系统SHALL检测到碰撞，根据瓦片类型触发对应响应（砖墙破坏或钢墙反弹）

### Requirement: 空间分区优化
系统SHALL使用网格空间分区优化碰撞检测，将26×26的地图划分为网格单元，仅检测相邻单元的实体碰撞。

#### Scenario: 网格查询
- **WHEN** 执行碰撞检测
- **THEN** 系统SHALL仅对位于同一网格单元或相邻单元的实体对进行AABB检测，跳过距离较远的实体对

#### Scenario: 实体网格更新
- **WHEN** 实体位置发生变化
- **THEN** 系统SHALL更新该实体所在的网格单元索引

### Requirement: 边界检测
系统MUST检测所有实体是否超出游戏区域边界（416×416像素的Canvas区域）。

#### Scenario: 坦克边界限制
- **WHEN** 坦克移动后位置超出游戏区域（超出顶部HUD区域或底部控制区域）
- **THEN** 系统SHALL限制坦克位置在有效游戏区域内

#### Scenario: 子弹出界
- **WHEN** 子弹移动后位置超出游戏区域
- **THEN** 子弹SHALL被标记为失效并被移除

### Requirement: 碰撞响应
系统MUST对不同类型的碰撞执行相应的响应逻辑。

#### Scenario: 坦克间碰撞
- **WHEN** 两个坦克的AABB重叠
- **THEN** 双方SHALL停止向对方方向移动，双方坦克保持在碰撞前位置

#### Scenario: 子弹穿透限制
- **WHEN** 一颗子弹已经命中了一个实体
- **THEN** 该子弹SHALL不会在同一逻辑帧内继续检测更多碰撞（防止一弹多杀）

#### Scenario: 友军伤害豁免
- **WHEN** 玩家子弹与玩家坦克碰撞 或 敌人子弹与敌人坦克碰撞
- **THEN** 系统SHALL忽略该次碰撞（无友军伤害）

#### Scenario: 玩家子弹与敌人子弹碰撞
- **WHEN** 玩家子弹AABB与敌人子弹AABB重叠
- **THEN** 两颗子弹SHALL同时消失（互相抵消），不产生其他伤害
