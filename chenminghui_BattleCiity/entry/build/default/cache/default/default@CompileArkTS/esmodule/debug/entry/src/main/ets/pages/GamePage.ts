if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface GamePage_Params {
    controller?: GameController;
    settings?: RenderingContextSettings;
    canvasCtx?: CanvasRenderingContext2D;
    scaleX?: number;
    scaleY?: number;
    currentState?: string;
    score?: number;
    lives?: number;
    level?: number;
    highScore?: number;
    enemyCount?: number;
    activeEffects?: ActiveEffectInfo[];
    lifeIndices?: number[];
    hudInterval?: number;
}
import { GameController } from "@bundle:com.example.battlecity/entry/ets/GameController";
import { GameState } from "@bundle:com.example.battlecity/entry/ets/engine/GameState";
import { Direction } from "@bundle:com.example.battlecity/entry/ets/entity/GameEntity";
import type { ActiveEffectInfo } from '../util/Types';
import { CANVAS_WIDTH, CANVAS_HEIGHT, COLOR_BG } from "@bundle:com.example.battlecity/entry/ets/util/Constants";
import { KeyCode } from "@ohos:multimodalInput.keyCode";
class GamePage extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.controller = new GameController();
        this.settings = new RenderingContextSettings(true);
        this.canvasCtx = new CanvasRenderingContext2D(this.settings);
        this.scaleX = 1;
        this.scaleY = 1;
        this.__currentState = new ObservedPropertySimplePU('STARTUP', this, "currentState");
        this.__score = new ObservedPropertySimplePU(0, this, "score");
        this.__lives = new ObservedPropertySimplePU(3, this, "lives");
        this.__level = new ObservedPropertySimplePU(1, this, "level");
        this.__highScore = new ObservedPropertySimplePU(0, this, "highScore");
        this.__enemyCount = new ObservedPropertySimplePU(0, this, "enemyCount");
        this.__activeEffects = new ObservedPropertyObjectPU([], this, "activeEffects");
        this.lifeIndices = [0, 1, 2, 3, 4, 5, 6, 7, 8];
        this.hudInterval = -1;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: GamePage_Params) {
        if (params.controller !== undefined) {
            this.controller = params.controller;
        }
        if (params.settings !== undefined) {
            this.settings = params.settings;
        }
        if (params.canvasCtx !== undefined) {
            this.canvasCtx = params.canvasCtx;
        }
        if (params.scaleX !== undefined) {
            this.scaleX = params.scaleX;
        }
        if (params.scaleY !== undefined) {
            this.scaleY = params.scaleY;
        }
        if (params.currentState !== undefined) {
            this.currentState = params.currentState;
        }
        if (params.score !== undefined) {
            this.score = params.score;
        }
        if (params.lives !== undefined) {
            this.lives = params.lives;
        }
        if (params.level !== undefined) {
            this.level = params.level;
        }
        if (params.highScore !== undefined) {
            this.highScore = params.highScore;
        }
        if (params.enemyCount !== undefined) {
            this.enemyCount = params.enemyCount;
        }
        if (params.activeEffects !== undefined) {
            this.activeEffects = params.activeEffects;
        }
        if (params.lifeIndices !== undefined) {
            this.lifeIndices = params.lifeIndices;
        }
        if (params.hudInterval !== undefined) {
            this.hudInterval = params.hudInterval;
        }
    }
    updateStateVars(params: GamePage_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__currentState.purgeDependencyOnElmtId(rmElmtId);
        this.__score.purgeDependencyOnElmtId(rmElmtId);
        this.__lives.purgeDependencyOnElmtId(rmElmtId);
        this.__level.purgeDependencyOnElmtId(rmElmtId);
        this.__highScore.purgeDependencyOnElmtId(rmElmtId);
        this.__enemyCount.purgeDependencyOnElmtId(rmElmtId);
        this.__activeEffects.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__currentState.aboutToBeDeleted();
        this.__score.aboutToBeDeleted();
        this.__lives.aboutToBeDeleted();
        this.__level.aboutToBeDeleted();
        this.__highScore.aboutToBeDeleted();
        this.__enemyCount.aboutToBeDeleted();
        this.__activeEffects.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private controller: GameController;
    private settings: RenderingContextSettings;
    private canvasCtx: CanvasRenderingContext2D;
    private scaleX: number;
    private scaleY: number;
    private __currentState: ObservedPropertySimplePU<string>;
    get currentState() {
        return this.__currentState.get();
    }
    set currentState(newValue: string) {
        this.__currentState.set(newValue);
    }
    private __score: ObservedPropertySimplePU<number>;
    get score() {
        return this.__score.get();
    }
    set score(newValue: number) {
        this.__score.set(newValue);
    }
    private __lives: ObservedPropertySimplePU<number>;
    get lives() {
        return this.__lives.get();
    }
    set lives(newValue: number) {
        this.__lives.set(newValue);
    }
    private __level: ObservedPropertySimplePU<number>;
    get level() {
        return this.__level.get();
    }
    set level(newValue: number) {
        this.__level.set(newValue);
    }
    private __highScore: ObservedPropertySimplePU<number>;
    get highScore() {
        return this.__highScore.get();
    }
    set highScore(newValue: number) {
        this.__highScore.set(newValue);
    }
    private __enemyCount: ObservedPropertySimplePU<number>;
    get enemyCount() {
        return this.__enemyCount.get();
    }
    set enemyCount(newValue: number) {
        this.__enemyCount.set(newValue);
    }
    private __activeEffects: ObservedPropertyObjectPU<ActiveEffectInfo[]>;
    get activeEffects() {
        return this.__activeEffects.get();
    }
    set activeEffects(newValue: ActiveEffectInfo[]) {
        this.__activeEffects.set(newValue);
    }
    private lifeIndices: number[];
    private hudInterval: number;
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
        if (this.hudInterval !== -1)
            clearInterval(this.hudInterval);
    }
    startHUD(): void {
        if (this.hudInterval !== -1)
            clearInterval(this.hudInterval);
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
        }
        else if (action === 'continue') {
            await this.controller.continueGame();
            this.startHUD();
        }
    }
    handleKeyDown(code: number): void {
        if (code === KeyCode.KEYCODE_DPAD_UP || code === KeyCode.KEYCODE_W) {
            this.controller.setDirection(Direction.UP);
        }
        else if (code === KeyCode.KEYCODE_DPAD_DOWN || code === KeyCode.KEYCODE_S) {
            this.controller.setDirection(Direction.DOWN);
        }
        else if (code === KeyCode.KEYCODE_DPAD_LEFT || code === KeyCode.KEYCODE_A) {
            this.controller.setDirection(Direction.LEFT);
        }
        else if (code === KeyCode.KEYCODE_DPAD_RIGHT || code === KeyCode.KEYCODE_D) {
            this.controller.setDirection(Direction.RIGHT);
        }
        else if (code === KeyCode.KEYCODE_SPACE) {
            this.controller.setShoot(true);
            if (this.currentState === 'MENU')
                this.onMenuAction('new');
            else if (this.currentState === 'GAME_OVER')
                this.onMenuAction('new');
        }
    }
    handleKeyUp(code: number): void {
        if (code === KeyCode.KEYCODE_DPAD_UP || code === KeyCode.KEYCODE_W) {
            if (this.controller.inputDirection === Direction.UP)
                this.controller.setDirection(null);
        }
        else if (code === KeyCode.KEYCODE_DPAD_DOWN || code === KeyCode.KEYCODE_S) {
            if (this.controller.inputDirection === Direction.DOWN)
                this.controller.setDirection(null);
        }
        else if (code === KeyCode.KEYCODE_DPAD_LEFT || code === KeyCode.KEYCODE_A) {
            if (this.controller.inputDirection === Direction.LEFT)
                this.controller.setDirection(null);
        }
        else if (code === KeyCode.KEYCODE_DPAD_RIGHT || code === KeyCode.KEYCODE_D) {
            if (this.controller.inputDirection === Direction.RIGHT)
                this.controller.setDirection(null);
        }
        else if (code === KeyCode.KEYCODE_SPACE) {
            this.controller.setShoot(false);
        }
    }
    private getEffectIcon(type: number): string {
        if (type === 0)
            return 'S';
        if (type === 1)
            return 'D';
        if (type === 2)
            return 'P';
        return 'F';
    }
    handleTouchDir(dir: Direction): void { this.controller.setDirection(dir); }
    handleTouchDirUp(): void { this.controller.setDirection(null); }
    handleTouchShoot(): void {
        this.controller.setShoot(true);
        setTimeout(() => this.controller.setShoot(false), 100);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create();
            Stack.width('100%');
            Stack.height('100%');
            Stack.backgroundColor(COLOR_BG);
            Stack.focusable(true);
            Stack.defaultFocus(true);
            Stack.onKeyEvent((event: KeyEvent) => {
                if (event.type === KeyType.Down)
                    this.handleKeyDown(event.keyCode);
                else if (event.type === KeyType.Up)
                    this.handleKeyUp(event.keyCode);
            });
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            // HUD Bar
            if (this.currentState === 'PLAYING' || this.currentState === 'PAUSED') {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Row.create();
                        Row.width('100%');
                        Row.height(32);
                        Row.backgroundColor('#333333');
                        Row.justifyContent(FlexAlign.Start);
                    }, Row);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('Stage ' + this.level.toString());
                        Text.fontColor(Color.White);
                        Text.fontSize(14);
                        Text.margin({ left: 8 });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(this.enemyCount.toString());
                        Text.fontColor('#FF4444');
                        Text.fontSize(14);
                        Text.margin({ left: 8 });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(this.score.toString());
                        Text.fontColor('#FFD700');
                        Text.fontSize(14);
                        Text.margin({ left: 16 });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Row.create();
                        Row.margin({ left: 16 });
                    }, Row);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        ForEach.create();
                        const forEachItemGenFunction = _item => {
                            const idx = _item;
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                If.create();
                                if (idx < this.lives) {
                                    this.ifElseBranchUpdateFunction(0, () => {
                                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                                            Text.create('♥');
                                            Text.fontColor('#FF0000');
                                            Text.fontSize(14);
                                            Text.margin({ left: 2 });
                                        }, Text);
                                        Text.pop();
                                    });
                                }
                                else {
                                    this.ifElseBranchUpdateFunction(1, () => {
                                    });
                                }
                            }, If);
                            If.pop();
                        };
                        this.forEachUpdateFunction(elmtId, this.lifeIndices, forEachItemGenFunction);
                    }, ForEach);
                    ForEach.pop();
                    Row.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        ForEach.create();
                        const forEachItemGenFunction = _item => {
                            const effect = _item;
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                Text.create(this.getEffectIcon(effect.type) + effect.remainingTime.toString() + 's');
                                Text.fontSize(12);
                                Text.fontColor('#00FF00');
                                Text.margin({ left: 4 });
                            }, Text);
                            Text.pop();
                        };
                        this.forEachUpdateFunction(elmtId, this.activeEffects, forEachItemGenFunction);
                    }, ForEach);
                    ForEach.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Blank.create();
                    }, Blank);
                    Blank.pop();
                    Row.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create();
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Canvas.create(this.canvasCtx);
            Canvas.width('100%');
            Canvas.height('100%');
            Canvas.onAreaChange((_old: Area, newVal: Area) => {
                const w: number = Number(newVal.width);
                const h: number = Number(newVal.height);
                if (w > 0 && h > 0) {
                    this.scaleX = w / CANVAS_WIDTH;
                    this.scaleY = h / CANVAS_HEIGHT;
                    this.controller.renderer.setScale(this.scaleX, this.scaleY);
                }
            });
        }, Canvas);
        Canvas.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.currentState === 'STARTUP' || this.currentState === 'MENU') {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.MenuOverlay.bind(this)();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.currentState === 'PAUSED') {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.PauseOverlay.bind(this)();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.currentState === 'GAME_OVER') {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.GameOverOverlay.bind(this)();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.currentState === 'LEVEL_COMPLETE') {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.LevelCompleteOverlay.bind(this)();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        Stack.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.currentState === 'PLAYING') {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.TouchControls.bind(this)();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        Column.pop();
        Stack.pop();
    }
    MenuOverlay(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.height('100%');
            Column.backgroundColor('#000000');
            Column.justifyContent(FlexAlign.Start);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('100%');
            Row.justifyContent(FlexAlign.Center);
            Row.margin({ top: 60, bottom: 80 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('I-    00');
            Text.fontSize(24);
            Text.fontColor(Color.White);
            Text.fontFamily('monospace');
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('HI- ' + this.highScore.toString());
            Text.fontSize(24);
            Text.fontColor(Color.White);
            Text.fontFamily('monospace');
            Text.fontWeight(FontWeight.Bold);
            Text.margin({ left: 40 });
        }, Text);
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.margin({ bottom: 50 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('BATTLE');
            Text.fontSize(64);
            Text.fontColor('#E05000');
            Text.fontFamily('monospace');
            Text.fontWeight(FontWeight.Bolder);
            Text.textShadow({ radius: 2, color: Color.White, offsetX: 2, offsetY: 2 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('CITY');
            Text.fontSize(64);
            Text.fontColor('#E05000');
            Text.fontFamily('monospace');
            Text.fontWeight(FontWeight.Bolder);
            Text.textShadow({ radius: 2, color: Color.White, offsetX: 2, offsetY: 2 });
        }, Text);
        Text.pop();
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.alignItems(HorizontalAlign.Start);
            Column.margin({ bottom: 50 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.margin({ bottom: 12 });
            Row.onClick(() => this.onMenuAction('new'));
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('►');
            Text.fontSize(20);
            Text.fontColor('#FFD700');
            Text.margin({ right: 12 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('1 PLAYER');
            Text.fontSize(20);
            Text.fontColor(Color.White);
            Text.fontFamily('monospace');
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('  CONSTRUCTION');
            Text.fontSize(20);
            Text.fontColor('#888888');
            Text.fontFamily('monospace');
            Text.fontWeight(FontWeight.Bold);
            Text.margin({ bottom: 30 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('PRESS SPACE');
            Text.fontSize(18);
            Text.fontColor('#FFD700');
            Text.fontFamily('monospace');
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.alignItems(HorizontalAlign.Center);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('namcot');
            Text.fontSize(26);
            Text.fontColor('#E05000');
            Text.fontFamily('monospace');
            Text.fontWeight(FontWeight.Bold);
            Text.margin({ bottom: 12 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('© 1980 1985 NAMCO LTD.');
            Text.fontSize(16);
            Text.fontColor(Color.White);
            Text.fontFamily('monospace');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('ALL RIGHTS RESERVED');
            Text.fontSize(16);
            Text.fontColor(Color.White);
            Text.fontFamily('monospace');
        }, Text);
        Text.pop();
        Column.pop();
        Column.pop();
    }
    PauseOverlay(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.height('100%');
            Column.backgroundColor('rgba(0,0,0,0.85)');
            Column.justifyContent(FlexAlign.Center);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('PAUSED');
            Text.fontSize(48);
            Text.fontColor('#FFD700');
            Text.fontFamily('monospace');
            Text.fontWeight(FontWeight.Bold);
            Text.margin({ bottom: 40 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('CONTINUE');
            Button.fontSize(20);
            Button.fontColor(Color.White);
            Button.backgroundColor('#444444');
            Button.margin({ bottom: 16 });
            Button.onClick(() => this.controller.resume());
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('RESTART');
            Button.fontSize(20);
            Button.fontColor(Color.White);
            Button.backgroundColor('#444444');
            Button.margin({ bottom: 16 });
            Button.onClick(() => { this.controller.restartLevel(); this.startHUD(); });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('MAIN MENU');
            Button.fontSize(20);
            Button.fontColor(Color.White);
            Button.backgroundColor('#444444');
            Button.onClick(() => { this.controller.gameLoop.stop(); this.stopHUD(); this.currentState = 'MENU'; });
        }, Button);
        Button.pop();
        Column.pop();
    }
    GameOverOverlay(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.height('100%');
            Column.backgroundColor('rgba(0,0,0,0.85)');
            Column.justifyContent(FlexAlign.Center);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('GAME OVER');
            Text.fontSize(48);
            Text.fontColor(Color.Red);
            Text.fontFamily('monospace');
            Text.fontWeight(FontWeight.Bold);
            Text.margin({ bottom: 16 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('SCORE: ' + this.controller.scoreMgr.score.toString());
            Text.fontSize(24);
            Text.fontColor(Color.White);
            Text.fontFamily('monospace');
            Text.margin({ bottom: 8 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.controller.scoreMgr.highScore > 0 && this.controller.scoreMgr.score >= this.controller.scoreMgr.highScore) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('NEW HIGH SCORE!');
                        Text.fontSize(20);
                        Text.fontColor('#FFD700');
                        Text.fontFamily('monospace');
                        Text.margin({ bottom: 30 });
                    }, Text);
                    Text.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('TRY AGAIN');
            Button.fontSize(20);
            Button.fontColor(Color.White);
            Button.backgroundColor('#444444');
            Button.margin({ bottom: 16 });
            Button.onClick(() => this.onMenuAction('new'));
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('MAIN MENU');
            Button.fontSize(20);
            Button.fontColor(Color.White);
            Button.backgroundColor('#444444');
            Button.onClick(() => { this.stopHUD(); this.currentState = 'MENU'; });
        }, Button);
        Button.pop();
        Column.pop();
    }
    LevelCompleteOverlay(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.height('100%');
            Column.backgroundColor('rgba(0,0,0,0.7)');
            Column.justifyContent(FlexAlign.Center);
            Column.onAppear(() => {
                setTimeout(() => {
                    if (this.controller.currentLevelNum <= 10) {
                        this.controller.nextLevel();
                        this.startHUD();
                    }
                    else {
                        this.currentState = 'GAME_OVER';
                    }
                }, 2000);
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('STAGE ' + this.controller.currentLevelNum.toString() + ' CLEAR!');
            Text.fontSize(36);
            Text.fontColor('#FFD700');
            Text.fontFamily('monospace');
            Text.fontWeight(FontWeight.Bold);
            Text.margin({ bottom: 10 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('SCORE: ' + this.controller.scoreMgr.score.toString());
            Text.fontSize(20);
            Text.fontColor(Color.White);
            Text.fontFamily('monospace');
        }, Text);
        Text.pop();
        Column.pop();
    }
    TouchControls(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('100%');
            Row.height(72);
            Row.backgroundColor('#222222');
            Row.position({ x: 0, y: 'calc(100% - 72px)' });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.margin({ left: 16 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('▲');
            Button.fontSize(16);
            Button.width(48);
            Button.height(40);
            Button.backgroundColor('#666666');
            Button.onTouch((e: TouchEvent) => {
                if (e.type === TouchType.Down)
                    this.handleTouchDir(Direction.UP);
                else
                    this.handleTouchDirUp();
            });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('◄');
            Button.fontSize(16);
            Button.width(48);
            Button.height(40);
            Button.backgroundColor('#666666');
            Button.onTouch((e: TouchEvent) => {
                if (e.type === TouchType.Down)
                    this.handleTouchDir(Direction.LEFT);
                else
                    this.handleTouchDirUp();
            });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('►');
            Button.fontSize(16);
            Button.width(48);
            Button.height(40);
            Button.backgroundColor('#666666');
            Button.onTouch((e: TouchEvent) => {
                if (e.type === TouchType.Down)
                    this.handleTouchDir(Direction.RIGHT);
                else
                    this.handleTouchDirUp();
            });
        }, Button);
        Button.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('▼');
            Button.fontSize(16);
            Button.width(48);
            Button.height(40);
            Button.backgroundColor('#666666');
            Button.onTouch((e: TouchEvent) => {
                if (e.type === TouchType.Down)
                    this.handleTouchDir(Direction.DOWN);
                else
                    this.handleTouchDirUp();
            });
        }, Button);
        Button.pop();
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('| |');
            Button.fontSize(14);
            Button.width(40);
            Button.height(40);
            Button.backgroundColor('#555555');
            Button.onClick(() => this.controller.pause());
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('A');
            Button.fontSize(18);
            Button.width(56);
            Button.height(56);
            Button.backgroundColor('#CC3300');
            Button.borderRadius(28);
            Button.margin({ right: 20, bottom: 10 });
            Button.onTouch((e: TouchEvent) => {
                if (e.type === TouchType.Down)
                    this.controller.setShoot(true);
                else
                    this.controller.setShoot(false);
            });
        }, Button);
        Button.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "GamePage";
    }
}
registerNamedRoute(() => new GamePage(undefined, {}), "", { bundleName: "com.example.battlecity", moduleName: "entry", pagePath: "pages/GamePage", pageFullPath: "entry/src/main/ets/pages/GamePage", integratedHsp: "false", moduleType: "followWithHap" });
