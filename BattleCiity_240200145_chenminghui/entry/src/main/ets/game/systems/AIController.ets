import { EnemyTank } from '../entities/EnemyTank';
import { PlayerTank } from '../entities/PlayerTank';
import { Bullet } from '../entities/Bullet';
import { Direction, AIState, EntityType, GameConfig } from '../../common/Constants';

const DIRECTION_LOCK_MIN_MS = 500;
const DIRECTION_LOCK_MAX_MS = 2000;
const CHASE_DETECTION_RANGE = 150; // pixels - range to detect player

export class AIController {
  private enemies: EnemyTank[] = [];
  private player: PlayerTank | null = null;

  setPlayer(player: PlayerTank | null): void {
    this.player = player;
  }

  addEnemy(enemy: EnemyTank): void {
    enemy.setPlayerRef(this.player);
    this.enemies.push(enemy);
  }

  removeEnemy(enemy: EnemyTank): void {
    const idx = this.enemies.indexOf(enemy);
    if (idx >= 0) {
      this.enemies.splice(idx, 1);
    }
  }

  clearAll(): void {
    this.enemies = [];
  }

  getEnemies(): EnemyTank[] {
    return this.enemies;
  }

  getActiveEnemies(): EnemyTank[] {
    return this.enemies.filter(e => e.active && e.canAct());
  }

  updateAll(deltaMs: number): void {
    for (const enemy of this.enemies) {
      if (!enemy.active) continue;
      this.updateSingle(enemy, deltaMs);
    }
  }

  private updateSingle(enemy: EnemyTank, deltaMs: number): void {
    enemy.updateTimers(deltaMs);
    if (!enemy.canAct()) return;

    // Determine AI state
    if (this.canSeePlayer(enemy)) {
      enemy.aiState = AIState.CHASE;
    } else {
      enemy.aiState = AIState.PATROL;
    }

    switch (enemy.aiState) {
      case AIState.PATROL:
        this.doPatrol(enemy, deltaMs);
        break;
      case AIState.CHASE:
        this.doChase(enemy, deltaMs);
        break;
    }
  }

  private canSeePlayer(enemy: EnemyTank): boolean {
    if (!this.player || !this.player.active) return false;

    const dx = this.player.centerX() - enemy.centerX();
    const dy = this.player.centerY() - enemy.centerY();
    const dist = Math.sqrt(dx * dx + dy * dy);

    return dist < CHASE_DETECTION_RANGE;
  }

  private doPatrol(enemy: EnemyTank, deltaMs: number): void {
    // Move in current direction
    const speed = enemy.speed;
    enemy.move(enemy.getDirectionDX() * speed, enemy.getDirectionDY() * speed);

    // Periodically change direction
    if (!enemy.isDirectionLocked()) {
      // Pick a new random direction with lock duration
      enemy.pickRandomDirection();
      const lockTime = DIRECTION_LOCK_MIN_MS +
        Math.random() * (DIRECTION_LOCK_MAX_MS - DIRECTION_LOCK_MIN_MS);
      enemy.setDirectionLock(lockTime);
    }
  }

  private doChase(enemy: EnemyTank, deltaMs: number): void {
    if (!this.player) return;

    const dx = this.player.centerX() - enemy.centerX();
    const dy = this.player.centerY() - enemy.centerY();

    // Prioritize the axis with greater distance
    if (Math.abs(dx) > Math.abs(dy)) {
      enemy.direction = dx > 0 ? Direction.RIGHT : Direction.LEFT;
    } else {
      enemy.direction = dy > 0 ? Direction.DOWN : Direction.UP;
    }

    const speed = enemy.speed;
    enemy.move(enemy.getDirectionDX() * speed, enemy.getDirectionDY() * speed);
    enemy.setDirectionLock(100); // keep direction briefly
  }

  // Check if enemy should shoot this frame (task 7.5)
  tryShoot(enemy: EnemyTank): Bullet | null {
    if (!enemy.active || !enemy.canShoot() || !enemy.canAct()) return null;
    if (!this.player || !this.player.active) return null;

    // Check alignment with player
    const aligned = this.isAlignedWithPlayer(enemy);
    if (!aligned) return null;

    // Accuracy check
    const roll = Math.random();
    if (roll > enemy.accuracy) return null;

    enemy.resetShootCooldown();

    const bullet = new Bullet();
    const cx = enemy.centerX() - GameConfig.BULLET_WIDTH / 2;
    const cy = enemy.centerY() - GameConfig.BULLET_HEIGHT / 2;

    bullet.fire(
      cx + enemy.getDirectionDX() * 8,
      cy + enemy.getDirectionDY() * 8,
      enemy.getDirectionDX(),
      enemy.getDirectionDY(),
      EntityType.ENEMY_TANK
    );
    return bullet;
  }

  private isAlignedWithPlayer(enemy: EnemyTank): boolean {
    if (!this.player) return false;

    // Check horizontal alignment
    if (enemy.direction === Direction.LEFT || enemy.direction === Direction.RIGHT) {
      const diffY = Math.abs(enemy.centerY() - this.player.centerY());
      return diffY < enemy.height; // within same row
    }

    // Check vertical alignment
    if (enemy.direction === Direction.UP || enemy.direction === Direction.DOWN) {
      const diffX = Math.abs(enemy.centerX() - this.player.centerX());
      return diffX < enemy.width; // within same column
    }

    return false;
  }
}
