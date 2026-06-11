import { GameState } from '../../common/Constants';
import { GameStateManager } from './GameStateManager';
import { GameLoop } from './GameLoop';
import { ResourceManager } from './ResourceManager';

export class GameWorld {
  private canvasCtx: CanvasRenderingContext2D;
  private stateManager: GameStateManager;
  private gameLoop: GameLoop;
  private resourceManager: ResourceManager;
  private destroyed: boolean = false;

  constructor(ctx: CanvasRenderingContext2D) {
    this.canvasCtx = ctx;
    this.stateManager = GameStateManager.getInstance();
    this.gameLoop = new GameLoop();
    this.resourceManager = ResourceManager.getInstance();
  }

  async start(): Promise<void> {
    this.stateManager.setState(GameState.INIT);

    // Load resources
    await this.resourceManager.preloadAll();

    // Set up game loop
    this.gameLoop.setUpdateCallback((dt: number) => {
      this.update(dt);
      this.render();
    });

    // Transition to running
    this.stateManager.setState(GameState.RUNNING);
    this.gameLoop.start();
  }

  pause(): void {
    if (this.stateManager.isRunning()) {
      this.stateManager.setState(GameState.PAUSED);
      this.gameLoop.stop();
    }
  }

  resume(): void {
    if (this.stateManager.isPaused()) {
      this.stateManager.setState(GameState.RUNNING);
      this.gameLoop.start();
    }
  }

  private update(_deltaTimeMs: number): void {
    if (!this.stateManager.isRunning()) {
      return;
    }
    // Entity updates, collision detection, AI, etc. will be wired here
  }

  private render(): void {
    const ctx = this.canvasCtx;
    // Clear screen
    ctx.fillStyle = '#000000';
    ctx.fillRect(0, 0, ctx.width, ctx.height);
    // Entity rendering will be wired here
  }

  destroy(): void {
    this.destroyed = true;
    this.gameLoop.stop();
    this.resourceManager.releaseResources();
    GameStateManager.resetInstance();
    ResourceManager.resetInstance();
  }
}
