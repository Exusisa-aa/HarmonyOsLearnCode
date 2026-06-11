import { BaseEntity } from './BaseEntity';
import { Direction, EntityType, TankType } from '../../common/Constants';

export class Tank extends BaseEntity {
  direction: Direction = Direction.UP;
  speed: number = 0;
  health: number = 1;
  maxHealth: number = 1;
  shootCooldownMs: number = 0;
  shootCooldownTimer: number = 0;
  tankType: TankType;

  constructor(tankType: TankType, entityType: EntityType) {
    super(entityType);
    this.tankType = tankType;
  }

  canShoot(): boolean {
    return this.shootCooldownTimer <= 0;
  }

  resetShootCooldown(): void {
    this.shootCooldownTimer = this.shootCooldownMs;
  }

  updateCooldown(deltaMs: number): void {
    if (this.shootCooldownTimer > 0) {
      this.shootCooldownTimer -= deltaMs;
    }
  }

  move(dx: number, dy: number): void {
    this.x += dx;
    this.y += dy;

    // Update direction based on movement
    if (Math.abs(dx) > Math.abs(dy)) {
      this.direction = dx > 0 ? Direction.RIGHT : Direction.LEFT;
    } else if (Math.abs(dy) > 0) {
      this.direction = dy > 0 ? Direction.DOWN : Direction.UP;
    }
  }

  getDirectionDX(): number {
    switch (this.direction) {
      case Direction.LEFT: return -1;
      case Direction.RIGHT: return 1;
      default: return 0;
    }
  }

  getDirectionDY(): number {
    switch (this.direction) {
      case Direction.UP: return -1;
      case Direction.DOWN: return 1;
      default: return 0;
    }
  }

  takeDamage(amount: number): void {
    this.health -= amount;
    if (this.health <= 0) {
      this.health = 0;
      this.active = false;
    }
  }

  isDestroyed(): boolean {
    return !this.active || this.health <= 0;
  }
}
