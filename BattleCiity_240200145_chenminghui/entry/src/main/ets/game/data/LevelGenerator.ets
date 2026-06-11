import { TerrainType, TankType } from '../../common/Constants';
import { LevelData, EnemyConfig, MapGrid } from './LevelData';

// Generates level data procedurally for all levels
export function generateLevel(levelNumber: number): LevelData {
  const rows = 26;
  const cols = 26;

  // Initialize empty grid
  const grid: MapGrid = [];
  for (let r = 0; r < rows; r++) {
    const row: TerrainType[] = [];
    for (let c = 0; c < cols; c++) {
      row.push(TerrainType.EMPTY);
    }
    grid.push(row);
  }

  // Place base at bottom center
  const baseCol = 12;
  const baseRow = 24;
  grid[baseRow][baseCol] = TerrainType.BASE;
  grid[baseRow][baseCol + 1] = TerrainType.BASE;
  grid[baseRow + 1][baseCol] = TerrainType.BASE;
  grid[baseRow + 1][baseCol + 1] = TerrainType.BASE;

  // Protect base with bricks
  grid[baseRow - 1][baseCol - 1] = TerrainType.BRICK;
  grid[baseRow - 1][baseCol] = TerrainType.BRICK;
  grid[baseRow - 1][baseCol + 1] = TerrainType.BRICK;
  grid[baseRow - 1][baseCol + 2] = TerrainType.BRICK;
  grid[baseRow][baseCol - 1] = TerrainType.BRICK;
  grid[baseRow][baseCol + 2] = TerrainType.BRICK;
  grid[baseRow + 1][baseCol - 1] = TerrainType.BRICK;
  grid[baseRow + 1][baseCol + 2] = TerrainType.BRICK;

  // Clear player start area (bottom left area)
  const playerCol = 8;
  const playerRow = 24;

  // Generate level-specific terrain
  switch (levelNumber) {
    case 1:
      generateLevel1(grid);
      break;
    case 2:
      generateLevel2(grid);
      break;
    case 3:
      generateLevel3(grid);
      break;
    default:
      generateRandomLevel(grid, levelNumber);
      break;
  }

  // Ensure player start area is clear
  for (let r = playerRow - 1; r <= playerRow + 1; r++) {
    for (let c = playerCol - 1; c <= playerCol + 2; c++) {
      if (r >= 0 && r < rows && c >= 0 && c < cols &&
          grid[r][c] !== TerrainType.BASE) {
        grid[r][c] = TerrainType.EMPTY;
      }
    }
  }

  // Enemy configuration based on level
  const enemies: EnemyConfig[] = getEnemyConfigForLevel(levelNumber);

  return {
    version: 1,
    levelNumber: levelNumber,
    mapRows: rows,
    mapCols: cols,
    grid: grid,
    playerStartX: playerCol,
    playerStartY: playerRow,
    baseX: baseCol,
    baseY: baseRow,
    enemies: enemies,
    enemySpawnX: 0,
    enemySpawnY: 0,
  };
}

function getEnemyConfigForLevel(level: number): EnemyConfig[] {
  switch (level) {
    case 1:
      return [
        { type: TankType.NORMAL, count: 8 },
        { type: TankType.FAST, count: 2 },
      ];
    case 2:
      return [
        { type: TankType.NORMAL, count: 6 },
        { type: TankType.FAST, count: 4 },
        { type: TankType.HEAVY, count: 2 },
      ];
    case 3:
      return [
        { type: TankType.NORMAL, count: 4 },
        { type: TankType.FAST, count: 4 },
        { type: TankType.HEAVY, count: 4 },
      ];
    case 4:
      return [
        { type: TankType.FAST, count: 6 },
        { type: TankType.HEAVY, count: 4 },
        { type: TankType.NORMAL, count: 4 },
      ];
    case 5:
      return [
        { type: TankType.HEAVY, count: 6 },
        { type: TankType.FAST, count: 4 },
        { type: TankType.NORMAL, count: 4 },
      ];
    default: {
      const extra = Math.min(level - 5, 4);
      return [
        { type: TankType.NORMAL, count: 4 + extra },
        { type: TankType.FAST, count: 4 + extra },
        { type: TankType.HEAVY, count: 6 + Math.floor(extra / 2) },
      ];
    }
  }
}

