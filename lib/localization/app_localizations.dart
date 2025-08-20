import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'app_name': '戒断不良习惯',
      'welcome_message': 'Welcome to戒断不良习惯 App!',
      'start_building_habits': 'Start breaking bad habits today.',
      'view_my_habits': 'View My戒断',
      'view_statistics': 'View Statistics',
      'my_habits': 'My戒断',
      'add_habit': 'Add戒断',
      'no_habits_yet': 'No戒断 yet. Add your first戒断!',
      'habit_details': '戒断 Details',
      'statistics': 'Statistics',
      'total_habits': 'Total戒断',
      'completed': 'Completed',
      'total_streaks': 'Total Streaks',
      'avg_streak': 'Avg. Streak',
      'habit_completion_over_time': '戒断 Completion Over Time',
      'login': 'Login',
      'signup': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'full_name': 'Full Name',
      'dont_have_account': 'Don\'t have an account? Sign up',
      'already_have_account': 'Already have an account? Login',
      'continue_as_guest': 'Continue as Guest',
      'habit_name': '戒断 Name',
      'description': 'Description',
      'start_date': 'Start Date',
      'start_time': 'Start Time',
      'target_end_date': 'Target End Date',
      'not_selected': 'Not selected',
      'save': 'Save',
      'mark_completed_today': 'Mark as Completed Today',
      'days_remaining': 'Days Remaining',
      'time_remaining': 'Time Remaining',
      'days_elapsed': 'Days Elapsed',
      'time_elapsed': 'Time Elapsed',
      'stage': 'Stage',
      'select_stage': 'Select Stage',
      'target_stage': 'Target Stage',
      'stage_24_hours': '24 Hours',
      'stage_3_days': '3 Days',
      'stage_1_week': '1 Week',
      'stage_1_month': '1 Month',
      'stage_1_quarter': '1 Quarter',
      'stage_1_year': '1 Year',
      'icon': 'Icon',
      'select_icon': 'Select Icon',
      'reminder_time': 'Reminder Time',
      'set_reminder': 'Set Reminder',
      'reminder_enabled': 'Reminder Enabled',
      'reminder_disabled': 'Reminder Disabled',
      'repeat_frequency': 'Repeat Frequency',
      'daily': 'Daily',
      'weekly': 'Weekly',
      'monthly': 'Monthly',
      'custom': 'Custom',
      'habit_created': 'Habit created successfully',
      'error': 'Error',
      'select_date': 'Select date',
      'save_habit': 'Save Habit',
    },
    'zh': {
      'app_name': '戒断不良习惯',
      'welcome_message': '欢迎使用戒断不良习惯应用程序！',
      'start_building_habits': '今天就开始戒掉坏习惯吧。',
      'view_my_habits': '查看我的戒断',
      'view_statistics': '查看统计信息',
      'my_habits': '我的戒断',
      'add_habit': '添加戒断',
      'no_habits_yet': '还没有戒断。添加你的第一个戒断！',
      'habit_details': '戒断详情',
      'statistics': '统计信息',
      'total_habits': '总戒断数',
      'completed': '已完成',
      'total_streaks': '总连续天数',
      'avg_streak': '平均连续天数',
      'habit_completion_over_time': '戒断完成情况趋势',
      'login': '登录',
      'signup': '注册',
      'email': '邮箱',
      'password': '密码',
      'confirm_password': '确认密码',
      'full_name': '全名',
      'dont_have_account': '没有账户？注册',
      'already_have_account': '已有账户？登录',
      'continue_as_guest': '以访客身份继续',
      'habit_name': '戒断名称',
      'description': '描述',
      'start_date': '开始日期',
      'start_time': '开始时间',
      'target_end_date': '目标结束日期',
      'not_selected': '未选择',
      'save': '保存',
      'mark_completed_today': '标记为今日已完成',
      'days_remaining': '剩余天数',
      'time_remaining': '剩余时间',
      'days_elapsed': '已过天数',
      'time_elapsed': '已过时间',
      'stage': '阶段',
      'select_stage': '选择阶段',
      'stage_24_hours': '24小时',
      'stage_3_days': '3天',
      'stage_1_week': '1周',
      'stage_1_month': '1个月',
      'stage_1_quarter': '1个季度',
      'stage_1_year': '1年',
      'icon': '图标',
      'select_icon': '选择图标',
      'edit_habit': '编辑习惯',
      'please_enter_habit_name': '请输入习惯名称',
      'habit_created': '习惯创建成功',
      'error': '错误',
      'select_date': '选择日期',
      'save_habit': '保存习惯',
    },
  };

  String get appName => _localizedValues[locale.languageCode]?['app_name'] ?? 'Habit Breaker';
  String get welcomeMessage => _localizedValues[locale.languageCode]?['welcome_message'] ?? 'Welcome to Habit Breaker App!';
  String get startBuildingHabits => _localizedValues[locale.languageCode]?['start_building_habits'] ?? 'Start building better habits today.';
  String get viewMyHabits => _localizedValues[locale.languageCode]?['view_my_habits'] ?? 'View My Habits';
  String get viewStatistics => _localizedValues[locale.languageCode]?['view_statistics'] ?? 'View Statistics';
  String get myHabits => _localizedValues[locale.languageCode]?['my_habits'] ?? 'My Habits';
  String get addHabit => _localizedValues[locale.languageCode]?['add_habit'] ?? 'Add Habit';
  String get noHabitsYet => _localizedValues[locale.languageCode]?['no_habits_yet'] ?? 'No habits yet. Add your first habit!';
  String get habitDetails => _localizedValues[locale.languageCode]?['habit_details'] ?? 'Habit Details';
  String get statistics => _localizedValues[locale.languageCode]?['statistics'] ?? 'Statistics';
  String get totalHabits => _localizedValues[locale.languageCode]?['total_habits'] ?? 'Total Habits';
  String get completed => _localizedValues[locale.languageCode]?['completed'] ?? 'Completed';
  String get totalStreaks => _localizedValues[locale.languageCode]?['total_streaks'] ?? 'Total Streaks';
  String get avgStreak => _localizedValues[locale.languageCode]?['avg_streak'] ?? 'Avg. Streak';
  String get habitCompletionOverTime => _localizedValues[locale.languageCode]?['habit_completion_over_time'] ?? 'Habit Completion Over Time';
  String get login => _localizedValues[locale.languageCode]?['login'] ?? 'Login';
  String get signup => _localizedValues[locale.languageCode]?['signup'] ?? 'Sign Up';
  String get email => _localizedValues[locale.languageCode]?['email'] ?? 'Email';
  String get password => _localizedValues[locale.languageCode]?['password'] ?? 'Password';
  String get confirmPassword => _localizedValues[locale.languageCode]?['confirm_password'] ?? 'Confirm Password';
  String get fullName => _localizedValues[locale.languageCode]?['full_name'] ?? 'Full Name';
  String get dontHaveAccount => _localizedValues[locale.languageCode]?['dont_have_account'] ?? 'Don\'t have an account? Sign up';
  String get alreadyHaveAccount => _localizedValues[locale.languageCode]?['already_have_account'] ?? 'Already have an account? Login';
  String get continueAsGuest => _localizedValues[locale.languageCode]?['continue_as_guest'] ?? 'Continue as Guest';
  String get habitName => _localizedValues[locale.languageCode]?['habit_name'] ?? 'Habit Name';
  String get description => _localizedValues[locale.languageCode]?['description'] ?? 'Description';
  String get targetEndDate => _localizedValues[locale.languageCode]?['target_end_date'] ?? 'Target End Date';
  String get notSelected => _localizedValues[locale.languageCode]?['not_selected'] ?? 'Not selected';
  String get save => _localizedValues[locale.languageCode]?['save'] ?? 'Save';
  String get markCompletedToday => _localizedValues[locale.languageCode]?['mark_completed_today'] ?? 'Mark as Completed Today';
  String get startDate => _localizedValues[locale.languageCode]?['start_date'] ?? 'Start Date';
  String get daysRemaining => _localizedValues[locale.languageCode]?['days_remaining'] ?? 'Days Remaining';
  String get timeRemaining => _localizedValues[locale.languageCode]?['time_remaining'] ?? 'Time Remaining';
  String get stage => _localizedValues[locale.languageCode]?['stage'] ?? 'Stage';
  String get selectStage => _localizedValues[locale.languageCode]?['select_stage'] ?? 'Select Stage';
  String get stage24Hours => _localizedValues[locale.languageCode]?['stage_24_hours'] ?? '24 Hours';
  String get stage3Days => _localizedValues[locale.languageCode]?['stage_3_days'] ?? '3 Days';
  String get stage1Week => _localizedValues[locale.languageCode]?['stage_1_week'] ?? '1 Week';
  String get stage1Month => _localizedValues[locale.languageCode]?['stage_1_month'] ?? '1 Month';
  String get stage1Quarter => _localizedValues[locale.languageCode]?['stage_1_quarter'] ?? '1 Quarter';
  String get stage1Year => _localizedValues[locale.languageCode]?['stage_1_year'] ?? '1 Year';
  String get icon => _localizedValues[locale.languageCode]?['icon'] ?? 'Icon';
  String get selectIcon => _localizedValues[locale.languageCode]?['select_icon'] ?? 'Select Icon';
  String get daysElapsed => _localizedValues[locale.languageCode]?['days_elapsed'] ?? 'Days Elapsed';
  String get timeElapsed => _localizedValues[locale.languageCode]?['time_elapsed'] ?? 'Time Elapsed';
  String get startTime => _localizedValues[locale.languageCode]?['start_time'] ?? 'Start Time';
  String get editHabit => _localizedValues[locale.languageCode]?['edit_habit'] ?? 'Edit Habit';
  String get pleaseEnterHabitName => _localizedValues[locale.languageCode]?['please_enter_habit_name'] ?? 'Please enter habit name';
  String get targetStage => _localizedValues[locale.languageCode]?['target_stage'] ?? 'Target Stage';
  String get reminderTime => _localizedValues[locale.languageCode]?['reminder_time'] ?? 'Reminder Time';
  String get setReminder => _localizedValues[locale.languageCode]?['set_reminder'] ?? 'Set Reminder';
  String get reminderEnabled => _localizedValues[locale.languageCode]?['reminder_enabled'] ?? 'Reminder Enabled';
  String get reminderDisabled => _localizedValues[locale.languageCode]?['reminder_disabled'] ?? 'Reminder Disabled';
  String get repeatFrequency => _localizedValues[locale.languageCode]?['repeat_frequency'] ?? 'Repeat Frequency';
  String get daily => _localizedValues[locale.languageCode]?['daily'] ?? 'Daily';
  String get weekly => _localizedValues[locale.languageCode]?['weekly'] ?? 'Weekly';
  String get monthly => _localizedValues[locale.languageCode]?['monthly'] ?? 'Monthly';
  String get custom => _localizedValues[locale.languageCode]?['custom'] ?? 'Custom';
  String get habitCreated => _localizedValues[locale.languageCode]?['habit_created'] ?? 'Habit created successfully';
  String get error => _localizedValues[locale.languageCode]?['error'] ?? 'Error';
  String get selectDate => _localizedValues[locale.languageCode]?['select_date'] ?? 'Select date';
  String get saveHabit => _localizedValues[locale.languageCode]?['save_habit'] ?? 'Save Habit';
}