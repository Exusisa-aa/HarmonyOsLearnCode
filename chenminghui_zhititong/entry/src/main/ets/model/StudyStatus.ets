import { Constants } from '../common/Constants'

// ==================== 接口定义 ====================

/**
 * 学习状态详情
 */
export interface StudyStatusDetail {
  isStudied: boolean              // 是否已学习
  studyTime?: number              // 学习时间（时间戳）
  lastScore?: number              // 最近一次得分
  bestScore?: number              // 最佳成绩
  totalAttempts?: number          // 总答题次数
  averageScore?: number           // 平均得分
  lastStudyDuration?: number      // 最近一次学习时长（秒）
}

/**
 * 学习统计信息
 */
export interface StudyStatistics {
  totalLevels: number             // 总级别数
  studiedLevels: number           // 已学习级别数
  completionRate: number          // 完成率（百分比）
  overallAverageScore: number     // 总体平均分
  bestOverallScore: number        // 总体最佳成绩
  totalStudyTime?: number         // 总学习时长（秒）
  levelDetails: Map<string, StudyStatusDetail>  // 各级别详情
}

// ==================== 学习状态管理类 ====================

/**
 * 学习状态管理类
 * 负责管理和持久化存储用户的学习进度和状态
 */
export class StudyStatusManager {
  // 存储键名
  private static readonly STORAGE_KEY = Constants.STORAGE_STUDY_STATUS

  // 内存中的学习状态缓存
  private static studyStatusMap: Map<string, StudyStatusDetail> = new Map()

  // 是否已初始化
  private static isInitialized: boolean = false

  /**
   * 初始化学习状态管理器
   * 从本地存储加载数据
   */
  static async initialize(): Promise<void> {
    if (this.isInitialized) {
      return
    }

    try {
      await this.loadFromStorage()
      this.isInitialized = true
    } catch (error) {
      console.error('学习状态初始化失败:', error)
      // 初始化失败时使用默认值
      this.initializeDefaultStatus()
    }
  }

  /**
   * 初始化默认状态
   */
  private static initializeDefaultStatus(): void {
    this.studyStatusMap.clear()

    // 初始化三个级别的状态
    Constants.LEVELS.forEach(level => {
      this.studyStatusMap.set(level, {
        isStudied: false,
        totalAttempts: 0
      })
    })
  }

  /**
   * 标记某级别为已学习
   * @param level 级别名称
   * @param score 本次得分（可选）
   * @param duration 学习时长（秒，可选）
   */
  static async markAsStudied(
    level: string,
    score?: number,
    duration?: number
  ): Promise<void> {
    const now = Date.now()
    let status = this.studyStatusMap.get(level)

    if (!status) {
      // 如果该级别不存在，创建新状态
      status = {
        isStudied: false,
        totalAttempts: 0
      }
    }

    // 更新状态
    status.isStudied = true
    status.studyTime = now

    // 更新答题次数
    status.totalAttempts = (status.totalAttempts || 0) + 1

    // 更新得分信息
    if (score !== undefined) {
      status.lastScore = score

      // 更新最佳成绩
      if (!status.bestScore || score > status.bestScore) {
        status.bestScore = score
      }

      // 重新计算平均分
      this.recalculateAverageScore(status, score)
    }

    // 更新学习时长
    if (duration !== undefined) {
      status.lastStudyDuration = duration
    }

    // 保存到内存
    this.studyStatusMap.set(level, status)

    // 持久化到本地存储
    try {
      await this.saveToStorage()
    } catch (error) {
      console.error('保存学习状态失败:', error)
    }
  }

  /**
   * 重新计算平均分数
   * @param status 学习状态对象
   * @param newScore 新分数
   */
  private static recalculateAverageScore(status: StudyStatusDetail, newScore: number): void {
    const attempts = status.totalAttempts || 1
    const currentAverage = status.averageScore || 0

    // 使用增量方式计算新的平均值
    status.averageScore = Math.round(
      ((currentAverage * (attempts - 1)) + newScore) / attempts
    )
  }

  /**
   * 获取某级别的学习状态
   * @param level 级别名称
   * @returns 是否已学习
   */
  static isStudied(level: string): boolean {
    const status = this.studyStatusMap.get(level)
    return status?.isStudied || false
  }

  /**
   * 获取某级别的详细学习状态
   * @param level 级别名称
   * @returns 学习状态详情，不存在则返回默认值
   */
  static getStudyStatusDetail(level: string): StudyStatusDetail {
    return this.studyStatusMap.get(level) || {
      isStudied: false,
      totalAttempts: 0
    }
  }

  /**
   * 获取某级别的最佳成绩
   * @param level 级别名称
   * @returns 最佳成绩，未学习则返回 null
   */
  static getBestScore(level: string): number | null {
    const status = this.studyStatusMap.get(level)
    return status?.bestScore || null
  }

  /**
   * 获取某级别的最近一次得分
   * @param level 级别名称
   * @returns 最近一次得分，未学习则返回 null
   */
  static getLastScore(level: string): number | null {
    const status = this.studyStatusMap.get(level)
    return status?.lastScore || null
  }

