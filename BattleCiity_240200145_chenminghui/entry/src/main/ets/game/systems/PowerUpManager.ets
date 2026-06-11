import { PowerUp } from '../entities/PowerUp';
import { PlayerTank } from '../entities/PlayerTank';
import { EnemyTank } from '../entities/EnemyTank';
import { PowerUpType, GameConfig } from '../../common/Constants';

export type PowerUpCollectCallback = (powerUp: PowerUp) => void;

export class PowerUpManager {
  private powerUps: PowerUp[] = [];
  private collectListeners: PowerUpCollectCallback[] = [];

  update(deltaMs: number, player: PlayerTank): void {
    const now = Date.now();

    // Update player power-up timers
    player.updatePowerUpTimers(deltaMs);

    // Remove expired power-ups
    this.powerUps = this.powerUps.filter(p => {
      if (p.isExpired(now)) {
        p.active = false;
        return false;
      }
      return p.active;
    });
  }

  tryDropFromEnemy(enemy: EnemyTank): PowerUp | null {
    const roll = Math.random();
    if (roll > GameConfig.POWERUP_DROP_CHANCE) {
      return null;
    }

    // Pick random power-up type
    const types = [
      PowerUpType.SPEED,
      PowerUpType.SHIELD,
      PowerUpType.FIREPOWER,
      PowerUpType.BASE_REINFORCE,
    ];
    const pick = types[Math.floor(Math.random() * types.length)];

    const powerUp = new PowerUp(
      enemy.centerX() - 8,
      enemy.centerY() - 8,
      pick
    );
    this.powerUps.push(powerUp);
    return powerUp;
  }

  collectPowerUp(powerUp: PowerUp, player: PlayerTank): void {
    const duration = powerUp.lifetimeMs;

    switch (powerUp.powerUpType) {
      case PowerUpType.SPEED:
        player.activateSpeedBoost(GameConfig.POWERUP_DURATION_MS);
        break;
      case PowerUpType.SHIELD:
        player.activateShield(GameConfig.POWERUP_DURATION_MS);
        break;
      case PowerUpType.FIREPOWER:
        player.activateFirepower(GameConfig.POWERUP_FIREPOWER_DURATION_MS);
        break;
      case PowerUpType.BASE_REINFORCE:
        // Base reinforcement handled in GameWorld (spawns steel walls)
        break;
    }

    powerUp.active = false;
    this.notifyCollectListeners(powerUp);
  }

  getPowerUps(): PowerUp[] {
    return this.powerUps.filter(p => p.active);
  }

  addPowerUp(powerUp: PowerUp): void {
    this.powerUps.push(powerUp);
  }

  onCollect(callback: PowerUpCollectCallback): void {
    this.collectListeners.push(callback);
  }

  private notifyCollectListeners(powerUp: PowerUp): void {
    for (const listener of this.collectListeners) {
      listener(powerUp);
    }
  }

  // Check if base reinforce is active (for HUD display)
  hasActiveBaseReinforce(): boolean {
    // Tracked in GameWorld, return false here
    return false;
  }

  getActiveEffects(player: PlayerTank): ActiveEffect[] {
    const effects: ActiveEffect[] = [];
    const now = Date.now();

    if (player.speedBoost) {
      effects.push({
        type: PowerUpType.SPEED,
        remainingMs: player.speedBoostTimer,
      });
    }
    if (player.shieldActive) {
      effects.push({
        type: PowerUpType.SHIELD,
        remainingMs: player.shieldTimer,
      });
    }
    if (player.firepowerActive) {
      effects.push({
        type: PowerUpType.FIREPOWER,
        remainingMs: player.firepowerTimer,
      });
    }
    return effects;
  }

  clear(): void {
    this.powerUps = [];
  }
}

export interface ActiveEffect {
  type: PowerUpType;
  remainingMs: number;
}
