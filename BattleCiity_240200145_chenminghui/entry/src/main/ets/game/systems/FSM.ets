// Finite State Machine framework

export interface FSMState<T> {
  enter(context: T): void;
  update(context: T, deltaMs: number): void;
  exit(context: T): void;
  shouldTransition(context: T): string | null; // returns next state name or null
}

export class FSM<T> {
  private states: Map<string, FSMState<T>> = new Map();
  private currentStateName: string = '';
  private currentState: FSMState<T> | null = null;
  private context: T;

  constructor(context: T) {
    this.context = context;
  }

  addState(name: string, state: FSMState<T>): void {
    this.states.set(name, state);
  }

  setInitialState(name: string): void {
    const state = this.states.get(name);
    if (state) {
      this.currentStateName = name;
      this.currentState = state;
      state.enter(this.context);
    }
  }

  update(deltaMs: number): void {
    if (!this.currentState) return;

    this.currentState.update(this.context, deltaMs);
    const nextStateName = this.currentState.shouldTransition(this.context);
    if (nextStateName) {
      this.transitionTo(nextStateName);
    }
  }

  private transitionTo(name: string): void {
    if (this.currentState) {
      this.currentState.exit(this.context);
    }
    const nextState = this.states.get(name);
    if (nextState) {
      this.currentStateName = name;
      this.currentState = nextState;
      nextState.enter(this.context);
    }
  }

  getCurrentStateName(): string {
    return this.currentStateName;
  }
}
