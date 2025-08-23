import 'dart:async';
import 'package:flutter/material.dart';
import 'package:habit_breaker_app/models/habit.dart';
import 'package:habit_breaker_app/localization/app_localizations.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback onCheck;
  final bool isCompact; // 用于在网格布局中显示紧凑版本

  const HabitCard({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onCheck,
    this.isCompact = false,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> with SingleTickerProviderStateMixin {
  late DateTime _currentTime;
  late Duration _elapsedTime;
  late double _progress;
  late Timer _timer;
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    // 初始化动画控制器
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    // 初始化_progressAnimation为默认值
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _updateTime();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _updateTime();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _updateTime() {
    _currentTime = DateTime.now();
    _elapsedTime = _currentTime.difference(widget.habit.startDate);
    
    // 计算当前阶段进度
    final stageDuration = widget.habit.currentStageEndDate.difference(widget.habit.currentStageStartDate);
    final elapsedStageDuration = _currentTime.difference(widget.habit.currentStageStartDate);
    
    if (elapsedStageDuration.isNegative) {
      _progress = 0.0;
    } else {
      _progress = elapsedStageDuration.inSeconds / stageDuration.inSeconds;
    }
    
    // 确保进度不超过1.0
    if (_progress > 1.0) {
      _progress = 1.0;
    }
    
    // 更新动画值，确保动画控制器已初始化
    if (mounted) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: _progress,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
      _animationController.forward(from: 0.0);
    }
  }
  
  /// 根据阶段获取对应的主题颜色
  Color _getStageColor(HabitStage stage) {
    switch (stage) {
      case HabitStage.hours24:
        return Colors.red; // 24小时 - 红色
      case HabitStage.days3:
        return Colors.orange; // 3天 - 橙色
      case HabitStage.week1:
        return Colors.yellow; // 1周 - 黄色
      case HabitStage.month1:
        return Colors.green; // 1个月 - 绿色
      case HabitStage.month3:
        return Colors.blue; // 3个月 - 蓝色
      case HabitStage.year1:
        return Colors.purple; // 1年 - 紫色
    }
  }
  
  /// 获取阶段的本地化名称
  String _getStageName(HabitStage stage, BuildContext context) {
    switch (stage) {
      case HabitStage.hours24:
        return AppLocalizations.of(context).stage24Hours;
      case HabitStage.days3:
        return AppLocalizations.of(context).stage3Days;
      case HabitStage.week1:
        return AppLocalizations.of(context).stage1Week;
      case HabitStage.month1:
        return AppLocalizations.of(context).stage1Month;
      case HabitStage.month3:
        return AppLocalizations.of(context).stage1Quarter;
      case HabitStage.year1:
        return AppLocalizations.of(context).stage1Year;
    }
  }

  
  
  Widget _buildTimeUnit(int value, String label) {
    return Column(
      children: [
        Container(
          padding: widget.isCompact 
              ? const EdgeInsets.all(6) 
              : const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getStageColor(widget.habit.stage),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: TextStyle(
              fontSize: widget.isCompact ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: widget.isCompact ? 10 : 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: widget.isCompact 
          ? const EdgeInsets.all(8.0) 
          : const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: widget.isCompact 
              ? const EdgeInsets.all(12.0) 
              : const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.habit.name,
                      style: widget.isCompact 
                          ? Theme.of(context).textTheme.titleMedium 
                          : Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStageColor(widget.habit.stage).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStageName(widget.habit.stage, context),
                      style: TextStyle(
                        fontSize: widget.isCompact ? 10 : 12,
                        fontWeight: FontWeight.bold,
                        color: _getStageColor(widget.habit.stage),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context).timeElapsed,
                style: widget.isCompact 
                    ? Theme.of(context).textTheme.titleMedium 
                    : Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              if (!widget.isCompact) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTimeUnit(
                      _elapsedTime.inDays,
                      'Days',
                    ),
                    _buildTimeUnit(
                      _elapsedTime.inHours % 24,
                      'Hours',
                    ),
                    _buildTimeUnit(
                      _elapsedTime.inMinutes % 60,
                      'Minutes',
                    ),
                    _buildTimeUnit(
                      _elapsedTime.inSeconds % 60,
                      'Seconds',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.habit.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
              ] else ...[
                // 紧凑布局只显示天数和小时
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTimeUnit(
                      _elapsedTime.inDays,
                      'Days',
                    ),
                    _buildTimeUnit(
                      _elapsedTime.inHours % 24,
                      'Hours',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // 紧凑布局中截断描述文本
                Text(
                  widget.habit.description.length > 50 
                      ? '${widget.habit.description.substring(0, 50)}...' 
                      : widget.habit.description,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],
              // 美观的自定义进度条，带有阶段主题颜色和动画效果
              Container(
                height: widget.isCompact ? 16 : 20,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    // 进度条背景
                    Container(
                      decoration: BoxDecoration(
                        color: _getStageColor(widget.habit.stage).withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // 进度条前景，带有动画效果
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _progressAnimation.value > 1.0 ? 1.0 : _progressAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _progressAnimation.value >= 1.0 
                                  ? Colors.green // 完成时显示绿色
                                  : _getStageColor(widget.habit.stage),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: _progressAnimation.value >= 1.0 
                                      ? Colors.green.withValues(alpha: 0.5)
                                      : _getStageColor(widget.habit.stage).withValues(alpha: 0.5),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // 进度文本
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(_progress * 100).toStringAsFixed(1)}% ${AppLocalizations.of(context).completed}',
                    style: widget.isCompact 
                        ? Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12) 
                        : Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${widget.habit.currentStageStartDate.toString().split(' ')[0]} - ${widget.habit.currentStageEndDate.toString().split(' ')[0]}',
                    style: widget.isCompact 
                        ? Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            color: Colors.grey[600],
                          )
                        : Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}