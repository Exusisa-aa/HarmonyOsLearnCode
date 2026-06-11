// Direction enum for 8-directional movement
export enum Direction {
  UP = 0,
  DOWN = 1,
  LEFT = 2,
  RIGHT = 3
}

// Game state machine states
export enum GameState {
  INIT = 0,
  RUNNING = 1,
  PAUSED = 2,
  GAME_OVER = 3,
  LEVEL_COMPLETE = 4
}

// Tank types
export enum TankType {
  PLAYER = 0,
  NORMAL = 1,
  FAST = 2,
  HEAVY = 3
}

// Power-up types
export enum PowerUpType {
  SPEED = 0,
  SHIELD = 1,
  FIREPOWER = 2,
  BASE_REINFORCE = 3
}

// Terrain / map cell types
export enum TerrainType {
  EMPTY = 0,
  BRICK = 1,
  STEEL = 2,
  WATER = 3,
  TREE = 4,
  BASE = 5
}

// Entity type for collision identification
export enum EntityType {
  PLAYER_TANK = 0,
  ENEMY_TANK = 1,
  BULLET = 2,
  TERRAIN = 3,
  POWERUP = 4
}

// Enemy AI FSM states
export enum AIState {
  PATROL = 0,
  CHASE = 1,
  SHOOT = 2
}

// Game configuration constants
export class GameConfig {
  // Map
  static readonly MAP_ROWS: number = 26;
  static readonly MAP_COLS: number = 26;
  static readonly TILE_SIZE: number = 16;

  // Game loop
  static readonly TARGET_FPS: number = 60;
  static readonly FIXED_DT: number = 1000 / 60; // 16.67ms

  // Player
  static readonly PLAYER_BASE_SPEED: number = 2; // pixels per frame
  static readonly PLAYER_MAX_BULLETS: number = 1;
  static readonly PLAYER_SHOOT_COOLDOWN: number = 500; // ms
  static readonly PLAYER_INITIAL_LIVES: number = 3;
  static readonly PLAYER_RESPAWN_INVINCIBLE_MS: number = 2000;

  // Bullet
  static readonly BULLET_BASE_SPEED: number = 4;
  static readonly BULLET_WIDTH: number = 4;
  static readonly BULLET_HEIGHT: number = 4;

  // Enemies
  static readonly MAX_ENEMIES_ON_FIELD: number = 4;
  static readonly ENEMY_RESPAWN_DELAY_MS: number = 3000;

  // Collision
  static readonly GRID_CELL_SIZE: number = 16; // spatial partition cell

  // Score
  static readonly SCORE_NORMAL: number = 100;
  static readonly SCORE_FAST: number = 200;
  static readonly SCORE_HEAVY: number = 300;
  static readonly EXTRA_LIFE_SCORE: number = 20000;

  // Power-up
  static readonly POWERUP_DROP_CHANCE: number = 0.2;
  static readonly POWERUP_DURATION_MS: number = 15000;
  static readonly POWERUP_SPEED_MULTIPLIER: number = 1.5;
  static readonly POWERUP_FIREPOWER_DURATION_MS: number = 10000;
  static readonly BASE_REINFORCE_DURATION_MS: number = 20000;
}
