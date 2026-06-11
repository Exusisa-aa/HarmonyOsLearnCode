export enum GameState {
  STARTUP,
  MENU,
  LOADING,
  PLAYING,
  PAUSED,
  LEVEL_COMPLETE,
  GAME_OVER
}

export class GameStateMachine {
  private current: GameState = GameState.STARTUP;
  private previous: GameState = GameState.STARTUP;
  private listeners: Map<GameState, Array<() => void>> = new Map();

  get state(): GameState { return this.current; }
  get prevState(): GameState { return this.previous; }

  onEnter(state: GameState, callback: () => void): void {
    let list = this.listeners.get(state);
    if (!list) {
      list = [];
      this.listeners.set(state, list);
    }
    list.push(callback);
  }

  transition(newState: GameState): void {
    if (newState === this.current) return;
    this.previous = this.current;
    this.current = newState;
    const callbacks = this.listeners.get(newState);
    if (callbacks) {
      callbacks.forEach(cb => cb());
    }
  }

  is(state: GameState): boolean { return this.current === state; }
}
