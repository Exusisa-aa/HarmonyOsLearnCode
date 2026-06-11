---
### 📄 文件 3：ARCHITECTURE.md

```markdown

# Battle City 架构蓝图与模块依赖

## 🏗️ 整体架构设计

### 1. 分层架构图

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃          📱 Presentation Layer               ┃
┃     (UI 组件、菜单、HUD、游戏界面)            ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃          ⚙️ Game Logic Layer                 ┃
┃     (游戏循环、状态机、实体管理)              ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃          🔧 Core Systems Layer               ┃
┃     (渲染系统、物理系统、音频系统)            ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃          💾 Data Layer                       ┃
┃     (模型接口、资源数据、配置常量)            ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

* * *

## 📁 目录结构规范

### 强制约定


╔══════════════════════════════════════════════════════════════════╗
║  🎮 Battle City 项目目录结构                                      ║
╠══════════════════════════════════════════════════════════════════╣
║  entry/src/main/ets/                                             ║
║  │                                                               ║
║  ├─ 📁 entryability/          → Ability 入口（禁止修改）          ║
║  │   └─ EntryAbility.ets                                        ║
║  │                                                               ║
║  ├─ 📁 pages/                 → 游戏页面层                       ║
║  │   ├─ Index.ets           → 主入口页面                        ║
║  │   ├─ GamePage.ets        → 游戏主场景页面                    ║
║  │   ├─ MenuPage.ets        → 菜单页面                          ║
║  │   └─ GameOverPage.ets    → 结束页面                          ║
║  │                                                               ║
║  ├─ 📁 components/            → UI 组件层                        ║
║  │   ├─ views/              → 视图组件                          ║
║  │   ├─ controls/           → 控制组件                          ║
║  │   └─ dialogs/            → 对话框组件                        ║
║  │                                                               ║
║  ├─ 📁 models/                → 数据模型层                       ║
║  │   ├─ interfaces/         → 接口定义                          ║
║  │   ├─ entities/           → 实体实现                          ║
║  │   └─ enums/              → 枚举定义                          ║
║  │                                                               ║
║  ├─ 📁 systems/               → 核心系统层                       ║
║  │   ├─ GameLoopSystem.ts   → 游戏循环系统                      ║
║  │   ├─ RenderSystem.ts     → 渲染系统                          ║
║  │   ├─ PhysicsSystem.ts    → 物理碰撞系统                      ║
║  │   ├─ AISystem.ts         → 敌人 AI 系统                       ║
║  │   ├─ InputSystem.ts      → 输入控制系统                      ║
║  │   ├─ AudioSystem.ts      → 音频管理系统                      ║
║  │   └─ PowerUpSystem.ts    → 道具系统                          ║
║  │                                                               ║
║  ├─ 📁 managers/              → 管理器层                         ║
║  │   ├─ EntityManager.ts    → 实体管理器                        ║
║  │   ├─ GameStateManager.ts → 状态管理器                        ║
║  │   ├─ LevelManager.ts     → 关卡管理器                        ║
║  │   ├─ ScoreManager.ts     → 分数管理器                        ║
║  │   └─ ResourceManager.ts  → 资源管理器                        ║
║  │                                                               ║
║  ├─ 📁 utils/                 → 工具类层                         ║
║  │   ├─ CollisionUtil.ts    → 碰撞检测工具                      ║
║  │   ├─ MathUtil.ts         → 数学计算工具                      ║
║  │   ├─ ObjectPool.ts       → 对象池工具                        ║
║  │   └─ Logger.ts           → 日志工具                          ║
║  │                                                               ║
║  ├─ 📁 constants/             → 常量配置层                       ║
║  │   ├─ GameConfig.ts       → 游戏全局配置                      ║
║  │   ├─ TankStats.ts        → 坦克属性配置                      ║
║  │   └─ LevelData.ts        → 关卡数据配置                      ║
║  │                                                               ║
║  └─ 📁 resources/             → 资源文件层                       ║
║      ├─ images/             → 图片资源                          ║
║      ├─ audio/              → 音频资源                          ║
║      └─ maps/               → 地图数据                          ║
╚══════════════════════════════════════════════════════════════════╝
---

## 🔌 模块职责与依赖关系

### 1. Presentation Layer（表现层）

#### pages/GamePage.ets

**职责**：承载游戏主场景，管理 Canvas 上下文  
**依赖**：`systems/*`, `components/views/*`  
**禁止**：包含任何业务逻辑代码

```typescript
@Component
export struct GamePage {
  @State private gameLoop: GameLoopSystem | null = null;

  aboutToAppear() {
    this.gameLoop = new GameLoopSystem();
  }

  build() {
    Stack() {
      Canvas(this.onCanvasReady)
        .width('100%')
        .height('100%')
      HUDView({ score: this.score })
        .position({ x: 0, y: 0 })
      VirtualJoystick()
        .visibility(this.showControls ? Visibility.Visible : Visibility.Hidden)
    }

  }
}

### 2. Game Logic Layer（游戏逻辑层）

#### systems/GameLoopSystem.ts

**职责**：游戏主循环，协调所有子系统  
**依赖**：`systems/*`, `managers/*`  
**性能要求**：单帧耗时 < 16.67ms
class GameLoopSystem implements IDisposable {
  private lastTime: number = 0;
  private accumulator: number = 0;
  private readonly FIXED_TIME_STEP = 16.67;

  start(canvasContext: CanvasRenderingContext) {
    this.lastTime = Date.now();
    this.loop();
  }

  private loop() {
    const currentTime = Date.now();
    let deltaTime = currentTime - this.lastTime;
    if (deltaTime > 1000) deltaTime = this.FIXED_TIME_STEP;
    this.accumulator += deltaTime;
    while (this.accumulator >= this.FIXED_TIME_STEP) {
      this.updateLogic(this.FIXED_TIME_STEP);
      this.accumulator -= this.FIXED_TIME_STEP;
    }
    this.renderSystem.render();
    this.lastTime = currentTime;
    requestAnimationFrame(() => this.loop());

  }

  dispose() {
    // 停止循环，释放资源
  }
}

### 3. Core Systems Layer（核心系统层）

#### systems/RenderSystem.ts

**职责**：统一渲染调度  
**依赖**：`@ohos.canvas`, `components/views/*`  
**渲染顺序**：地图 → 墙体 → 坦克 → 子弹 → 特效 → HUD
class RenderSystem {
  private canvasContext: CanvasRenderingContext;
  private scaleRatio: number = 2.0;

  render() {
    this.canvasContext.clear();
    this.canvasContext.save();
    const centerX = this.canvasWidth / 2;
    const centerY = this.canvasHeight / 2;
    this.canvasContext.translate(centerX, centerY);
    this.canvasContext.scale(this.scaleRatio, this.scaleRatio);
    this.canvasContext.translate(-centerX, -centerY);
    this.drawBackground();
    this.drawWalls();
    this.drawTanks();
    this.drawBullets();
    this.drawExplosions();
    this.canvasContext.restore();
    this.canvasContext.flush();

  }
}

### 4. Data Layer（数据层）

#### constants/GameConfig.ts

**职责**：全局游戏参数配置
export class GameConfig {
  static readonly MAP_GRID_WIDTH = 26;
  static readonly MAP_GRID_HEIGHT = 26;
  static readonly GRID_SIZE = 16;
  static readonly PLAYER_BASE_SPEED = 2;
  static readonly PLAYER_BASE_FIRE_RATE = 30;
  static readonly ENEMY_SPAWN_INTERVAL = 3000;
  static readonly ENEMY_MAX_COUNT = 4;
  static readonly BULLET_BASE_SPEED = 5;
  static readonly PLAYER_INITIAL_LIVES = 3;
}
🔗 模块依赖规则
---------

✅ 允许：上层依赖下层
❌ 禁止：下层依赖上层
❌ 禁止：同层循环依赖

pages/ (L4)
  ↓ depends on
components/ (L3)
  ↓ depends on
systems/ (L2)
  ↓ depends on
managers/ (L1)
  ↓ depends on
models/ (L0)

🧵 并发模型设计
---------

### TaskPool 任务分类

#### 高优先级任务（立即执行）

class CriticalCollisionTask implements taskpool.Task {
  async execute() {
    // 检测子弹是否击中玩家
  }
}
```

#### 低优先级任务（批量处理）

class EnemyAITask implements taskpool.Task {
  async execute() {
    // 计算所有敌人的最佳移动方向
  }
}
📊 性能监控体系

---------

class PerformanceMonitor {
  private frameCount = 0;
  private lastTime = 0;
  private fps = 0;

  update() {
    this.frameCount++;
    const now = Date.now();
    if (now - this.lastTime >= 1000) {
      this.fps = this.frameCount;
      this.frameCount = 0;
      this.lastTime = now;
      if (this.fps < 30) {
        console.warn('⚠️ FPS 低于 30！当前:', this.fps);
      }
    }

  }
}
