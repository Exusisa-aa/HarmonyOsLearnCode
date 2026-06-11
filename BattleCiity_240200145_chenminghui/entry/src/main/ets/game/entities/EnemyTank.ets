import { Tank } from './Tank';
import type { PlayerTank } from './PlayerTank';
import { EntityType, TankType, AIState, GameConfig } from '../../common/Constants';

// Enemy type configuration
interface EnemyConfig {
  speed: number;
  health: number;
  accuracy: number;
  scoreValue: number;
  label: string;
}

function getEnemyConfig(type: TankType): EnemyConfig {
  switch (type) {
    case TankType.PLAYER:
      return { speed: 2, health: 1, accuracy: 1.0, scoreValue: 0, label: 'Player' };
    case TankType.NORMAL:
      return { speed: 1.5, health: 1, accuracy: 0.3, scoreValue: GameConfig.SCORE_NORMAL, label: 'Normal' };
    case TankType.FAST:
      return { speed: 2.25, health: 1, accuracy: 0.3, scoreValue: GameConfig.SCORE_FAST, label: 'Fast' };
    case TankType.HEAVY:
      return { speed: 1.0, health: 2, accuracy: 0.5, scoreValue: GameConfig.SCORE_HEAVY, label: 'Heavy' };
  }
}

export class EnemyTank extends Tank {
  aiState: AIState = AIState.PATROL;
  accuracy: number = 0.3;
  scoreValue: number = 100;

  // Direction change timer for patrol
  directionTimer: number = 0;
  directionLockMs: number = 0;

  // Spawn animation
  spawning: boolean = true;
  spawnTimer: number = 0;
  private static readonly SPAWN_DURATION_MS: number = 1000;

  // Player reference for AI targeting
  playerRef: PlayerTank | null = null;

  constructor(enemyType: TankType) {
    super(enemyType, EntityType.ENEMY_TANK);
    const config = getEnemyConfig(enemyType);
    if (config) {
      this.speed = config.speed;
      this.health = config.health;
      this.maxHealth = config.health;
      this.accuracy = config.accuracy;
      this.scoreValue = config.scoreValue;
    }
    this.shootCooldownMs = 1000; // 1 second base cooldown
    this.spawnTimer = EnemyTank.SPAWN_DURATION_MS;
  }

  setPlayerRef(player: PlayerTank | null): void {
    this.playerRef = player;
  }

  updateTimers(deltaMs: number): void {
    this.updateCooldown(deltaMs);
    if (this.directionTimer > 0) {
      this.directionTimer -= deltaMs;
    }
    if (this.spawning) {
      this.spawnTimer -= deltaMs;
      if (this.spawnTimer <= 0) {
        this.spawning = false;
      }
    }
  }

  canAct(): boolean {
    return !this.spawning && this.active;
  }

  setDirectionLock(ms: number): void {
    this.directionTimer = ms;
    this.directionLockMs = ms;
  }

  isDirectionLocked(): boolean {
    return this.directionTimer > 0;
  }

  pickRandomDirection(): void {
    const dirs = [0, 1, 2, 3]; // UP, DOWN, LEFT, RIGHT
    const pick = dirs[Math.floor(Math.random() * dirs.length)];
    this.direction = pick;
  }
}
