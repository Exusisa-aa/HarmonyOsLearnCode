import { Terrain } from '../entities/Terrain';
import { EnemyTank } from '../entities/EnemyTank';
import { PlayerTank } from '../entities/PlayerTank';
import { TerrainType, TankType, GameConfig } from '../../common/Constants';
import { LevelData, EnemyConfig } from '../data/LevelData';

export class LevelLoader {
  private levelData: LevelData | null = null;

  loadLevel(data: LevelData): void {
    this.levelData = data;
  }

  getLevelNumber(): number {
    return this.levelData ? this.levelData.levelNumber : 1;
  }

  createTerrainEntities(): Terrain[] {
    const terrains: Terrain[] = [];
    if (!this.levelData) {
      return terrains;
    }

    const { grid, mapRows, mapCols } = this.levelData;
    const tileSize = GameConfig.TILE_SIZE;

    for (let row = 0; row < mapRows; row++) {
      for (let col = 0; col < mapCols; col++) {
        const cellType = grid[row][col];
        if (cellType !== TerrainType.EMPTY) {
          const terrain = new Terrain(
            col * tileSize,
            row * tileSize,
            tileSize,
            tileSize,
            cellType
          );
          terrains.push(terrain);
        }
      }
    }
    return terrains;
  }

  createEnemyQueue(): EnemyTank[] {
    const enemies: EnemyTank[] = [];
    if (!this.levelData) {
      return enemies;
    }

    for (const config of this.levelData.enemies) {
      for (let i = 0; i < config.count; i++) {
        const enemy = new EnemyTank(config.type);
        enemies.push(enemy);
      }
    }
    return enemies;
  }

  getEnemySpawnPosition(): { x: number; y: number } {
    if (this.levelData) {
      return {
        x: this.levelData.enemySpawnX * GameConfig.TILE_SIZE,
        y: this.levelData.enemySpawnY * GameConfig.TILE_SIZE,
      };
    }
    return { x: 0, y: 0 };
  }

  getPlayerStartPosition(): { x: number; y: number } {
    if (this.levelData) {
      return {
        x: this.levelData.playerStartX * GameConfig.TILE_SIZE,
        y: this.levelData.playerStartY * GameConfig.TILE_SIZE,
      };
    }
    return { x: 9 * GameConfig.TILE_SIZE, y: 24 * GameConfig.TILE_SIZE };
  }

  getBasePosition(): { x: number; y: number } {
    if (this.levelData) {
      return {
        x: this.levelData.baseX * GameConfig.TILE_SIZE,
        y: this.levelData.baseY * GameConfig.TILE_SIZE,
      };
    }
    return { x: 12 * GameConfig.TILE_SIZE, y: 24 * GameConfig.TILE_SIZE };
  }
}