function generateLevel1(grid: MapGrid): void {
  // Classic Battle City first level layout
  // Brick walls forming corridors
  for (let r = 2; r < 23; r += 4) {
    for (let c = 2; c < 24; c++) {
      if (grid[r][c] === TerrainType.EMPTY) {
        grid[r][c] = TerrainType.BRICK;
      }
    }
  }
  // Some steel walls
  grid[6][10] = TerrainType.STEEL;
  grid[6][11] = TerrainType.STEEL;
  grid[6][14] = TerrainType.STEEL;
  grid[6][15] = TerrainType.STEEL;
  grid[14][10] = TerrainType.STEEL;
  grid[14][11] = TerrainType.STEEL;
  grid[14][14] = TerrainType.STEEL;
  grid[14][15] = TerrainType.STEEL;
  // Water obstacles
  grid[10][12] = TerrainType.WATER;
  grid[10][13] = TerrainType.WATER;
  grid[11][12] = TerrainType.WATER;
  grid[11][13] = TerrainType.WATER;
}

function generateLevel2(grid: MapGrid): void {
  // More open layout with brick clusters
  for (let r = 2; r < 22; r += 3) {
    for (let c = 0; c < 26; c += 2) {
      if (grid[r][c] === TerrainType.EMPTY && Math.random() > 0.4) {
        grid[r][c] = TerrainType.BRICK;
      }
    }
  }
  // Steel pillars
  for (let r = 4; r < 20; r += 5) {
    grid[r][6] = TerrainType.STEEL;
    grid[r][7] = TerrainType.STEEL;
    grid[r][18] = TerrainType.STEEL;
    grid[r][19] = TerrainType.STEEL;
  }
  // Tree clusters (visual cover, passable)
  for (let r = 2; r < 20; r += 6) {
    for (let c = 11; c < 15; c++) {
      if (grid[r][c] === TerrainType.EMPTY) {
        grid[r][c] = TerrainType.TREE;
      }
    }
  }
}

function generateLevel3(grid: MapGrid): void {
  // Fortress-like layout
  // Center steel fortress
  for (let r = 10; r < 16; r++) {
    for (let c = 10; c < 16; c++) {
      if (r === 10 || r === 15 || c === 10 || c === 15) {
        grid[r][c] = TerrainType.STEEL;
      }
    }
  }
  // Brick corridors
  for (let r = 0; r < 26; r += 5) {
    for (let c = 0; c < 26; c++) {
      if (grid[r][c] === TerrainType.EMPTY) {
        grid[r][c] = TerrainType.BRICK;
      }
    }
  }
  // Water moats
  for (let c = 8; c < 18; c++) {
    grid[8][c] = TerrainType.WATER;
    grid[17][c] = TerrainType.WATER;
  }
}

function generateRandomLevel(grid: MapGrid, seed: number): void {
  // Seeded random layout
  const rng = new SimpleRNG(seed * 137);

  // Brick clusters
  for (let i = 0; i < 80 + seed * 10; i++) {
    const r = Math.floor(rng.next() * 23);
    const c = Math.floor(rng.next() * 26);
    if (grid[r][c] === TerrainType.EMPTY) {
      if (rng.next() > 0.3) {
        grid[r][c] = TerrainType.BRICK;
      }
    }
  }

  // Steel blocks
  for (let i = 0; i < 10 + seed * 2; i++) {
    const r = Math.floor(rng.next() * 22);
    const c = Math.floor(rng.next() * 24);
    if (grid[r][c] === TerrainType.EMPTY && grid[r][c + 1] === TerrainType.EMPTY) {
      grid[r][c] = TerrainType.STEEL;
      grid[r][c + 1] = TerrainType.STEEL;
    }
  }

  // Water pools
  for (let i = 0; i < 3 + seed; i++) {
    const r = 2 + Math.floor(rng.next() * 18);
    const c = Math.floor(rng.next() * 22);
    if (grid[r][c] === TerrainType.EMPTY && grid[r][c + 1] === TerrainType.EMPTY) {
      grid[r][c] = TerrainType.WATER;
      grid[r][c + 1] = TerrainType.WATER;
      if (r + 1 < 24 && grid[r + 1][c] === TerrainType.EMPTY) {
        grid[r + 1][c] = TerrainType.WATER;
        grid[r + 1][c + 1] = TerrainType.WATER;
      }
    }
  }

  // Tree patches
  for (let i = 0; i < 5 + seed; i++) {
    const r = Math.floor(rng.next() * 22);
    const c = Math.floor(rng.next() * 24);
    if (grid[r][c] === TerrainType.EMPTY) {
      grid[r][c] = TerrainType.TREE;
      if (c + 1 < 26) grid[r][c + 1] = TerrainType.TREE;
    }
  }
}

// Simple seeded RNG
class SimpleRNG {
  private state: number;

  constructor(seed: number) {
    this.state = seed;
  }

  next(): number {
    this.state = (this.state * 1103515245 + 12345) & 0x7fffffff;
    return this.state / 0x7fffffff;
  }
}
