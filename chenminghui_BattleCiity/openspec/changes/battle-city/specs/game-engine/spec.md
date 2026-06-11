## ADDED Requirements

### Requirement: 游戏循环
系统SHALL维护一个稳定的游戏循环，目标帧率为60 FPS，逻辑更新使用固定时间步长（16ms），渲染与逻辑更新分离。

#### Scenario: 正常游戏循环运行
- **WHEN** 游戏处于运行状态
- **THEN** 每16ms执行一次逻辑更新（移动、碰撞检测、AI）并且每个渲染帧绘制当前游戏状态到Canvas

#### Scenario: 帧率下降时的表现
- **WHEN** 设备性能不足导致帧间隔超过32ms
- **THEN** 系统SHALL执行多次逻辑更新追赶进度，确保游戏逻辑不因帧率波动而加速或减速

### Requirement: 游戏状态管理
系统SHALL管理游戏的状态转换，支持以下状态：启动（STARTUP）、主菜单（MENU）、关卡加载（LOADING）、运行中（PLAYING）、暂停（PAUSED）、关卡完成（LEVEL_COMPLETE）、游戏结束（GAME_OVER）。

#### Scenario: 游戏启动
- **WHEN** 应用启动
- **THEN** 游戏进入STARTUP状态，加载必要资源，然后自动转换到MENU状态显示主菜单

#### Scenario: 游戏暂停与恢复
- **WHEN** 玩家在PLAYING状态下点击暂停按钮
- **THEN** 游戏进入PAUSED状态，游戏循环停止逻辑更新但保持渲染，显示暂停面板；再次点击恢复时回到PLAYING状态

#### Scenario: 关卡完成
- **WHEN** 所有敌人被消灭
- **THEN** 游戏进入LEVEL_COMPLETE状态，显示过关信息，2秒后加载下一关卡

#### Scenario: 游戏结束
- **WHEN** 玩家基地被摧毁或玩家生命值为0
- **THEN** 游戏进入GAME_OVER状态，显示游戏结束界面和最终得分

### Requirement: Canvas渲染
系统SHALL使用HarmonyOS Canvas 2D API绘制所有游戏场景元素，包括地图、坦克、子弹、道具和特效。

#### Scenario: 游戏场景渲染
- **WHEN** 游戏处于PLAYING状态
- **THEN** Canvas SHALL绘制：地图瓦片（背景/砖墙/钢墙/水/森林/冰/基地）、所有坦克实体、所有子弹实体、所有道具实体、爆炸特效

#### Scenario: 渲染层级
- **WHEN** 渲染游戏场景
- **THEN** 渲染顺序SHALL为：地形层→道具层→子弹层→坦克层→特效层→基地保护层

### Requirement: 资源管理
系统SHALL在游戏启动时加载所有必要的图片和配置资源，并在关卡切换时合理管理内存。

#### Scenario: 资源预加载
- **WHEN** 游戏进入STARTUP状态
- **THEN** 系统SHALL加载所有瓦片图片、坦克精灵、UI图片等资源，加载完成后进入MENU状态

#### Scenario: 关卡切换资源管理
- **WHEN** 从当前关卡切换到新关卡
- **THEN** 系统SHALL释放旧关卡实体资源（坦克、子弹、道具对象），加载新关卡地图数据，复用图片纹理资源
