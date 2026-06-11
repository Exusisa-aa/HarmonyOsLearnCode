import { EnemyTank } from '../entities/EnemyTank';
import { GameConfig } from '../../common/Constants';

export class EnemySpawner {
  private spawnQueue: EnemyTank[] = [];
  private activeEnemies: EnemyTank[] = [];
  private spawnTimer: number = 0;
  private maxOnField: number = GameConfig.MAX_ENEMIES_ON_FIELD;
  private spawnX: number = 0;
  private spawnY: number = 0;

  setSpawnPosition(x: number, y: number): void {
    this.spawnX = x;
    this.spawnY = y;
  }

  setQueue(queue: EnemyTank[]): void {
    this.spawnQueue = [...queue];
    this.activeEnemies = [];
    this.spawnTimer = 0;
  }

  update(deltaMs: number): EnemyTank | null {
    // Count active enemies
    this.activeEnemies = this.activeEnemies.filter(e => e.active);

    if (this.spawnQueue.length === 0 && this.activeEnemies.length === 0) {
      return null; // All enemies deployed and destroyed
    }

    if (this.spawnQueue.length > 0 &&
        this.activeEnemies.length < this.maxOnField &&
        this.spawnTimer <= 0) {
      const enemy = this.spawnQueue.shift()!;
      enemy.x = this.spawnX;
      enemy.y = this.spawnY;
      enemy.active = true;
      this.activeEnemies.push(enemy);

      // Set cooldown before next spawn
      this.spawnTimer = 2000;
      return enemy;
    }

    if (this.spawnTimer > 0) {
      this.spawnTimer -= deltaMs;
    }

    return null;
  }

  // Called when an enemy is destroyed - queue respawn if needed
  onEnemyDestroyed(enemy: EnemyTank): void {
    const idx = this.activeEnemies.indexOf(enemy);
    if (idx >= 0) {
      this.activeEnemies.splice(idx, 1);
    }
  }

  getActiveEnemies(): EnemyTank[] {
    return this.activeEnemies.filter(e => e.active);
  }

  getQueueRemaining(): number {
    return this.spawnQueue.length;
  }

  clear(): void {
    this.spawnQueue = [];
    this.activeEnemies = [];
    this.spawnTimer = 0;
  }
}
