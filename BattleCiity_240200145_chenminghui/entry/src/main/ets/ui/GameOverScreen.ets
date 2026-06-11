@Component
export struct GameOverScreen {
  @Prop finalScore: number = 0;
  @Prop enemiesDestroyed: number = 0;
  @Prop levelReached: number = 1;
  @Prop victory: boolean = false;
  onRestart?: () => void;
  onMainMenu?: () => void;

  build() {
    Column() {
      Text(this.victory ? $r('app.string.level_complete') : $r('app.string.game_over'))
        .fontSize($r('app.float.game_over_font_size'))
        .fontWeight(FontWeight.Bold)
        .fontColor(this.victory ? '#FFD700' : '#FF4444')
        .margin({ bottom: 30 })

      // Stats
      Column() {
        Row() {
          Text($r('app.string.score_label') + ': ')
            .fontSize($r('app.float.hud_large_font_size'))
            .fontColor('#888888')
          Text(this.finalScore.toString())
            .fontSize($r('app.float.hud_large_font_size'))
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
        }
        .margin({ bottom: 8 })

        Row() {
          Text($r('app.string.enemies_destroyed') + ': ')
            .fontSize($r('app.float.hud_font_size'))
            .fontColor('#888888')
          Text(this.enemiesDestroyed.toString())
            .fontSize($r('app.float.hud_font_size'))
            .fontColor('#FFFFFF')
        }
        .margin({ bottom: 8 })

        Row() {
          Text($r('app.string.level_label') + ': ')
            .fontSize($r('app.float.hud_font_size'))
            .fontColor('#888888')
          Text(this.levelReached.toString())
            .fontSize($r('app.float.hud_font_size'))
            .fontColor('#FFFFFF')
        }
      }
      .margin({ bottom: 40 })
      .alignItems(HorizontalAlign.Start)

      // Buttons
      Button($r('app.string.restart_game'))
        .fontSize($r('app.float.menu_button_font_size'))
        .width('60%')
        .height(46)
        .backgroundColor('#16213E')
        .fontColor('#FFFFFF')
        .margin({ bottom: 12 })
        .borderRadius(8)
        .onClick(() => { if (this.onRestart) this.onRestart(); })

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
    .backgroundColor('#1A1A2ECC')
  }
}
