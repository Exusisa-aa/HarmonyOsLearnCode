import { Constants } from '../../common/Constants'
import { ExamTitle } from '../../components/ExamTitle'
import { Question, ExamAnswerManager, AnswerStatus } from '../../model/ExamAnswer'
import { StudyStatusManager } from '../../model/StudyStatus'
import router from '@ohos.router'
import promptAction from '@ohos.promptAction'

@Entry
@Component
export struct ExamDetail {
  // 当前题目索引
  @State currentQuestionIndex: number = 0
  // 用户答案数组，存储每道题选择的选项索引，-1表示未选择
  @State userAnswers: number[] = []
  // 当前级别
  @State currentLevel: string = '初级'
  // 当前题目列表
  @State questionList: Question[] = []

  // 计时器相关
  @State timeSpent: number = 0 // 已用时间（秒）
  private timer: number = -1

  // UI状态
  @State showAnswerCard: boolean = false // 是否显示答题卡
  @State slideOffset: number = 0 // 滑动手势偏移量

  // 初级题目
  private juniorQuestions: Question[] = [
    {
      id: 1,
      question: 'ArkTS 支持 any 类型',
      options: ['A. 正确', 'B. 错误'],
      correctAnswer: 0
    },
    {
      id: 2,
      question: 'HarmonyOS 使用 ArkUI 作为声明式 UI 框架',
      options: ['A. 正确', 'B. 错误'],
      correctAnswer: 0
    },
    {
      id: 3,
      question: '@State 装饰器用于装饰组件中的状态变量',
      options: ['A. 正确', 'B. 错误'],
      correctAnswer: 0
    }
  ]

  // 中级题目
  private intermediateQuestions: Question[] = [
    {
      id: 1,
      question: '@Prop 装饰的变量可以被子组件修改并同步回父组件',
      options: ['A. 正确', 'B. 错误'],
      correctAnswer: 1
    },
    {
      id: 2,
      question: 'LazyForEach 可以实现列表的懒加载以提升性能',
      options: ['A. 正确', 'B. 错误'],
      correctAnswer: 0
    },
    {
      id: 3,
      question: 'ArkUI 中的 Column 组件默认主轴方向是从上到下',
      options: ['A. 正确', 'B. 错误'],
      correctAnswer: 0
    }
  ]

  // 高级题目
  private seniorQuestions: Question[] = [
    {
      id: 1,
      question: '@Provide 和 @Consume 装饰器可以实现跨层级组件的双向数据同步',
      options: ['A. 正确', 'B. 错误'],
      correctAnswer: 0
    },
    {
      id: 2,
      question: 'HarmonyOS 的 Ability 只能是 UIAbility 类型',
      options: ['A. 正确', 'B. 错误'],
      correctAnswer: 1
    },
    {
      id: 3,
      question: '使用 @Observed 和 @ObjectLink 可以实现嵌套对象的深度观察',
      options: ['A. 正确', 'B. 错误'],
      correctAnswer: 0
    }
  ]

  aboutToAppear() {
    // 获取路由参数
    const params = router.getParams() as Record<string, string>
    if (params && params.level) {
      this.currentLevel = params.level
    }

    // 根据级别设置题目列表
    this.updateQuestionList()

    // 初始化用户答案数组
    this.userAnswers = new Array(this.questionList.length).fill(-1)

    // 启动计时器
    this.startTimer()
  }

  aboutToDisappear() {
    // 清除计时器
    this.stopTimer()
  }

  /**
   * 启动计时器
   */
  private startTimer(): void {
    this.timer = setInterval(() => {
      this.timeSpent++
    }, 1000)
  }

  /**
   * 停止计时器
   */
  private stopTimer(): void {
    if (this.timer !== -1) {
      clearInterval(this.timer)
      this.timer = -1
    }
  }

  /**
   * 更新题目列表
   */
  private updateQuestionList(): void {
    switch (this.currentLevel) {
      case Constants.LEVEL_INTERMEDIATE:
        this.questionList = this.intermediateQuestions
        break
      case Constants.LEVEL_SENIOR:
        this.questionList = this.seniorQuestions
        break
      default:
        this.questionList = this.juniorQuestions
        break
    }
  }

