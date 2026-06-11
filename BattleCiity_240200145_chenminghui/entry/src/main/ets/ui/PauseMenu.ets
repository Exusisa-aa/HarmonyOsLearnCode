@Component
export struct PauseMenu {
  onResume?: () => void;
  onRestart?: () => void;
  onSaveGame?: () => void;
  onMainMenu?: () => void;

  build() {
    Column() {
      Text('PAUSED')
        .fontSize($r('app.float.game_over_font_size'))
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFD700')
        .margin({ bottom: 30 })

      Button($r('app.string.resume_game'))
        .fontSize($r('app.float.menu_button_font_size'))
        .width('60%')
        .height(46)
        .backgroundColor('#16213E')
        .fontColor('#FFFFFF')
        .margin({ bottom: 12 })
        .borderRadius(8)
        .onClick(() => { if (this.onResume) this.onResume(); })

      Button($r('app.string.restart_game'))
        .fontSize($r('app.float.menu_button_font_size'))
        .width('60%')
        .height(46)
        .backgroundColor('#16213E')
        .fontColor('#FFFFFF')
        .margin({ bottom: 12 })
        .borderRadius(8)
        .onClick(() => { if (this.onRestart) this.onRestart(); })

      Button($r('app.string.save_game'))
        .fontSize($r('app.float.menu_button_font_size'))
        .width('60%')
        .height(46)
        .backgroundColor('#16213E')
        .fontColor('#FFFFFF')
        .margin({ bottom: 12 })
        .borderRadius(8)
        .onClick(() => { if (this.onSaveGame) this.onSaveGame(); })

      Button($r('app.string.main_menu'))
        .fontSize($r('app.float.menu_button_font_size'))
        .width('60%')
        .height(46)
        .backgroundColor('#16213E')
        .fontColor('#FFFFFF')
        .margin({ bottom: 12 })
        .borderRadius(8)
        .onClick(() => { if (this.onMainMenu) this.onMainMenu(); })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#000000CC')
  }
}
