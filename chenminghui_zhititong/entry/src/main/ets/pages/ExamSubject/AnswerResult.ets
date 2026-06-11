import { Constants } from '../../common/Constants'
import { ExamTitle } from '../../components/ExamTitle'
import { AnswerResult as AnswerResultData, GradeLevel, ExamAnswerManager } from '../../model/ExamAnswer'
import router from '@ohos.router'

@Entry
@Component
export struct AnswerResult {
  // 答题结果数据
  @State totalQuestions: number = 0
  @State correctCount: number = 0
  @State wrongCount: number = 0
  @State unansweredCount: number = 0
  @State score: number = 0
  @State questionStatus: number[] = []
  @State accuracy: number = 0
  @State gradeLevel: GradeLevel = GradeLevel.FAIL
  @State comment: string = ''
  @State timeSpent?: number

  // UI状态
  @State animatedScore: number = 0
  @State showDetail: boolean = false

  aboutToAppear() {
    // 获取路由参数
    const params = router.getParams() as Record<string, Object>
    if (params) {
      if (params.totalQuestions !== undefined) {
        this.totalQuestions = params.totalQuestions as number
      }
      if (params.correctCount !== undefined) {
        this.correctCount = params.correctCount as number
      }
      if (params.wrongCount !== undefined) {
        this.wrongCount = params.wrongCount as number
      }
      if (params.unansweredCount !== undefined) {
        this.unansweredCount = params.unansweredCount as number
      }
      if (params.score !== undefined) {
        this.score = params.score as number
      }
      if (params.questionStatus !== undefined) {
        this.questionStatus = params.questionStatus as number[]
      }

      // 计算正确率
      this.accuracy = this.totalQuestions > 0
        ? Math.round((this.correctCount / this.totalQuestions) * 100)
        : 0

      // 评定等级
      this.gradeLevel = ExamAnswerManager.getGradeLevel(this.score)

      // 生成评语
      this.comment = ExamAnswerManager.generateComment(
        this.score,
        this.gradeLevel,
        this.totalQuestions,
        this.correctCount,
        this.wrongCount,
        this.unansweredCount
      )
    }

    // 启动分数动画
    this.startScoreAnimation()
  }

  /**
   * 启动分数滚动动画
   */
  private startScoreAnimation(): void {
    const duration = 1000 // 动画持续时间（毫秒）
    const steps = 30 // 动画步数
    const increment = this.score / steps
    let currentStep = 0

    const timer = setInterval(() => {
      currentStep++
      this.animatedScore = Math.min(Math.round(increment * currentStep), this.score)

      if (currentStep >= steps) {
        clearInterval(timer)
        this.animatedScore = this.score
      }
    }, duration / steps)
  }

  /**
   * 获取题目状态颜色
   */
  private getStatusColor(status: number): ResourceColor {
    switch (status) {
      case 0:
        return Constants.STATUS_CARD_UNANSWERED // 灰色-未答
      case 1:
        return Constants.STATUS_CORRECT // 绿色-答对
      case 2:
        return Constants.STATUS_WRONG // 红色-答错
      default:
        return Constants.STATUS_CARD_UNANSWERED
    }
  }

  /**
   * 获取题目文字颜色
   */
  private getTextColor(status: number): ResourceColor {
    switch (status) {
      case 0:
        return Constants.TEXT_PRIMARY // 灰色背景用深色文字
      case 1:
      case 2:
        return Constants.TEXT_WHITE // 绿色/红色背景用白色文字
      default:
        return Constants.TEXT_PRIMARY
    }
  }

  /**
   * 获取等级对应的颜色
   */
  private getGradeColor(): ResourceColor {
    switch (this.gradeLevel) {
      case GradeLevel.EXCELLENT:
        return '#FFD700' // 金色
      case GradeLevel.GOOD:
        return Constants.SUCCESS_COLOR // 绿色
      case GradeLevel.MEDIUM:
        return Constants.INFO_COLOR // 蓝色
      case GradeLevel.PASS:
        return Constants.WARNING_COLOR // 橙色
      case GradeLevel.FAIL:
        return Constants.ERROR_COLOR // 红色
      default:
        return Constants.TEXT_PRIMARY
    }
  }

