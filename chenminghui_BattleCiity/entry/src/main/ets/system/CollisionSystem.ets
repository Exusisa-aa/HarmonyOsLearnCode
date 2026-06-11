import { GameEntity } from '../entity/GameEntity';
import { Terrain, TileType } from '../entity/Terrain';
import { Bullet, BulletOwner } from '../entity/Bullet';
import { Tank, PlayerTank, EnemyTank } from '../entity/Tank';
import { PowerUp } from '../entity/PowerUp';
import { Rect } from '../util/Types';
import { TILE_SIZE, MAP_COLS, MAP_ROWS, CANVAS_WIDTH, CANVAS_HEIGHT } from '../util/Constants';

export enum CollisionResult {
  NONE,
  WALL_HIT,
  BULLET_HIT_WALL,
  BULLET_HIT_TANK,
  BULLET_HIT_BASE,
  BULLET_CANCEL_BULLET,
  PLAYER_COLLECT_POWERUP
}

export class CollisionSystem {
  private grid: Map<number, GameEntity[]> = new Map();
  private cellSize: number = TILE_SIZE * 2;

  clear(): void {
    this.grid.clear();
  }

  registerEntity(entity: GameEntity): void {
    const cells: number[] = this.getCells(entity);
    for (const cell of cells) {
      let list: GameEntity[] | undefined = this.grid.get(cell);
      if (!list) {
        list = [];
        this.grid.set(cell, list);
      }
      list.push(entity);
    }
  }

  private getCells(entity: GameEntity): number[] {
    const cells: number[] = [];
    const x1: number = Math.floor(entity.x / this.cellSize);
    const y1: number = Math.floor(entity.y / this.cellSize);
    const x2: number = Math.floor((entity.x + entity.width) / this.cellSize);
    const y2: number = Math.floor((entity.y + entity.height) / this.cellSize);
    const gridW: number = Math.ceil(MAP_COLS * TILE_SIZE / this.cellSize);
    for (let y = y1; y <= y2; y++) {
      for (let x = x1; x <= x2; x++) {
        cells.push(y * gridW + x);
      }
    }
    return cells;
  }

  checkAABB(a: GameEntity, b: GameEntity): boolean {
    return a.x < b.x + b.width &&
           a.x + a.width > b.x &&
           a.y < b.y + b.height &&
           a.y + a.height > b.y;
  }

  checkRectCollision(entity: GameEntity, rect: Rect): boolean {
    return entity.x < rect.x + rect.width &&
           entity.x + entity.width > rect.x &&
           entity.y < rect.y + rect.height &&
           entity.y + entity.height > rect.y;
  }

  canMoveTo(tank: Tank, terrain: Terrain[], allTanks: Tank[]): boolean {
    // Boundary check
    if (tank.x < 0 || tank.y < 0 ||
        tank.x + tank.width > CANVAS_WIDTH ||
        tank.y + tank.height > CANVAS_HEIGHT) {
      return false;
    }

    // Terrain collision
    for (const t of terrain) {
      if (!t.isActive) continue;
      if (!t.isSolid) continue;
      if (this.checkAABB(tank, t)) {
        return false;
      }
    }

    // Tank-tank collision
    for (const other of allTanks) {
      if (other === tank || !other.alive) continue;
      if (this.checkAABB(tank, other)) {
        return false;
      }
    }

    return true;
  }

  checkBulletCollisions(
    bullet: Bullet,
    terrain: Terrain[],
    playerTank: PlayerTank,
    enemyTanks: EnemyTank[],
    bullets: Bullet[],
    baseRect: Rect
  ): CollisionResult {
    // Boundary
    if (bullet.x < 0 || bullet.x > CANVAS_WIDTH ||
        bullet.y < 0 || bullet.y > CANVAS_HEIGHT) {
      bullet.isActive = false;
      return CollisionResult.NONE;
    }

    // Terrain
    for (const t of terrain) {
      if (!t.isActive) continue;
      if (!t.isSolid) continue;
      if (this.checkAABB(bullet, t)) {
        bullet.isActive = false;
        if (t.isDestructible) {
          t.isActive = false;
        } else if (t.tileType === TileType.STEEL && bullet.canBreakSteel) {
          t.isActive = false;
        }
        return CollisionResult.BULLET_HIT_WALL;
      }
    }

    // Base
    if (bullet.isActive && this.checkRectCollision(bullet, baseRect)) {
      bullet.isActive = false;
      return CollisionResult.BULLET_HIT_BASE;
    }

    // Bullet vs bullet
    if (bullet.isActive) {
      for (const other of bullets) {
        if (other === bullet || !other.isActive) continue;
        if (bullet.owner !== other.owner && this.checkAABB(bullet, other)) {
          bullet.isActive = false;
          other.isActive = false;
          return CollisionResult.BULLET_CANCEL_BULLET;
        }
      }
    }

    // Bullet vs tanks
    if (bullet.isActive) {
      if (bullet.owner === BulletOwner.PLAYER) {
        for (const enemy of enemyTanks) {
          if (!enemy.alive) continue;
          if (this.checkAABB(bullet, enemy)) {
            bullet.isActive = false;
            enemy.takeDamage();
            return CollisionResult.BULLET_HIT_TANK;
          }
        }
      } else {
        if (playerTank.alive && this.checkAABB(bullet, playerTank)) {
          bullet.isActive = false;
          if (!playerTank.isInvincible) {
            playerTank.takeDamage();
          }
          return CollisionResult.BULLET_HIT_TANK;
        }
      }
    }

    return CollisionResult.NONE;
  }

  checkPowerUpCollection(player: PlayerTank, powerUps: PowerUp[]): PowerUp | null {
    for (const p of powerUps) {
      if (!p.isActive) continue;
      if (this.checkAABB(player, p)) {
        p.isActive = false;
        return p;
      }
    }
    return null;
  }
}
