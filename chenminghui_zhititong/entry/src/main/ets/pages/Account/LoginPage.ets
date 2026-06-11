import { Constants } from '../../common/Constants'
import { CustomInputComp } from '../../components/CustomInputComp'
import router from '@ohos.router'
import promptAction from '@ohos.promptAction'

@Entry
@Component
struct LoginPage {
  // 是否为注册模式
  @State isReg: boolean = false

  // 表单数据
  @State phone: string = ''
  @State password: string = ''
  @State confirmPassword: string = ''

  // UI状态
  @State isLoading: boolean = false
  @State errorMessage: string = ''
  @State rememberPassword: boolean = false

  // 输入框焦点状态
  @State phoneFocused: boolean = false
  @State passwordFocused: boolean = false
  @State confirmPwdFocused: boolean = false

  /**
   * 验证手机号格式
   */
  private validatePhone(phone: string): boolean {
    // 简单的手机号验证：11位数字，以1开头
    const phoneRegex = /^1[3-9]\d{9}$/
    return phoneRegex.test(phone)
  }

  /**
   * 验证密码格式
   */
  private validatePassword(password: string): boolean {
    // 密码长度6-20位
    return password.length >= 6 && password.length <= 20
  }

  /**
   * 验证整个表单
   */
  private validateForm(): boolean {
    // 清空错误信息
    this.errorMessage = ''

    // 验证手机号
    if (!this.phone) {
      this.errorMessage = '请输入手机号'
      return false
    }

    if (!this.validatePhone(this.phone)) {
      this.errorMessage = '请输入正确的手机号'
      return false
    }

    // 验证密码
    if (!this.password) {
      this.errorMessage = '请输入密码'
      return false
    }

    if (!this.validatePassword(this.password)) {
      this.errorMessage = '密码长度为6-20位'
      return false
    }

    // 注册模式下验证确认密码
    if (this.isReg) {
      if (!this.confirmPassword) {
        this.errorMessage = '请确认密码'
        return false
      }

      if (this.password !== this.confirmPassword) {
        this.errorMessage = '两次输入的密码不一致'
        return false
      }
    }

    return true
  }

  /**
   * 处理登录
   */
  private async handleLogin(): Promise<void> {
    // 验证表单
    if (!this.validateForm()) {
      this.showToast(this.errorMessage)
      return
    }

    // 设置加载状态
    this.isLoading = true

    try {
      // TODO: 调用登录API
      // const result = await loginApi(this.phone, this.password)

      // 模拟登录延迟
      await new Promise(resolve => setTimeout(resolve, 1000))

      // 如果选择了记住密码，保存到本地
      if (this.rememberPassword) {
        await this.savePassword()
      }

      this.showToast('登录成功')

      // 跳转到习题列表页
      router.pushUrl({
        url: Constants.ROUTE_EXAM
      })
    } catch (error) {
      this.showToast('登录失败，请重试')
      console.error('登录失败:', error)
    } finally {
      this.isLoading = false
    }
  }

  /**
   * 处理注册
   */
  private async handleRegister(): Promise<void> {
    // 验证表单
    if (!this.validateForm()) {
      this.showToast(this.errorMessage)
      return
    }

    // 设置加载状态
    this.isLoading = true

    try {
      // TODO: 调用注册API
      // const result = await registerApi(this.phone, this.password)

      // 模拟注册延迟
      await new Promise(resolve => setTimeout(resolve, 1000))

      this.showToast('注册成功')

      // 注册成功后切换到登录模式
      this.isReg = false
      this.confirmPassword = ''
    } catch (error) {
      this.showToast('注册失败，请重试')
      console.error('注册失败:', error)
    } finally {
      this.isLoading = false
    }
  }

  /**
   * 处理提交（键盘回车）
   */
  private handleSubmit(): void {
    if (this.isReg) {
      this.handleRegister()
    } else {
      this.handleLogin()
    }
  }

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
   * 保存密码到本地
   */
  private async savePassword(): Promise<void> {
    try {
      // TODO: 实现密码保存逻辑
      // 注意：实际应用中应该加密存储
      console.log('保存密码')
    } catch (error) {
      console.error('保存密码失败:', error)
    }
  }

  /**
   * 加载保存的密码
   */
  private async loadSavedPassword(): Promise<void> {
    try {
      // TODO: 实现密码加载逻辑
      console.log('加载保存的密码')
    } catch (error) {
      console.error('加载密码失败:', error)
    }
  }

  /**
   * 处理忘记密码
   */
  private handleForgotPassword(): void {
    this.showToast('请联系客服重置密码')
  }

  aboutToAppear(): void {
    // 页面加载时尝试加载保存的密码
    this.loadSavedPassword()
  }

