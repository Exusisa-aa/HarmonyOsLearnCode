import { Constants } from '../common/Constants'
import { ExamTitle } from '../components/ExamTitle'
import { StudyStatusManager, StudyStatistics } from '../model/StudyStatus'
import router from '@ohos.router'

// 级别配置信息
interface LevelConfig {
  name: string
  icon: string
  questionCount: number
  difficulty: number // 1-5星
  description: string
  color: string
}

@Entry
@Component
export struct Exam {
  // 学习状态
  @State studyStatus: Record<string, boolean> = {}

  // 学习统计
  @State statistics: StudyStatistics = {
    totalLevels: 0,
    studiedLevels: 0,
    completionRate: 0,
    overallAverageScore: 0,
    bestOverallScore: 0,
    levelDetails: new Map()
  }

  // 级别配置
  private levelConfigs: LevelConfig[] = [
    {
      name: Constants.LEVEL_JUNIOR,
      icon: '🌱',
      questionCount: 3,
      difficulty: 1,
      description: '基础概念与语法',
      color: '#4CAF50'
    },
    {
      name: Constants.LEVEL_INTERMEDIATE,
      icon: '🚀',
      questionCount: 3,
      difficulty: 3,
      description: '进阶特性与应用',
      color: '#2196F3'
    },
    {
      name: Constants.LEVEL_SENIOR,
      icon: '👑',
      questionCount: 3,
      difficulty: 5,
      description: '高级架构与优化',
      color: '#9C27B0'
    }
  ]

  aboutToAppear() {
    // 获取学习状态
    this.updateStudyStatus()
  }

  onPageShow() {
    // 每次页面显示时刷新学习状态
    this.updateStudyStatus()
  }

  /**
   * 更新学习状态和统计信息
   */
  private updateStudyStatus(): void {
    this.studyStatus = StudyStatusManager.getAllStatus()
    this.statistics = StudyStatusManager.getStatistics()
  }

  /**
   * 生成难度星级字符串
   */
  private getDifficultyStars(difficulty: number): string {
    const fullStars = '★'.repeat(difficulty)
    const emptyStars = '☆'.repeat(5 - difficulty)
    return fullStars + emptyStars
  }

  /**
   * 获取难度颜色
   */
  private getDifficultyColor(difficulty: number): ResourceColor {
    if (difficulty <= 2) {
      return Constants.SUCCESS_COLOR
    } else if (difficulty <= 3) {
      return Constants.WARNING_COLOR
    } else {
      return Constants.ERROR_COLOR
    }
  }

  /**
   * 跳转到考试详情
   */
  private navigateToExam(level: string): void {
    router.pushUrl({
      url: Constants.ROUTE_EXAM_DETAIL,
      params: { level: level }
    })
  }

  /**
   * 跳转到个人中心
   */
  private navigateToProfile(): void {
    router.pushUrl({
      url: Constants.ROUTE_PROFILE,
      params: {
        totalQuestions: this.statistics.studiedLevels,
        wrongQuestions: 0
      }
    })
  }

