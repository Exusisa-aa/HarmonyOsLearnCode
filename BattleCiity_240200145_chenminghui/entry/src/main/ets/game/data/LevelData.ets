import { TerrainType, TankType } from '../../common/Constants';

// Enemy configuration in a level
export interface EnemyConfig {
  type: TankType;
  count: number;
}

// A single cell in the map grid
export type MapGrid = TerrainType[][];

// Full level data structure
export interface LevelData {
  version: number;
  levelNumber: number;
  mapRows: number;
  mapCols: number;
  grid: MapGrid;
  playerStartX: number;
  playerStartY: number;
  baseX: number;
  baseY: number;
  enemies: EnemyConfig[];
  enemySpawnX: number;
  enemySpawnY: number;
}

// Save data structure
export interface SaveData {
  version: number;
  currentLevel: number;
  score: number;
  lives: number;
  terrainState: boolean[][]; // tracks which bricks have been destroyed
  timestamp: number;
}
