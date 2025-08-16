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
      'view_my_habits': 'View My Habits',
      'view_statistics': 'View Statistics',
      'my_habits': 'My Habits',
      'add_habit': 'Add Habit',
      'no_habits_yet': 'No habits yet. Add your first habit!',
      'habit_details': 'Habit Details',
      'statistics': 'Statistics',
      'total_habits': 'Total Habits',
      'completed': 'Completed',
      'total_streaks': 'Total Streaks',
      'avg_streak': 'Avg. Streak',
      'habit_completion_over_time': 'Habit Completion Over Time',
      'login': 'Login',
      'signup': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'full_name': 'Full Name',
      'dont_have_account': 'Don\'t have an account? Sign up',
      'already_have_account': 'Already have an account? Login',
      'continue_as_guest': 'Continue as Guest',
      'habit_name': 'Habit Name',
      'description': 'Description',
      'start_date': 'Start Date',
      'target_end_date': 'Target End Date',
      'not_selected': 'Not selected',
      'save': 'Save',
      'mark_completed_today': 'Mark as Completed Today',
      'days_remaining': 'Days Remaining',
      'time_remaining': 'Time Remaining',
    },
    'zh': {
      'app_name': '戒断不良习惯',
      'welcome_message': '欢迎使用戒断不良习惯应用！',
      'start_building_habits': '开始戒断不良习惯。',
      'view_my_habits': '查看我的习惯',
      'view_statistics': '查看统计',
      'my_habits': '我的习惯',
      'add_habit': '添加习惯',
      'no_habits_yet': '还没有习惯。添加你的第一个习惯！',
      'habit_details': '习惯详情',
      'statistics': '统计',
      'total_habits': '总习惯数',
      'completed': '已完成',
      'total_streaks': '总连续天数',
      'avg_streak': '平均连续天数',
      'habit_completion_over_time': '习惯完成情况',
      'login': '登录',
      'signup': '注册',
      'email': '邮箱',
      'password': '密码',
      'confirm_password': '确认密码',
      'full_name': '全名',
      'dont_have_account': '没有账户？注册',
      'already_have_account': '已有账户？登录',
      'continue_as_guest': '以访客身份继续',
      'habit_name': '习惯名称',
      'description': '描述',
      'start_date': '开始日期',
      'target_end_date': '目标结束日期',
      'not_selected': '未选择',
      'save': '保存',
      'mark_completed_today': '标记为今日完成',
      'days_remaining': '剩余天数',
      'time_remaining': '剩余时间',
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
}