  /**
   * 获取等级对应的图标
   */
  private getGradeIcon(): string {
    switch (this.gradeLevel) {
      case GradeLevel.EXCELLENT:
        return '🏆'
      case GradeLevel.GOOD:
        return '👍'
      case GradeLevel.MEDIUM:
        return '💪'
      case GradeLevel.PASS:
        return '✓'
      case GradeLevel.FAIL:
        return '✗'
      default:
        return '?'
    }
  }

  /**
   * 格式化时间
   */
  private formatTime(seconds: number): string {
    const minutes = Math.floor(seconds / 60)
    const secs = seconds % 60
    if (minutes > 0) {
      return `${minutes}分${secs}秒`
    }
    return `${secs}秒`
  }

  /**
   * 点击答题卡题目
   */
  private handleQuestionClick(index: number): void {
    // TODO: 跳转到对应题目查看答案解析
    console.log(`查看第 ${index + 1} 题详情`)
  }

  /**
   * 重新答题
   */
  private handleRetry(): void {
    router.back()
  }

  /**
   * 查看答案解析
   */
  private handleViewExplanation(): void {
    // TODO: 跳转到答案解析页面
    console.log('查看答案解析')
  }

  /**
   * 返回首页
   */
  private handleGoHome(): void {
    router.pushUrl({
      url: Constants.ROUTE_EXAM
    })
  }

