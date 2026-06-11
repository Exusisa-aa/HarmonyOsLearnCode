export class Constants {
  // ==================== 基础常量 ====================
  static readonly SERVER: string = 'http://192.168.20.192:3000';
  static readonly FULL_PARENT = '100%';

  // ==================== 字体相关常量 ====================
  static readonly TITLE_FONT_SIZE = 25;
  static readonly TITLE_SIZE = 28;
  static readonly NORMAL_TEXT_FONT_SIZE = 17;
  static readonly NORMAL_SIZE = 16;
  static readonly TAB_TEXT_SIZE = 16;
  static readonly BOLD_WEIGHT = 700;

  // ==================== 间距相关常量 ====================
  static readonly SPACE_SIZE = 12;
  static readonly SMALL_SPACE = 8;
  static readonly COLUMN_PADDING = 15;
  static readonly ITEM_SPACE = 20;
  static readonly LOGIN_PAGE_PADDING = 30;

  // ==================== 尺寸相关常量 ====================
  static readonly NAV_HEIGHT = 60;
  static readonly SUBTITLE_HEIGHT = 40;
  static readonly INPUT_HEIGHT = 50;
  static readonly BUTTON_HEIGHT = 45;
  static readonly PANEL_SIZE = 20;
  static readonly ARROW_WIDTH = 60;
  static readonly LOGO_WIDTH = 80;
  static readonly PREFIX_ICON_WIDTH = 24;
  static readonly QUESTION_TYPE_WIDTH = 50;
  static readonly OPTION_HEIGHT = 50;
  static readonly OPTION_RADIUS = 8;
  static readonly EXAM_ITEM_HEIGHT = 40;
  static readonly GRID_ITEM_HEIGHT = 40;
  static readonly RETRY_BUTTON_WIDTH = 120;

  // ==================== 圆角相关常量 ====================
  static readonly BORDER_RADIUS_SMALL = 8;
  static readonly BORDER_RADIUS_MEDIUM = 12;
  static readonly BORDER_RADIUS_LARGE = 16;
  static readonly BORDER_RADIUS_CIRCLE = '50%';

  // ==================== 输入框相关常量 ====================
  static readonly LOGIN_INPUT_MAX_LEN = 20;
  static readonly LIGHT_GRAY: ResourceColor = '#F5F5F5';

  // ==================== Logo与标题间距 ====================
  static readonly LOGO_TITLE_TOP_MARGIN = 20;
  static readonly LOGO_TITLE_BOTTOM_MARGIN = 30;

  // ==================== 颜色常量 ====================
  // 主题色
  static readonly PRIMARY_COLOR: ResourceColor = '#4CAF50';
  static readonly PRIMARY_LIGHT: ResourceColor = '#00D9A5';
  static readonly PRIMARY_DARK: ResourceColor = '#00A67C';

  // 功能色
  static readonly SUCCESS_COLOR: ResourceColor = '#4CAF50';
  static readonly WARNING_COLOR: ResourceColor = '#FF9800';
  static readonly ERROR_COLOR: ResourceColor = '#F44336';
  static readonly INFO_COLOR: ResourceColor = '#1976D2';

  // 文字颜色
  static readonly TEXT_PRIMARY: ResourceColor = '#333333';
  static readonly TEXT_SECONDARY: ResourceColor = '#666666';
  static readonly TEXT_HINT: ResourceColor = '#999999';
  static readonly TEXT_BLACK: ResourceColor = '#000000';
  static readonly TEXT_WHITE: ResourceColor = '#FFFFFF';

  // 背景颜色
  static readonly BG_WHITE: ResourceColor = '#FFFFFF';
  static readonly BG_LIGHT: ResourceColor = '#F5F5F5';
  static readonly BG_GRAY: ResourceColor = '#E0E0E0';
  static readonly BG_LIGHT_YELLOW: ResourceColor = '#FFF8E1';
  static readonly BG_LIGHT_ORANGE: ResourceColor = '#FFE0B2';
  static readonly BG_LIGHT_BLUE: ResourceColor = '#E3F2FD';

  // 边框颜色
  static readonly BORDER_COLOR: ResourceColor = '#E0E0E0';
  static readonly BORDER_SELECTED: ResourceColor = '#1976D2';

  // ==================== 答题状态颜色 ====================
  static readonly STATUS_UNANSWERED: ResourceColor = '#999999';
  static readonly STATUS_CORRECT: ResourceColor = '#4CAF50';
  static readonly STATUS_WRONG: ResourceColor = '#F44336';
  static readonly STATUS_CARD_UNANSWERED: ResourceColor = '#E0E0E0';

  // ==================== 渐变配置 ====================
  static readonly GRADIENT_COLORS = [
    ['#00D9A5', 0.4],
    ['#00A67C', 1]
  ];
  static readonly GRADIENT_DIRECTION = GradientDirection.Right;

  // ==================== 阴影配置 ====================
  static readonly SHADOW_RADIUS = 10;
  static readonly SHADOW_OFFSET_X = 0;
  static readonly SHADOW_OFFSET_Y = 4;
  static readonly SHADOW_COLOR: ResourceColor = '#1A000000';

  // ==================== 动画相关常量 ====================
  static readonly ANIMATION_DURATION = 300;
  static readonly ANIMATION_EASING = Ease.Out;

  // ==================== 透明度配置 ====================
  static readonly OPACITY_DISABLED = 0.3;
  static readonly OPACITY_NORMAL = 1;

  // ==================== 网格布局常量 ====================
  static readonly GRID_COLUMNS = 3;
  static readonly GRID_COLUMN_TEMPLATE = '1fr 1fr 1fr';
  static readonly GRID_ROWS_GAP = 20;
  static readonly GRID_COLUMNS_GAP = 12;
  static readonly GRID_ITEM_SIZE = 50;

  // ==================== 分隔线常量 ====================
  static readonly DIVIDER_WIDTH = 1;
  static readonly DIVIDER_HEIGHT = 50;
  static readonly DIVIDER_COLOR: ResourceColor = '#E0E0E0';

  // ==================== 头像相关常量 ====================
  static readonly AVATAR_SIZE = 100;
  static readonly AVATAR_RADIUS = 50;

  // ==================== 统计卡片常量 ====================
  static readonly STATS_CARD_WIDTH_PERCENT = '80%';
  static readonly STATS_CARD_PADDING = 30;
  static readonly STATS_NUMBER_SIZE = 32;
  static readonly STATS_LABEL_SIZE = 16;
  static readonly STATS_LABEL_MARGIN_TOP = 8;

  // ==================== 得分显示常量 ====================
  static readonly SCORE_CIRCLE_ASPECT_RATIO = 1;
  static readonly SCORE_CIRCLE_WIDTH_PERCENT = '75%';
  static readonly SCORE_DISPLAY_SIZE = 40;
  static readonly SCORE_TOTAL_SIZE = 16;

  // ==================== 结果面板常量 ====================
  static readonly RESULT_PANEL_ASPECT_RATIO = 1.3;
  static readonly RESULT_PANEL_MARGIN_TOP = 12;
  static readonly RESULT_PANEL_MARGIN_BOTTOM = 12;
  static readonly RESULT_RIGHT_WIDTH = 120;

  // ==================== 答题卡常量 ====================
  static readonly ANSWER_CARD_TITLE_MARGIN_TOP = 25;
  static readonly ANSWER_CARD_TITLE_MARGIN_BOTTOM = 10;
  static readonly ANSWER_CARD_HEADER_HEIGHT = 50;
  static readonly ANSWER_CARD_GRID_HEIGHT = 60;
  static readonly ANSWER_CARD_STATUS_INDICATOR_SIZE = 10;
  static readonly ANSWER_CARD_STATUS_TEXT_SIZE = 12;
  static readonly ANSWER_CARD_STATUS_ROW_SPACE = 12;
  static readonly ANSWER_CARD_STATUS_ITEM_SPACE = 4;
  static readonly ANSWER_CARD_GRID_MARGIN_TOP = 8;
  static readonly ANSWER_CARD_RETRY_BUTTON_MARGIN_TOP = 10;

  // ==================== 题目状态指示器 ====================
  static readonly STATUS_INDICATOR_UNANSWERED_COLOR: ResourceColor = '#999999';
  static readonly STATUS_INDICATOR_CORRECT_COLOR: ResourceColor = '#4CAF50';
  static readonly STATUS_INDICATOR_WRONG_COLOR: ResourceColor = '#F44336';

  // ==================== 按钮样式常量 ====================
  static readonly BUTTON_BORDER_RADIUS = 25;
  static readonly BUTTON_FONT_SIZE = 18;
  static readonly BUTTON_WIDTH_PERCENT = '80%';
  static readonly BUTTON_SUBMIT_COLOR: ResourceColor = '#4CAF50';

  // ==================== API接口路径 ====================
  static readonly API_LOGIN = '/api/login';
  static readonly API_REGISTER = '/api/register';
  static readonly API_GET_QUESTIONS = '/api/questions';
  static readonly API_SUBMIT_ANSWERS = '/api/submit';
  static readonly API_GET_USER_INFO = '/api/user/info';
  static readonly API_UPDATE_PROFILE = '/api/user/update';

  // ==================== 本地存储Key ====================
  static readonly STORAGE_TOKEN = 'token';
  static readonly STORAGE_USER_INFO = 'userInfo';
  static readonly STORAGE_STUDY_STATUS = 'studyStatus';
  static readonly STORAGE_USER_ANSWERS = 'userAnswers';

  // ==================== 路由路径 ====================
  static readonly ROUTE_INDEX = 'pages/Index';
  static readonly ROUTE_LOGIN = 'pages/Account/LoginPage';
  static readonly ROUTE_EXAM = 'pages/Exam';
  static readonly ROUTE_EXAM_DETAIL = 'pages/ExamSubject/ExamDetail';
  static readonly ROUTE_ANSWER_RESULT = 'pages/ExamSubject/AnswerResult';
  static readonly ROUTE_PROFILE = 'pages/Profile';

  // ==================== 考试级别 ====================
  static readonly LEVEL_JUNIOR = '初级';
  static readonly LEVEL_INTERMEDIATE = '中级';
  static readonly LEVEL_SENIOR = '高级';
  static readonly LEVELS = [Constants.LEVEL_JUNIOR, Constants.LEVEL_INTERMEDIATE, Constants.LEVEL_SENIOR];

  // ==================== 默认配置 ====================
  static readonly DEFAULT_SCORE_TOTAL = 100;
  static readonly DEFAULT_TRANSITION_DELAY = 500;
}