  build() {
    Column() {
      // Logo区域
      Column() {
        Image($r('app.media.logo0'))
          .width(Constants.LOGO_WIDTH)
          .aspectRatio(1)

        Text($r('app.string.Welcome'))
          .fontSize(Constants.TITLE_SIZE)
          .fontWeight(FontWeight.Bold)
          .fontColor(Constants.TEXT_PRIMARY)
          .margin({
            top: Constants.LOGO_TITLE_TOP_MARGIN,
            bottom: Constants.LOGO_TITLE_BOTTOM_MARGIN
          })
      }
      .width(Constants.FULL_PARENT)

      // 表单区域
      Column({
        space: Constants.ITEM_SPACE
      }) {
        // 登录/注册选项卡
        Row() {
          Text($r('app.string.Login'))
            .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
            .fontWeight(this.isReg ? FontWeight.Regular : FontWeight.Bold)
            .fontColor(this.isReg ? Constants.TEXT_SECONDARY : Constants.PRIMARY_DARK)
            .onClick(() => {
              this.isReg = false
              this.errorMessage = ''
              this.confirmPassword = ''
            })
            .animation({
              duration: Constants.ANIMATION_DURATION,
              easing: Constants.ANIMATION_EASING
            })

          Text($r('app.string.Reg'))
            .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
            .fontWeight(this.isReg ? FontWeight.Bold : FontWeight.Regular)
            .fontColor(this.isReg ? Constants.PRIMARY_DARK : Constants.TEXT_SECONDARY)
            .onClick(() => {
              this.isReg = true
              this.errorMessage = ''
            })
            .animation({
              duration: Constants.ANIMATION_DURATION,
              easing: Constants.ANIMATION_EASING
            })
        }
        .width(Constants.FULL_PARENT)
        .justifyContent(FlexAlign.SpaceAround)
        .padding({ bottom: Constants.SMALL_SPACE })

        // 错误提示
        if (this.errorMessage) {
          Text(this.errorMessage)
            .fontSize(Constants.NORMAL_SIZE)
            .fontColor(Constants.ERROR_COLOR)
            .width(Constants.FULL_PARENT)
            .textAlign(TextAlign.Center)
            .padding({
              top: Constants.SMALL_SPACE,
              bottom: Constants.SMALL_SPACE
            })
            .backgroundColor(Constants.BG_LIGHT_ORANGE)
            .borderRadius(Constants.BORDER_RADIUS_SMALL)
            .animation({
              duration: Constants.ANIMATION_DURATION,
              easing: Constants.ANIMATION_EASING
            })
        }

        // 账号输入框
        CustomInputComp({
          text: $phone,
          placeholder: '请输入手机号',
          icon: $r('app.media.user0'),
          type: InputType.Number,
          clearButtonMode: true,
          onChange: (value: string) => {
            this.phone = value
            this.errorMessage = ''
          },
          onSubmit: () => {
            this.passwordFocused = true
          }
        })

        // 密码输入框
        CustomInputComp({
          text: $password,
          placeholder: '请输入密码',
          icon: $r('app.media.pwd0'),
          type: InputType.Password,
          onSubmit: () => {
            if (this.isReg) {
              this.confirmPwdFocused = true
            } else {
              this.handleSubmit()
            }
          }
        })

        // 注册时显示确认密码框
        if (this.isReg) {
          CustomInputComp({
            text: $confirmPassword,
            placeholder: '请再次输入密码',
            icon: $r('app.media.pwd0'),
            type: InputType.Password,
            onSubmit: () => {
              this.handleSubmit()
            }
          })
            .animation({
              duration: Constants.ANIMATION_DURATION,
              easing: Constants.ANIMATION_EASING
            })
        }

        // 记住密码 & 忘记密码
        Row() {
          // 记住密码
          Row({ space: Constants.SMALL_SPACE }) {
            Checkbox()
              .select(this.rememberPassword)
              .onChange((value: boolean) => {
                this.rememberPassword = value
              })

            Text('记住密码')
              .fontSize(Constants.NORMAL_SIZE)
              .fontColor(Constants.TEXT_SECONDARY)
          }
          .layoutWeight(1)

          // 忘记密码
          Text('忘记密码？')
            .fontSize(Constants.NORMAL_SIZE)
            .fontColor(Constants.INFO_COLOR)
            .onClick(() => {
              this.handleForgotPassword()
            })
        }
        .width(Constants.FULL_PARENT)
        .padding({ top: Constants.SMALL_SPACE })

        // 登录/注册按钮
        Button(this.isReg ? $r('app.string.Reg') : $r('app.string.Login'))
          .width(Constants.FULL_PARENT)
          .height(Constants.BUTTON_HEIGHT)
          .fontSize(Constants.BUTTON_FONT_SIZE)
          .fontColor(Color.White)
          .borderRadius(Constants.BUTTON_BORDER_RADIUS)
          .linearGradient({
            direction: Constants.GRADIENT_DIRECTION,
            colors: Constants.GRADIENT_COLORS as [[string, number], [string, number]]
          })
          .enabled(!this.isLoading)
          .opacity(this.isLoading ? Constants.OPACITY_DISABLED : Constants.OPACITY_NORMAL)
          .onClick(() => {
            if (!this.isLoading) {
              if (this.isReg) {
                this.handleRegister()
              } else {
                this.handleLogin()
              }
            }
          })
          .margin({
            top: Constants.ITEM_SPACE
          })

        // 加载指示器
        if (this.isLoading) {
          Row() {
            LoadingProgress()
              .width(30)
              .height(30)
              .color(Color.White)

            Text('处理中...')
              .fontSize(Constants.NORMAL_SIZE)
              .fontColor(Color.White)
              .margin({ left: Constants.SMALL_SPACE })
          }
          .justifyContent(FlexAlign.Center)
          .width(Constants.FULL_PARENT)
          .padding({ top: Constants.SMALL_SPACE })
          .animation({
            duration: Constants.ANIMATION_DURATION,
            easing: Constants.ANIMATION_EASING
          })
        }
      }
      .width(Constants.FULL_PARENT)
      .padding(Constants.LOGIN_PAGE_PADDING)
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundImage($r('app.media.homeBg0'))
    .backgroundImageSize(ImageSize.FILL)
    .padding(Constants.LOGIN_PAGE_PADDING)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      // 点击空白处收起键盘
      FocusControl.clearFocus()
    })
  }
}
