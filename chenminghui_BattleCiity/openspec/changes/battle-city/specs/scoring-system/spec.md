## ADDED Requirements

### Requirement: 分数计算
系统MUST按敌人类型给予不同的击杀分数，并实时更新显示。

#### Scenario: 击杀得分记录
- **WHEN** 玩家消灭敌人坦克
- **THEN** 系统SHALL按敌人类型添加分数：基础型+100分、快速型+200分、重甲型+300分，并立即更新HUD显示

#### Scenario: 关卡完成奖励
- **WHEN** 关卡中所有敌人被消灭
- **THEN** 系统SHALL给予关卡完成奖励分数 = 剩余基地围墙砖块数 × 50分

### Requirement: 生命值系统
玩家MUST拥有初始3条生命，被敌人子弹击中扣除1条生命，生命归零则游戏结束。

#### Scenario: 初始生命值
- **WHEN** 游戏开始（进入第1关）
- **THEN** 玩家生命值SHALL初始化为3

#### Scenario: 被击中扣命
- **WHEN** 玩家坦克被敌人子弹击中
- **THEN** 生命值SHALL减少1，HUD上生命图标减少一个，玩家获得2秒无敌状态

#### Scenario: 复活
- **WHEN** 玩家失去生命但生命值大于0
- **THEN** 玩家坦克SHALL在基地附近出生点重新生成，保留当前分数和道具效果

#### Scenario: 生命归零游戏结束
- **WHEN** 玩家生命值降为0
- **THEN** 游戏SHALL进入GAME_OVER状态，显示最终得分

#### Scenario: 额外生命获取
- **WHEN** 玩家得分达到20000分的倍数
- **THEN** 玩家SHALL获得1条额外生命（生命值上限为9）

### Requirement: 关卡进度保存
系统MUST在关卡完成时自动保存进度，支持玩家重新启动后从上次关卡继续。

#### Scenario: 自动保存进度
- **WHEN** 关卡完成（所有敌人被消灭）
- **THEN** 系统SHALL将当前关卡号、得分、生命值自动保存到Preferences

#### Scenario: 加载存档
- **WHEN** 玩家在主菜单选择"继续游戏"
- **THEN** 系统SHALL从Preferences读取上次存档数据，从对应关卡开始游戏，恢复得分和生命值

#### Scenario: 新游戏
- **WHEN** 玩家在主菜单选择"新游戏"
- **THEN** 系统SHALL清除旧存档，从第1关开始，得分归零，生命值重置为3

### Requirement: 最高分记录
系统MUST记录并显示历史最高分。

#### Scenario: 更新最高分
- **WHEN** 游戏结束时当前得分大于历史最高分
- **THEN** 系统SHALL更新最高分记录并保存到Preferences，在游戏结束界面标注"新纪录"

#### Scenario: 主菜单显示最高分
- **WHEN** 主菜单显示
- **THEN** 系统SHALL读取并在主菜单上显示历史最高分
