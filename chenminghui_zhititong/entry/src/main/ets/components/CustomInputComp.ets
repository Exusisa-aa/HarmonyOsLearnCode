import { Constants } from '../common/Constants'

@Component
export struct CustomInputComp {
  // 组件属性
  @Prop text: string = ''
  placeholder: ResourceStr | string = ''
  icon: ResourceStr = ''
  type: InputType = InputType.Normal
  enabled: boolean = true
  clearButtonMode: boolean = false

  // 回调函数
  onChange?: (value: string) => void
  onSubmit?: (value: string) => void

  // 内部状态
  @State isFocused: boolean = false
  @State showClearButton: boolean = false

  build() {
    Row() {
      // 显示前缀图标
      if (this.icon) {
        Image(this.icon)
          .width(Constants.PREFIX_ICON_WIDTH)
          .height(Constants.PREFIX_ICON_WIDTH)
          .opacity(this.enabled ? Constants.OPACITY_NORMAL : Constants.OPACITY_DISABLED)
          .margin({ right: Constants.SMALL_SPACE })
      }

      // 输入框
      TextInput({
        text: this.text,
        placeholder: this.placeholder
      })
        .type(this.type)
        .maxLength(Constants.LOGIN_INPUT_MAX_LEN)
        .showPasswordIcon(this.type === InputType.Password)
        .backgroundColor(Color.Transparent)
        .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
        .fontColor(this.enabled ? Constants.TEXT_PRIMARY : Constants.TEXT_HINT)
        .placeholderColor(Constants.TEXT_HINT)
        .enabled(this.enabled)
        .layoutWeight(1)
        .onChange((value: string) => {
          this.text = value
          this.showClearButton = this.clearButtonMode && value.length > 0
          if (this.onChange) {
            this.onChange(value)
          }
        })
        .onSubmit((enterKey: EnterKeyType) => {
          if (this.onSubmit) {
            this.onSubmit(this.text)
          }
        })
        .onFocus(() => {
          this.isFocused = true
        })
        .onBlur(() => {
          this.isFocused = false
        })

      // 清除按钮
      if (this.showClearButton && this.enabled) {
        Image($r('sys.media.ohos_ic_public_cancel'))
          .width(16)
          .height(16)
          .fillColor(Constants.TEXT_HINT)
          .onClick(() => {
            this.text = ''
            this.showClearButton = false
            if (this.onChange) {
              this.onChange('')
            }
          })
          .margin({ left: Constants.SMALL_SPACE })
      }
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.INPUT_HEIGHT)
    .backgroundColor(this.enabled ? Constants.LIGHT_GRAY : Constants.BG_GRAY)
    .borderRadius(Constants.BORDER_RADIUS_CIRCLE)
    .padding({
      left: Constants.SPACE_SIZE,
      right: this.showClearButton ? Constants.SMALL_SPACE : Constants.SPACE_SIZE
    })
    .border({
      width: this.isFocused ? 2 : 0,
      color: this.isFocused ? Constants.PRIMARY_COLOR : Color.Transparent
    })
    .animation({
      duration: Constants.ANIMATION_DURATION,
      easing: Constants.ANIMATION_EASING
    })
  }
}
