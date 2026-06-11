import { BaseEntity, AABB } from '../entities/BaseEntity';
import { Bullet } from '../entities/Bullet';
import { Tank } from '../entities/Tank';
import { PlayerTank } from '../entities/PlayerTank';
import { EnemyTank } from '../entities/EnemyTank';
import { Terrain } from '../entities/Terrain';
import { PowerUp } from '../entities/PowerUp';
import { EntityType, TerrainType, GameConfig } from '../../common/Constants';

export interface CollisionResult {
  hit: boolean;
  hitX?: number;
  hitY?: number;
  hitEntity?: BaseEntity;
}

// Spatial grid for collision optimization
class SpatialGrid {
  private cellSize: number = GameConfig.GRID_CELL_SIZE;
  private grid: Map<number, BaseEntity[]>;
  private cols: number;

  constructor(mapWidth: number, mapHeight: number) {
    this.cols = Math.ceil(mapWidth / this.cellSize);
    this.grid = new Map();
  }

  clear(): void {
    this.grid.clear();
  }

  private key(col: number, row: number): number {
    return row * this.cols + col;
  }

  insert(entity: BaseEntity): void {
    if (!entity.active) return;
    const aabb = entity.getAABB();
    const minCol = Math.floor(aabb.x / this.cellSize);
    const minRow = Math.floor(aabb.y / this.cellSize);
    const maxCol = Math.floor((aabb.x + aabb.width) / this.cellSize);
    const maxRow = Math.floor((aabb.y + aabb.height) / this.cellSize);

    for (let r = minRow; r <= maxRow; r++) {
      for (let c = minCol; c <= maxCol; c++) {
        const k = this.key(c, r);
        let list = this.grid.get(k);
        if (!list) {
          list = [];
          this.grid.set(k, list);
        }
        list.push(entity);
      }
    }
  }

  getNearby(entity: BaseEntity): BaseEntity[] {
    const aabb = entity.getAABB();
    const minCol = Math.floor(aabb.x / this.cellSize);
    const minRow = Math.floor(aabb.y / this.cellSize);
    const maxCol = Math.floor((aabb.x + aabb.width) / this.cellSize);
    const maxRow = Math.floor((aabb.y + aabb.height) / this.cellSize);

    const result: BaseEntity[] = [];
    const seen = new Set<BaseEntity>();

    for (let r = minRow; r <= maxRow; r++) {
      for (let c = minCol; c <= maxCol; c++) {
        const list = this.grid.get(this.key(c, r));
        if (list) {
          for (const e of list) {
            if (e !== entity && !seen.has(e)) {
              seen.add(e);
              result.push(e);
            }
          }
        }
      }
    }
    return result;
  }
}

// Collision callbacks
export interface CollisionHandler {
  onBulletHitTerrain(bullet: Bullet, terrain: Terrain): void;
  onBulletHitTank(bullet: Bullet, tank: Tank): void;
  onTankHitTerrain(tank: Tank, terrain: Terrain): CollisionResult;
  onPlayerCollectPowerUp(player: PlayerTank, powerUp: PowerUp): void;
}

export class CollisionSystem {
  private grid: SpatialGrid;

  constructor(mapWidth: number, mapHeight: number) {
    this.grid = new SpatialGrid(mapWidth, mapHeight);
  }