  /**
   * 计算已答题数量
   */
  private getAnsweredCount(): number {
    return this.userAnswers.filter(answer => answer !== -1).length
  }

  /**
   * 判断是否所有题目都已作答
   */
  private isAllAnswered(): boolean {
    return this.getAnsweredCount() === this.questionList.length
  }

  /**
   * 获取未答题目索引列表
   */
  private getUnansweredIndexes(): number[] {
    const unanswered: number[] = []
    this.userAnswers.forEach((answer, index) => {
      if (answer === -1) {
        unanswered.push(index)
      }
    })
    return unanswered
  }

  /**
   * 格式化时间
   */
  private formatTime(seconds: number): string {
    const minutes = Math.floor(seconds / 60)
    const secs = seconds % 60
    return `${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`
  }

  /**
   * 切换到上一题
   */
  private previousQuestion(): void {
    if (this.currentQuestionIndex > 0) {
      this.currentQuestionIndex--
      this.slideOffset = 0
    }
  }

  /**
   * 切换到下一题
   */
  private nextQuestion(): void {
    if (this.currentQuestionIndex < this.questionList.length - 1) {
      this.currentQuestionIndex++
      this.slideOffset = 0
    }
  }

  /**
   * 跳转到指定题目
   */
  private jumpToQuestion(index: number): void {
    if (index >= 0 && index < this.questionList.length) {
      this.currentQuestionIndex = index
      this.showAnswerCard = false
    }
  }

  /**
   * 选择选项
   */
  private selectOption(optionIndex: number): void {
    this.userAnswers[this.currentQuestionIndex] = optionIndex
  }

  /**
   * 显示确认提交对话框
   */
  private showSubmitConfirm(): void {
    const unansweredCount = this.questionList.length - this.getAnsweredCount()

    let message = '确定要提交答案吗？'
    if (unansweredCount > 0) {
      message = `还有 ${unansweredCount} 道题未作答，确定要提交吗？`
    }

    promptAction.showDialog({
      title: '提示',
      message: message,
      buttons: [
        {
          text: '取消',
          color: Constants.TEXT_SECONDARY
        },
        {
          text: '确定',
          color: Constants.PRIMARY_COLOR
        }
      ]
    }).then((result) => {
      if (result.index === 1) {
        this.submitAnswers()
      }
    })
  }

  /**
   * 提交答案
   */
  private submitAnswers(): void {
    // 停止计时器
    this.stopTimer()

    // 标记该级别为已学习
    StudyStatusManager.markAsStudied(this.currentLevel, undefined, this.timeSpent)

    // 批改答案
    const result = ExamAnswerManager.gradeAnswers(this.questionList, this.userAnswers, this.timeSpent)

    // 跳转到答题结果页
    router.pushUrl({
      url: Constants.ROUTE_ANSWER_RESULT,
      params: {
        totalQuestions: result.totalQuestions,
        correctCount: result.correctCount,
        wrongCount: result.wrongCount,
        unansweredCount: result.unansweredCount,
        score: result.score,
        questionStatus: result.questionStatus,
        accuracy: result.accuracy,
        timeSpent: result.timeSpent
      }
    })
  }

  /**
   * 获取选项字母
   */
  private getOptionLetter(index: number): string {
    return String.fromCharCode(65 + index) // A, B, C, D...
  }

