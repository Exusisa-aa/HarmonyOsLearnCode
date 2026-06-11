import { PowerUp, PowerUpType } from "@bundle:com.example.battlecity/entry/ets/entity/PowerUp";
import type { PlayerTank, EnemyTank } from '../entity/Tank';
import { POWERUP_DROP_CHANCE, POWERUP_MAX_ON_FIELD, POWERUP_DURATION_SPEED, POWERUP_DURATION_SHIELD, POWERUP_DURATION_POWER, POWERUP_DURATION_FREEZE } from "@bundle:com.example.battlecity/entry/ets/util/Constants";
import type { ActiveEffectInfo } from '../util/Types';
interface ActiveEffect {
    type: PowerUpType;
    timer: number;
    maxTimer: number;
}
export class PowerUpManager {
    powerUps: PowerUp[] = [];
    private activeEffects: ActiveEffect[] = [];
    clear(): void {
        this.powerUps = [];
        this.activeEffects = [];
    }
    tryDrop(x: number, y: number): void {
        if (this.powerUps.filter(p => p.isActive).length >= POWERUP_MAX_ON_FIELD)
            return;
        if (Math.random() > POWERUP_DROP_CHANCE)
            return;
        const types = [PowerUpType.SPEED, PowerUpType.SHIELD, PowerUpType.POWER, PowerUpType.FREEZE];
        const type = types[Math.floor(Math.random() * types.length)];
        this.powerUps.push(new PowerUp(x, y, type));
    }
    update(dt: number, player: PlayerTank, enemies: EnemyTank[]): void {
        // Update power-ups on field
        for (const p of this.powerUps) {
            if (p.isActive)
                p.update(dt);
        }
        this.powerUps = this.powerUps.filter(p => p.isActive);
        // Update active effects
        for (let i = this.activeEffects.length - 1; i >= 0; i--) {
            this.activeEffects[i].timer--;
            if (this.activeEffects[i].timer <= 0) {
                this.deactivateEffect(this.activeEffects[i].type, player, enemies);
                this.activeEffects.splice(i, 1);
            }
        }
    }
    collect(powerUp: PowerUp, player: PlayerTank, enemies: EnemyTank[]): void {
        // Refresh if same type already active
        const existing = this.activeEffects.find(e => e.type === powerUp.powType);
        if (existing) {
            existing.timer = existing.maxTimer;
            return;
        }
        // Add new effect
        let maxTimer: number;
        switch (powerUp.powType) {
            case PowerUpType.SPEED:
                maxTimer = POWERUP_DURATION_SPEED;
                break;
            case PowerUpType.SHIELD:
                maxTimer = POWERUP_DURATION_SHIELD;
                break;
            case PowerUpType.POWER:
                maxTimer = POWERUP_DURATION_POWER;
                break;
            case PowerUpType.FREEZE:
                maxTimer = POWERUP_DURATION_FREEZE;
                break;
        }
        this.activeEffects.push({ type: powerUp.powType, timer: maxTimer, maxTimer });
        this.activateEffect(powerUp.powType, player, enemies);
    }
    private activateEffect(type: PowerUpType, player: PlayerTank, enemies: EnemyTank[]): void {
        switch (type) {
            case PowerUpType.SPEED:
                player.speedBoosted = true;
                player.speed *= 2;
                break;
            case PowerUpType.SHIELD:
                player.shieldActive = true;
                break;
            case PowerUpType.POWER:
                player.powerActive = true;
                player.shootCooldownMax = Math.floor(player.shootCooldownMax / 2);
                // Allow 2 bullets — handled in game controller
                break;
            case PowerUpType.FREEZE:
                for (const enemy of enemies) {
                    enemy.frozen = true;
                }
                break;
        }
    }
    private deactivateEffect(type: PowerUpType, player: PlayerTank, enemies: EnemyTank[]): void {
        switch (type) {
            case PowerUpType.SPEED:
                player.speedBoosted = false;
                player.speed /= 2;
                break;
            case PowerUpType.SHIELD:
                player.shieldActive = false;
                break;
            case PowerUpType.POWER:
                player.powerActive = false;
                player.shootCooldownMax *= 2;
                break;
            case PowerUpType.FREEZE:
                for (const enemy of enemies) {
                    enemy.frozen = false;
                }
                break;
        }
    }
    getActiveEffects(): ActiveEffectInfo[] {
        const result: ActiveEffectInfo[] = [];
        for (const e of this.activeEffects) {
            const info: ActiveEffectInfo = {
                type: e.type as number,
                remainingTime: Math.ceil(e.timer / 60)
            };
            result.push(info);
        }
        return result;
    }
    getPowerUpCount(): number {
        return this.powerUps.filter(p => p.isActive).length;
    }
}