  update(
    bullets: Bullet[],
    playerTanks: PlayerTank[],
    enemyTanks: EnemyTank[],
    terrains: Terrain[],
    powerUps: PowerUp[],
    handler: CollisionHandler
  ): void {
    // Build spatial grid
    this.grid.clear();
    for (const b of bullets) { if (b.active) this.grid.insert(b); }
    for (const p of playerTanks) { if (p.active) this.grid.insert(p); }
    for (const e of enemyTanks) { if (e.active) this.grid.insert(e); }
    for (const t of terrains) { if (t.active) this.grid.insert(t); }
    for (const p of powerUps) { if (p.active) this.grid.insert(p); }

    // Bullet collisions (task 5.3, 5.4)
    for (const bullet of bullets) {
      if (!bullet.active) continue;
      const nearby = this.grid.getNearby(bullet);

      for (const other of nearby) {
        if (!other.active || !bullet.active) continue;

        if (other.entityType === EntityType.TERRAIN) {
          if (bullet.collidesWith(other)) {
            handler.onBulletHitTerrain(bullet, other as Terrain);
          }
        } else if (other.entityType === EntityType.ENEMY_TANK && bullet.shooterType === EntityType.PLAYER_TANK) {
          if (bullet.collidesWith(other)) {
            handler.onBulletHitTank(bullet, other as Tank);
          }
        } else if (other.entityType === EntityType.PLAYER_TANK && bullet.shooterType === EntityType.ENEMY_TANK) {
          if (bullet.collidesWith(other)) {
            handler.onBulletHitTank(bullet, other as Tank);
          }
        } else if (other.entityType === EntityType.BULLET) {
          // Bullet vs bullet (mutual cancellation)
          const otherBullet = other as Bullet;
          if (bullet.shooterType !== otherBullet.shooterType && bullet.collidesWith(otherBullet)) {
            bullet.deactivate();
            otherBullet.deactivate();
          }
        }
      }
    }

    // Tank-terrain and tank-tank collisions (task 5.5, 5.6)
    const allTanks: Tank[] = [...playerTanks, ...enemyTanks];

    for (const tank of allTanks) {
      if (!tank.active) continue;
      const nearby = this.grid.getNearby(tank);

      for (const other of nearby) {
        if (!other.active) continue;

        if (other.entityType === EntityType.TERRAIN) {
          const terrain = other as Terrain;
          if (terrain.isBlocking() && tank.collidesWith(terrain)) {
            handler.onTankHitTerrain(tank, terrain);
          }
        } else if ((other.entityType === EntityType.PLAYER_TANK || other.entityType === EntityType.ENEMY_TANK) &&
                   other !== tank) {
          if (tank.collidesWith(other)) {
            // Both tanks stop - push apart
            this.resolveTankTankCollision(tank, other as Tank);
          }
        }
      }
    }

    // Player-powerup collection (task 9.1)
    for (const player of playerTanks) {
      if (!player.active) continue;
      const nearby = this.grid.getNearby(player);

      for (const other of nearby) {
        if (!other.active) continue;
        if (other.entityType === EntityType.POWERUP) {
          if (player.collidesWith(other)) {
            handler.onPlayerCollectPowerUp(player, other as PowerUp);
          }
        }
      }
    }
  }

  private resolveTankTankCollision(a: Tank, b: Tank): void {
    // Push both tanks apart along the axis of least overlap
    const aabbA = a.getAABB();
    const aabbB = b.getAABB();

    const overlapX = Math.min(
      aabbA.x + aabbA.width - aabbB.x,
      aabbB.x + aabbB.width - aabbA.x
    );
    const overlapY = Math.min(
      aabbA.y + aabbA.height - aabbB.y,
      aabbB.y + aabbB.height - aabbA.y
    );

    if (overlapX < overlapY) {
      // Separate on X axis
      const push = overlapX / 2;
      if (aabbA.centerX() < aabbB.centerX()) {
        a.x -= push;
        b.x += push;
      } else {
        a.x += push;
        b.x -= push;
      }
    } else {
      // Separate on Y axis
      const push = overlapY / 2;
      if (aabbA.centerY() < aabbB.centerY()) {
        a.y -= push;
        b.y += push;
      } else {
        a.y += push;
        b.y -= push;
      }
    }
  }

  // Static utility: AABB overlap check (task 5.1)
  static checkAABB(a: AABB, b: AABB): boolean {
    return (
      a.x < b.x + b.width &&
      a.x + a.width > b.x &&
      a.y < b.y + b.height &&
      a.y + a.height > b.y
    );
  }

  // Static utility: boundary check
  static checkBounds(x: number, y: number, width: number, height: number,
                     mapW: number, mapH: number): boolean {
    return x >= 0 && y >= 0 && x + width <= mapW && y + height <= mapH;
  }
}
