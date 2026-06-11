// Game dimensions
export const CANVAS_WIDTH = 720;
export const CANVAS_HEIGHT = 1280;
export const GAME_AREA_X = 0;
export const GAME_AREA_Y = 0;
export const GAME_AREA_WIDTH = 720;
export const GAME_AREA_HEIGHT = 1248;
// Tile system
export const TILE_SIZE = 48;
export const MAP_COLS = 15; // 720 / 48
export const MAP_ROWS = 26; // 1248 / 48
// Grid offset for centering 15-column map in 720px canvas
export const GRID_OFFSET_X = 0;
// Tank sizes
export const TANK_WIDTH = 40;
export const TANK_HEIGHT = 40;
// Bullet
export const BULLET_SIZE = 10;
export const BULLET_SPEED = 10;
// Speeds (pixels per second)
export const PLAYER_SPEED = 360;
export const ENEMY_BASIC_SPEED = 180;
export const ENEMY_FAST_SPEED = 360;
export const ENEMY_HEAVY_SPEED = 90;
// Cooldowns (frames at 60fps)
export const PLAYER_SHOOT_COOLDOWN = 15;
export const ENEMY_BASIC_COOLDOWN = 90;
export const ENEMY_FAST_COOLDOWN = 60;
export const ENEMY_HEAVY_COOLDOWN = 120;
// Player
export const PLAYER_START_LIVES = 3;
export const PLAYER_INVINCIBLE_DURATION = 120; // 2 seconds at 60fps
export const PLAYER_START_X = 336;
export const PLAYER_START_Y = 1056;
export const EXTRA_LIFE_SCORE = 20000;
export const MAX_LIVES = 9;
// Power-ups
export const POWERUP_SIZE = 40;
export const POWERUP_DURATION_SPEED = 15 * 60; // 15s in frames
export const POWERUP_DURATION_SHIELD = 20 * 60; // 20s in frames
export const POWERUP_DURATION_POWER = 20 * 60; // 20s in frames
export const POWERUP_DURATION_FREEZE = 10 * 60; // 10s in frames
export const POWERUP_DROP_CHANCE = 0.15;
export const POWERUP_MAX_ON_FIELD = 2;
export const POWERUP_BLINK_START = 20 * 60; // Start blinking after 20s
export const POWERUP_LIFETIME = 25 * 60; // Disappear after 25s
// Enemy spawning
export const MAX_ENEMIES_ON_FIELD = 4;
export const ENEMY_SPAWN_INTERVAL = 5 * 60; // 5s between spawns
// Base
export const BASE_X = 336;
export const BASE_Y = 1152;
export const BASE_SIZE = 48;
// Scoring
export const SCORE_BASIC_ENEMY = 100;
export const SCORE_FAST_ENEMY = 200;
export const SCORE_HEAVY_ENEMY = 300;
// Colors
export const COLOR_BG = '#2C2C2C';
export const COLOR_BLACK = '#000000';
export const COLOR_WHITE = '#FFFFFF';
export const COLOR_BRICK = '#CC4400';
export const COLOR_BRICK_LIGHT = '#DD6622';
export const COLOR_STEEL = '#DDDDDD';
export const COLOR_STEEL_DARK = '#888888';
export const COLOR_PLAYER_BODY = '#E0A000';
export const COLOR_PLAYER_HIGHLIGHT = '#FFCC00';
export const COLOR_ENEMY_BASIC = '#CCCCCC';
export const COLOR_ENEMY_FAST = '#88CCFF';
export const COLOR_ENEMY_HEAVY = '#666666';
export const COLOR_TRACK = '#444444';
export const COLOR_GUN = '#888888';
export const COLOR_EXPLOSION = '#FF0000';
export const COLOR_BASE_EAGLE = '#FFFFFF';
export const COLOR_WATER = '#1A1A8A';
export const COLOR_FOREST = '#0A5A0A';
export const COLOR_ICE = '#CCEEFF';
