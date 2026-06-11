# Battle City 精细复刻工程 - AI 生产约束系统

## 🎯 项目定位

**目标**：1:1 精细复刻 1985 年 NAMCO 公司经典游戏《Battle City》（坦克大战）
**平台**：HarmonyOS 6.0.2 (API Version 22)
**语言**：arkts (严格模式)
**标准**：生产级质量，非示例程序

---

## 📋 核心技术规范

### 1. 技术栈锁定

```typescript
// 必须使用的 API

- HarmonyOS SDK 6.0.2.130 (API 22)
- @ohos.canvas (Canvas2D 渲染)
- @ohos.multimedia.audio (音频播放)
- @ohos.resourceManager (资源管理)
- @ohos.taskpool (并发计算)

// 禁止使用的特性

- 禁止使用 Web 组件
- 禁止使用第三方游戏引擎
- 禁止使用已废弃的 API (参考 API 22 弃用列表)

### 2. 代码风格强制约定

#### 2.1 文件命名规范

✅ 正确：

- TankView.ets (组件必须以 View 结尾)
- GameScenePage.ets (页面必须以 Page 结尾)
- CollisionUtil.ets (工具类必须以 Util 结尾)
- GameConstants.ets (常量文件必须以 Constants 结尾)
- ITank.ts (接口必须以 I 开头)

❌ 错误：

- tank.ets
- TankComponent.ets
- tank-helper.ets

#### 2.2 变量与函数命名

// 类名：PascalCaseclass TankRenderer { }

// 接口名：PascalCase，必须以 I 开头interface IMovable { }

// 函数名：camelCasefunction calculateCollision() { }

// 常量：UPPER_SNAKE_CASEconst MAX_TANK_COUNT = 4;

// 私有成员：以下划线前缀标识private _currentDirection: Direction;

// 状态装饰器：必须标注注释@State @ObservedVARIABLES score: number = 0; // 玩家得分

#### 2.3 注释规范 (JSDoc 标准)

/**

* 坦克移动逻辑处理器
* @module TankMovement
* @version 1.0.0
* @author AI Assistant*/

/**

* 计算坦克与墙体的碰撞检测结果
* @function checkWallCollision
* @param {Tank} tank - 待检测的坦克对象
* @param {Wall[]} walls - 墙体数组
* @returns {boolean} 是否发生碰撞
* @throws {TypeError} 当参数类型错误时*/

### 3. 性能红线

#### 3.1 主线程约束

// ✅ 正确：主线程只负责渲染和输入响应@Builderbuild() { Column() { Canvas(this.onCanvasReady) .width('100%') .height('100%') }}

// ❌ 错误：禁止在 build 中执行耗时逻辑@Builderbuild() { // 禁止：循环、网络请求、文件 IO、复杂计算 for (let i = 0; i < 100; i++) { } // 绝对禁止}

#### 3.2 并发模型强制要求

// 必须使用 TaskPool 的场景：

1. 地图数据解析（超过 100x100 的矩阵）
2. 敌人 AI 路径计算（A*算法等）
3. 碰撞检测批量计算（超过 10 个物体）
4. 资源预加载

// 示例：TaskPool 使用模板import { taskpool } from '@ohos.taskpool';

class CollisionTask implements taskpool.Task { name: string = 'collisionDetection';

async execute() { // 耗时碰撞检测逻辑 return collisionResults; }}

// 提交任务const task = new CollisionTask();const result = await taskpool.execute(task);

#### 3.3 帧率保障

// 目标：稳定 60FPS (16.67ms/帧)// 拆分策略：

* 逻辑更新：独立 Timer，固定 60Hz
* 渲染绘制：requestAnimationFrame 或 Canvas.refresh()
* 输入处理：事件驱动，立即响应

// 性能监控指标const FRAME_TIME_BUDGET = 16.67; // msconst LOGIC_UPDATE_INTERVAL = 16.67; // ms

### 4. 内存管理规范

#### 4.1 资源生命周期

// 必须实现资源释放接口的类interface IDisposable { dispose(): void;}

// 示例：坦克类必须清理资源class Tank implements IDisposable { private texture: CanvasImageSource;

dispose() { // 释放图片资源 this.texture = null; }}

// 关卡切换时必须调用aboutToDisappear() { this.gameObjects.forEach(obj => obj.dispose());}

#### 4.2 对象池模式（强制使用）

// 禁止频繁创建销毁的对象：

1. 子弹对象
2. 爆炸特效
3. 敌人坦克

// 必须使用对象池class BulletPool { private pool: Bullet[] = []; private maxSize = 20;

acquire(): Bullet { return this.pool.length > 0 ? this.pool.pop() : new Bullet(); }

release(bullet: Bullet) { if (this.pool.length < this.maxSize) { bullet.reset(); // 重置状态 this.pool.push(bullet); } }}

### 5. 反模式清单（AI 禁止生成的代码）

#### ❌ 绝对禁止的代码模式

// 1. 直接修改@State 对象属性（不会触发更新）@State position = { x: 0, y: 0 };updatePosition() { this.position.x = 10; // ❌ 错误！ // ✅ 正确：this.position = { ...this.position, x: 10 };}

// 2. 在循环中创建对象for (let i = 0; i < 100; i++) { new Bullet(); // ❌ 错误！应使用对象池}

// 3. 未处理的 PromisesomeAsyncFunction().then(result => { }); // ❌ 缺少 catch// ✅ 正确：.catch(err => console.error(err));

// 4. 硬编码魔法数字if (speed > 5) { } // ❌ 错误// ✅ 正确：const MAX_SPEED = 5; if (speed > MAX_SPEED) { }

// 5. 直接访问父组件私有成员this.parent.privateVariable; // ❌ 错误// ✅ 正确：通过@Link 或回调函数通信

// 6. 阻塞主线程的同步操作fs.readSync(); // ❌ 错误http.request({ sync: true }); // ❌ 错误

// 7. 未检查边界就访问数组const first = array[0]; // ❌ 可能 undefined// ✅ 正确：const first = array.length > 0 ? array[0] : null;

### 6. 错误处理规范

#### 6.1 异常捕获层级

// Level 1: 可恢复错误（记录日志，继续运行）try { this.loadTexture();} catch (err) { console.error('纹理加载失败，使用默认纹理', err); this.useDefaultTexture();}

// Level 2: 致命错误（停止游戏，显示错误界面）if (this.criticalResource === null) { throw new Error('关键资源缺失，游戏无法运行');}

#### 6.2 日志分级

// DEBUG: 调试信息（开发环境）console.debug('坦克位置更新', tank.position);

// INFO: 重要状态变更（生产环境保留）console.info('游戏进入暂停状态');

// WARN: 警告（不影响运行但需注意）console.warn('帧率低于 30FPS');

// ERROR: 错误（需要修复）console.error('碰撞检测失败', err);

### 7. AI 交互协议

#### 7.1 标准指令模板

每次向 AI 下达任务时，必须包含以下结构：

【任务类型】功能开发/BUG 修复/性能优化

【涉及模块】Tank/Bullet/Map/Enemy

【参考文档】DOMAIN_MODEL.md 第 X 节 + ARCHITECTURE.md 第 Y 节

【验收标准】ACCEPTANCE_TESTS.md 用例编号

【约束检查】输出后必须附合规性自检报告

#### 7.2 AI 输出要求

AI 必须在代码后附加：

/** * 【合规性自检】

* ✅ 遵循 PROMPT_SYSTEM.md - 第 2.1 节 命名规范

* ✅ 遵循 DOMAIN_MODEL.md - 坦克接口定义 

* ✅ 遵循 ARCHITECTURE.md - 模块分层 

* ✅ 性能影响：主线程耗时 < 2ms，无内存泄漏风险 

* ✅ 测试覆盖：已通过 ACCEPTANCE_TESTS.md #TC001-#TC005 */

📊 版本控制策略
---------

### Git 提交规范

格式：<type>(<scope>): <subject>

# 示例：

feat(game-core): 实现坦克移动逻辑fix(collision): 

修复子弹穿透墙体问题docs(domain-model): 

更新坦克接口定义refactor(performance): 

优化碰撞检测性能 (减少 50% 耗时)test(unit):

 添加坦克移动单元测试

# type 类型：

* feat: 新功能
* fix: 修复 BUG
* docs: 文档更新
* refactor: 重构（非性能优化）
* perf: 性能优化
* test: 测试相关
* chore: 构建/工具配置

🚨 违规处理流程
---------

如果发现 AI 生成的代码违反上述规范：

1. **立即停止**：不接受该代码，标记为"需重构"
2. **指出违规点**：明确引用违反的规范条款
3. **要求重新生成**：提供修正后的提示词
4. **记录案例**：添加到本文档的"常见违规案例"章节
```
