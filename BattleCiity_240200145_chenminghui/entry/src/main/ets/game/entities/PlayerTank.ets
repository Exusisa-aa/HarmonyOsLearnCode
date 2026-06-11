import { Tank } from './Tank';
import { EntityType, TankType, GameConfig } from '../../common/Constants';

export class PlayerTank extends Tank {
  // Power-up effect flags
  speedBoost: boolean = false;
  shieldActive: boolean = false;
  firepowerActive: boolean = false;
  invincible: boolean = false;

  speedBoostTimer: number = 0;
  shieldTimer: number = 0;
  firepowerTimer: number = 0;
  invincibleTimer: number = 0;

  maxBullets: number = GameConfig.PLAYER_MAX_BULLETS;
  activeBulletCount: number = 0;

  constructor() {
    super(TankType.PLAYER, EntityType.PLAYER_TANK);
    this.speed = GameConfig.PLAYER_BASE_SPEED;
    this.health = 1;
    this.maxHealth = 1;
    this.shootCooldownMs = GameConfig.PLAYER_SHOOT_COOLDOWN;
  }

  getEffectiveSpeed(): number {
    if (this.speedBoost) {
      return this.speed * GameConfig.POWERUP_SPEED_MULTIPLIER;
    }
    return this.speed;
  }

  updatePowerUpTimers(deltaMs: number): void {
    if (this.speedBoost) {
      this.speedBoostTimer -= deltaMs;
      if (this.speedBoostTimer <= 0) {
        this.speedBoost = false;
        this.speedBoostTimer = 0;
      }
    }
    if (this.shieldActive) {
      this.shieldTimer -= deltaMs;
      if (this.shieldTimer <= 0) {
        this.shieldActive = false;
        this.shieldTimer = 0;
      }
    }
    if (this.firepowerActive) {
      this.firepowerTimer -= deltaMs;
      if (this.firepowerTimer <= 0) {
        this.firepowerActive = false;
        this.firepowerTimer = 0;
      }
    }
    if (this.invincible) {
      this.invincibleTimer -= deltaMs;
      if (this.invincibleTimer <= 0) {
        this.invincible = false;
        this.invincibleTimer = 0;
      }
    }
  }

  activateSpeedBoost(durationMs: number): void {
    this.speedBoost = true;
    this.speedBoostTimer = durationMs;
  }

  activateShield(durationMs: number): void {
    this.shieldActive = true;
    this.shieldTimer = durationMs;
  }

  activateFirepower(durationMs: number): void {
    this.firepowerActive = true;
    this.firepowerTimer = durationMs;
  }

  activateInvincible(durationMs: number): void {
    this.invincible = true;
    this.invincibleTimer = durationMs;
  }

  override takeDamage(amount: number): void {
    if (this.invincible || this.shieldActive) {
      if (this.shieldActive) {
        this.shieldActive = false;
        this.shieldTimer = 0;
      }
      return;
    }
    super.takeDamage(amount);
  }
}
