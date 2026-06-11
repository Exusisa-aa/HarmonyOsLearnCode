import { GameState } from '../../common/Constants';

type StateChangeCallback = (from: GameState, to: GameState) => void;

export class GameStateManager {
  private static instance: GameStateManager | null = null;

  private currentState: GameState = GameState.INIT;
  private previousState: GameState = GameState.INIT;
  private listeners: StateChangeCallback[] = [];

  private constructor() {}

  static getInstance(): GameStateManager {
    if (!GameStateManager.instance) {
      GameStateManager.instance = new GameStateManager();
    }
    return GameStateManager.instance;
  }

  static resetInstance(): void {
    GameStateManager.instance = null;
  }

  getState(): GameState {
    return this.currentState;
  }

  getPreviousState(): GameState {
    return this.previousState;
  }

  setState(newState: GameState): void {
    if (newState === this.currentState) {
      return;
    }
    this.previousState = this.currentState;
    this.currentState = newState;
    this.notifyListeners(this.previousState, newState);
  }

  isRunning(): boolean {
    return this.currentState === GameState.RUNNING;
  }

  isPaused(): boolean {
    return this.currentState === GameState.PAUSED;
  }

  isGameOver(): boolean {
    return this.currentState === GameState.GAME_OVER;
  }

  onStateChange(callback: StateChangeCallback): void {
    this.listeners.push(callback);
  }

  removeListener(callback: StateChangeCallback): void {
    const index = this.listeners.indexOf(callback);
    if (index >= 0) {
      this.listeners.splice(index, 1);
    }
  }

  private notifyListeners(from: GameState, to: GameState): void {
    for (const listener of this.listeners) {
      listener(from, to);
    }
  }
}
