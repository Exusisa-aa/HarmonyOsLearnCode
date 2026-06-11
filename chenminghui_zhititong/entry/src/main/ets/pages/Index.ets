import { router } from '@kit.ArkUI'
import { Constants } from '../common/Constants'

@Entry
@Component
struct Index {
  // 加载进度
  @State progress: number = 0
  @State loadingText: string = '正在启动...'

  // 动画状态
  @State logoScale: number = 0.8
  @State logoOpacity: number = 0
  @State textOpacity: number = 0

  aboutToAppear(): void {
    // 启动动画
    this.startAnimation()

    // 模拟加载过程
    this.simulateLoading()
  }

  /**
   * 启动入场动画
   */
  private startAnimation(): void {
    // Logo 动画
    setTimeout(() => {
      this.logoScale = 1
      this.logoOpacity = 1
    }, 100)

    // 文字动画
    setTimeout(() => {
      this.textOpacity = 1
    }, 400)
  }

  /**
   * 模拟加载过程
   */
  private simulateLoading(): void {
    const steps = [
      { progress: 30, text: '初始化资源...', delay: 300 },
      { progress: 60, text: '加载配置...', delay: 600 },
      { progress: 90, text: '准备就绪...', delay: 900 },
      { progress: 100, text: '启动完成', delay: 1200 }
    ]

    steps.forEach((step) => {
      setTimeout(() => {
        this.progress = step.progress
        this.loadingText = step.text

        // 加载完成后跳转
        if (step.progress === 100) {
          setTimeout(() => {
            this.navigateToLogin()
          }, 300)
        }
      }, step.delay)
    })
  }

  /**
   * 跳转到登录页
   */
  private navigateToLogin(): void {
    // TODO: 可以在这里检查登录状态
    // const isLoggedIn = checkLoginStatus()
    // if (isLoggedIn) {
    //   router.replaceUrl({ url: Constants.ROUTE_EXAM })
    // } else {
    router.replaceUrl({
      url: Constants.ROUTE_LOGIN
    })
    // }
  }

  build() {
    Stack() {
      // 背景渐变
      Column()
        .width(Constants.FULL_PARENT)
        .height(Constants.FULL_PARENT)
        .linearGradient({
          direction: GradientDirection.Bottom,
          colors: [
            ['#E8F5E9', 0.0],
            ['#FFFFFF', 0.5],
            ['#E8F5E9', 1.0]
          ]
        })

      // 装饰性圆形
      Circle()
        .width(300)
        .height(300)
        .fill(`${Constants.PRIMARY_COLOR}08`)
        .position({ x: -100, y: -100 })

      Circle()
        .width(200)
        .height(200)
        .fill(`${Constants.PRIMARY_COLOR}05`)
        .position({ x: '70%', y: '60%' })

      // 主内容
      Column() {
        // Logo 区域
        Column() {
          // Logo 图标
          Image($r('app.media.logo0'))
            .width(100)
            .height(100)
            .scale({ x: this.logoScale, y: this.logoScale })
            .opacity(this.logoOpacity)
            .animation({
              duration: 600,
              easing: Constants.ANIMATION_EASING
            })

          // 应用名称
          Text('智题通')
            .fontSize(32)
            .fontWeight(FontWeight.Bold)
            .fontColor(Constants.PRIMARY_COLOR)
            .margin({ top: 20 })
            .opacity(this.textOpacity)
            .animation({
              duration: 600,
              easing: Constants.ANIMATION_EASING
            })

          // 应用标语
          Text('智慧刷题 · 轻松通关')
            .fontSize(14)
            .fontColor(Constants.TEXT_SECONDARY)
            .margin({ top: 8 })
            .letterSpacing(2)
            .opacity(this.textOpacity)
            .animation({
              duration: 600,
              easing: Constants.ANIMATION_EASING,
              delay: 200
            })
        }
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)

        // 加载进度区域
        Column({ space: 15 }) {
          // 进度条
          Progress({
            value: this.progress,
            total: 100,
            type: ProgressType.Linear
          })
            .width('60%')
            .height(4)
            .color(Constants.PRIMARY_COLOR)
            .backgroundColor(Constants.BG_GRAY)
            .borderRadius(2)
            .animation({
              duration: 300,
              easing: Constants.ANIMATION_EASING
            })

          // 加载文本
          Text(this.loadingText)
            .fontSize(Constants.NORMAL_SIZE)
            .fontColor(Constants.TEXT_HINT)
            .letterSpacing(1)

          // 版本号
          Text('v1.0.0')
            .fontSize(12)
            .fontColor(Constants.TEXT_HINT)
            .opacity(0.6)
            .margin({ top: 10 })
        }
        .width(Constants.FULL_PARENT)
        .padding({ bottom: 60 })
      }
      .width(Constants.FULL_PARENT)
      .height(Constants.FULL_PARENT)
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
  }
}
