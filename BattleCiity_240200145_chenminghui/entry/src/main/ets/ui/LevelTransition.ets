@Component
export struct LevelTransition {
  @Prop fromLevel: number = 0;
  @Prop toLevel: number = 1;
  @State displayText: string = '';
  @State alpha: number = 1;
  onComplete?: () => void;

  aboutToAppear(): void {
    this.displayText = 'Level ' + this.toLevel;
    this.runAnimation();
  }

  private runAnimation(): void {
    setTimeout(() => {
      this.alpha = 0;
      setTimeout(() => {
        if (this.onComplete) this.onComplete();
      }, 500);
    }, 1500);
  }

  build() {
    Column() {
      if (this.fromLevel > 0) {
        Text('Level ' + this.fromLevel + ' Complete!')
          .fontSize($r('app.float.hud_large_font_size'))
          .fontColor('#FFD700')
          .margin({ bottom: 16 })
      }

      Text(this.displayText)
        .fontSize($r('app.float.menu_title_font_size'))
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')
        .textShadow({ radius: 8, color: '#FFD70088', offsetX: 0, offsetY: 0 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#000000DD')
    .opacity(this.alpha)
    .animation({ duration: 500, curve: Curve.EaseInOut })
  }
}
