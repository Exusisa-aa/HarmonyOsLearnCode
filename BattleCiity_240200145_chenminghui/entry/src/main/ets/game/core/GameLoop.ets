import { GameConfig } from '../../common/Constants';

type FrameCallback = (deltaTimeMs: number) => void;

export class GameLoop {
  private running: boolean = false;
  private lastTime: number = 0;
  private accumulatedTime: number = 0;
  private timerId: number = -1;
  private updateCallback: FrameCallback | null = null;

  setUpdateCallback(callback: FrameCallback): void {
    this.updateCallback = callback;
  }

  start(): void {
    if (this.running) {
      return;
    }
    this.running = true;
    this.lastTime = Date.now();
    this.accumulatedTime = 0;
    this.scheduleNext();
  }

  stop(): void {
    this.running = false;
    if (this.timerId >= 0) {
      clearTimeout(this.timerId);
      this.timerId = -1;
    }
  }

  private scheduleNext(): void {
    this.timerId = setTimeout(() => {
      this.tick();
      if (this.running) {
        this.scheduleNext();
      }
    }, 1); // schedule as soon as possible, tick controls rate
  }

  private tick(): void {
    if (!this.running) {
      return;
    }
    const now = Date.now();
    const elapsed = now - this.lastTime;
    this.lastTime = now;

    // Clamp to prevent spiral of death
    const clampedElapsed = Math.min(elapsed, 200);
    this.accumulatedTime += clampedElapsed;

    // Fixed timestep updates
    while (this.accumulatedTime >= GameConfig.FIXED_DT) {
      if (this.updateCallback) {
        this.updateCallback(GameConfig.FIXED_DT);
      }
      this.accumulatedTime -= GameConfig.FIXED_DT;
    }
  }
}
