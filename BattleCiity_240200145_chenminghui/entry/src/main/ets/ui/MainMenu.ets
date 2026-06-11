export interface MainMenuCallbacks {
  onNewGame: () => void;
  onContinue: () => void;
  onSettings: () => void;
}

@Component
export struct MainMenu {
  @Prop hasSaveData: boolean = false;
  onNewGame?: () => void;
  onContinue?: () => void;
  onSettings?: () => void;

  build() {
    Column() {
      // Title
      Text($r('app.string.game_title'))
        .fontSize($r('app.float.menu_title_font_size'))
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFD700')
        .margin({ bottom: 50 })
        .textShadow({ radius: 4, color: '#FF660088', offsetX: 0, offsetY: 0 })

      // New Game button
      Button($r('app.string.new_game'))
        .fontSize($r('app.float.menu_button_font_size'))
        .width('60%')
        .height(50)
        .backgroundColor('#16213E')
        .fontColor('#FFFFFF')
        .margin({ bottom: 16 })
        .borderRadius(8)
        .onClick(() => {
          if (this.onNewGame) this.onNewGame();
        })

      // Continue button (only if save data exists)
      if (this.hasSaveData) {
        Button($r('app.string.continue_game'))
          .fontSize($r('app.float.menu_button_font_size'))
          .width('60%')
          .height(50)
          .backgroundColor('#16213E')
          .fontColor('#FFFFFF')
          .margin({ bottom: 16 })
          .borderRadius(8)
          .onClick(() => {
            if (this.onContinue) this.onContinue();
          })
      }

      // Settings button
      Button($r('app.string.settings'))
        .fontSize($r('app.float.menu_button_font_size'))
        .width('60%')
        .height(50)
        .backgroundColor('#16213E')
        .fontColor('#FFFFFF')
        .margin({ bottom: 16 })
        .borderRadius(8)
        .onClick(() => {
          if (this.onSettings) this.onSettings();
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#1A1A2E')
  }
}
