import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

// 日志域标识
const DOMAIN = 0x0000;
// 日志标签
const LOG_TAG = 'EntryAbility';

export default class EntryAbility extends UIAbility {
  // 窗口实例
  private windowStage: window.WindowStage | null = null;
  // 应用是否在前台
  private isForeground: boolean = false;

  /**
   * 应用创建时调用
   * 用于执行一次性的初始化操作
   */
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, LOG_TAG, 'Ability onCreate - 应用开始初始化');

    try {
      // 设置颜色模式为跟随系统
      this.context.getApplicationContext().setColorMode(
        ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET
      );
      hilog.info(DOMAIN, LOG_TAG, '颜色模式设置成功：跟随系统');
    } catch (err) {
      hilog.error(DOMAIN, LOG_TAG, '设置颜色模式失败: %{public}s', JSON.stringify(err));
    }

    try {
      // 可以在这里进行全局数据初始化
      // 例如：初始化本地存储、加载用户配置等
      this.initGlobalData();
      hilog.info(DOMAIN, LOG_TAG, '全局数据初始化完成');
    } catch (err) {
      hilog.error(DOMAIN, LOG_TAG, '全局数据初始化失败: %{public}s', JSON.stringify(err));
    }

    hilog.info(DOMAIN, LOG_TAG, 'Ability onCreate - 应用初始化完成');
  }

  /**
   * 应用销毁时调用
   * 用于清理资源和保存数据
   */
  onDestroy(): void {
    hilog.info(DOMAIN, LOG_TAG, 'Ability onDestroy - 应用开始销毁');

    try {
      // 清理资源
      this.cleanupResources();
      hilog.info(DOMAIN, LOG_TAG, '资源清理完成');
    } catch (err) {
      hilog.error(DOMAIN, LOG_TAG, '资源清理失败: %{public}s', JSON.stringify(err));
    }

    hilog.info(DOMAIN, LOG_TAG, 'Ability onDestroy - 应用销毁完成');
  }

  /**
   * 窗口阶段创建时调用
   * 用于加载页面内容和配置窗口属性
   */
  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, LOG_TAG, 'Ability onWindowStageCreate - 窗口阶段创建');

    this.windowStage = windowStage;

    try {
      // 配置窗口属性
      this.configureWindow(windowStage);
      hilog.info(DOMAIN, LOG_TAG, '窗口配置完成');
    } catch (err) {
      hilog.error(DOMAIN, LOG_TAG, '窗口配置失败: %{public}s', JSON.stringify(err));
    }

    // 加载主页面内容
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(DOMAIN, LOG_TAG, '页面加载失败: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, LOG_TAG, '页面加载成功');
    });
  }

  /**
   * 窗口阶段销毁时调用
   * 用于释放窗口相关资源
   */
  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, LOG_TAG, 'Ability onWindowStageDestroy - 窗口阶段销毁');

    // 释放窗口引用
    this.windowStage = null;
  }

  /**
   * 应用切换到前台时调用
   * 用于恢复数据和更新UI
   */
  onForeground(): void {
    hilog.info(DOMAIN, LOG_TAG, 'Ability onForeground - 应用切换到前台');
    this.isForeground = true;

    try {
      // 恢复前台数据
      this.restoreForegroundData();
      hilog.info(DOMAIN, LOG_TAG, '前台数据恢复完成');
    } catch (err) {
      hilog.error(DOMAIN, LOG_TAG, '前台数据恢复失败: %{public}s', JSON.stringify(err));
    }
  }

  /**
   * 应用切换到后台时调用
   * 用于保存数据和暂停任务
   */
  onBackground(): void {
    hilog.info(DOMAIN, LOG_TAG, 'Ability onBackground - 应用切换到后台');
    this.isForeground = false;

    try {
      // 保存后台数据
      this.saveBackgroundData();
      hilog.info(DOMAIN, LOG_TAG, '后台数据保存完成');
    } catch (err) {
      hilog.error(DOMAIN, LOG_TAG, '后台数据保存失败: %{public}s', JSON.stringify(err));
    }
  }

  /**
   * 初始化全局数据
   * 在应用启动时执行一次性的数据初始化
   */
  private initGlobalData(): void {
    // TODO: 在这里添加全局数据初始化逻辑
    // 例如：
    // - 初始化本地存储
    // - 加载用户偏好设置
    // - 检查登录状态
    // - 初始化网络请求配置
  }

  /**
   * 清理资源
   * 在应用销毁时清理所有资源
   */
  private cleanupResources(): void {
    // TODO: 在这里添加资源清理逻辑
    // 例如：
    // - 关闭数据库连接
    // - 清除缓存
    // - 取消订阅
    // - 停止定时器
  }

  /**
   * 配置窗口属性
   * 设置窗口的各种显示属性
   */
  private configureWindow(windowStage: window.WindowStage): void {
    // 获取主窗口
    const mainWindow = windowStage.getMainWindowSync();

    // 设置窗口布局全屏（可选）
    // mainWindow.setWindowLayoutFullScreen(true);

    // 设置状态栏颜色（可选）
    // mainWindow.setWindowSystemBarProperties({
    //   statusBarColor: '#00000000',
    //   statusBarContentColor: '#000000'
    // });

    // 设置导航栏颜色（可选）
    // mainWindow.setWindowSystemBarProperties({
    //   navigationBarColor: '#FFFFFF',
    //   navigationBarContentColor: '#000000'
    // });

    // 锁定屏幕方向为竖屏（可选）
    // mainWindow.setPreferredOrientation(window.Orientation.PORTRAIT);
  }

  /**
   * 恢复前台数据
   * 当应用从后台切换到前台时调用
   */
  private restoreForegroundData(): void {
    // TODO: 在这里添加前台数据恢复逻辑
    // 例如：
    // - 刷新用户信息
    // - 更新实时数据
    // - 重新启动定时器
    // - 重新建立网络连接
  }

  /**
   * 保存后台数据
   * 当应用从前台切换到后台时调用
   */
  private saveBackgroundData(): void {
    // TODO: 在这里添加后台数据保存逻辑
    // 例如：
    // - 保存用户操作状态
    // - 暂停网络请求
    // - 停止定时器
    // - 保存临时数据
  }

  /**
   * 获取窗口实例
   * @returns 窗口实例，可能为 null
   */
  public getWindowStage(): window.WindowStage | null {
    return this.windowStage;
  }

  /**
   * 判断应用是否在前台
   * @returns true-在前台，false-在后台
   */
  public getIsForeground(): boolean {
    return this.isForeground;
  }
}
