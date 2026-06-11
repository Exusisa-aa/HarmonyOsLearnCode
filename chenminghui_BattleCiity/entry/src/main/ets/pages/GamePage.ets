import { GameController } from '../GameController';
import { GameState } from '../engine/GameState';
import { Direction } from '../entity/GameEntity';
import { ActiveEffectInfo } from '../util/Types';
import { CANVAS_WIDTH, CANVAS_HEIGHT, COLOR_BG } from '../util/Constants';
import { KeyCode } from '@ohos.multimodalInput.keyCode';

@Entry
@Component
struct GamePage {
  private controller: GameController = new GameController();
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasCtx: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private scaleX: number = 1;
  private scaleY: number = 1;

  @State currentState: string = 'STARTUP';
  @State score: number = 0;
  @State lives: number = 3;
  @State level: number = 1;
  @State highScore: number = 0;
  @State enemyCount: number = 0;
  @State activeEffects: ActiveEffectInfo[] = [];
  private lifeIndices: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8];

  private hudInterval: number = -1;

  aboutToAppear(): void {
    const ctx = getContext(this);
    this.controller.resourceMgr.init(ctx);
    this.controller.renderer.bindContext(this.canvasCtx);
    this.controller.onStateChange = (state: GameState) => {
      this.currentState = GameState[state];
    };
    this.controller.scoreMgr.init(ctx).then(() => {
      this.highScore = this.controller.scoreMgr.highScore;
      this.currentState = 'STARTUP';
    });
  }

  aboutToDisappear(): void {
    this.controller.gameLoop.stop();
    if (this.hudInterval !== -1) clearInterval(this.hudInterval);
  }

  startHUD(): void {
    if (this.hudInterval !== -1) clearInterval(this.hudInterval);
    this.hudInterval = setInterval(() => {
      this.score = this.controller.scoreMgr.score;
      this.lives = this.controller.scoreMgr.lives;
      this.level = this.controller.currentLevelNum;
      this.enemyCount = this.controller.remainingEnemies + this.controller.spawnQueue.length;
      this.activeEffects = this.controller.powerUpMgr.getActiveEffects();
    }, 100);
  }

  stopHUD(): void {
    if (this.hudInterval !== -1) {
      clearInterval(this.hudInterval);
      this.hudInterval = -1;
    }
  }

  async onMenuAction(action: string): Promise<void> {
    if (action === 'new') {
      await this.controller.startNewGame();
      this.startHUD();
    } else if (action === 'continue') {
      await this.controller.continueGame();
      this.startHUD();
    }
  }

  handleKeyDown(code: number): void {
    if (code === KeyCode.KEYCODE_DPAD_UP || code === KeyCode.KEYCODE_W) {
      this.controller.setDirection(Direction.UP);
    } else if (code === KeyCode.KEYCODE_DPAD_DOWN || code === KeyCode.KEYCODE_S) {
      this.controller.setDirection(Direction.DOWN);
    } else if (code === KeyCode.KEYCODE_DPAD_LEFT || code === KeyCode.KEYCODE_A) {
      this.controller.setDirection(Direction.LEFT);
    } else if (code === KeyCode.KEYCODE_DPAD_RIGHT || code === KeyCode.KEYCODE_D) {
      this.controller.setDirection(Direction.RIGHT);
    } else if (code === KeyCode.KEYCODE_SPACE) {
      this.controller.setShoot(true);
      if (this.currentState === 'MENU') this.onMenuAction('new');
      else if (this.currentState === 'GAME_OVER') this.onMenuAction('new');
    }
  }

  handleKeyUp(code: number): void {
    if (code === KeyCode.KEYCODE_DPAD_UP || code === KeyCode.KEYCODE_W) {
      if (this.controller.inputDirection === Direction.UP) this.controller.setDirection(null);
    } else if (code === KeyCode.KEYCODE_DPAD_DOWN || code === KeyCode.KEYCODE_S) {
      if (this.controller.inputDirection === Direction.DOWN) this.controller.setDirection(null);
    } else if (code === KeyCode.KEYCODE_DPAD_LEFT || code === KeyCode.KEYCODE_A) {
      if (this.controller.inputDirection === Direction.LEFT) this.controller.setDirection(null);
    } else if (code === KeyCode.KEYCODE_DPAD_RIGHT || code === KeyCode.KEYCODE_D) {
      if (this.controller.inputDirection === Direction.RIGHT) this.controller.setDirection(null);
    } else if (code === KeyCode.KEYCODE_SPACE) {
      this.controller.setShoot(false);
    }
  }

  private getEffectIcon(type: number): string {
    if (type === 0) return 'S';
    if (type === 1) return 'D';
    if (type === 2) return 'P';
    return 'F';
  }

  handleTouchDir(dir: Direction): void { this.controller.setDirection(dir); }
  handleTouchDirUp(): void { this.controller.setDirection(null); }
  handleTouchShoot(): void {
    this.controller.setShoot(true);
    setTimeout(() => this.controller.setShoot(false), 100);
  }

  build() {
    Stack() {
      Column() {
        // HUD Bar
        if (this.currentState === 'PLAYING' || this.currentState === 'PAUSED') {
          Row() {
            Text('Stage ' + this.level.toString()).fontColor(Color.White).fontSize(14).margin({ left: 8 })
            Text(this.enemyCount.toString()).fontColor('#FF4444').fontSize(14).margin({ left: 8 })
            Text(this.score.toString()).fontColor('#FFD700').fontSize(14).margin({ left: 16 })
            Row() {
              ForEach(this.lifeIndices, (idx: number) => {
                if (idx < this.lives) {
                  Text('♥').fontColor('#FF0000').fontSize(14).margin({ left: 2 })
                }
              })
            }.margin({ left: 16 })
            ForEach(this.activeEffects, (effect: ActiveEffectInfo) => {
              Text(this.getEffectIcon(effect.type) + effect.remainingTime.toString() + 's')
                .fontSize(12).fontColor('#00FF00').margin({ left: 4 })
            })
            Blank()
          }
          .width('100%').height(32).backgroundColor('#333333')
          .justifyContent(FlexAlign.Start)
        }

        Stack() {
          Canvas(this.canvasCtx)
            .width('100%').height('100%')
            .onAreaChange((_old: Area, newVal: Area) => {
              const w: number = Number(newVal.width);
              const h: number = Number(newVal.height);
              if (w > 0 && h > 0) {
                this.scaleX = w / CANVAS_WIDTH;
                this.scaleY = h / CANVAS_HEIGHT;
                this.controller.renderer.setScale(this.scaleX, this.scaleY);
              }
            })

          if (this.currentState === 'STARTUP' || this.currentState === 'MENU') {
            this.MenuOverlay()
          }
          if (this.currentState === 'PAUSED') {
            this.PauseOverlay()
          }
          if (this.currentState === 'GAME_OVER') {
            this.GameOverOverlay()
          }
          if (this.currentState === 'LEVEL_COMPLETE') {
            this.LevelCompleteOverlay()
          }
        }

        if (this.currentState === 'PLAYING') {
          this.TouchControls()
        }
      }
    }
    .width('100%').height('100%').backgroundColor(COLOR_BG)
    .focusable(true).defaultFocus(true)
    .onKeyEvent((event: KeyEvent) => {
      if (event.type === KeyType.Down) this.handleKeyDown(event.keyCode);
      else if (event.type === KeyType.Up) this.handleKeyUp(event.keyCode);
    })
  }

  @Builder MenuOverlay() {
    Column() {
      Row() {
        Text('I-    00').fontSize(24).fontColor(Color.White).fontFamily('monospace').fontWeight(FontWeight.Bold)
        Text('HI- ' + this.highScore.toString()).fontSize(24).fontColor(Color.White).fontFamily('monospace').fontWeight(FontWeight.Bold).margin({ left: 40 })
      }.width('100%').justifyContent(FlexAlign.Center).margin({ top: 60, bottom: 80 })

      Column() {
        Text('BATTLE').fontSize(64).fontColor('#E05000').fontFamily('monospace').fontWeight(FontWeight.Bolder)
          .textShadow({ radius: 2, color: Color.White, offsetX: 2, offsetY: 2 })
        Text('CITY').fontSize(64).fontColor('#E05000').fontFamily('monospace').fontWeight(FontWeight.Bolder)
          .textShadow({ radius: 2, color: Color.White, offsetX: 2, offsetY: 2 })
      }.margin({ bottom: 50 })

      Column() {
        Row() {
          Text('►').fontSize(20).fontColor('#FFD700').margin({ right: 12 })
          Text('1 PLAYER').fontSize(20).fontColor(Color.White).fontFamily('monospace').fontWeight(FontWeight.Bold)
        }.margin({ bottom: 12 }).onClick(() => this.onMenuAction('new'))

        Text('  CONSTRUCTION').fontSize(20).fontColor('#888888').fontFamily('monospace').fontWeight(FontWeight.Bold).margin({ bottom: 30 })
        Text('PRESS SPACE').fontSize(18).fontColor('#FFD700').fontFamily('monospace').fontWeight(FontWeight.Bold)
      }.alignItems(HorizontalAlign.Start).margin({ bottom: 50 })

      Column() {
        Text('namcot').fontSize(26).fontColor('#E05000').fontFamily('monospace').fontWeight(FontWeight.Bold).margin({ bottom: 12 })
        Text('© 1980 1985 NAMCO LTD.').fontSize(16).fontColor(Color.White).fontFamily('monospace')
        Text('ALL RIGHTS RESERVED').fontSize(16).fontColor(Color.White).fontFamily('monospace')
      }.alignItems(HorizontalAlign.Center)
    }
    .width('100%').height('100%').backgroundColor('#000000').justifyContent(FlexAlign.Start)
  }

  @Builder PauseOverlay() {
    Column() {
      Text('PAUSED').fontSize(48).fontColor('#FFD700').fontFamily('monospace').fontWeight(FontWeight.Bold).margin({ bottom: 40 })
      Button('CONTINUE').fontSize(20).fontColor(Color.White).backgroundColor('#444444')
        .margin({ bottom: 16 }).onClick(() => this.controller.resume())
      Button('RESTART').fontSize(20).fontColor(Color.White).backgroundColor('#444444')
        .margin({ bottom: 16 }).onClick(() => { this.controller.restartLevel(); this.startHUD(); })
      Button('MAIN MENU').fontSize(20).fontColor(Color.White).backgroundColor('#444444')
        .onClick(() => { this.controller.gameLoop.stop(); this.stopHUD(); this.currentState = 'MENU'; })
    }
    .width('100%').height('100%').backgroundColor('rgba(0,0,0,0.85)').justifyContent(FlexAlign.Center)
  }

  @Builder GameOverOverlay() {
    Column() {
      Text('GAME OVER').fontSize(48).fontColor(Color.Red).fontFamily('monospace').fontWeight(FontWeight.Bold).margin({ bottom: 16 })
      Text('SCORE: ' + this.controller.scoreMgr.score.toString()).fontSize(24).fontColor(Color.White).fontFamily('monospace').margin({ bottom: 8 })
      if (this.controller.scoreMgr.highScore > 0 && this.controller.scoreMgr.score >= this.controller.scoreMgr.highScore) {
        Text('NEW HIGH SCORE!').fontSize(20).fontColor('#FFD700').fontFamily('monospace').margin({ bottom: 30 })
      }
      Button('TRY AGAIN').fontSize(20).fontColor(Color.White).backgroundColor('#444444')
        .margin({ bottom: 16 }).onClick(() => this.onMenuAction('new'))
      Button('MAIN MENU').fontSize(20).fontColor(Color.White).backgroundColor('#444444')
        .onClick(() => { this.stopHUD(); this.currentState = 'MENU'; })
    }
    .width('100%').height('100%').backgroundColor('rgba(0,0,0,0.85)').justifyContent(FlexAlign.Center)
  }

  @Builder LevelCompleteOverlay() {
    Column() {
      Text('STAGE ' + this.controller.currentLevelNum.toString() + ' CLEAR!').fontSize(36).fontColor('#FFD700').fontFamily('monospace').fontWeight(FontWeight.Bold).margin({ bottom: 10 })
      Text('SCORE: ' + this.controller.scoreMgr.score.toString()).fontSize(20).fontColor(Color.White).fontFamily('monospace')
    }
    .width('100%').height('100%').backgroundColor('rgba(0,0,0,0.7)').justifyContent(FlexAlign.Center)
    .onAppear(() => {
      setTimeout(() => {
        if (this.controller.currentLevelNum <= 10) {
          this.controller.nextLevel();
          this.startHUD();
        } else {
          this.currentState = 'GAME_OVER';
        }
      }, 2000);
    })
  }

  @Builder TouchControls() {
    Row() {
      Column() {
        Button('▲').fontSize(16).width(48).height(40).backgroundColor('#666666')
          .onTouch((e: TouchEvent) => {
            if (e.type === TouchType.Down) this.handleTouchDir(Direction.UP);
            else this.handleTouchDirUp();
          })
        Row() {
          Button('◄').fontSize(16).width(48).height(40).backgroundColor('#666666')
            .onTouch((e: TouchEvent) => {
              if (e.type === TouchType.Down) this.handleTouchDir(Direction.LEFT);
              else this.handleTouchDirUp();
            })
          Button('►').fontSize(16).width(48).height(40).backgroundColor('#666666')
            .onTouch((e: TouchEvent) => {
              if (e.type === TouchType.Down) this.handleTouchDir(Direction.RIGHT);
              else this.handleTouchDirUp();
            })
        }
        Button('▼').fontSize(16).width(48).height(40).backgroundColor('#666666')
          .onTouch((e: TouchEvent) => {
            if (e.type === TouchType.Down) this.handleTouchDir(Direction.DOWN);
            else this.handleTouchDirUp();
          })
      }.margin({ left: 16 })

      Blank()

      Button('| |').fontSize(14).width(40).height(40).backgroundColor('#555555')
        .onClick(() => this.controller.pause())

      Blank()

      Button('A').fontSize(18).width(56).height(56).backgroundColor('#CC3300').borderRadius(28)
        .margin({ right: 20, bottom: 10 })
        .onTouch((e: TouchEvent) => {
          if (e.type === TouchType.Down) this.controller.setShoot(true);
          else this.controller.setShoot(false);
        })
    }
    .width('100%').height(72).backgroundColor('#222222')
    .position({ x: 0, y: 'calc(100% - 72px)' })
  }
}
