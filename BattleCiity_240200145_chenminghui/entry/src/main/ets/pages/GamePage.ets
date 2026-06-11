import { router } from '@kit.ArkUI';
import { GameWorld } from '../game/core/GameWorld';
import { GameStateManager } from '../game/core/GameStateManager';
import { GameState } from '../common/Constants';
import { GameHUD } from '../ui/GameHUD';
import { PauseMenu } from '../ui/PauseMenu';
import { GameOverScreen } from '../ui/GameOverScreen';
import { LevelTransition } from '../ui/LevelTransition';
import { VirtualJoystick, JoystickEvent } from '../ui/VirtualJoystick';
import { ShootButton } from '../ui/ShootButton';
import { InputManager } from '../game/systems/InputManager';
import { ActiveEffect } from '../game/systems/PowerUpManager';

interface PageParams {
  newGame: boolean;
  settings?: boolean;
}

@Entry
@Component
struct GamePage {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasCtx: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private gameWorld: GameWorld | null = null;
  private inputManager: InputManager = new InputManager();

  @State gameState: GameState = GameState.INIT;
  @State score: number = 0;
  @State lives: number = 3;
  @State level: number = 1;
  @State activeEffects: ActiveEffect[] = [];
  @State enemiesDestroyed: number = 0;
  @State showPause: boolean = false;
  @State showGameOver: boolean = false;
  @State showLevelTransition: boolean = false;
  @State fromLevel: number = 0;
  @State toLevel: number = 1;
  @State victory: boolean = false;

  // Joystick and shoot button state
  @State joystickEvent: JoystickEvent = { dx: 0, dy: 0, active: false };
  @State shootPressed: boolean = false;

  aboutToAppear(): void {
    const params = router.getParams() as PageParams;
    this.inputManager = new InputManager();

    // Listen to game state changes
    const stateManager = GameStateManager.getInstance();
    stateManager.onStateChange((from: GameState, to: GameState) => {
      this.gameState = to;
      if (to === GameState.GAME_OVER) {
        this.showGameOver = true;
        this.updateGameOverStats();
      } else if (to === GameState.LEVEL_COMPLETE) {
        this.showLevelTransition = true;
        this.fromLevel = this.level;
        this.toLevel = this.level + 1;
      } else if (to === GameState.PAUSED) {
        this.showPause = true;
      } else if (to === GameState.RUNNING) {
        this.showPause = false;
        this.showGameOver = false;
        this.showLevelTransition = false;
      }
    });
  }

  aboutToDisappear(): void {
    if (this.gameWorld) {
      this.gameWorld.destroy();
      this.gameWorld = null;
    }
  }

  private updateGameOverStats(): void {
    // Stats are updated via callbacks in GameWorld
  }

  build() {
    Stack() {
      // Game Canvas
      Canvas(this.canvasCtx)
        .width('100%')
        .height('100%')
        .onReady(() => {
          this.gameWorld = new GameWorld(this.canvasCtx);
          this.gameWorld.start();
        })

      // HUD overlay (top)
      Column() {
        GameHUD({
          score: this.score,
          lives: this.lives,
          level: this.level,
          activeEffects: this.activeEffects,
        })

        Blank()
      }
      .width('100%')
      .height('100%')
      .hitTestBehavior(HitTestMode.None)

      // Bottom controls
      Column() {
        Blank()

        Row() {
          // Virtual joystick (left side)
          VirtualJoystick({ joystickEvent: $joystickEvent })
            .margin({ left: 24, bottom: 32 })

          Blank()

          // Shoot button (right side)
          ShootButton({ shootPressed: $shootPressed })
            .margin({ right: 24, bottom: 32 })
        }
        .width('100%')

        // Pause button (top-right corner)
        Row() {
          Blank()
          Button('||')
            .width(40)
            .height(40)
            .fontSize(18)
            .backgroundColor('#33333388')
            .fontColor('#FFFFFF')
            .borderRadius(20)
            .margin({ top: 8, right: 12 })
            .onClick(() => {
              const sm = GameStateManager.getInstance();
              if (sm.isRunning()) {
                sm.setState(GameState.PAUSED);
              } else if (sm.isPaused()) {
                sm.setState(GameState.RUNNING);
              }
            })
        }
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .hitTestBehavior(HitTestMode.None)

      // Pause menu overlay
      if (this.showPause) {
        PauseMenu({
          onResume: () => {
            GameStateManager.getInstance().setState(GameState.RUNNING);
          },
          onRestart: () => {
            this.restartGame();
          },
          onSaveGame: () => {
            this.showPause = false;
            GameStateManager.getInstance().setState(GameState.RUNNING);
          },
          onMainMenu: () => {
            if (this.gameWorld) this.gameWorld.destroy();
            router.back();
          },
        })
      }

      // Game over overlay
      if (this.showGameOver) {
        GameOverScreen({
          finalScore: this.score,
          enemiesDestroyed: this.enemiesDestroyed,
          levelReached: this.level,
          victory: this.victory,
          onRestart: () => {
            this.restartGame();
          },
          onMainMenu: () => {
            if (this.gameWorld) this.gameWorld.destroy();
            router.back();
          },
        })
      }

      // Level transition overlay
      if (this.showLevelTransition) {
        LevelTransition({
          fromLevel: this.fromLevel,
          toLevel: this.toLevel,
          onComplete: () => {
            this.showLevelTransition = false;
            this.level = this.toLevel;
            GameStateManager.getInstance().setState(GameState.RUNNING);
          },
        })
      }
    }
    .width('100%')
    .height('100%')
  }

  private restartGame(): void {
    this.showGameOver = false;
    this.showPause = false;
    this.showLevelTransition = false;
    this.score = 0;
    this.lives = 3;
    this.level = 1;
    this.activeEffects = [];
    this.enemiesDestroyed = 0;

    if (this.gameWorld) {
      this.gameWorld.destroy();
    }
    this.gameWorld = new GameWorld(this.canvasCtx);
    this.gameWorld.start();
  }
}
