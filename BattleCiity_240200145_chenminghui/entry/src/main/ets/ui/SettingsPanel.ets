@Component
export struct SettingsPanel {
  @State volume: number = 80;
  @State sensitivity: number = 50;
  onClose?: () => void;

  build() {
    Column() {
      Text($r('app.string.settings'))
        .fontSize($r('app.float.menu_title_font_size'))
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFD700')
        .margin({ bottom: 30 })

      // Volume control
      Column() {
        Text($r('app.string.volume_label'))
          .fontSize($r('app.float.menu_button_font_size'))
          .fontColor('#FFFFFF')
          .margin({ bottom: 8 })

        Slider({
          value: this.volume,
          min: 0,
          max: 100,
          step: 1,
          style: SliderStyle.InSet,
        })
          .width('80%')
          .blockColor('#FFD700')
          .trackColor('#444444')
          .selectedColor('#FFD700')
          .onChange((value: number) => {
            this.volume = value;
          })
      }
      .margin({ bottom: 24 })

      // Sensitivity control
      Column() {
        Text($r('app.string.sensitivity_label'))
          .fontSize($r('app.float.menu_button_font_size'))
          .fontColor('#FFFFFF')
          .margin({ bottom: 8 })

        Slider({
          value: this.sensitivity,
          min: 10,
          max: 100,
          step: 1,
          style: SliderStyle.InSet,
        })
          .width('80%')
          .blockColor('#FFD700')
          .trackColor('#444444')
          .selectedColor('#FFD700')
          .onChange((value: number) => {
            this.sensitivity = value;
          })
      }
      .margin({ bottom: 30 })

      Button('Close')
        .fontSize($r('app.float.menu_button_font_size'))
        .width('40%')
        .height(46)
        .backgroundColor('#16213E')
        .fontColor('#FFFFFF')
        .borderRadius(8)
        .onClick(() => { if (this.onClose) this.onClose(); })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#1A1A2ECC')
  }
}
