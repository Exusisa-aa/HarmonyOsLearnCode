---
### 📄 文件 2：DOMAIN_MODEL.md

```markdown

# Battle City 领域模型与接口契约

## 🎮 游戏概述

**原版发行**：1985 年，NAMCO 公司  
**游戏类型**：2D 固定视角战术射击  
**核心玩法**：保护鹰徽基地，消灭所有敌人坦克

---

## 📐 核心数据结构

### 1. 基础几何接口

#### IPosition - 位置坐标

```typescript
/**

* 二维坐标位置（像素单位）
* 原点 (0,0) 位于画布左上角
  */
  interface IPosition {
  /** X 坐标（横轴，向右为正） */
  x: number;
  /** Y 坐标（纵轴，向下为正） */
  y: number;
  }

#### IDimension - 尺寸规格

/**

* 矩形尺寸定义
  */
  interface IDimension {
  /** 宽度（像素） */
  width: number;
  /** 高度（像素） */
  height: number;
  }

#### IRectangle - 矩形区域
```

### 2. 方向与运动

#### Direction - 方向枚举

/**

* 坦克移动方向（四向）
* 原版仅支持上下左右，不支持斜向移动
  */
  enum Direction {
  UP = 0,    // 向上（Y 轴负方向）
  RIGHT = 1, // 向右（X 轴正方向）
  DOWN = 2,  // 向下（Y 轴正方向）
  LEFT = 3   // 向左（X 轴负方向）
  }

#### IMovable - 可移动对象

/**

* 所有可移动物体的通用接口
  */
  interface IMovable {
  /** 当前位置 */
  position: IPosition;
  /** 移动速度（像素/帧） */
  speed: number;
  /** 当前朝向 */
  direction: Direction;
  /** 是否正在移动 */
  isMoving: boolean;
  /**
  
  * 移动到指定方向
  * @param direction 目标方向
    */
    move(direction: Direction): void;
  
  /**
  
  * 停止移动
    */
    stop(): void;
  
  /**
  
  * 获取碰撞矩形
  * @returns 当前占据的矩形区域
    */
    getBounds(): IRectangle;
    }

### 3. 游戏实体接口

#### ITank - 坦克基类接口

/**

* 坦克实体接口（玩家和敌人通用）

* 逻辑尺寸：16x16 像素（用于碰撞检测、移动计算）

* 渲染尺寸：32x32 像素（放大 2 倍适配手机屏幕）
  */
  interface ITank extends IMovable, IDisposable {
  /** 坦克类型（玩家/普通敌人/高级敌人） */
  tankType: TankType;
  /** 生命值（原版均为 1 击毁） */
  health: number;
  /** 当前等级（影响子弹速度和威力） */
  level: TankLevel;
  /** 无敌状态剩余时间（毫秒） */
  invincibleTime: number;
  /** 是否被冻结（敌人特殊状态） */
  isFrozen: boolean;
  /**
  
  * 发射子弹
  * @returns 新创建的子弹对象，如果无法发射则返回 null
    */
    fire(): Bullet | null;
  
  /**
  
  * 受到攻击
  * @param damage 伤害值
    */
    takeDamage(damage: number): void;
  
  /**
  
  * 设置无敌状态
  * @param durationMs 持续时间（毫秒）
    */
    setInvincible(durationMs: number): void;
  
  /**
  
  * 更新坦克状态（每帧调用）
  * @param deltaTime 距离上一帧的时间间隔（毫秒）
    */
    update(deltaTime: number): void;
    }

#### TankType - 坦克类型枚举

/**

* 坦克种类定义
* 对应原版不同外观和属性的坦克
  */
  enum TankType {
  PLAYER = 0,           // 玩家坦克（灰色→黄色升级）
  ENEMY_BASIC = 1,      // 基本型敌人（铜色）
  ENEMY_FAST = 2,       // 快速型敌人（银色，移动快）
  ENEMY_POWER = 3,      // 力量型敌人（金色，可摧毁砖墙）
  ENEMY_ARMOR = 4,      // 装甲型敌人（需要多次击中）
  BOSS = 99             // BOSS 级敌人（最终关卡）
  }

#### IBullet - 子弹接口

/**

* 子弹实体接口

* 逻辑尺寸：3x3 像素（原版规格）

* 渲染尺寸：6x6 像素（放大 2 倍）
  */
  interface IBullet extends IDisposable {
  /** 子弹来源（玩家/敌人） */
  owner: BulletOwner;
  /** 子弹位置 */
  position: IPosition;
  /** 子弹方向 */
  direction: Direction;
  /** 子弹速度（像素/帧） */
  speed: number;
  /** 子弹伤害值 */
  damage: number;
  /** 是否已激活（未击中任何物体） */
  isActive: boolean;
  /**
  
  * 更新子弹位置（每帧调用）
  * @param deltaTime 时间间隔（毫秒）
    */
    update(deltaTime: number): void;
  
  /**
  
  * 击中目标后的处理
  * @param target 被击中的对象
    */
    onHit(target: HitTarget): void;
  
  /**
  
  * 获取子弹碰撞矩形
    */
    getBounds(): IRectangle;
    }

#### BulletOwner - 子弹归属

/**

* 子弹发射者身份
  */
  enum BulletOwner {
  PLAYER = 'player',     // 玩家发射
  ENEMY = 'enemy'        // 敌人发射
  }

#### HitTarget - 击中目标类型

/**

* 子弹可能击中的对象类型
  */
  type HitTarget = 
  | { type: 'wall'; wall: IWall }      // 墙体
  | { type: 'tank'; tank: ITank }      // 坦克
  | { type: 'base'; base: IBase }      // 基地
  | { type: 'bullet'; bullet: IBullet }// 子弹对撞
  | { type: 'boundary' };               // 边界

### 4. 地图元素

#### IWall - 墙体接口

/**

* 墙体/障碍物接口

* 逻辑尺寸：16x16 像素（26x26 网格）

* 渲染尺寸：32x32 像素（总地图 832x832 像素）
  */
  interface IWall extends IDisposable {
  /** 墙体类型 */
  wallType: WallType;
  /** 墙体位置（网格坐标） */
  gridPosition: IPosition;
  /** 墙体生命值（砖墙=1，钢墙=无限） */
  health: number;
  /** 是否已被摧毁 */
  isDestroyed: boolean;
  /**
  
  * 受到攻击
  * @param damage 伤害值
  * @returns 是否被摧毁
    */
    takeDamage(damage: number): boolean;
  
  /**
  
  * 获取墙体渲染矩形（像素坐标）
    */
    getRenderBounds(): IRectangle;
    }

#### WallType - 墙体类型枚举

/**

* 墙体材质分类
* 对应原版不同的视觉表现和物理属性
  */
  enum WallType {
  BRICK = 0,      // 砖墙（绿色）：可被子弹摧毁，坦克可通过
  STEEL = 1,      // 钢墙（银白色）：仅高等级子弹可摧毁，坦克不可通过
  FOREST = 2,     // 森林（绿色树木）：可遮挡坦克，不阻挡子弹
  ICE = 3,        // 冰面（白色）：减速效果，不阻挡子弹和坦克
  WATER = 4,      // 水域（蓝色）：阻挡坦克和子弹，不阻挡爆炸
  BASE = 5        // 基地（鹰徽）：被摧毁则游戏结束
  }

#### IMap - 地图接口

/**

* 游戏地图接口

* 原版共 35 个关卡，每关 26x26 网格

* 必须包含完整的 35 关原始地图数据（严格还原原版布局）
  */
  interface IMap extends IDisposable {
  /** 关卡编号（1-35） */
  level: number;
  /** 地图网格数据（26x26 二维数组） */
  grid: IWall[][];
  /** 基地位置 */
  basePosition: IPosition;
  /** 玩家出生点位置 */
  playerSpawnPoint: IPosition;
  /** 
  
  * 敌人出生点数组（5 个位置）
  * 1. 左上角 (1, 1)
  * 2. 右上角 (24, 1)
  * 3. 左下角 (1, 24)
  * 4. 中上区域 (12, 1) - 新增
  * 5. 中下区域 (12, 24) - 新增
       */
       enemySpawnPoints: IPosition[];
  
  /**
  
  * 根据网格坐标获取墙体
  * @param gridX 网格 X 坐标（0-25）
  * @param gridY 网格 Y 坐标（0-25）
  * @returns 墙体对象或 null
    */
    getWallAt(gridX: number, gridY: number): IWall | null;
  
  /**
  
  * 检查某位置是否可通行
  * @param pixelX 像素 X 坐标
  * @param pixelY 像素 Y 坐标
  * @param bounds 物体尺寸
  * @returns 是否可通行
    */
    isPassable(pixelX: number, pixelY: number, bounds: IDimension): boolean;
  
  /**
  
  * 解析地图数据（从数字矩阵转换为墙体对象）
  * @param mapData 原始地图数据（0=空地，1=砖墙，2=钢墙...）
    */
    parseMapData(mapData: number[][]): void;
    }

### 5. 基地系统

#### IBase - 基地接口

/**

* 基地（鹰徽）接口

* 游戏的核心保护目标
  */
  interface IBase {
  /** 基地位置（网格坐标） */
  position: IPosition;
  /** 是否存活 */
  isAlive: boolean;
  /** 基地被摧毁时的回调 */
  onDestroyed: () => void;
  /**
  
  * 基地被击中
    */
    hit(): void;
  
  /**
  
  * 重置基地状态（进入下一关）
    */
    reset(): void;
    }

### 6. 游戏状态

#### GameState - 游戏状态枚举

/**

* 游戏全局状态机
  */
  enum GameState {
  MENU = 0,          // 主菜单（选择单人/双人模式）
  PREPARING = 1,     // 关卡准备中（显示"READY"）
  PLAYING = 2,       // 游戏中
  PAUSED = 3,        // 暂停
  GAME_OVER = 4,     // 游戏结束
  VICTORY = 5,       // 胜利（通过第 35 关）
  TRANSITION = 6     // 关卡过渡（显示"GAME OVER"或"NEXT STAGE"）
  }

#### IGameInfo - 游戏信息接口

/**

* 游戏运行时信息
  */
  interface IGameInfo {
  /** 当前游戏状态 */
  currentState: GameState;
  /** 当前关卡（1-35） */
  currentStage: number;
  /** 玩家 1 得分 */
  player1Score: number;
  /** 玩家 2 得分（双人模式） */
  player2Score: number;
  /** 
  * 剩余生命数（原版设定：3 条）
  * 单人模式：仅使用 player1Lives
  * 双人模式：共享生命池，轮流使用
    */
    remainingLives: number;
    /** 已消灭敌人数 */
    enemiesDefeated: number;
    /** 本关应出现的敌人总数 */
    totalEnemiesInStage: number;
    /** 游戏开始时间戳 */
    startTime: number;
    /** 累计游戏时长（毫秒） */
    elapsedTime: number;
    }

### 7. 道具系统

#### IPowerUp - 道具接口

/**

* 道具/奖励接口

* 原版共有 7 种随机道具

* 生成规则：每消灭 20 辆敌方坦克生成 1 个（第 20、40、60...）
  */
  interface IPowerUp extends IDisposable {
  /** 道具类型 */
  powerUpType: PowerUpType;
  /** 道具位置 */
  position: IPosition;
  /** 是否存在时间限制（毫秒） */
  expireTime: number;
  /** 是否已被拾取 */
  isCollected: boolean;
  /**
  
  * 应用道具效果
  * @param tank 拾取道具的坦克
    */
    apply(tank: ITank): void;
    }

#### PowerUpType - 道具类型枚举

/**

* 道具效果分类
* 原版道具为闪烁的旗帜，持续 10 秒
* 7 种道具等概率随机出现（各 1/7 ≈ 14.3%）
  */
  enum PowerUpType {
  HELMET = 0,     // 头盔：无敌状态（10 秒）
  GRENADE = 1,    // 手榴弹：炸毁屏幕上所有敌人
  CLOCK = 2,      // 时钟：冻结所有敌人（10 秒）
  STAR = 3,       // 星星：坦克升级（提升子弹速度和威力）
  SHIP = 4,       // 船：可通行水域（10 秒）
  SHOVEL = 5,     // 铲子：加固基地周围墙体（变为钢墙，持续 20 秒）
  GUN = 6         // 枪：提升子弹威力（可摧毁所有墙体）
  }

### 8. 输入控制

#### IInputState - 输入状态接口

/**

* 玩家输入状态

* 支持键盘和虚拟按键双模式
  */
  interface IInputState {
  /** 是否按下上方向 */
  upPressed: boolean;
  /** 是否按下下方向 */
  downPressed: boolean;
  /** 是否按下左方向 */
  leftPressed: boolean;
  /** 是否按下右方向 */
  rightPressed: boolean;
  /** 是否按下开火键 */
  firePressed: boolean;
  /** 是否按下暂停键 */
  pausePressed: boolean;
  /**
  
  * 重置所有输入状态
    */
    reset(): void;
  
  /**
  
  * 获取期望的移动方向
  * @returns 方向或 null（无输入）
    */
    getDesiredDirection(): Direction | null;
    }

### 9. 存档系统

#### IGameData - 存档数据结构

/**

* 游戏存档数据接口
* 支持最高分记录和通关进度保存
  */
  interface IGameData {
  /** 玩家 1 最高分 */
  highScoreP1: number;
  /** 玩家 2 最高分（双人模式） */
  highScoreP2: number;
  /** 当前关卡（1-35） */
  currentStage: number;
  /** 已通关关卡数 */
  stagesCleared: number;
  /** 总游戏时间（毫秒） */
  totalPlayTime: number;
  /** 消灭敌人总数 */
  totalEnemiesDestroyed: number;
  /** 存档时间戳 */
  lastSaveTime: number;
  /** 难度等级 */
  difficulty: DifficultyLevel;
  }

### 10. 虚拟按键控制

#### IVirtualControl - 虚拟按键接口

/**

* 移动端虚拟按键布局

* 针对手机触摸屏优化设计
  */
  interface IVirtualControl {
  /** 方向键区域（十字键或摇杆） */
  directionalPad: DirectionalPad;
  /** 开火按钮 */
  fireButton: FireButton;
  /** 暂停按钮 */
  pauseButton: PauseButton;
  /**
  
  * 是否显示虚拟按键
  * @returns 根据设备类型自动判断（手机=显示，平板=可选）
    */
    isVisible(): boolean;
    }

🔧 工具类接口
--------

### ICollisionDetector - 碰撞检测器

interface ICollisionDetector {
  intersects(rect1: IRectangle, rect2: IRectangle): boolean;
  checkBulletWallCollision(bullet: IBullet, walls: IWall[]): HitResult | null;
  checkBulletTankCollision(bullet: IBullet, tanks: ITank[]): HitResult | null;
  checkTankWallCollision(tank: ITank, walls: IWall[]): boolean;
  checkBoundaryCollision(tank: ITank, mapBounds: IRectangle): boolean;
}

### IPathFinder - 路径查找器

interface IPathFinder {
  findPath(start: IPosition, end: IPosition, map: IMap): IPosition[];
  getRandomDirection(tank: ITank, map: IMap): Direction;
}
📊 性能指标约束
---------

// 实体数量上限
const MAX_BULLETS_ON_SCREEN = 20;
const MAX_ENEMIES_ON_SCREEN = 4;
const MAX_POWERUPS_ON_SCREEN = 1;
const MAX_PARTICLES = 50;

// 屏幕适配规范
const LOGICAL_WIDTH = 416;
const LOGICAL_HEIGHT = 416;
const RENDER_WIDTH = 832;
const RENDER_HEIGHT = 832;

// 游戏平衡配置
const PLAYER_BASE_SPEED = 2;
const PLAYER_BASE_FIRE_RATE = 30;
const BULLET_BASE_SPEED = 5;
const PLAYER_INITIAL_LIVES = 3;
