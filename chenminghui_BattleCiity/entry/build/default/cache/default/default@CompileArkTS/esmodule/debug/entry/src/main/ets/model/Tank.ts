import { Bullet, BulletOwner } from "@bundle:com.example.battlecity/entry/ets/model/Bullet";
export enum Direction {
    UP = 0,
    RIGHT = 1,
    DOWN = 2,
    LEFT = 3
}
export abstract class Tank {
    x: number;
    y: number;
    width: number;
    height: number;
    speed: number;
    direction: Direction;
    isDestroyed: boolean;
    shootCooldown: number = 0;
    defaultCooldown: number = 20;
    constructor(x: number, y: number, speed: number) {
        this.x = x;
        this.y = y;
        this.width = 40; // Reduced size to fit in 48px corridors (40 < 48)
        this.height = 40;
        this.speed = speed; // Pixels per second
        this.direction = Direction.UP;
        this.isDestroyed = false;
    }
    abstract update(dt: number): void;
    shoot(): Bullet | null {
        if (this.shootCooldown > 0)
            return null;
        let bulletX = this.x + this.width / 2 - 5; // Center - half width of bullet (10/2)
        let bulletY = this.y + this.height / 2 - 5;
        let vx = 0;
        let vy = 0;
        switch (this.direction) {
            case Direction.UP:
                vy = -1;
                bulletY = this.y - 10;
                break;
            case Direction.RIGHT:
                vx = 1;
                bulletX = this.x + this.width;
                break;
            case Direction.DOWN:
                vy = 1;
                bulletY = this.y + this.height;
                break;
            case Direction.LEFT:
                vx = -1;
                bulletX = this.x - 10;
                break;
        }
        this.shootCooldown = this.defaultCooldown;
        return new Bullet(bulletX, bulletY, vx, vy, this instanceof PlayerTank ? BulletOwner.PLAYER : BulletOwner.ENEMY);
    }
}
export class PlayerTank extends Tank {
    constructor(x: number, y: number) {
        super(x, y, 360); // Speed 6 * 60 = 360 px/s
        this.defaultCooldown = 15;
        this.direction = Direction.UP;
    }
    update(dt: number) {
        if (this.shootCooldown > 0)
            this.shootCooldown--;
    }
    move(direction: Direction, dt: number) {
        this.direction = direction;
        const moveDist = this.speed * dt;
        switch (direction) {
            case Direction.UP:
                this.y -= moveDist;
                break;
            case Direction.DOWN:
                this.y += moveDist;
                break;
            case Direction.LEFT:
                this.x -= moveDist;
                break;
            case Direction.RIGHT:
                this.x += moveDist;
                break;
        }
    }
}
export class EnemyTank extends Tank {
    moveTimer: number = 0;
    constructor(x: number, y: number) {
        super(x, y, 180); // Speed 3 * 60 = 180 px/s
        this.direction = Direction.DOWN;
        this.shootCooldown = 60 + Math.floor(Math.random() * 60);
    }
    update(dt: number) {
        if (this.shootCooldown > 0)
            this.shootCooldown--;
        // Simple AI: Move in current direction, change direction randomly
        if (this.moveTimer <= 0) {
            this.direction = Math.floor(Math.random() * 4);
            this.moveTimer = 30 + Math.floor(Math.random() * 60); // Change direction every 30-90 frames
        }
        this.moveTimer--;
        // Note: Actual movement is handled in GamePage to check collisions first
        // But we update the intended direction here
    }
}
