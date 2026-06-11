import { GameEntity, Direction } from "@bundle:com.example.battlecity/entry/ets/entity/GameEntity";
import { Bullet, BulletOwner } from "@bundle:com.example.battlecity/entry/ets/entity/Bullet";
import { TANK_WIDTH, TANK_HEIGHT, PLAYER_SPEED, PLAYER_SHOOT_COOLDOWN, ENEMY_BASIC_SPEED, ENEMY_FAST_SPEED, ENEMY_HEAVY_SPEED, ENEMY_BASIC_COOLDOWN, ENEMY_FAST_COOLDOWN, ENEMY_HEAVY_COOLDOWN, PLAYER_START_X, PLAYER_START_Y, PLAYER_INVINCIBLE_DURATION, COLOR_PLAYER_BODY, COLOR_PLAYER_HIGHLIGHT, COLOR_ENEMY_BASIC, COLOR_ENEMY_FAST, COLOR_ENEMY_HEAVY, COLOR_TRACK, COLOR_GUN } from "@bundle:com.example.battlecity/entry/ets/util/Constants";
import { RenderLayer } from "@bundle:com.example.battlecity/entry/ets/engine/CanvasRenderer";
export enum EnemyType {
    BASIC = 0,
    FAST = 1,
    HEAVY = 2
}
export abstract class Tank extends GameEntity {
    speed: number;
    direction: Direction;
    hp: number;
    maxHp: number;
    shootCooldown: number;
    shootCooldownMax: number;
    alive: boolean = true;
    constructor(x: number, y: number, speed: number, hp: number, cooldownMax: number) {
        super(x, y, TANK_WIDTH, TANK_HEIGHT);
        this.speed = speed;
        this.direction = Direction.UP;
        this.hp = hp;
        this.maxHp = hp;
        this.shootCooldown = 0;
        this.shootCooldownMax = cooldownMax;
        this.layer = RenderLayer.TANKS;
    }
    update(dt: number): void {
        if (this.shootCooldown > 0)
            this.shootCooldown--;
    }
    canShoot(): boolean { return this.shootCooldown <= 0; }
    shoot(): Bullet | null {
        if (!this.canShoot())
            return null;
        let bx = this.centerX - 5;
        let by = this.centerY - 5;
        let vx = 0, vy = 0;
        switch (this.direction) {
            case Direction.UP:
                vy = -1;
                by = this.y - 10;
                break;
            case Direction.DOWN:
                vy = 1;
                by = this.y + this.height;
                break;
            case Direction.LEFT:
                vx = -1;
                bx = this.x - 10;
                break;
            case Direction.RIGHT:
                vx = 1;
                bx = this.x + this.width;
                break;
        }
        this.shootCooldown = this.shootCooldownMax;
        return new Bullet(bx, by, vx, vy, this.getOwner());
    }
    abstract getOwner(): BulletOwner;
    takeDamage(): boolean {
        this.hp--;
        if (this.hp <= 0) {
            this.alive = false;
            this.isActive = false;
            return true;
        }
        return false;
    }
    render(ctx: CanvasRenderingContext2D): void {
        const bodyColor = this.getBodyColor();
        const x = this.x, y = this.y, w = this.width, h = this.height;
        const dir = this.direction;
        // Tracks
        ctx.fillStyle = COLOR_TRACK;
        if (dir === Direction.UP || dir === Direction.DOWN) {
            ctx.fillRect(x, y, 8, h);
            ctx.fillRect(x + w - 8, y, 8, h);
            ctx.fillStyle = '#000000';
            for (let i = 2; i < h; i += 6) {
                ctx.fillRect(x, y + i, 8, 2);
                ctx.fillRect(x + w - 8, y + i, 8, 2);
            }
        }
        else {
            ctx.fillRect(x, y, w, 8);
            ctx.fillRect(x, y + h - 8, w, 8);
            ctx.fillStyle = '#000000';
            for (let i = 2; i < w; i += 6) {
                ctx.fillRect(x + i, y, 2, 8);
                ctx.fillRect(x + i, y + h - 8, 2, 8);
            }
        }
        // Body
        ctx.fillStyle = bodyColor;
        if (dir === Direction.UP || dir === Direction.DOWN) {
            ctx.fillRect(x + 8, y + 4, w - 16, h - 8);
        }
        else {
            ctx.fillRect(x + 4, y + 8, w - 8, h - 16);
        }
        // Turret base
        ctx.fillStyle = this.getHighlightColor();
        ctx.beginPath();
        ctx.arc(x + w / 2, y + h / 2, 8, 0, Math.PI * 2);
        ctx.fill();
        ctx.fillStyle = bodyColor;
        ctx.beginPath();
        ctx.arc(x + w / 2, y + h / 2, 4, 0, Math.PI * 2);
        ctx.fill();
        // Gun barrel
        ctx.fillStyle = COLOR_GUN;
        const cx = x + w / 2, cy = y + h / 2;
        switch (dir) {
            case Direction.UP:
                ctx.fillRect(cx - 3, y - 4, 6, h / 2 + 4);
                ctx.fillStyle = '#000';
                ctx.fillRect(cx - 4, y - 4, 8, 4);
                break;
            case Direction.DOWN:
                ctx.fillRect(cx - 3, cy, 6, h / 2 + 4);
                ctx.fillStyle = '#000';
                ctx.fillRect(cx - 4, y + h, 8, 4);
                break;
            case Direction.LEFT:
                ctx.fillRect(x - 4, cy - 3, w / 2 + 4, 6);
                ctx.fillStyle = '#000';
                ctx.fillRect(x - 4, cy - 4, 4, 8);
                break;
            case Direction.RIGHT:
                ctx.fillRect(cx, cy - 3, w / 2 + 4, 6);
                ctx.fillStyle = '#000';
                ctx.fillRect(x + w, cy - 4, 4, 8);
                break;
        }
    }
    abstract getBodyColor(): string;
    abstract getHighlightColor(): string;
}
// PlayerTank
export class PlayerTank extends Tank {
    invincibleTimer: number = 0;
    speedBoosted: boolean = false;
    shieldActive: boolean = false;
    powerActive: boolean = false;
    frozen: boolean = false;
    constructor(x: number = PLAYER_START_X, y: number = PLAYER_START_Y) {
        super(x, y, PLAYER_SPEED, 1, PLAYER_SHOOT_COOLDOWN);
        this.direction = Direction.UP;
    }
    getOwner(): BulletOwner { return BulletOwner.PLAYER; }
    update(dt: number): void {
        super.update(dt);
        if (this.invincibleTimer > 0)
            this.invincibleTimer--;
    }
    get isInvincible(): boolean { return this.invincibleTimer > 0 || this.shieldActive; }
    makeInvincible(): void { this.invincibleTimer = PLAYER_INVINCIBLE_DURATION; }
    getBodyColor(): string { return COLOR_PLAYER_BODY; }
    getHighlightColor(): string { return COLOR_PLAYER_HIGHLIGHT; }
    render(ctx: CanvasRenderingContext2D): void {
        // Blink during invincibility
        if (this.isInvincible && Math.floor(this.invincibleTimer / 4) % 2 === 0)
            return;
        super.render(ctx);
        // Shield visual
        if (this.shieldActive) {
            ctx.strokeStyle = '#4488FF';
            ctx.lineWidth = 3;
            ctx.beginPath();
            ctx.arc(this.centerX, this.centerY, this.width / 2 + 6, 0, Math.PI * 2);
            ctx.stroke();
            ctx.lineWidth = 1;
        }
    }
}
// EnemyTank
export class EnemyTank extends Tank {
    enemyType: EnemyType;
    frozen: boolean = false;
    moveTimer: number = 0;
    constructor(x: number, y: number, type: EnemyType = EnemyType.BASIC) {
        let spd: number, cooldownMax: number, hp: number;
        switch (type) {
            case EnemyType.FAST:
                spd = ENEMY_FAST_SPEED;
                cooldownMax = ENEMY_FAST_COOLDOWN;
                hp = 1;
                break;
            case EnemyType.HEAVY:
                spd = ENEMY_HEAVY_SPEED;
                cooldownMax = ENEMY_HEAVY_COOLDOWN;
                hp = 3;
                break;
            default:
                spd = ENEMY_BASIC_SPEED;
                cooldownMax = ENEMY_BASIC_COOLDOWN;
                hp = 1;
                break;
        }
        super(x, y, spd, hp, cooldownMax);
        this.enemyType = type;
        this.direction = Direction.DOWN;
        this.shootCooldown = cooldownMax + Math.floor(Math.random() * cooldownMax);
    }
    getOwner(): BulletOwner { return BulletOwner.ENEMY; }
    getBodyColor(): string {
        switch (this.enemyType) {
            case EnemyType.FAST: return COLOR_ENEMY_FAST;
            case EnemyType.HEAVY: return COLOR_ENEMY_HEAVY;
            default: return COLOR_ENEMY_BASIC;
        }
    }
    getHighlightColor(): string {
        switch (this.enemyType) {
            case EnemyType.FAST: return '#AAEEFF';
            case EnemyType.HEAVY: return '#999999';
            default: return '#EEEEEE';
        }
    }
    get scoreValue(): number {
        switch (this.enemyType) {
            case EnemyType.FAST: return 200;
            case EnemyType.HEAVY: return 300;
            default: return 100;
        }
    }
}
