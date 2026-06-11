import { GameStateMachine, GameState } from "@bundle:com.example.battlecity/entry/ets/engine/GameState";
import { GameLoop } from "@bundle:com.example.battlecity/entry/ets/engine/GameLoop";
import { CanvasRenderer } from "@bundle:com.example.battlecity/entry/ets/engine/CanvasRenderer";
import { ResourceManager } from "@bundle:com.example.battlecity/entry/ets/engine/ResourceManager";
import { PlayerTank, EnemyTank } from "@bundle:com.example.battlecity/entry/ets/entity/Tank";
import type { Tank, EnemyType } from "@bundle:com.example.battlecity/entry/ets/entity/Tank";
import type { Bullet } from './entity/Bullet';
import { TileType } from "@bundle:com.example.battlecity/entry/ets/entity/Terrain";
import type { Terrain } from "@bundle:com.example.battlecity/entry/ets/entity/Terrain";
import type { PowerUp } from './entity/PowerUp';
import { Explosion } from "@bundle:com.example.battlecity/entry/ets/entity/Explosion";
import { Direction } from "@bundle:com.example.battlecity/entry/ets/entity/GameEntity";
import { LevelLoader } from "@bundle:com.example.battlecity/entry/ets/level/LevelLoader";
import type { LevelConfig } from "@bundle:com.example.battlecity/entry/ets/level/LevelLoader";
import { CollisionSystem } from "@bundle:com.example.battlecity/entry/ets/system/CollisionSystem";
import { AISystem } from "@bundle:com.example.battlecity/entry/ets/system/AISystem";
import { ScoreManager } from "@bundle:com.example.battlecity/entry/ets/system/ScoreManager";
import { PowerUpManager } from "@bundle:com.example.battlecity/entry/ets/system/PowerUpManager";
import type { Rect, Point } from './util/Types';
import { MAX_ENEMIES_ON_FIELD, ENEMY_SPAWN_INTERVAL } from "@bundle:com.example.battlecity/entry/ets/util/Constants";
export class GameController {
    stateMachine: GameStateMachine = new GameStateMachine();
    gameLoop: GameLoop = new GameLoop();
    renderer: CanvasRenderer = new CanvasRenderer();
    resourceMgr: ResourceManager = new ResourceManager();
    collisionSystem: CollisionSystem = new CollisionSystem();
    aiSystem: AISystem = new AISystem(this.collisionSystem);
    scoreMgr: ScoreManager = new ScoreManager();
    powerUpMgr: PowerUpManager = new PowerUpManager();
    levelLoader: LevelLoader = new LevelLoader(this.resourceMgr);
    currentLevelNum: number = 1;
    player: PlayerTank = new PlayerTank();
    enemies: EnemyTank[] = [];
    bullets: Bullet[] = [];
    terrain: Terrain[] = [];
    explosions: Explosion[] = [];
    baseRect: Rect = { x: 336, y: 1152, width: 48, height: 48 };
    isBaseDestroyed: boolean = false;
    spawnQueue: EnemyType[] = [];
    private spawnTimer: number = 0;
    private enemySpawnIndex: number = 0;
    private spawnPoints: Point[] = [];
    totalEnemyCount: number = 0;
    remainingEnemies: number = 0;
    onStateChange: ((state: GameState) => void) | null = null;
    inputDirection: Direction | null = null;
    inputShoot: boolean = false;
    constructor() {
        this.setupStateMachine();
        this.setupGameLoop();
    }
    init(context: Context): void {
        this.resourceMgr.init(context);
        this.scoreMgr.init(context);
    }
    private setupStateMachine(): void {
        this.stateMachine.onEnter(GameState.MENU, () => {
            this.gameLoop.stop();
        });
        this.stateMachine.onEnter(GameState.PLAYING, () => {
            this.gameLoop.start();
        });
        this.stateMachine.onEnter(GameState.PAUSED, () => {
            this.gameLoop.stop();
        });
        this.stateMachine.onEnter(GameState.GAME_OVER, () => {
            this.gameLoop.stop();
            this.scoreMgr.updateHighScore();
        });
        this.stateMachine.onEnter(GameState.LEVEL_COMPLETE, () => {
            this.gameLoop.stop();
        });
    }
    private setupGameLoop(): void {
        this.gameLoop.onUpdate = (dt: number) => this.update(dt);
        this.gameLoop.onRender = () => this.renderer.render();
    }
    async startNewGame(): Promise<void> {
        this.scoreMgr.reset(true);
        this.currentLevelNum = 1;
        this.stateMachine.transition(GameState.LOADING);
        await this.loadLevel(this.currentLevelNum);
        this.stateMachine.transition(GameState.PLAYING);
        this.fireStateChange(GameState.PLAYING);
    }
    async continueGame(): Promise<void> {
        const hasSave: boolean = await this.scoreMgr.loadProgress();
        if (hasSave) {
            this.currentLevelNum = this.scoreMgr.currentLevel;
        }
        else {
            this.scoreMgr.reset(true);
            this.currentLevelNum = 1;
        }
        this.stateMachine.transition(GameState.LOADING);
        await this.loadLevel(this.currentLevelNum);
        this.stateMachine.transition(GameState.PLAYING);
        this.fireStateChange(GameState.PLAYING);
    }
    async loadLevel(levelNum: number): Promise<void> {
        const config: LevelConfig = this.levelLoader.load(levelNum);
        this.terrain = config.terrain;
        this.spawnQueue = [...config.enemies];
        this.spawnPoints = config.spawnPoints;
        this.totalEnemyCount = config.totalEnemies;
        this.remainingEnemies = config.totalEnemies;
        this.baseRect = config.baseRect;
        this.isBaseDestroyed = false;
        this.player = new PlayerTank();
        this.enemies = [];
        this.bullets = [];
        this.explosions = [];
        this.powerUpMgr.clear();
        this.renderer.clearEntities();
        for (const t of this.terrain) {
            this.renderer.addEntity(t);
        }
        this.spawnInitialEnemies();
        this.spawnTimer = 0;
    }
    private spawnInitialEnemies(): void {
        const count: number = Math.min(3, this.spawnQueue.length);
        for (let i = 0; i < count; i++) {
            this.spawnNextEnemy();
        }
    }
    private spawnNextEnemy(): void {
        if (this.spawnQueue.length === 0)
            return;
        const type: EnemyType = this.spawnQueue.shift()!;
        const sp = this.spawnPoints[this.enemySpawnIndex % this.spawnPoints.length];
        this.enemySpawnIndex++;
        const enemy: EnemyTank = new EnemyTank(sp.x, sp.y, type);
        this.enemies.push(enemy);
        this.renderer.addEntity(enemy);
    }
    update(dt: number): void {
        if (!this.stateMachine.is(GameState.PLAYING))
            return;
        if (this.isBaseDestroyed) {
            this.stateMachine.transition(GameState.GAME_OVER);
            this.fireStateChange(GameState.GAME_OVER);
            return;
        }
        this.updatePlayer(dt);
        this.updateEnemies(dt);
        this.updateBullets();
        this.powerUpMgr.update(dt, this.player, this.enemies);
        for (const e of this.explosions) {
            e.timer--;
        }
        this.explosions = this.explosions.filter((e: Explosion) => e.timer > 0);
        this.updateSpawning();
        this.refreshRenderer();
    }
    private updatePlayer(dt: number): void {
        if (!this.player.alive)
            return;
        this.player.update(dt);
        if (this.inputDirection !== null) {
            const dir: Direction = this.inputDirection;
            this.player.direction = dir;
            const moveDist: number = this.player.speed * dt;
            const prevX: number = this.player.x;
            const prevY: number = this.player.y;
            switch (dir) {
                case Direction.UP:
                    this.player.y -= moveDist;
                    break;
                case Direction.DOWN:
                    this.player.y += moveDist;
                    break;
                case Direction.LEFT:
                    this.player.x -= moveDist;
                    break;
                case Direction.RIGHT:
                    this.player.x += moveDist;
                    break;
            }
            const allTanks: Tank[] = [];
            allTanks.push(this.player);
            for (const e of this.enemies) {
                allTanks.push(e);
            }
            if (!this.collisionSystem.canMoveTo(this.player, this.terrain, allTanks)) {
                this.player.x = prevX;
                this.player.y = prevY;
                this.tryCornering(dir, moveDist, allTanks);
            }
        }
        if (this.inputShoot) {
            const bullet: Bullet | null = this.player.shoot();
            if (bullet) {
                bullet.canBreakSteel = this.player.powerActive;
                this.bullets.push(bullet);
                if (this.player.powerActive) {
                    const b2: Bullet | null = this.player.shoot();
                    if (b2) {
                        b2.canBreakSteel = true;
                        this.bullets.push(b2);
                    }
                }
            }
        }
        const collected: PowerUp | null = this.collisionSystem.checkPowerUpCollection(this.player, this.powerUpMgr.powerUps);
        if (collected) {
            this.powerUpMgr.collect(collected, this.player, this.enemies);
        }
    }
    private tryCornering(dir: Direction, _moveDist: number, allTanks: Tank[]): void {
        const nudge: number = 4;
        if (dir === Direction.UP || dir === Direction.DOWN) {
            this.player.x -= nudge;
            if (this.collisionSystem.canMoveTo(this.player, this.terrain, allTanks))
                return;
            this.player.x += nudge * 2;
            if (this.collisionSystem.canMoveTo(this.player, this.terrain, allTanks))
                return;
            this.player.x -= nudge;
        }
        else {
            this.player.y -= nudge;
            if (this.collisionSystem.canMoveTo(this.player, this.terrain, allTanks))
                return;
            this.player.y += nudge * 2;
            if (this.collisionSystem.canMoveTo(this.player, this.terrain, allTanks))
                return;
            this.player.y -= nudge;
        }
    }
    private updateEnemies(dt: number): void {
        for (const enemy of this.enemies) {
            if (!enemy.alive)
                continue;
            if (enemy.frozen) {
                enemy.update(dt);
                continue;
            }
            this.aiSystem.updateEnemy(enemy, this.player, this.terrain, this.enemies, this.bullets, dt);
            const moveDist: number = enemy.speed * dt;
            const prevX: number = enemy.x;
            const prevY: number = enemy.y;
            switch (enemy.direction) {
                case Direction.UP:
                    enemy.y -= moveDist;
                    break;
                case Direction.DOWN:
                    enemy.y += moveDist;
                    break;
                case Direction.LEFT:
                    enemy.x -= moveDist;
                    break;
                case Direction.RIGHT:
                    enemy.x += moveDist;
                    break;
            }
            const allTanks: Tank[] = [];
            allTanks.push(this.player);
            for (const e of this.enemies) {
                allTanks.push(e);
            }
            if (!this.collisionSystem.canMoveTo(enemy, this.terrain, allTanks)) {
                enemy.x = prevX;
                enemy.y = prevY;
                enemy.direction = Math.floor(Math.random() * 4);
                enemy.moveTimer = 30 + Math.floor(Math.random() * 60);
            }
            if (this.aiSystem.shouldShoot(enemy, this.player)) {
                const bullet: Bullet | null = enemy.shoot();
                if (bullet)
                    this.bullets.push(bullet);
            }
        }
    }
    private updateBullets(): void {
        for (const bullet of this.bullets) {
            if (!bullet.isActive)
                continue;
            bullet.update(0);
            this.collisionSystem.checkBulletCollisions(bullet, this.terrain, this.player, this.enemies, this.bullets, this.baseRect);
            if (!bullet.isActive) {
                this.explosions.push(new Explosion(bullet.x - 19, bullet.y - 19, 25));
            }
        }
        // Handle dead enemies
        for (const enemy of this.enemies) {
            if (!enemy.alive) {
                this.scoreMgr.addKillScore(enemy.enemyType);
                this.remainingEnemies--;
                this.renderer.removeEntity(enemy);
                this.powerUpMgr.tryDrop(enemy.x, enemy.y);
            }
        }
        this.enemies = this.enemies.filter((e: EnemyTank) => e.alive);
        // Check base hit
        if (!this.isBaseDestroyed) {
            for (const bullet of this.bullets) {
                if (!bullet.isActive)
                    continue;
                const bx: number = bullet.x;
                const by: number = bullet.y;
                const bw: number = bullet.width;
                const bh: number = bullet.height;
                if (bx < this.baseRect.x + this.baseRect.width &&
                    bx + bw > this.baseRect.x &&
                    by < this.baseRect.y + this.baseRect.height &&
                    by + bh > this.baseRect.y) {
                    this.isBaseDestroyed = true;
                    this.explosions.push(new Explosion(this.baseRect.x, this.baseRect.y, 25));
                    break;
                }
            }
        }
        // Player death
        if (!this.player.alive) {
            const isDead: boolean = this.scoreMgr.loseLife();
            this.explosions.push(new Explosion(this.player.x, this.player.y, 25));
            if (isDead) {
                this.stateMachine.transition(GameState.GAME_OVER);
                this.fireStateChange(GameState.GAME_OVER);
            }
            else {
                this.player = new PlayerTank();
                this.player.makeInvincible();
            }
        }
        // Level complete check
        if (this.remainingEnemies <= 0 && this.spawnQueue.length === 0) {
            let aliveEnemyCount: number = 0;
            for (const e of this.enemies) {
                if (e.alive)
                    aliveEnemyCount++;
            }
            if (aliveEnemyCount === 0) {
                let remainingBricks: number = 0;
                for (const t of this.terrain) {
                    if (t.isActive && (t.tileType === TileType.BRICK || t.tileType === TileType.BASE_WALL)) {
                        remainingBricks++;
                    }
                }
                this.scoreMgr.addLevelClearBonus(remainingBricks);
                this.scoreMgr.currentLevel = this.currentLevelNum + 1;
                this.scoreMgr.saveProgress();
                this.stateMachine.transition(GameState.LEVEL_COMPLETE);
                this.fireStateChange(GameState.LEVEL_COMPLETE);
            }
        }
        this.bullets = this.bullets.filter((b: Bullet) => b.isActive);
    }
    private updateSpawning(): void {
        if (this.spawnQueue.length === 0)
            return;
        let aliveEnemyCount: number = 0;
        for (const e of this.enemies) {
            if (e.alive)
                aliveEnemyCount++;
        }
        if (aliveEnemyCount >= MAX_ENEMIES_ON_FIELD)
            return;
        this.spawnTimer++;
        if (this.spawnTimer >= ENEMY_SPAWN_INTERVAL) {
            this.spawnTimer = 0;
            this.spawnNextEnemy();
        }
    }
    private refreshRenderer(): void {
        this.renderer.clearEntities();
        for (const t of this.terrain) {
            this.renderer.addEntity(t);
        }
        for (const p of this.powerUpMgr.powerUps) {
            if (p.isActive)
                this.renderer.addEntity(p);
        }
        for (const b of this.bullets) {
            if (b.isActive)
                this.renderer.addEntity(b);
        }
        if (this.player.alive)
            this.renderer.addEntity(this.player);
        for (const e of this.enemies) {
            if (e.alive)
                this.renderer.addEntity(e);
        }
    }
    private fireStateChange(state: GameState): void {
        if (this.onStateChange)
            this.onStateChange(state);
    }
    setDirection(dir: Direction | null): void { this.inputDirection = dir; }
    setShoot(shooting: boolean): void { this.inputShoot = shooting; }
    pause(): void {
        if (this.stateMachine.is(GameState.PLAYING)) {
            this.stateMachine.transition(GameState.PAUSED);
            this.fireStateChange(GameState.PAUSED);
        }
    }
    resume(): void {
        if (this.stateMachine.is(GameState.PAUSED)) {
            this.stateMachine.transition(GameState.PLAYING);
            this.fireStateChange(GameState.PLAYING);
        }
    }
    restartLevel(): void {
        this.stateMachine.transition(GameState.LOADING);
        this.loadLevel(this.currentLevelNum);
        this.stateMachine.transition(GameState.PLAYING);
        this.fireStateChange(GameState.PLAYING);
    }
    nextLevel(): void {
        this.currentLevelNum++;
        this.stateMachine.transition(GameState.LOADING);
        this.loadLevel(this.currentLevelNum);
        this.stateMachine.transition(GameState.PLAYING);
        this.fireStateChange(GameState.PLAYING);
    }
    get isPlaying(): boolean { return this.stateMachine.is(GameState.PLAYING); }
}
