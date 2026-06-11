import { router } from '@kit.ArkUI';
import { MainMenu } from '../ui/MainMenu';
import { SaveManager } from '../game/systems/SaveManager';

@Entry
@Component
struct Index {
  @State hasSaveData: boolean = false;

  aboutToAppear(): void {
    this.checkSaveData();
  }

  async checkSaveData(): Promise<void> {
    try {
      const saveManager = SaveManager.getInstance();
      const ctx = getContext(this);
      if (ctx) {
        this.hasSaveData = await saveManager.hasSaveData(ctx);
      }
    } catch (_e) {
      this.hasSaveData = false;
    }
  }

  build() {
    Column() {
      MainMenu({
        hasSaveData: this.hasSaveData,
        onNewGame: () => {
          router.pushUrl({ url: 'pages/GamePage', params: { newGame: true } });
        },
        onContinue: () => {
          router.pushUrl({ url: 'pages/GamePage', params: { newGame: false } });
        },
        onSettings: () => {
          router.pushUrl({ url: 'pages/GamePage', params: { settings: true } });
        },
      })
    }
    .width('100%')
    .height('100%')
  }
}
