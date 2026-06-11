// ==================== 枚举定义 ====================

/**
 * 题目难度枚举
 */
export enum QuestionDifficulty {
  EASY = '简单',
  MEDIUM = '中等',
  HARD = '困难'
}

/**
 * 题目类型枚举
 */
export enum QuestionType {
  SINGLE_CHOICE = '单选题',
  MULTIPLE_CHOICE = '多选题',
  TRUE_FALSE = '判断题'
}

/**
 * 答题状态枚举
 */
export enum AnswerStatus {
  UNANSWERED = 0,  // 未答
  CORRECT = 1,     // 答对
  WRONG = 2        // 答错
}

/**
 * 成绩等级枚举
 */
export enum GradeLevel {
  EXCELLENT = '优秀',      // 90-100分
  GOOD = '良好',           // 80-89分
  MEDIUM = '中等',         // 70-79分
  PASS = '及格',           // 60-69分
  FAIL = '不及格'          // 0-59分
}

// ==================== 接口定义 ====================

/**
 * 题目数据结构
 */
export interface Question {
  id: number                    // 题目ID
  question: string              // 题干
  options: string[]             // 选项列表
  correctAnswer: number         // 正确答案索引
  difficulty?: QuestionDifficulty  // 题目难度（可选）
  type?: QuestionType              // 题目类型（可选）
  explanation?: string            // 答案解析（可选）
  score?: number                  // 题目分值（可选，默认根据总题数平均分配）
}

/**
 * 答题结果数据结构
 */
export interface AnswerResult {
  totalQuestions: number        // 总题数
  correctCount: number          // 答对数量
  wrongCount: number            // 答错数量
  unansweredCount: number       // 未答数量
  score: number                 // 得分（满分100）
  questionStatus: number[]      // 每道题的状态：0-未答，1-答对，2-答错
  accuracy: number              // 正确率（百分比）
  gradeLevel: GradeLevel        // 成绩等级
  comment: string               // 成绩评语
  timeSpent?: number            // 答题耗时（秒，可选）
}

/**
 * 答题统计信息
 */
export interface AnswerStatistics {
  totalQuestions: number        // 总题数
  answeredQuestions: number     // 已答题数
  unansweredQuestions: number   // 未答题数
  correctRate: number           // 正确率
  averageTimePerQuestion?: number  // 平均每题耗时（秒）
  difficultyDistribution?: Map<QuestionDifficulty, number>  // 难度分布
  typeDistribution?: Map<QuestionType, number>  // 题型分布
}

// ==================== 答案管理类 ====================

/**
 * 考试答案管理类
 * 提供答案批改、统计分析等功能
 */
export class ExamAnswerManager {
  // 满分分数
  private static readonly FULL_SCORE = 100;

  // 成绩等级分数线
  private static readonly GRADE_EXCELLENT = 90;
  private static readonly GRADE_GOOD = 80;
  private static readonly GRADE_MEDIUM = 70;
  private static readonly GRADE_PASS = 60;

  /**
   * 批改答案
   * @param questions 题目列表
   * @param userAnswers 用户答案数组
   * @param timeSpent 答题耗时（秒，可选）
   * @returns 答题结果
   */
  static gradeAnswers(
    questions: Question[],
    userAnswers: number[],
    timeSpent?: number
  ): AnswerResult {
    const totalQuestions = questions.length

    // 参数验证
    if (totalQuestions === 0) {
      throw new Error('题目列表不能为空')
    }

    if (userAnswers.length !== totalQuestions) {
      throw new Error('用户答案数量与题目数量不匹配')
    }

    let correctCount = 0
    let wrongCount = 0
    let unansweredCount = 0
    const questionStatus: number[] = []

    // 逐题批改
    for (let i = 0; i < totalQuestions; i++) {
      const userAnswer = userAnswers[i]
      const correctAnswer = questions[i].correctAnswer

      if (userAnswer === -1 || userAnswer === undefined) {
        // 未答
        unansweredCount++
        questionStatus.push(AnswerStatus.UNANSWERED)
      } else if (userAnswer === correctAnswer) {
        // 答对
        correctCount++
        questionStatus.push(AnswerStatus.CORRECT)
      } else {
        // 答错
        wrongCount++
        questionStatus.push(AnswerStatus.WRONG)
      }
    }

    // 计算得分（满分100分）
    const score = Math.round((correctCount / totalQuestions) * this.FULL_SCORE)

    // 计算正确率
    const accuracy = Math.round((correctCount / totalQuestions) * 100)

    // 评定成绩等级
    const gradeLevel = this.getGradeLevel(score)

    // 生成成绩评语
    const comment = this.generateComment(score, gradeLevel, totalQuestions, correctCount, wrongCount, unansweredCount)

    return {
      totalQuestions,
      correctCount,
      wrongCount,
      unansweredCount,
      score,
      questionStatus,
      accuracy,
      gradeLevel,
      comment,
      timeSpent
    }
  }

  /**
   * 根据分数获取成绩等级
   * @param score 分数
   * @returns 成绩等级
   */
  static getGradeLevel(score: number): GradeLevel {
    if (score >= this.GRADE_EXCELLENT) {
      return GradeLevel.EXCELLENT
    } else if (score >= this.GRADE_GOOD) {
      return GradeLevel.GOOD
    } else if (score >= this.GRADE_MEDIUM) {
      return GradeLevel.MEDIUM
    } else if (score >= this.GRADE_PASS) {
      return GradeLevel.PASS
    } else {
      return GradeLevel.FAIL
    }
  }

