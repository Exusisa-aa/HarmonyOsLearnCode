import { Terrain } from '../entities/Terrain';
import { EnemyTank } from '../entities/EnemyTank';
import { PlayerTank } from '../entities/PlayerTank';
import { LevelLoader } from './LevelLoader';
import { ResourceManager } from '../core/ResourceManager';
import { GameStateManager } from '../core/GameStateManager';
import { GameState, GameConfig } from '../../common/Constants';
import { LevelData } from '../data/LevelData';

export class LevelManager {
  private levelLoader: LevelLoader;
  private resourceManager: ResourceManager;
  private stateManager: GameStateManager;

  currentLevelNum: number = 1;
  totalLevels: number = 10;
  enemiesRemaining: number = 0;
  enemiesDestroyed: number = 0;

  constructor() {
    this.levelLoader = new LevelLoader();
    this.resourceManager = ResourceManager.getInstance();
    this.stateManager = GameStateManager.getInstance();
  }

  loadLevel(levelNum: number): LevelData | null {
    const data = this.resourceManager.getLevel(levelNum);
    if (!data) {
      return null;
    }
    this.levelLoader.loadLevel(data);
    this.currentLevelNum = levelNum;
    this.enemiesDestroyed = 0;

    // Count total enemies for this level
    this.enemiesRemaining = 0;
    for (const config of data.enemies) {
      this.enemiesRemaining += config.count;
    }
    return data;
  }

  getTerrainEntities(): Terrain[] {
    return this.levelLoader.createTerrainEntities();
  }

  getEnemyQueue(): EnemyTank[] {
    return this.levelLoader.createEnemyQueue();
  }

  getPlayerStartPos(): { x: number; y: number } {
    return this.levelLoader.getPlayerStartPosition();
  }

  getEnemySpawnPos(): { x: number; y: number } {
    return this.levelLoader.getEnemySpawnPosition();
  }

  getBasePos(): { x: number; y: number; width: number; height: number } {
    const pos = this.levelLoader.getBasePosition();
    return {
      x: pos.x,
      y: pos.y,
      width: GameConfig.TILE_SIZE * 2,
      height: GameConfig.TILE_SIZE * 2,
    };
  }

  onEnemyDestroyed(): void {
    this.enemiesRemaining--;
    this.enemiesDestroyed++;
    if (this.enemiesRemaining <= 0) {
      this.onLevelComplete();
    }
  }

  private onLevelComplete(): void {
    if (this.currentLevelNum >= this.totalLevels) {
      // Game won - all levels complete
      this.stateManager.setState(GameState.GAME_OVER);
      return;
    }
    this.stateManager.setState(GameState.LEVEL_COMPLETE);
  }

  gotoNextLevel(): boolean {
    const nextLevel = this.currentLevelNum + 1;
    if (nextLevel > this.totalLevels) {
      return false;
    }
    return this.loadLevel(nextLevel) !== null;
  }

  onBaseDestroyed(): void {
    this.stateManager.setState(GameState.GAME_OVER);
  }

  reset(): void {
    this.currentLevelNum = 1;
    this.enemiesRemaining = 0;
    this.enemiesDestroyed = 0;
  }
}
