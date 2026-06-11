import { TankType } from '../../common/Constants';

export type ScoreChangeCallback = (newScore: number, addedAmount: number) => void;

export class ScoreManager {
  private score: number = 0;
  private listeners: ScoreChangeCallback[] = [];

  private static getScoreForTank(type: TankType): number {
    switch (type) {
      case TankType.PLAYER: return 0;
      case TankType.NORMAL: return 100;
      case TankType.FAST: return 200;
      case TankType.HEAVY: return 300;
    }
  }

  getScore(): number {
    return this.score;
  }

  addScore(tankType: TankType): void {
    const points = ScoreManager.getScoreForTank(tankType);
    this.score += points;
    this.notifyListeners(points);
  }

  reset(): void {
    this.score = 0;
  }

  onScoreChange(callback: ScoreChangeCallback): void {
    this.listeners.push(callback);
  }

  removeListener(callback: ScoreChangeCallback): void {
    const idx = this.listeners.indexOf(callback);
    if (idx >= 0) {
      this.listeners.splice(idx, 1);
    }
  }

  private notifyListeners(added: number): void {
    for (const listener of this.listeners) {
      listener(this.score, added);
    }
  }
}