  build() {
    Stack() {
      Column() {
        // 顶部标题栏
        ExamTitle({
          titleText: `${this.currentLevel}答题`,
          titleColor: Color.White,
          back: $r('app.media.back0'),
          rightIcon: $r('app.media.default_profile0'),
          onRightClick: () => {
            router.pushUrl({
              url: Constants.ROUTE_PROFILE
            })
          }
        })

        // 主体答题面板
        Column() {
          // 进度信息栏
          Row() {
            // 题目进度
            Text() {
              Span('题目 ')
                .fontColor(Constants.TEXT_SECONDARY)
              Span(`${this.currentQuestionIndex + 1}`)
                .fontColor(Constants.PRIMARY_COLOR)
                .fontWeight(FontWeight.Bold)
              Span(` / ${this.questionList.length}`)
                .fontColor(Constants.TEXT_SECONDARY)
            }
            .fontSize(Constants.NORMAL_SIZE)

            // 计时器
            Text(`⏱ ${this.formatTime(this.timeSpent)}`)
              .fontSize(Constants.NORMAL_SIZE)
              .fontColor(Constants.WARNING_COLOR)
              .fontWeight(FontWeight.Medium)
          }
          .width(Constants.FULL_PARENT)
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({
            left: Constants.COLUMN_PADDING,
            right: Constants.COLUMN_PADDING,
            top: Constants.SMALL_SPACE,
            bottom: Constants.SMALL_SPACE
          })
          .backgroundColor(Constants.BG_LIGHT_YELLOW)

          // 进度条
          Progress({
            value: this.currentQuestionIndex + 1,
            total: this.questionList.length,
            type: ProgressType.Linear
          })
            .width(Constants.FULL_PARENT)
            .height(4)
            .color(Constants.PRIMARY_COLOR)
            .backgroundColor(Constants.BG_GRAY)

          // 题目内容区域
          Column({ space: Constants.SPACE_SIZE }) {
            // 题号和题干
            Column({ space: Constants.SMALL_SPACE }) {
              // 题号标签
              Text(`第 ${this.currentQuestionIndex + 1} 题`)
                .fontSize(Constants.NORMAL_SIZE)
                .fontColor(Constants.PRIMARY_COLOR)
                .fontWeight(FontWeight.Medium)
                .padding({
                  left: Constants.SMALL_SPACE,
                  right: Constants.SMALL_SPACE,
                  top: 4,
                  bottom: 4
                })
                .backgroundColor(Constants.BG_LIGHT_BLUE)
                .borderRadius(Constants.BORDER_RADIUS_SMALL)
                .alignSelf(ItemAlign.Start)

              // 题干
              Text(this.questionList[this.currentQuestionIndex].question)
                .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
                .fontWeight(FontWeight.Bold)
                .fontColor(Constants.TEXT_PRIMARY)
                .lineHeight(24)
                .width(Constants.FULL_PARENT)
            }
            .width(Constants.FULL_PARENT)
            .alignItems(HorizontalAlign.Start)

            // 选项列表
            Column({ space: Constants.SMALL_SPACE }) {
              ForEach(this.questionList[this.currentQuestionIndex].options,
                (option: string, index: number) => {
                  Row({ space: Constants.SMALL_SPACE }) {
                    // 选项字母
                    Text(this.getOptionLetter(index))
                      .width(30)
                      .height(30)
                      .textAlign(TextAlign.Center)
                      .fontSize(Constants.NORMAL_SIZE)
                      .fontWeight(FontWeight.Bold)
                      .fontColor(
                        this.userAnswers[this.currentQuestionIndex] === index
                          ? Color.White
                          : Constants.PRIMARY_COLOR
                      )
                      .backgroundColor(
                        this.userAnswers[this.currentQuestionIndex] === index
                          ? Constants.PRIMARY_COLOR
                          : Color.Transparent
                      )
                      .borderRadius(Constants.BORDER_RADIUS_CIRCLE)
                      .border({
                        width: 2,
                        color: this.userAnswers[this.currentQuestionIndex] === index
                          ? Constants.PRIMARY_COLOR
                          : Constants.BORDER_COLOR
                      })

                    // 选项内容
                    Text(option.substring(3)) // 去掉 "A. " 前缀
                      .layoutWeight(1)
                      .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
                      .fontColor(
                        this.userAnswers[this.currentQuestionIndex] === index
                          ? Constants.PRIMARY_COLOR
                          : Constants.TEXT_PRIMARY
                      )
                      .fontWeight(
                        this.userAnswers[this.currentQuestionIndex] === index
                          ? FontWeight.Medium
                          : FontWeight.Regular
                      )
                  }
                  .width(Constants.FULL_PARENT)
                  .padding({
                    left: Constants.COLUMN_PADDING,
                    right: Constants.COLUMN_PADDING,
                    top: Constants.SMALL_SPACE,
                    bottom: Constants.SMALL_SPACE
                  })
                  .backgroundColor(
                    this.userAnswers[this.currentQuestionIndex] === index
                      ? Constants.BG_LIGHT_BLUE
                      : Color.White
                  )
                  .borderRadius(Constants.BORDER_RADIUS_MEDIUM)
                  .border({
                    width: 2,
                    color: this.userAnswers[this.currentQuestionIndex] === index
                      ? Constants.PRIMARY_COLOR
                      : Constants.BORDER_COLOR
                  })
                  .shadow(
                    this.userAnswers[this.currentQuestionIndex] === index
                      ? {
                      radius: 8,
                      color: 'rgba(76, 175, 80, 0.2)',
                      offsetX: 0,
                      offsetY: 2
                    }
                      : undefined
                  )
                  .onClick(() => {
                    this.selectOption(index)
                  })
                  .stateStyles({
                    pressed: {
                      .scale({ x: 0.98, y: 0.98 })
                    },
                    normal: {
                      .scale({ x: 1, y: 1 })
                    }
                  })
                  .animation({
                    duration: Constants.ANIMATION_DURATION,
                    easing: Constants.ANIMATION_EASING
                  })
                },
                (item: string, index: number) => `${this.currentQuestionIndex}_${index}`
              )
            }
            .width(Constants.FULL_PARENT)
          }
          .width(Constants.FULL_PARENT)
          .layoutWeight(1)
          .backgroundColor(Color.White)
          .padding(Constants.SPACE_SIZE)
          .scrollBar(BarState.Off)

          // 底部操作栏
          Column({ space: Constants.SMALL_SPACE }) {
            // 提交按钮
            Button('提交答案')
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
                this.showSubmitConfirm()
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

            // 上一题/下一题按钮
            Row() {
              Button('上一题')
                .layoutWeight(1)
                .height(Constants.BUTTON_HEIGHT)
                .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
                .fontColor(Constants.TEXT_PRIMARY)
                .backgroundColor(Color.White)
                .borderRadius(Constants.BORDER_RADIUS_MEDIUM)
                .border({
                  width: 1,
                  color: Constants.BORDER_COLOR
                })
                .enabled(this.currentQuestionIndex > 0)
                .opacity(this.currentQuestionIndex > 0 ? 1 : 0.5)
                .onClick(() => {
                  this.previousQuestion()
                })

              Button('下一题')
                .layoutWeight(1)
                .height(Constants.BUTTON_HEIGHT)
                .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
                .fontColor(Color.White)
                .backgroundColor(Constants.PRIMARY_COLOR)
                .borderRadius(Constants.BORDER_RADIUS_MEDIUM)
                .margin({ left: Constants.SMALL_SPACE })
                .enabled(this.currentQuestionIndex < this.questionList.length - 1)
                .opacity(this.currentQuestionIndex < this.questionList.length - 1 ? 1 : 0.5)
                .onClick(() => {
                  this.nextQuestion()
                })
            }
            .width(Constants.FULL_PARENT)
          }
          .width(Constants.FULL_PARENT)
          .padding({
            left: Constants.SPACE_SIZE,
            right: Constants.SPACE_SIZE,
            top: Constants.SMALL_SPACE,
            bottom: Constants.SPACE_SIZE
          })
          .backgroundColor(Color.White)
        }
        .width(Constants.FULL_PARENT)
        .layoutWeight(1)
        .backgroundColor(Color.White)
        .borderRadius({
          topLeft: Constants.PANEL_SIZE,
          topRight: Constants.PANEL_SIZE
        })
      }
      .width(Constants.FULL_PARENT)
      .height(Constants.FULL_PARENT)
      .backgroundColor(Constants.PRIMARY_COLOR)

      // 浮动答题卡按钮
      Button('答题卡')
        .position({ x: '80%', y: '60%' })
        .width(60)
        .height(60)
        .fontSize(12)
        .fontColor(Color.White)
        .backgroundColor(Constants.INFO_COLOR)
        .borderRadius(Constants.BORDER_RADIUS_CIRCLE)
        .shadow({
          radius: 10,
          color: 'rgba(0, 0, 0, 0.2)',
          offsetX: 0,
          offsetY: 4
        })
        .onClick(() => {
          this.showAnswerCard = !this.showAnswerCard
        })
        .stateStyles({
          pressed: {
            .scale({ x: 0.9, y: 0.9 })
          },
          normal: {
            .scale({ x: 1, y: 1 })
          }
        })
        .animation({
          duration: Constants.ANIMATION_DURATION,
          easing: Constants.ANIMATION_EASING
        })

      // 答题卡弹窗
      if (this.showAnswerCard) {
        Column() {
          // 弹窗标题
          Row() {
            Text('答题卡')
              .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
              .fontWeight(FontWeight.Bold)
              .fontColor(Constants.TEXT_PRIMARY)

            Text(`已答 ${this.getAnsweredCount()}/${this.questionList.length}`)
              .fontSize(Constants.NORMAL_SIZE)
              .fontColor(Constants.TEXT_SECONDARY)
          }
          .width(Constants.FULL_PARENT)
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ bottom: Constants.SMALL_SPACE })

          // 答题卡网格
          Grid() {
            ForEach(this.questionList, (question: Question, index: number) => {
              GridItem() {
                Text(`${index + 1}`)
                  .fontSize(Constants.NORMAL_SIZE)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(
                    this.userAnswers[index] !== -1
                      ? Color.White
                      : Constants.TEXT_PRIMARY
                  )
              }
              .width(45)
              .height(45)
              .justifyContent(FlexAlign.Center)
              .backgroundColor(
                this.userAnswers[index] !== -1
                  ? Constants.PRIMARY_COLOR
                  : Color.White
              )
              .borderRadius(Constants.BORDER_RADIUS_SMALL)
              .border({
                width: 1,
                color: this.currentQuestionIndex === index
                  ? Constants.PRIMARY_COLOR
                  : Constants.BORDER_COLOR
              })
              .onClick(() => {
                this.jumpToQuestion(index)
              })
            })
          }
          .width(Constants.FULL_PARENT)
          .columnsTemplate('repeat(5, 1fr)')
          .columnsGap(Constants.SMALL_SPACE)
          .rowsGap(Constants.SMALL_SPACE)
          .margin({ bottom: Constants.ITEM_SPACE })

          // 图例
          Row({ space: Constants.ITEM_SPACE }) {
            Row({ space: 4 }) {
              Circle()
                .width(12)
                .height(12)
                .fill(Constants.PRIMARY_COLOR)
              Text('已答')
                .fontSize(12)
                .fontColor(Constants.TEXT_SECONDARY)
            }

            Row({ space: 4 }) {
              Circle()
                .width(12)
                .height(12)
                .fill(Color.White)
                .stroke(Constants.BORDER_COLOR)
                .strokeWidth(1)
              Text('未答')
                .fontSize(12)
                .fontColor(Constants.TEXT_SECONDARY)
            }
          }
          .margin({ bottom: Constants.ITEM_SPACE })

          // 关闭按钮
          Button('关闭')
            .width(Constants.FULL_PARENT)
            .height(Constants.BUTTON_HEIGHT)
            .fontSize(Constants.NORMAL_TEXT_FONT_SIZE)
            .fontColor(Color.White)
            .backgroundColor(Constants.INFO_COLOR)
            .borderRadius(Constants.BORDER_RADIUS_MEDIUM)
            .onClick(() => {
              this.showAnswerCard = false
            })
        }
        .width('80%')
        .padding(Constants.SPACE_SIZE)
        .backgroundColor(Color.White)
        .borderRadius(Constants.BORDER_RADIUS_LARGE)
        .shadow({
          radius: 20,
          color: 'rgba(0, 0, 0, 0.3)',
          offsetX: 0,
          offsetY: 8
        })
        .position({ x: '10%', y: '20%' })
        .animation({
          duration: Constants.ANIMATION_DURATION,
          easing: Constants.ANIMATION_EASING
        })
      }
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .gesture(
      GestureGroup(GesturePriority.Default,
        // 左滑 - 下一题
        SwipeGesture({ direction: SwipeDirection.Left })
          .onAction(() => {
            this.nextQuestion()
          }),
        // 右滑 - 上一题
        SwipeGesture({ direction: SwipeDirection.Right })
          .onAction(() => {
            this.previousQuestion()
          })
      )
    )
  }
}