  /**
   * 生成成绩评语
   * @param score 分数
   * @param gradeLevel 成绩等级
   * @param totalQuestions 总题数
   * @param correctCount 答对数量
   * @param wrongCount 答错数量
   * @param unansweredCount 未答数量
   * @returns 评语字符串
   */
  static generateComment(
    score: number,
    gradeLevel: GradeLevel,
    totalQuestions: number,
    correctCount: number,
    wrongCount: number,
    unansweredCount: number
  ): string {
    let comment = ''

    switch (gradeLevel) {
      case GradeLevel.EXCELLENT:
        comment = '太棒了！继续保持！'
        break
      case GradeLevel.GOOD:
        comment = '表现不错，再接再厉！'
        break
      case GradeLevel.MEDIUM:
        comment = '还有提升空间，加油！'
        break
      case GradeLevel.PASS:
        comment = '勉强及格，需要更加努力！'
        break
      case GradeLevel.FAIL:
        comment = '不及格，请认真复习后再试！'
        break
    }

    // 添加详细统计信息
    const details = `\n共${totalQuestions}题，答对${correctCount}题，答错${wrongCount}题`
    if (unansweredCount > 0) {
      comment += `${details}，未答${unansweredCount}题`
    } else {
      comment += details
    }

    return comment
  }

  /**
   * 获取答错的题目列表
   * @param questions 题目列表
   * @param userAnswers 用户答案数组
   * @returns 答错的题目列表
   */
  static getWrongQuestions(questions: Question[], userAnswers: number[]): Question[] {
    const wrongQuestions: Question[] = []

    for (let i = 0; i < questions.length; i++) {
      const userAnswer = userAnswers[i]
      const correctAnswer = questions[i].correctAnswer

      // 答错的题目
      if (userAnswer !== -1 && userAnswer !== undefined && userAnswer !== correctAnswer) {
        wrongQuestions.push(questions[i])
      }
    }

    return wrongQuestions
  }

  /**
   * 获取未答的题目列表
   * @param questions 题目列表
   * @param userAnswers 用户答案数组
   * @returns 未答的题目列表
   */
  static getUnansweredQuestions(questions: Question[], userAnswers: number[]): Question[] {
    const unansweredQuestions: Question[] = []

    for (let i = 0; i < questions.length; i++) {
      const userAnswer = userAnswers[i]

      // 未答的题目
      if (userAnswer === -1 || userAnswer === undefined) {
        unansweredQuestions.push(questions[i])
      }
    }

    return unansweredQuestions
  }

  /**
   * 获取答题统计信息
   * @param questions 题目列表
   * @param userAnswers 用户答案数组
   * @param timeSpent 答题耗时（秒，可选）
   * @returns 答题统计信息
   */
  static getStatistics(
    questions: Question[],
    userAnswers: number[],
    timeSpent?: number
  ): AnswerStatistics {
    const totalQuestions = questions.length
    const answeredQuestions = userAnswers.filter(answer => answer !== -1 && answer !== undefined).length
    const unansweredQuestions = totalQuestions - answeredQuestions

    // 计算正确率
    let correctCount = 0
    for (let i = 0; i < totalQuestions; i++) {
      if (userAnswers[i] === questions[i].correctAnswer) {
        correctCount++
      }
    }
    const correctRate = totalQuestions > 0 ? Math.round((correctCount / totalQuestions) * 100) : 0

    // 计算平均每题耗时
    const averageTimePerQuestion = timeSpent && answeredQuestions > 0
      ? Math.round(timeSpent / answeredQuestions)
      : undefined

    // 统计难度分布
    const difficultyDistribution = new Map<QuestionDifficulty, number>()
    questions.forEach(question => {
      const difficulty = question.difficulty || QuestionDifficulty.MEDIUM
      difficultyDistribution.set(
        difficulty,
        (difficultyDistribution.get(difficulty) || 0) + 1
      )
    })

    // 统计题型分布
    const typeDistribution = new Map<QuestionType, number>()
    questions.forEach(question => {
      const type = question.type || QuestionType.SINGLE_CHOICE
      typeDistribution.set(
        type,
        (typeDistribution.get(type) || 0) + 1
      )
    })

    return {
      totalQuestions,
      answeredQuestions,
      unansweredQuestions,
      correctRate,
      averageTimePerQuestion,
      difficultyDistribution,
      typeDistribution
    }
  }

  /**
   * 格式化答题结果为字符串
   * @param result 答题结果
   * @returns 格式化后的字符串
   */
  static formatResultToString(result: AnswerResult): string {
    const lines = [
      '========== 答题结果 ==========',
      `总分：${result.score}分`,
      `等级：${result.gradeLevel}`,
      `正确率：${result.accuracy}%`,
      `总题数：${result.totalQuestions}题`,
      `答对：${result.correctCount}题`,
      `答错：${result.wrongCount}题`,
      `未答：${result.unansweredCount}题`,
      `评语：${result.comment}`,
    ]

    if (result.timeSpent) {
      const minutes = Math.floor(result.timeSpent / 60)
      const seconds = result.timeSpent % 60
      lines.push(`用时：${minutes}分${seconds}秒`)
    }

    lines.push('========================')

    return lines.join('\n')
  }

  /**
   * 检查是否所有题目都已作答
   * @param userAnswers 用户答案数组
   * @returns true-全部作答，false-有未答题目
   */
  static isAllAnswered(userAnswers: number[]): boolean {
    return userAnswers.every(answer => answer !== -1 && answer !== undefined)
  }

  /**
   * 获取未答题目数量
   * @param userAnswers 用户答案数组
   * @returns 未答题目数量
   */
  static getUnansweredCount(userAnswers: number[]): number {
    return userAnswers.filter(answer => answer === -1 || answer === undefined).length
  }
}
