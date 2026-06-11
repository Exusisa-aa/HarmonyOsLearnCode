import { Constants } from '../common/Constants'
import { CustomInputComp } from '../components/CustomInputComp'
import promptAction from '@ohos.promptAction'

@Entry
@Component
struct TestCustomInputComp {
  // 测试数据
  @State textValue: string = ''
  @State passwordValue: string = ''
  @State numberValue: string = ''
  @State emailValue: string = ''
  @State phoneValue: string = ''
  @State disabledValue: string = '禁用状态的输入框'
  @State clearableValue: string = ''

  /**
   * 显示Toast提示
   */
  private showToast(message: string): void {
    promptAction.showToast({
      message: message,
      duration: 2000
    })
  }

  /**
   * 处理提交
   */
  private handleSubmit(): void {
    const info = [
      `文本: ${this.textValue}`,
      `密码: ${this.passwordValue}`,
      `数字: ${this.numberValue}`,
      `邮箱: ${this.emailValue}`,
      `手机: ${this.phoneValue}`,
      `可清除: ${this.clearableValue}`
    ].join('\n')

    console.info('表单数据:', info)
    this.showToast('提交成功，查看日志')
  }

  build() {
    Column() {
      // 顶部标题栏
      Row() {
        Text('CustomInputComp 组件测试')
          .fontSize(Constants.TITLE_FONT_SIZE)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)

        Button('提交')
          .fontSize(Constants.NORMAL_SIZE)
          .fontColor(Color.White)
          .backgroundColor('rgba(255, 255, 255, 0.2)')
          .borderRadius(Constants.BORDER_RADIUS_SMALL)
          .padding({
            left: Constants.COLUMN_PADDING,
            right: Constants.COLUMN_PADDING,
            top: Constants.SMALL_SPACE,
            bottom: Constants.SMALL_SPACE
          })
          .onClick(() => {
            this.handleSubmit()
          })
      }
      .width(Constants.FULL_PARENT)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(Constants.SPACE_SIZE)
      .backgroundColor(Constants.PRIMARY_COLOR)

      // 滚动内容区
      Scroll() {
        Column({ space: Constants.ITEM_SPACE }) {

          // 基础输入框测试
          Column({ space: Constants.SPACE_SIZE }) {
            Text('📝 基础输入框')
              .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
              .fontWeight(FontWeight.Bold)
              .fontColor(Constants.TEXT_PRIMARY)
              .width(Constants.FULL_PARENT)

            // 文本输入
            Column({ space: 4 }) {
              Text('文本输入')
                .fontSize(Constants.NORMAL_SIZE)
                .fontColor(Constants.TEXT_SECONDARY)

              CustomInputComp({
                text: $textValue,
                icon: $r('app.media.user0'),
                placeholder: '请输入文本内容',
                type: InputType.Normal,
                onChange: (value: string) => {
                  console.info('文本输入:', value)
                }
              })

              if (this.textValue) {
                Text(`当前值: ${this.textValue}`)
                  .fontSize(12)
                  .fontColor(Constants.INFO_COLOR)
              }
            }
            .width(Constants.FULL_PARENT)
            .alignItems(HorizontalAlign.Start)

            // 密码输入
            Column({ space: 4 }) {
              Text('密码输入')
                .fontSize(Constants.NORMAL_SIZE)
                .fontColor(Constants.TEXT_SECONDARY)

              CustomInputComp({
                text: $passwordValue,
                icon: $r('app.media.pwd0'),
                placeholder: '请输入密码',
                type: InputType.Password
              })

              if (this.passwordValue) {
                Text(`当前值长度: ${this.passwordValue.length}`)
                  .fontSize(12)
                  .fontColor(Constants.INFO_COLOR)
              }
            }
            .width(Constants.FULL_PARENT)
            .alignItems(HorizontalAlign.Start)
          }
          .width(Constants.FULL_PARENT)
          .padding(Constants.SPACE_SIZE)
          .backgroundColor(Color.White)
          .borderRadius(Constants.BORDER_RADIUS_LARGE)
          .margin({ left: Constants.SPACE_SIZE, right: Constants.SPACE_SIZE })

          // 特殊类型输入框测试
          Column({ space: Constants.SPACE_SIZE }) {
            Text('🔢 特殊类型输入')
              .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
              .fontWeight(FontWeight.Bold)
              .fontColor(Constants.TEXT_PRIMARY)
              .width(Constants.FULL_PARENT)

            // 数字输入
            Column({ space: 4 }) {
              Text('数字输入')
                .fontSize(Constants.NORMAL_SIZE)
                .fontColor(Constants.TEXT_SECONDARY)

              CustomInputComp({
                text: $numberValue,
                icon: '🔢',
                placeholder: '请输入数字',
                type: InputType.Number
              })
            }
            .width(Constants.FULL_PARENT)
            .alignItems(HorizontalAlign.Start)

            // 邮箱输入
            Column({ space: 4 }) {
              Text('邮箱输入')
                .fontSize(Constants.NORMAL_SIZE)
                .fontColor(Constants.TEXT_SECONDARY)

              CustomInputComp({
                text: $emailValue,
                icon: '📧',
                placeholder: '请输入邮箱地址',
                type: InputType.Email
              })
            }
            .width(Constants.FULL_PARENT)
            .alignItems(HorizontalAlign.Start)

            // 手机号输入
            Column({ space: 4 }) {
              Text('手机号输入')
                .fontSize(Constants.NORMAL_SIZE)
                .fontColor(Constants.TEXT_SECONDARY)

              CustomInputComp({
                text: $phoneValue,
                icon: '📱',
                placeholder: '请输入手机号',
                type: InputType.PhoneNumber
              })
            }
            .width(Constants.FULL_PARENT)
            .alignItems(HorizontalAlign.Start)
          }
          .width(Constants.FULL_PARENT)
          .padding(Constants.SPACE_SIZE)
          .backgroundColor(Color.White)
          .borderRadius(Constants.BORDER_RADIUS_LARGE)
          .margin({ left: Constants.SPACE_SIZE, right: Constants.SPACE_SIZE })

          // 高级功能测试
          Column({ space: Constants.SPACE_SIZE }) {
            Text('✨ 高级功能')
              .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
              .fontWeight(FontWeight.Bold)
              .fontColor(Constants.TEXT_PRIMARY)
              .width(Constants.FULL_PARENT)

            // 带清除按钮
            Column({ space: 4 }) {
              Text('带清除按钮')
                .fontSize(Constants.NORMAL_SIZE)
                .fontColor(Constants.TEXT_SECONDARY)

              CustomInputComp({
                text: $clearableValue,
                icon: '🔍',
                placeholder: '输入内容后显示清除按钮',
                type: InputType.Normal,
                clearButtonMode: true
              })

              if (this.clearableValue) {
                Text(`当前值: ${this.clearableValue}`)
                  .fontSize(12)
                  .fontColor(Constants.SUCCESS_COLOR)
              }
            }
            .width(Constants.FULL_PARENT)
            .alignItems(HorizontalAlign.Start)

            // 禁用状态
            Column({ space: 4 }) {
              Text('禁用状态')
                .fontSize(Constants.NORMAL_SIZE)
                .fontColor(Constants.TEXT_SECONDARY)

              CustomInputComp({
                text: $disabledValue,
                icon: '🚫',
                placeholder: '禁用的输入框',
                type: InputType.Normal,
                enabled: false
              })

              Text('此输入框已禁用，无法编辑')
                .fontSize(12)
                .fontColor(Constants.TEXT_HINT)
            }
            .width(Constants.FULL_PARENT)
            .alignItems(HorizontalAlign.Start)

            // 无图标输入
            Column({ space: 4 }) {
              Text('无图标输入')
                .fontSize(Constants.NORMAL_SIZE)
                .fontColor(Constants.TEXT_SECONDARY)

              CustomInputComp({
                placeholder: '没有图标的输入框',
                type: InputType.Normal
              })
            }
            .width(Constants.FULL_PARENT)
            .alignItems(HorizontalAlign.Start)
          }
          .width(Constants.FULL_PARENT)
          .padding(Constants.SPACE_SIZE)
          .backgroundColor(Color.White)
          .borderRadius(Constants.BORDER_RADIUS_LARGE)
          .margin({ left: Constants.SPACE_SIZE, right: Constants.SPACE_SIZE })

          // 使用说明
          Column({ space: Constants.SMALL_SPACE }) {
            Text('📖 使用说明')
              .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
              .fontWeight(FontWeight.Bold)
              .fontColor(Constants.TEXT_PRIMARY)
              .width(Constants.FULL_PARENT)

            Column({ space: 4 }) {
              Text('• 支持双向数据绑定 (@Prop text)')
                .fontSize(12)
                .fontColor(Constants.TEXT_SECONDARY)
              Text('• 支持 onChange 回调监听输入变化')
                .fontSize(12)
                .fontColor(Constants.TEXT_SECONDARY)
              Text('• 支持 onSubmit 回调监听键盘提交')
                .fontSize(12)
                .fontColor(Constants.TEXT_SECONDARY)
              Text('• 支持 clearButtonMode 显示清除按钮')
                .fontSize(12)
                .fontColor(Constants.TEXT_SECONDARY)
              Text('• 支持 enabled 属性控制禁用状态')
                .fontSize(12)
                .fontColor(Constants.TEXT_SECONDARY)
              Text('• 支持多种 InputType 类型')
                .fontSize(12)
                .fontColor(Constants.TEXT_SECONDARY)
              Text('• 自动显示焦点状态边框')
                .fontSize(12)
                .fontColor(Constants.TEXT_SECONDARY)
            }
            .width(Constants.FULL_PARENT)
            .alignItems(HorizontalAlign.Start)
            .padding({ left: Constants.SMALL_SPACE })
          }
          .width(Constants.FULL_PARENT)
          .padding(Constants.SPACE_SIZE)
          .backgroundColor(Constants.BG_LIGHT_YELLOW)
          .borderRadius(Constants.BORDER_RADIUS_LARGE)
          .margin({
            left: Constants.SPACE_SIZE,
            right: Constants.SPACE_SIZE,
            bottom: 30
          })
        }
        .width(Constants.FULL_PARENT)
        .padding({ top: Constants.SPACE_SIZE, bottom: Constants.SPACE_SIZE })
      }
      .width(Constants.FULL_PARENT)
      .layoutWeight(1)
      .backgroundColor(Constants.BG_LIGHT)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
  }
}
