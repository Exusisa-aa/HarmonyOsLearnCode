import { Constants } from '../common/Constants'
import { ExamTitle } from '../components/ExamTitle'
import { StudyStatusManager, StudyStatistics } from '../model/StudyStatus'
import router from '@ohos.router'
import promptAction from '@ohos.promptAction'

// 菜单项配置
interface MenuItem {
  icon: string
  title: string
  subtitle?: string
  showArrow: boolean
  onClick: () => void
}

@Entry
@Component
export struct Profile {
  // 用户信息
  @State nickname: string = '学习者'
  @State phone: string = '138****8888'
  @State avatarUrl: string = ''

  // 学习统计
  @State statistics: StudyStatistics = {
    totalLevels: 0,
    studiedLevels: 0,
    completionRate: 0,
    overallAverageScore: 0,
    bestOverallScore: 0,
    levelDetails: new Map()
  }

  // 已刷题目数量
  @State totalQuestions: number = 0
  // 错题数量
  @State wrongQuestions: number = 0

  aboutToAppear() {
    // 从路由参数获取数据
    const params = router.getParams() as Record<string, Object>
    if (params) {
      if (params.totalQuestions !== undefined) {
        this.totalQuestions = params.totalQuestions as number
      }
      if (params.wrongQuestions !== undefined) {
        this.wrongQuestions = params.wrongQuestions as number
      }
    }

    // 加载学习统计数据
    this.loadStatistics()

    // TODO: 加载用户信息
    this.loadUserInfo()
  }

  onPageShow() {
    // 每次页面显示时刷新数据
    this.loadStatistics()
  }

  /**
   * 加载学习统计数据
   */
  private loadStatistics(): void {
    this.statistics = StudyStatusManager.getStatistics()
  }

  /**
   * 加载用户信息
   */
  private loadUserInfo(): void {
    // TODO: 从本地存储或服务器获取用户信息
    console.log('加载用户信息')
  }

  /**
   * 编辑资料
   */
  private handleEditProfile(): void {
    promptAction.showToast({
      message: '编辑资料功能开发中',
      duration: 2000
    })
  }

  /**
   * 查看错题本
   */
  private handleWrongQuestions(): void {
    promptAction.showToast({
      message: '错题本功能开发中',
      duration: 2000
    })
  }

  /**
   * 查看学习记录
   */
  private handleStudyRecord(): void {
    promptAction.showToast({
      message: '学习记录功能开发中',
      duration: 2000
    })
  }

  /**
   * 设置
   */
  private handleSettings(): void {
    promptAction.showToast({
      message: '设置功能开发中',
      duration: 2000
    })
  }

  /**
   * 关于我们
   */
  private handleAbout(): void {
    promptAction.showDialog({
      title: '关于智题通',
      message: '版本：v1.0.0\n\n智慧刷题 · 轻松通关',
      buttons: [
        {
          text: '确定',
          color: Constants.PRIMARY_COLOR
        }
      ]
    })
  }

  /**
   * 登出
   */
  private handleLogout(): void {
    promptAction.showDialog({
      title: '提示',
      message: '确定要退出登录吗？',
      buttons: [
        {
          text: '取消',
          color: Constants.TEXT_SECONDARY
        },
        {
          text: '确定',
          color: Constants.ERROR_COLOR
        }
      ]
    }).then((result) => {
      if (result.index === 1) {
        // TODO: 清除登录状态
        router.replaceUrl({
          url: Constants.ROUTE_LOGIN
        })
      }
    })
  }

