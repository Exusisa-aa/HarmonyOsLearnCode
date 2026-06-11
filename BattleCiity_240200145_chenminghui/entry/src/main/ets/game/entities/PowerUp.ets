import { BaseEntity } from './BaseEntity';
import { EntityType, PowerUpType, GameConfig } from '../../common/Constants';

export class PowerUp extends BaseEntity {
  powerUpType: PowerUpType;
  spawnTime: number;
  lifetimeMs: number;
  blinkThresholdMs: number;

  constructor(x: number, y: number, type: PowerUpType) {
    super(EntityType.POWERUP);
    this.x = x;
    this.y = y;
    this.width = 16;
    this.height = 16;
    this.powerUpType = type;
    this.spawnTime = Date.now();
    this.lifetimeMs = GameConfig.POWERUP_DURATION_MS;
    this.blinkThresholdMs = 3000; // start blinking 3s before expiry
  }

  isExpired(now: number): boolean {
    return (now - this.spawnTime) >= this.lifetimeMs;
  }

  shouldBlink(now: number): boolean {
    const remaining = this.lifetimeMs - (now - this.spawnTime);
    return remaining <= this.blinkThresholdMs;
  }

  getRemainingTimeMs(now: number): number {
    return Math.max(0, this.lifetimeMs - (now - this.spawnTime));
  }
}
