import { Constants } from '../common/Constants'
import router from '@ohos.router'

@Component
export struct ExamTitle {
  // 返回按钮配置
  back: Resource = $r('app.media.back0')
  showBackButton: boolean = true
  onBackClick?: () => void

  // 标题配置
  titleText: string = ''
  titleColor: Color | Resource = Color.White
  titleFontSize: number = Constants.TITLE_FONT_SIZE

  // 右侧内容配置（图标或文字，二选一）
  rightIcon: Resource | null = null
  rightText: string = ''
  onRightClick?: () => void
  onRightTextClick?: () => void

  // 整体样式配置
  backgroundColor: ResourceColor = Color.Transparent
  showShadow: boolean = false

  build() {
    RelativeContainer() {
      // 左侧返回按钮
      if (this.showBackButton) {
        Image(this.back)
          .width(Constants.TITLE_FONT_SIZE)
          .height(Constants.TITLE_FONT_SIZE)
          .objectFit(ImageFit.Contain)
          .alignRules({
            left: { anchor: '__container__', align: HorizontalAlign.Start },
            center: { anchor: '__container__', align: VerticalAlign.Center }
          })
          .offset({ left: Constants.SPACE_SIZE })
          .onClick(() => {
            if (this.onBackClick) {
              this.onBackClick()
            } else {
              router.back()
            }
          })
          .stateStyles({
            pressed: {
              .opacity(0.6)
              .scale({ x: 0.9, y: 0.9 })
            },
            normal: {
              .opacity(1)
              .scale({ x: 1, y: 1 })
            }
          })
          .animation({
            duration: Constants.ANIMATION_DURATION,
            easing: Constants.ANIMATION_EASING
          })
      }

      // 中间标题
      Text(this.titleText)
        .fontSize(this.titleFontSize)
        .fontColor(this.titleColor)
        .fontWeight(Constants.BOLD_WEIGHT)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .alignRules({
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
          center: { anchor: '__container__', align: VerticalAlign.Center }
        })

      // 右侧图标
      if (this.rightIcon !== null && this.rightText === '') {
        Image(this.rightIcon)
          .width(Constants.TITLE_FONT_SIZE)
          .height(Constants.TITLE_FONT_SIZE)
          .objectFit(ImageFit.Contain)
          .alignRules({
            right: { anchor: '__container__', align: HorizontalAlign.End },
            center: { anchor: '__container__', align: VerticalAlign.Center }
          })
          .offset({ right: Constants.SPACE_SIZE })
          .onClick(() => {
            if (this.onRightClick) {
              this.onRightClick()
            }
          })
          .stateStyles({
            pressed: {
              .opacity(0.6)
              .scale({ x: 0.9, y: 0.9 })
            },
            normal: {
              .opacity(1)
              .scale({ x: 1, y: 1 })
            }
          })
          .animation({
            duration: Constants.ANIMATION_DURATION,
            easing: Constants.ANIMATION_EASING
          })
      }

      // 右侧文字按钮
      if (this.rightText !== '') {
        Text(this.rightText)
          .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
          .fontColor(this.titleColor)
          .fontWeight(FontWeight.Medium)
          .alignRules({
            right: { anchor: '__container__', align: HorizontalAlign.End },
            center: { anchor: '__container__', align: VerticalAlign.Center }
          })
          .offset({ right: Constants.SPACE_SIZE })
          .padding({
            left: Constants.COLUMN_PADDING,
            right: Constants.COLUMN_PADDING,
            top: Constants.SMALL_SPACE,
            bottom: Constants.SMALL_SPACE
          })
          .borderRadius(Constants.BORDER_RADIUS_SMALL)
          .onClick(() => {
            if (this.onRightTextClick) {
              this.onRightTextClick()
            }
          })
          .stateStyles({
            pressed: {
              .opacity(0.7)
              .backgroundColor('rgba(255, 255, 255, 0.1)')
            },
            normal: {
              .opacity(1)
              .backgroundColor(Color.Transparent)
            }
          })
          .animation({
            duration: Constants.ANIMATION_DURATION,
            easing: Constants.ANIMATION_EASING
          })
      }
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.NAV_HEIGHT)
    .backgroundColor(this.backgroundColor)
    .shadow(this.showShadow ? {
      radius: Constants.SHADOW_RADIUS,
      color: Constants.SHADOW_COLOR,
      offsetX: Constants.SHADOW_OFFSET_X,
      offsetY: Constants.SHADOW_OFFSET_Y
    } : undefined)
  }
}