  build() {
    Column() {
      // 顶部标题栏
      ExamTitle({
        titleText: '个人中心',
        titleColor: Color.White,
        back: $r('app.media.back0'),
        showBackButton: true
      })

      Scroll() {
        Column() {
          // 用户信息卡片
          Column() {
            Row() {
              // 头像
              Stack() {
                Image($r('app.media.default_profile0'))
                  .width(80)
                  .height(80)
                  .borderRadius(Constants.BORDER_RADIUS_CIRCLE)
                  .border({
                    width: 3,
                    color: Color.White
                  })

                // 编辑图标
                Image($r('sys.media.ohos_ic_public_edit'))
                  .width(24)
                  .height(24)
                  .position({ x: 56, y: 56 })
                  .backgroundColor(Color.White)
                  .borderRadius(Constants.BORDER_RADIUS_CIRCLE)
                  .padding(4)
              }
              .onClick(() => {
                this.handleEditProfile()
              })

              // 用户信息
              Column({ space: 8 }) {
                Text(this.nickname)
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.White)
                  .alignSelf(ItemAlign.Start)

                Text(this.phone)
                  .fontSize(14)
                  .fontColor('rgba(255, 255, 255, 0.8)')
                  .alignSelf(ItemAlign.Start)
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
              .margin({ left: 20 })

              // 箭头
              Text('›')
                .fontSize(30)
                .fontColor(Color.White)
                .opacity(0.8)
            }
            .width(Constants.FULL_PARENT)
            .alignItems(VerticalAlign.Center)
          }
          .width(Constants.FULL_PARENT)
          .padding(Constants.SPACE_SIZE)
          .linearGradient({
            direction: GradientDirection.RightBottom,
            colors: [
              [Constants.PRIMARY_COLOR, 0.0],
              [Constants.PRIMARY_DARK, 1.0]
            ]
          })
          .borderRadius({
            bottomLeft: Constants.BORDER_RADIUS_LARGE,
            bottomRight: Constants.BORDER_RADIUS_LARGE
          })
          .margin({ bottom: Constants.SPACE_SIZE })

          // 学习统计卡片
          Column() {
            Text('学习统计')
              .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
              .fontWeight(FontWeight.Bold)
              .fontColor(Constants.TEXT_PRIMARY)
              .width(Constants.FULL_PARENT)
              .textAlign(TextAlign.Start)
              .margin({ bottom: Constants.SPACE_SIZE })

            // 统计数据网格
            Grid() {
              // 已完成科目
              GridItem() {
                Column({ space: Constants.SMALL_SPACE }) {
                  Text(`${this.statistics.studiedLevels}`)
                    .fontSize(28)
                    .fontWeight(Constants.BOLD_WEIGHT)
                    .fontColor(Constants.PRIMARY_COLOR)

                  Text('已完成科目')
                    .fontSize(12)
                    .fontColor(Constants.TEXT_HINT)
                }
              }

              // 完成率
              GridItem() {
                Column({ space: Constants.SMALL_SPACE }) {
                  Text(`${this.statistics.completionRate}%`)
                    .fontSize(28)
                    .fontWeight(Constants.BOLD_WEIGHT)
                    .fontColor(Constants.INFO_COLOR)

                  Text('完成率')
                    .fontSize(12)
                    .fontColor(Constants.TEXT_HINT)
                }
              }

              // 平均分
              GridItem() {
                Column({ space: Constants.SMALL_SPACE }) {
                  Text(`${this.statistics.overallAverageScore}`)
                    .fontSize(28)
                    .fontWeight(Constants.BOLD_WEIGHT)
                    .fontColor(Constants.WARNING_COLOR)

                  Text('平均分')
                    .fontSize(12)
                    .fontColor(Constants.TEXT_HINT)
                }
              }

              // 最佳成绩
              GridItem() {
                Column({ space: Constants.SMALL_SPACE }) {
                  Text(`${this.statistics.bestOverallScore}`)
                    .fontSize(28)
                    .fontWeight(Constants.BOLD_WEIGHT)
                    .fontColor(Constants.ERROR_COLOR)

                  Text('最佳成绩')
                    .fontSize(12)
                    .fontColor(Constants.TEXT_HINT)
                }
              }
            }
            .width(Constants.FULL_PARENT)
            .columnsTemplate('1fr 1fr')
            .rowsGap(Constants.ITEM_SPACE)
            .columnsGap(Constants.SPACE_SIZE)
          }
          .width(Constants.FULL_PARENT)
          .padding(Constants.SPACE_SIZE)
          .backgroundColor(Color.White)
          .borderRadius(Constants.BORDER_RADIUS_LARGE)
          .margin({ bottom: Constants.SPACE_SIZE })
          .shadow({
            radius: Constants.SHADOW_RADIUS,
            color: Constants.SHADOW_COLOR,
            offsetX: Constants.SHADOW_OFFSET_X,
            offsetY: Constants.SHADOW_OFFSET_Y
          })

          // 答题统计卡片
          Column() {
            Text('答题统计')
              .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
              .fontWeight(FontWeight.Bold)
              .fontColor(Constants.TEXT_PRIMARY)
              .width(Constants.FULL_PARENT)
              .textAlign(TextAlign.Start)
              .margin({ bottom: Constants.SPACE_SIZE })

            Row() {
              Column({ space: Constants.SMALL_SPACE }) {
                Text(`${this.totalQuestions}`)
                  .fontSize(24)
                  .fontWeight(Constants.BOLD_WEIGHT)
                  .fontColor(Constants.PRIMARY_COLOR)

                Text('已刷题目')
                  .fontSize(12)
                  .fontColor(Constants.TEXT_HINT)
              }
              .layoutWeight(1)

              Divider()
                .vertical(true)
                .height(40)
                .color(Constants.DIVIDER_COLOR)

              Column({ space: Constants.SMALL_SPACE }) {
                Text(`${this.wrongQuestions}`)
                  .fontSize(24)
                  .fontWeight(Constants.BOLD_WEIGHT)
                  .fontColor(Constants.ERROR_COLOR)

                Text('错题数量')
                  .fontSize(12)
                  .fontColor(Constants.TEXT_HINT)
              }
              .layoutWeight(1)
            }
            .width(Constants.FULL_PARENT)
          }
          .width(Constants.FULL_PARENT)
          .padding(Constants.SPACE_SIZE)
          .backgroundColor(Color.White)
          .borderRadius(Constants.BORDER_RADIUS_LARGE)
          .margin({ bottom: Constants.SPACE_SIZE })
          .shadow({
            radius: Constants.SHADOW_RADIUS,
            color: Constants.SHADOW_COLOR,
            offsetX: Constants.SHADOW_OFFSET_X,
            offsetY: Constants.SHADOW_OFFSET_Y
          })

          // 功能菜单
          Column() {
            Text('功能菜单')
              .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
              .fontWeight(FontWeight.Bold)
              .fontColor(Constants.TEXT_PRIMARY)
              .width(Constants.FULL_PARENT)
              .textAlign(TextAlign.Start)
              .margin({ bottom: Constants.SPACE_SIZE })

            Column() {
              // 错题本
              Row() {
                Row({ space: Constants.SPACE_SIZE }) {
                  Text('📝')
                    .fontSize(20)
                  Text('错题本')
                    .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
                    .fontColor(Constants.TEXT_PRIMARY)
                }

                Text('›')
                  .fontSize(24)
                  .fontColor(Constants.TEXT_HINT)
              }
              .width(Constants.FULL_PARENT)
              .padding({
                top: Constants.COLUMN_PADDING,
                bottom: Constants.COLUMN_PADDING
              })
              .onClick(() => {
                this.handleWrongQuestions()
              })
              .stateStyles({
                pressed: {
                  .backgroundColor(Constants.BG_LIGHT)
                },
                normal: {
                  .backgroundColor(Color.White)
                }
              })

              Divider().color(Constants.BORDER_COLOR)

              // 学习记录
              Row() {
                Row({ space: Constants.SPACE_SIZE }) {
                  Text('📊')
                    .fontSize(20)
                  Text('学习记录')
                    .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
                    .fontColor(Constants.TEXT_PRIMARY)
                }

                Text('›')
                  .fontSize(24)
                  .fontColor(Constants.TEXT_HINT)
              }
              .width(Constants.FULL_PARENT)
              .padding({
                top: Constants.COLUMN_PADDING,
                bottom: Constants.COLUMN_PADDING
              })
              .onClick(() => {
                this.handleStudyRecord()
              })
              .stateStyles({
                pressed: {
                  .backgroundColor(Constants.BG_LIGHT)
                },
                normal: {
                  .backgroundColor(Color.White)
                }
              })

              Divider().color(Constants.BORDER_COLOR)

              // 设置
              Row() {
                Row({ space: Constants.SPACE_SIZE }) {
                  Text('⚙️')
                    .fontSize(20)
                  Text('设置')
                    .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
                    .fontColor(Constants.TEXT_PRIMARY)
                }

                Text('›')
                  .fontSize(24)
                  .fontColor(Constants.TEXT_HINT)
              }
              .width(Constants.FULL_PARENT)
              .padding({
                top: Constants.COLUMN_PADDING,
                bottom: Constants.COLUMN_PADDING
              })
              .onClick(() => {
                this.handleSettings()
              })
              .stateStyles({
                pressed: {
                  .backgroundColor(Constants.BG_LIGHT)
                },
                normal: {
                  .backgroundColor(Color.White)
                }
              })

              Divider().color(Constants.BORDER_COLOR)

              // 关于我们
              Row() {
                Row({ space: Constants.SPACE_SIZE }) {
                  Text('ℹ️')
                    .fontSize(20)
                  Text('关于我们')
                    .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
                    .fontColor(Constants.TEXT_PRIMARY)
                }

                Text('›')
                  .fontSize(24)
                  .fontColor(Constants.TEXT_HINT)
              }
              .width(Constants.FULL_PARENT)
              .padding({
                top: Constants.COLUMN_PADDING,
                bottom: Constants.COLUMN_PADDING
              })
              .onClick(() => {
                this.handleAbout()
              })
              .stateStyles({
                pressed: {
                  .backgroundColor(Constants.BG_LIGHT)
                },
                normal: {
                  .backgroundColor(Color.White)
                }
              })
            }
            .width(Constants.FULL_PARENT)
          }
          .width(Constants.FULL_PARENT)
          .padding(Constants.SPACE_SIZE)
          .backgroundColor(Color.White)
          .borderRadius(Constants.BORDER_RADIUS_LARGE)
          .margin({ bottom: Constants.SPACE_SIZE })
          .shadow({
            radius: Constants.SHADOW_RADIUS,
            color: Constants.SHADOW_COLOR,
            offsetX: Constants.SHADOW_OFFSET_X,
            offsetY: Constants.SHADOW_OFFSET_Y
          })

          // 登出按钮
          Button('退出登录')
            .width(Constants.FULL_PARENT)
            .height(Constants.BUTTON_HEIGHT)
            .fontSize(Constants.BUTTON_FONT_SIZE)
            .fontColor(Color.White)
            .borderRadius(Constants.BUTTON_BORDER_RADIUS)
            .linearGradient({
              direction: Constants.GRADIENT_DIRECTION,
              colors: Constants.GRADIENT_COLORS as [[string, number], [string, number]]
            })
            .margin({ top: 10, bottom: 30 })
            .onClick(() => {
              this.handleLogout()
            })
            .stateStyles({
              pressed: {
                .scale({ x: 0.98, y: 0.98 })
                .opacity(0.9)
              },
              normal: {
                .scale({ x: 1, y: 1 })
                .opacity(1)
              }
            })
            .animation({
              duration: Constants.ANIMATION_DURATION,
              easing: Constants.ANIMATION_EASING
            })
        }
        .width(Constants.FULL_PARENT)
        .padding(Constants.SPACE_SIZE)
      }
      .width(Constants.FULL_PARENT)
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor(Constants.BG_LIGHT)
  }
}
