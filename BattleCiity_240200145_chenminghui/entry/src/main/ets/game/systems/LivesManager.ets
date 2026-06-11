import { GameConfig } from '../../common/Constants';

export type LivesChangeCallback = (lives: number) => void;
export type GameOverCallback = () => void;

export class LivesManager {
  private lives: number;
  private scoreMilestoneForExtraLife: number;
  private extraLifeAwardedAt: number = -1;
  private livesListeners: LivesChangeCallback[] = [];
  private gameOverListeners: GameOverCallback[] = [];

  constructor(initialScore: number = 0) {
    this.lives = GameConfig.PLAYER_INITIAL_LIVES;
    this.scoreMilestoneForExtraLife = GameConfig.EXTRA_LIFE_SCORE;
  }

  getLives(): number {
    return this.lives;
  }

  loseLife(): boolean {
    this.lives--;
    this.notifyLivesListeners();
    if (this.lives <= 0) {
      this.notifyGameOverListeners();
      return false;
    }
    return true; // can respawn
  }

  checkExtraLife(score: number): void {
    const milestone = Math.floor(score / this.scoreMilestoneForExtraLife);
    if (milestone > this.extraLifeAwardedAt) {
      this.extraLifeAwardedAt = milestone;
      this.lives++;
      this.notifyLivesListeners();
    }
  }

  reset(): void {
    this.lives = GameConfig.PLAYER_INITIAL_LIVES;
    this.extraLifeAwardedAt = -1;
  }

  onLivesChange(callback: LivesChangeCallback): void {
    this.livesListeners.push(callback);
  }

  onGameOver(callback: GameOverCallback): void {
    this.gameOverListeners.push(callback);
  }

  private notifyLivesListeners(): void {
    for (const listener of this.livesListeners) {
      listener(this.lives);
    }
  }

  private notifyGameOverListeners(): void {
    for (const listener of this.gameOverListeners) {
      listener();
    }
  }
}