  build() {
    Scroll() {
      Column() {
        // 顶部标题栏
        ExamTitle({
          titleText: '答题结果',
          titleColor: Constants.PRIMARY_COLOR,
          back: $r('app.media.back0'),
          rightIcon: $r('app.media.default_profile0'),
          onRightClick: () => {
            router.pushUrl({
              url: Constants.ROUTE_PROFILE
            })
          }
        })

        // 成绩展示卡片
        Column() {
          // 等级图标
          Text(this.getGradeIcon())
            .fontSize(50)
            .margin({ bottom: Constants.SMALL_SPACE })

          // 分数圆形展示
          Stack() {
            // 背景圆环
            Circle()
              .width(160)
              .height(160)
              .fill(Color.Transparent)
              .stroke(Constants.BG_GRAY)
              .strokeWidth(10)

            // 进度圆环（根据分数）
            Circle()
              .width(160)
              .height(160)
              .fill(Color.Transparent)
              .stroke(this.getGradeColor())
              .strokeWidth(10)
              .strokeDashArray([440, 1000]) // 根据分数调整
              .rotate({ angle: -90 })

            // 分数文本
            Column() {
              Text(`${this.animatedScore}`)
                .fontSize(Constants.SCORE_DISPLAY_SIZE)
                .fontWeight(Constants.BOLD_WEIGHT)
                .fontColor(this.getGradeColor())

              Text('/ 100 分')
                .fontSize(Constants.SCORE_TOTAL_SIZE)
                .fontColor(Constants.TEXT_SECONDARY)
                .margin({ top: 4 })
            }
          }
          .width(180)
          .height(180)
          .margin({ top: 10, bottom: 15 })

          // 等级和评语
          Text(this.gradeLevel)
            .fontSize(Constants.TITLE_FONT_SIZE)
            .fontWeight(Constants.BOLD_WEIGHT)
            .fontColor(this.getGradeColor())
            .margin({ bottom: Constants.SMALL_SPACE })

          Text(this.comment)
            .fontSize(Constants.NORMAL_SIZE)
            .fontColor(Constants.TEXT_SECONDARY)
            .textAlign(TextAlign.Center)
            .padding({ left: 20, right: 20 })
        }
        .width(Constants.FULL_PARENT)
        .padding({ top: 20, bottom: 20 })
        .backgroundColor(Color.White)
        .borderRadius(Constants.BORDER_RADIUS_LARGE)
        .margin({ bottom: Constants.SPACE_SIZE })
        .shadow({
          radius: Constants.SHADOW_RADIUS,
          color: Constants.SHADOW_COLOR,
          offsetX: Constants.SHADOW_OFFSET_X,
          offsetY: Constants.SHADOW_OFFSET_Y
        })

        // 统计数据卡片
        Row() {
          // 总题数
          Column({ space: Constants.SMALL_SPACE }) {
            Text(`${this.totalQuestions}`)
              .fontSize(Constants.STATS_NUMBER_SIZE)
              .fontWeight(Constants.BOLD_WEIGHT)
              .fontColor(Constants.TEXT_PRIMARY)

            Text('总题数')
              .fontSize(Constants.STATS_LABEL_SIZE)
              .fontColor(Constants.TEXT_HINT)
          }
          .layoutWeight(1)

          Divider()
            .vertical(true)
            .height(40)
            .color(Constants.DIVIDER_COLOR)

          // 答对
          Column({ space: Constants.SMALL_SPACE }) {
            Text(`${this.correctCount}`)
              .fontSize(Constants.STATS_NUMBER_SIZE)
              .fontWeight(Constants.BOLD_WEIGHT)
              .fontColor(Constants.SUCCESS_COLOR)

            Text('答对')
              .fontSize(Constants.STATS_LABEL_SIZE)
              .fontColor(Constants.TEXT_HINT)
          }
          .layoutWeight(1)

          Divider()
            .vertical(true)
            .height(40)
            .color(Constants.DIVIDER_COLOR)

          // 答错
          Column({ space: Constants.SMALL_SPACE }) {
            Text(`${this.wrongCount}`)
              .fontSize(Constants.STATS_NUMBER_SIZE)
              .fontWeight(Constants.BOLD_WEIGHT)
              .fontColor(Constants.ERROR_COLOR)

            Text('答错')
              .fontSize(Constants.STATS_LABEL_SIZE)
              .fontColor(Constants.TEXT_HINT)
          }
          .layoutWeight(1)

          Divider()
            .vertical(true)
            .height(40)
            .color(Constants.DIVIDER_COLOR)

          // 正确率
          Column({ space: Constants.SMALL_SPACE }) {
            Text(`${this.accuracy}%`)
              .fontSize(Constants.STATS_NUMBER_SIZE)
              .fontWeight(Constants.BOLD_WEIGHT)
              .fontColor(Constants.INFO_COLOR)

            Text('正确率')
              .fontSize(Constants.STATS_LABEL_SIZE)
              .fontColor(Constants.TEXT_HINT)
          }
          .layoutWeight(1)
        }
        .width(Constants.FULL_PARENT)
        .padding(Constants.STATS_CARD_PADDING)
        .backgroundColor(Color.White)
        .borderRadius(Constants.BORDER_RADIUS_LARGE)
        .margin({ bottom: Constants.SPACE_SIZE })
        .shadow({
          radius: Constants.SHADOW_RADIUS,
          color: Constants.SHADOW_COLOR,
          offsetX: Constants.SHADOW_OFFSET_X,
          offsetY: Constants.SHADOW_OFFSET_Y
        })

        // 答题耗时（如果有）
        if (this.timeSpent !== undefined) {
          Row({ space: Constants.SMALL_SPACE }) {
            Text('⏱️')
              .fontSize(20)

            Text(`答题耗时：${this.formatTime(this.timeSpent!)}`)
              .fontSize(Constants.NORMAL_SIZE)
              .fontColor(Constants.TEXT_SECONDARY)
          }
          .padding({
            left: Constants.COLUMN_PADDING,
            right: Constants.COLUMN_PADDING,
            top: Constants.SMALL_SPACE,
            bottom: Constants.SMALL_SPACE
          })
          .backgroundColor(Constants.BG_LIGHT_BLUE)
          .borderRadius(Constants.BORDER_RADIUS_SMALL)
          .margin({ bottom: Constants.SPACE_SIZE })
          .alignSelf(ItemAlign.Start)
        }

        // 答题卡区域
        Column() {
          // 标题和图例
          Row() {
            Text('答题卡')
              .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
              .fontWeight(Constants.BOLD_WEIGHT)
              .fontColor(Constants.TEXT_PRIMARY)

            // 状态图例
            Row({ space: Constants.ANSWER_CARD_STATUS_ITEM_SPACE }) {
              Row({ space: 4 }) {
                Circle()
                  .width(Constants.ANSWER_CARD_STATUS_INDICATOR_SIZE)
                  .height(Constants.ANSWER_CARD_STATUS_INDICATOR_SIZE)
                  .fill(Constants.STATUS_INDICATOR_UNANSWERED_COLOR)
                Text('未答')
                  .fontSize(Constants.ANSWER_CARD_STATUS_TEXT_SIZE)
                  .fontColor(Constants.TEXT_HINT)
              }

              Row({ space: 4 }) {
                Circle()
                  .width(Constants.ANSWER_CARD_STATUS_INDICATOR_SIZE)
                  .height(Constants.ANSWER_CARD_STATUS_INDICATOR_SIZE)
                  .fill(Constants.STATUS_INDICATOR_CORRECT_COLOR)
                Text('答对')
                  .fontSize(Constants.ANSWER_CARD_STATUS_TEXT_SIZE)
                  .fontColor(Constants.SUCCESS_COLOR)
              }

              Row({ space: 4 }) {
                Circle()
                  .width(Constants.ANSWER_CARD_STATUS_INDICATOR_SIZE)
                  .height(Constants.ANSWER_CARD_STATUS_INDICATOR_SIZE)
                  .fill(Constants.STATUS_INDICATOR_WRONG_COLOR)
                Text('答错')
                  .fontSize(Constants.ANSWER_CARD_STATUS_TEXT_SIZE)
                  .fontColor(Constants.ERROR_COLOR)
              }
            }
          }
          .width(Constants.FULL_PARENT)
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ bottom: Constants.ANSWER_CARD_GRID_MARGIN_TOP })

          // 答题卡网格
          Grid() {
            ForEach(this.questionStatus, (status: number, index: number) => {
              GridItem() {
                Text(`${index + 1}`)
                  .fontSize(Constants.NORMAL_SIZE)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(this.getTextColor(status))
              }
              .height(Constants.GRID_ITEM_SIZE)
              .borderRadius(Constants.BORDER_RADIUS_SMALL)
              .backgroundColor(this.getStatusColor(status))
              .justifyContent(FlexAlign.Center)
              .onClick(() => {
                this.handleQuestionClick(index)
              })
              .stateStyles({
                pressed: {
                  .scale({ x: 0.95, y: 0.95 })
                  .opacity(0.8)
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
            })
          }
          .width(Constants.FULL_PARENT)
          .columnsTemplate(Constants.GRID_COLUMN_TEMPLATE)
          .columnsGap(Constants.GRID_COLUMNS_GAP)
          .rowsGap(Constants.GRID_ROWS_GAP)
          .margin({ bottom: Constants.ITEM_SPACE })
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

        // 操作按钮区域
        Column({ space: Constants.ITEM_SPACE }) {
          // 重新答题按钮
          Button('重新答题')
            .width(Constants.BUTTON_WIDTH_PERCENT)
            .height(Constants.BUTTON_HEIGHT)
            .fontSize(Constants.BUTTON_FONT_SIZE)
            .fontColor(Color.White)
            .borderRadius(Constants.BUTTON_BORDER_RADIUS)
            .linearGradient({
              direction: Constants.GRADIENT_DIRECTION,
              colors: Constants.GRADIENT_COLORS as [[string, number], [string, number]]
            })
            .onClick(() => {
              this.handleRetry()
            })

          // 查看答案解析按钮
          Button('查看答案解析')
            .width(Constants.BUTTON_WIDTH_PERCENT)
            .height(Constants.BUTTON_HEIGHT)
            .fontSize(Constants.BUTTON_FONT_SIZE)
            .fontColor(Constants.PRIMARY_COLOR)
            .borderRadius(Constants.BUTTON_BORDER_RADIUS)
            .backgroundColor(Color.White)
            .border({
              width: 2,
              color: Constants.PRIMARY_COLOR
            })
            .onClick(() => {
              this.handleViewExplanation()
            })

          // 返回首页按钮
          Button('返回首页')
            .width(Constants.BUTTON_WIDTH_PERCENT)
            .height(Constants.BUTTON_HEIGHT)
            .fontSize(Constants.BUTTON_FONT_SIZE)
            .fontColor(Constants.TEXT_SECONDARY)
            .borderRadius(Constants.BUTTON_BORDER_RADIUS)
            .backgroundColor(Color.Transparent)
            .onClick(() => {
              this.handleGoHome()
            })
        }
        .width(Constants.FULL_PARENT)
        .padding({ bottom: 30 })
      }
      .width(Constants.FULL_PARENT)
      .padding(Constants.SPACE_SIZE)
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundImage($r('app.media.resultBg0'))
    .backgroundImageSize({ width: '100%', height: '100%' })
    .scrollBar(BarState.Off)
  }
}