  /**
   * 获取某级别的答题次数
   * @param level 级别名称
   * @returns 答题次数
   */
  static getAttemptCount(level: string): number {
    const status = this.studyStatusMap.get(level)
    return status?.totalAttempts || 0
  }

  /**
   * 获取所有学习状态（简化版，向后兼容）
   * @returns 级别名称到是否已学习的映射
   */
  static getAllStatus(): Record<string, boolean> {
    const result: Record<string, boolean> = {}

    Constants.LEVELS.forEach(level => {
      result[level] = this.isStudied(level)
    })

    return result
  }

  /**
   * 获取所有学习状态详情
   * @returns 级别名称到学习状态详情的映射
   */
  static getAllStatusDetails(): Map<string, StudyStatusDetail> {
    return new Map(this.studyStatusMap)
  }

  /**
   * 获取学习统计信息
   * @returns 学习统计信息
   */
  static getStatistics(): StudyStatistics {
    const totalLevels = Constants.LEVELS.length
    let studiedLevels = 0
    let totalScore = 0
    let scoreCount = 0
    let bestOverallScore = 0
    let totalStudyTime = 0

    Constants.LEVELS.forEach(level => {
      const status = this.studyStatusMap.get(level)

      if (status?.isStudied) {
        studiedLevels++

        if (status.lastScore !== undefined) {
          totalScore += status.lastScore
          scoreCount++
        }

        if (status.bestScore && status.bestScore > bestOverallScore) {
          bestOverallScore = status.bestScore
        }

        if (status.lastStudyDuration) {
          totalStudyTime += status.lastStudyDuration
        }
      }
    })

    const completionRate = totalLevels > 0
      ? Math.round((studiedLevels / totalLevels) * 100)
      : 0

    const overallAverageScore = scoreCount > 0
      ? Math.round(totalScore / scoreCount)
      : 0

    return {
      totalLevels,
      studiedLevels,
      completionRate,
      overallAverageScore,
      bestOverallScore,
      totalStudyTime,
      levelDetails: new Map(this.studyStatusMap)
    }
  }

  /**
   * 计算总体完成率
   * @returns 完成率（0-100）
   */
  static getCompletionRate(): number {
    const stats = this.getStatistics()
    return stats.completionRate
  }

  /**
   * 重置某级别的学习状态
   * @param level 级别名称
   */
  static async resetLevel(level: string): Promise<void> {
    this.studyStatusMap.delete(level)

    // 重新初始化为默认状态
    this.studyStatusMap.set(level, {
      isStudied: false,
      totalAttempts: 0
    })

    // 保存到本地存储
    try {
      await this.saveToStorage()
    } catch (error) {
      console.error('重置学习状态失败:', error)
    }
  }

  /**
   * 重置所有学习状态
   */
  static async resetAll(): Promise<void> {
    this.initializeDefaultStatus()

    // 清空本地存储
    try {
      await this.saveToStorage()
    } catch (error) {
      console.error('重置所有学习状态失败:', error)
    }
  }

  /**
   * 从本地存储加载数据
   */
  private static async loadFromStorage(): Promise<void> {
    try {
      // TODO: 实现实际的本地存储加载逻辑
      // 使用 Preferences API 或其他持久化方案

      // 示例代码（需要根据实际存储方案调整）：
      // const preferences = await dataPreferences.getPreferences(
      //   this.context,
      //   this.STORAGE_KEY
      // )
      // const data = await preferences.get(this.STORAGE_KEY, '{}')
      // const parsed = JSON.parse(data as string)

      // 暂时使用默认初始化
      this.initializeDefaultStatus()
    } catch (error) {
      console.error('从本地存储加载失败:', error)
      this.initializeDefaultStatus()
    }
  }

  /**
   * 保存到本地存储
   */
  private static async saveToStorage(): Promise<void> {
    try {
      // TODO: 实现实际的本地存储保存逻辑
      // 使用 Preferences API 或其他持久化方案

      // 示例代码（需要根据实际存储方案调整）：
      // const preferences = await dataPreferences.getPreferences(
      //   this.context,
      //   this.STORAGE_KEY
      // )
      // const data = JSON.stringify(Object.fromEntries(this.studyStatusMap))
      // await preferences.put(this.STORAGE_KEY, data)
      // await preferences.flush()

      console.log('学习状态已保存')
    } catch (error) {
      console.error('保存到本地存储失败:', error)
      throw error
    }
  }

  /**
   * 检查管理器是否已初始化
   * @returns true-已初始化，false-未初始化
   */
  static getIsInitialized(): boolean {
    return this.isInitialized
  }

  /**
   * 获取所有已学习的级别列表
   * @returns 已学习的级别名称数组
   */
  static getStudiedLevels(): string[] {
    const studiedLevels: string[] = []

    this.studyStatusMap.forEach((status, level) => {
      if (status.isStudied) {
        studiedLevels.push(level)
      }
    })

    return studiedLevels
  }

  /**
   * 获取未学习的级别列表
   * @returns 未学习的级别名称数组
   */
  static getUnstudiedLevels(): string[] {
    const unstudiedLevels: string[] = []

    Constants.LEVELS.forEach(level => {
      if (!this.isStudied(level)) {
        unstudiedLevels.push(level)
      }
    })

    return unstudiedLevels
  }
}

