import { GameStateMachine, GameState } from './GameState';

export class GameLoop {
  private timerId: number = -1;
  private lastTime: number = 0;
  private fixedDt: number = 1 / 60;
  private accumulator: number = 0;
  private maxFrameTime: number = 0.1;

  onUpdate: ((dt: number) => void) | null = null;
  onRender: (() => void) | null = null;

  get isRunning(): boolean { return this.timerId !== -1; }

  start(): void {
    if (this.isRunning) return;
    this.lastTime = Date.now();
    this.accumulator = 0;
    this.timerId = setInterval(() => {
      const now = Date.now();
      let frameTime = (now - this.lastTime) / 1000;
      if (frameTime > this.maxFrameTime) frameTime = this.maxFrameTime;
      this.lastTime = now;
      this.accumulator += frameTime;

      while (this.accumulator >= this.fixedDt) {
        if (this.onUpdate) this.onUpdate(this.fixedDt);
        this.accumulator -= this.fixedDt;
      }

      if (this.onRender) this.onRender();
    }, 16);
  }

  stop(): void {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
  }
}
