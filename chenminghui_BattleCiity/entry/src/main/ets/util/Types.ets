// Shared interfaces for ArkTS (no object literal types)
// Avoid circular imports by using basic types where needed

export interface Point {
  x: number;
  y: number;
}

export interface Rect {
  x: number;
  y: number;
  width: number;
  height: number;
}

export interface LevelDataEnemies {
  BASIC: number;
  FAST: number;
  HEAVY: number;
}

export interface LevelData {
  name: string;
  map: string[];
  enemies: LevelDataEnemies;
  spawnPoints: Point[];
}

export interface ScaleInfo {
  x: number;
  y: number;
}

export interface ActiveEffectInfo {
  type: number;
  remainingTime: number;
}