  build() {
    Column() {
      // 顶部标题栏
      ExamTitle({
        titleText: '习题列表',
        titleColor: Color.White,
        back: $r('app.media.back0'),
        rightIcon: $r('app.media.default_profile0'),
        onRightClick: () => {
          this.navigateToProfile()
        }
      })

      // 学习进度概览卡片
      Column() {
        Row() {
          // 左侧 - 完成进度
          Column({ space: Constants.SMALL_SPACE }) {
            Text('学习进度')
              .fontSize(Constants.NORMAL_SIZE)
              .fontColor(Constants.TEXT_SECONDARY)

            Row({ space: 4 }) {
              Text(`${this.statistics.studiedLevels}`)
                .fontSize(28)
                .fontWeight(Constants.BOLD_WEIGHT)
                .fontColor(Constants.PRIMARY_COLOR)

              Text(`/ ${this.statistics.totalLevels}`)
                .fontSize(Constants.NORMAL_SIZE)
                .fontColor(Constants.TEXT_HINT)
            }

            Text('已完成科目')
              .fontSize(12)
              .fontColor(Constants.TEXT_HINT)
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)

          // 右侧 - 完成率圆形进度
          Stack() {
            Circle()
              .width(70)
              .height(70)
              .fill(Color.Transparent)
              .stroke(Constants.BG_GRAY)
              .strokeWidth(6)

            Circle()
              .width(70)
              .height(70)
              .fill(Color.Transparent)
              .stroke(Constants.PRIMARY_COLOR)
              .strokeWidth(6)
              .strokeDashArray([220 * this.statistics.completionRate / 100, 220])
              .rotate({ angle: -90 })

            Text(`${this.statistics.completionRate}%`)
              .fontSize(16)
              .fontWeight(Constants.BOLD_WEIGHT)
              .fontColor(Constants.PRIMARY_COLOR)
          }
          .width(80)
          .height(80)
        }
        .width(Constants.FULL_PARENT)
        .padding({ left: 5, right: 5 })

        // 进度条
        Progress({
          value: this.statistics.completionRate,
          total: 100,
          type: ProgressType.Linear
        })
          .width(Constants.FULL_PARENT)
          .height(6)
          .color(Constants.PRIMARY_COLOR)
          .backgroundColor(Constants.BG_GRAY)
          .borderRadius(3)
          .margin({ top: Constants.SMALL_SPACE })
      }
      .width(Constants.FULL_PARENT)
      .padding(Constants.SPACE_SIZE)
      .backgroundColor(Color.White)
      .borderRadius({
        bottomLeft: Constants.BORDER_RADIUS_LARGE,
        bottomRight: Constants.BORDER_RADIUS_LARGE
      })
      .shadow({
        radius: Constants.SHADOW_RADIUS,
        color: Constants.SHADOW_COLOR,
        offsetX: Constants.SHADOW_OFFSET_X,
        offsetY: Constants.SHADOW_OFFSET_Y
      })

      // 习题列表
      List({ space: Constants.SPACE_SIZE }) {
        ForEach(this.levelConfigs, (config: LevelConfig, index: number) => {
          ListItem() {
            Column() {
              Row() {
                // 左侧图标和标题
                Row({ space: Constants.SPACE_SIZE }) {
                  // 图标背景
                  Column() {
                    Text(config.icon)
                      .fontSize(24)
                  }
                  .width(50)
                  .height(50)
                  .justifyContent(FlexAlign.Center)
                  .backgroundColor(`${config.color}15`)
                  .borderRadius(Constants.BORDER_RADIUS_MEDIUM)

                  // 标题信息
                  Column({ space: 4 }) {
                    Row({ space: Constants.SMALL_SPACE }) {
                      Text(`鸿蒙认证${config.name}`)
                        .fontSize(Constants.TAB_TEXT_SIZE)
                        .fontWeight(Constants.BOLD_WEIGHT)
                        .fontColor(Constants.TEXT_PRIMARY)

                      Text('- 选择题')
                        .fontSize(Constants.NORMAL_SIZE)
                        .fontColor(Constants.TEXT_SECONDARY)
                    }

                    Text(config.description)
                      .fontSize(12)
                      .fontColor(Constants.TEXT_HINT)
                  }
                  .alignItems(HorizontalAlign.Start)
                  .layoutWeight(1)
                }
                .layoutWeight(1)

                // 右侧状态和箭头
                Column({ space: Constants.SMALL_SPACE }) {
                  // 学习状态标签
                  Text(this.studyStatus[config.name] ? '✓ 已学习' : '未学习')
                    .fontSize(11)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(
                      this.studyStatus[config.name]
                        ? Constants.SUCCESS_COLOR
                        : Constants.TEXT_HINT
                    )
                    .padding({
                      left: 8,
                      right: 8,
                      top: 3,
                      bottom: 3
                    })
                    .backgroundColor(
                      this.studyStatus[config.name]
                        ? `${Constants.SUCCESS_COLOR}15`
                        : Constants.BG_LIGHT
                    )
                    .borderRadius(Constants.BORDER_RADIUS_SMALL)

                  // 难度星级
                  Text(this.getDifficultyStars(config.difficulty))
                    .fontSize(12)
                    .fontColor(this.getDifficultyColor(config.difficulty))
                }
                .alignItems(HorizontalAlign.End)

                // 箭头图标
                Text('›')
                  .fontSize(24)
                  .fontColor(Constants.TEXT_HINT)
                  .margin({ left: Constants.SMALL_SPACE })
              }
              .width(Constants.FULL_PARENT)
              .alignItems(VerticalAlign.Center)

              // 底部信息栏
              Row() {
                // 题目数量
                Row({ space: 4 }) {
                  Text('📝')
                    .fontSize(14)
                  Text(`${config.questionCount} 道题`)
                    .fontSize(12)
                    .fontColor(Constants.TEXT_HINT)
                }

                // 最佳成绩（如果已学习）
                if (this.studyStatus[config.name]) {
                  Row({ space: 4 }) {
                    Text('🏆')
                      .fontSize(14)
                    Text(`最佳: ${StudyStatusManager.getBestScore(config.name) || '-'}分`)
                      .fontSize(12)
                      .fontColor(Constants.WARNING_COLOR)
                  }
                }
              }
              .width(Constants.FULL_PARENT)
              .justifyContent(FlexAlign.SpaceBetween)
              .margin({ top: Constants.SMALL_SPACE })
              .padding({ top: Constants.SMALL_SPACE })
              .border({
                width: { top: 1 },
                color: Constants.BORDER_COLOR
              })
            }
            .width(Constants.FULL_PARENT)
            .padding(Constants.COLUMN_PADDING)
            .onClick(() => {
              this.navigateToExam(config.name)
            })
            .stateStyles({
              pressed: {
                .scale({ x: 0.98, y: 0.98 })
                .backgroundColor(Constants.BG_LIGHT)
              },
              normal: {
                .scale({ x: 1, y: 1 })
                .backgroundColor(Color.White)
              }
            })
            .animation({
              duration: Constants.ANIMATION_DURATION,
              easing: Constants.ANIMATION_EASING
            })
          }
        }, (config: LevelConfig) => config.name)
      }
      .width(Constants.FULL_PARENT)
      .layoutWeight(1)
      .padding({
        left: Constants.SPACE_SIZE,
        right: Constants.SPACE_SIZE,
        top: Constants.SPACE_SIZE
      })
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
    }
    .width(Constants.FULL_PARENT)
    .height(Constants.FULL_PARENT)
    .backgroundColor(Constants.BG_LIGHT)
  }
}
