import { EnemyTank, EnemyType } from '../entity/Tank';
import { PlayerTank } from '../entity/Tank';
import { Direction } from '../entity/GameEntity';
import { Terrain, TileType } from '../entity/Terrain';
import { Bullet, BulletOwner } from '../entity/Bullet';
import { CollisionSystem } from './CollisionSystem';
import { TILE_SIZE, MAP_COLS } from '../util/Constants';

export enum AIState {
  PATROL,
  CHASE,
  ATTACK,
  EVADE
}

const DETECT_RANGE = 6; // Tiles

export class AISystem {
  private collisionSystem: CollisionSystem;

  constructor(collisionSystem: CollisionSystem) {
    this.collisionSystem = collisionSystem;
  }

  updateEnemy(enemy: EnemyTank, player: PlayerTank, terrain: Terrain[], allEnemies: EnemyTank[], bullets: Bullet[], dt: number): void {
    if (!enemy.alive || enemy.frozen) return;

    enemy.update(dt);
    const state = this.determineState(enemy, player, bullets);

    switch (state) {
      case AIState.PATROL: this.doPatrol(enemy, terrain); break;
      case AIState.CHASE: this.doChase(enemy, player); break;
      case AIState.ATTACK: this.doAttack(enemy, player); break;
      case AIState.EVADE: this.doEvade(enemy, player, bullets); break;
    }
  }

  private determineState(enemy: EnemyTank, player: PlayerTank, bullets: Bullet[]): AIState {
    // Check for incoming bullets to evade
    for (const b of bullets) {
      if (b.owner !== BulletOwner.ENEMY && b.isActive) {
        const dx = b.x - enemy.x;
        const dy = b.y - enemy.y;
        if (Math.abs(dx) < TILE_SIZE * 3 && Math.abs(dy) < TILE_SIZE * 3) {
          const isAligned = this.isAlignedWithBullet(enemy, b);
          if (isAligned && Math.random() < 0.3) return AIState.EVADE;
        }
      }
    }

    // Check if player is in same row/column
    const sameColumn = Math.abs(enemy.centerX - player.centerX) < TILE_SIZE / 2;
    const sameRow = Math.abs(enemy.centerY - player.centerY) < TILE_SIZE / 2;
    if (sameColumn || sameRow) {
      const dist = Math.sqrt(
        (enemy.centerX - player.centerX) ** 2 + (enemy.centerY - player.centerY) ** 2
      );
      if (dist < TILE_SIZE * DETECT_RANGE) {
        if (sameColumn || sameRow) return AIState.ATTACK;
        return AIState.CHASE;
      }
    }

    return AIState.PATROL;
  }

  private isAlignedWithBullet(enemy: EnemyTank, bullet: Bullet): boolean {
    if (bullet.vx !== 0) {
      return Math.abs(enemy.centerY - bullet.y) < TILE_SIZE;
    } else {
      return Math.abs(enemy.centerX - bullet.x) < TILE_SIZE;
    }
  }

  private doPatrol(enemy: EnemyTank, terrain: Terrain[]): void {
    enemy.moveTimer--;
    if (enemy.moveTimer <= 0) {
      enemy.direction = Math.floor(Math.random() * 4);
      enemy.moveTimer = 30 + Math.floor(Math.random() * 60);
    }
  }

  private doChase(enemy: EnemyTank, player: PlayerTank): void {
    const dx = player.centerX - enemy.centerX;
    const dy = player.centerY - enemy.centerY;

    if (Math.abs(dx) > Math.abs(dy)) {
      enemy.direction = dx > 0 ? Direction.RIGHT : Direction.LEFT;
    } else {
      enemy.direction = dy > 0 ? Direction.DOWN : Direction.UP;
    }
  }

  private doAttack(enemy: EnemyTank, player: PlayerTank): void {
    // Face the player
    this.doChase(enemy, player);
    // Shooting handled externally
  }

  private doEvade(enemy: EnemyTank, player: PlayerTank, bullets: Bullet[]): void {
    // Try moving perpendicular to nearest threat
    for (const b of bullets) {
      if (b.owner === BulletOwner.PLAYER && b.isActive) {
        if (Math.abs(b.vx) > 0) {
          enemy.direction = Math.random() > 0.5 ? Direction.UP : Direction.DOWN;
        } else if (Math.abs(b.vy) > 0) {
          enemy.direction = Math.random() > 0.5 ? Direction.LEFT : Direction.RIGHT;
        }
        break;
      }
    }
  }

  shouldShoot(enemy: EnemyTank, player: PlayerTank): boolean {
    if (!enemy.canShoot()) return false;
    const sameColumn = Math.abs(enemy.centerX - player.centerX) < TILE_SIZE;
    const sameRow = Math.abs(enemy.centerY - player.centerY) < TILE_SIZE;
    if (!sameColumn && !sameRow) return false;
    return Math.random() < 0.3; // 30% chance per check
  }
}
