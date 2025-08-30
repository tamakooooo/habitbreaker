import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 可编辑的进度条组件
/// 支持用户点击编辑进度值，包含输入验证和实时更新功能
class EditableProgressIndicator extends StatefulWidget {
  final double progress; // 当前进度值 (0.0 - 1.0)
  final double size; // 进度条大小
  final Color? color; // 进度条颜色
  final bool isEditable; // 是否可编辑
  final Function(double)? onProgressChanged; // 进度值改变回调
  final String? label; // 进度条标签
  final bool showPercentage; // 是否显示百分比

  const EditableProgressIndicator({
    super.key,
    required this.progress,
    this.size = 100,
    this.color,
    this.isEditable = true,
    this.onProgressChanged,
    this.label,
    this.showPercentage = true,
  });

  @override
  State<EditableProgressIndicator> createState() => _EditableProgressIndicatorState();
}

class _EditableProgressIndicatorState extends State<EditableProgressIndicator>
    with SingleTickerProviderStateMixin {
  late TextEditingController _textController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isEditing = false;
  double _currentProgress = 0.0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _currentProgress = widget.progress;
    _textController = TextEditingController(
      text: (_currentProgress * 100).toStringAsFixed(1),
    );
    
    // 动画控制器用于编辑状态指示
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(EditableProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress && !_isEditing) {
      setState(() {
        _currentProgress = widget.progress;
        _textController.text = (_currentProgress * 100).toStringAsFixed(1);
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// 验证输入值
  bool _validateInput(String value) {
    if (value.isEmpty) {
      _errorMessage = '请输入进度值';
      return false;
    }
    
    final double? numValue = double.tryParse(value);
    if (numValue == null) {
      _errorMessage = '请输入有效的数字';
      return false;
    }
    
    if (numValue < 0 || numValue > 100) {
      _errorMessage = '进度值必须在0-100之间';
      return false;
    }
    
    _errorMessage = null;
    return true;
  }

  /// 开始编辑
  void _startEditing() {
    if (!widget.isEditable) return;
    
    setState(() {
      _isEditing = true;
      _errorMessage = null;
    });
    _animationController.forward();
  }

  /// 完成编辑
  void _finishEditing() {
    final String value = _textController.text.trim();
    
    if (_validateInput(value)) {
      final double newProgress = double.parse(value) / 100;
      setState(() {
        _currentProgress = newProgress;
        _isEditing = false;
      });
      
      // 调用回调函数
      widget.onProgressChanged?.call(newProgress);
    } else {
      // 如果验证失败，保持编辑状态
      setState(() {});
      return;
    }
    
    _animationController.reverse();
  }

  /// 取消编辑
  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _errorMessage = null;
      _textController.text = (_currentProgress * 100).toStringAsFixed(1);
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = widget.color ?? theme.primaryColor;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 进度条主体
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: _isEditing
                      ? Border.all(
                          color: primaryColor,
                          width: 2,
                        )
                      : null,
                  boxShadow: _isEditing
                      ? [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 背景圆环
                    CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 8,
                      backgroundColor: theme.dividerColor.withOpacity(0.2),
                      color: Colors.transparent,
                    ),
                    // 进度圆环
                    CircularProgressIndicator(
                      value: _currentProgress,
                      strokeWidth: 8,
                      color: primaryColor,
                    ),
                    // 中心内容
                    _buildCenterContent(theme, primaryColor),
                  ],
                ),
              ),
            );
          },
        ),
        
        // 错误信息显示
        if (_errorMessage != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.error.withOpacity(0.3),
              ),
            ),
            child: Text(
              _errorMessage!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
        
        // 标签显示
        if (widget.label != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.label!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.hintColor,
            ),
          ),
        ],
      ],
    );
  }

  /// 构建中心内容
  Widget _buildCenterContent(ThemeData theme, Color primaryColor) {
    if (_isEditing) {
      return _buildEditingContent(theme);
    } else {
      return _buildDisplayContent(theme, primaryColor);
    }
  }

  /// 构建显示模式的中心内容
  Widget _buildDisplayContent(ThemeData theme, Color primaryColor) {
    return GestureDetector(
      onTap: widget.isEditable ? _startEditing : null,
      child: Container(
        width: widget.size * 0.7,
        height: widget.size * 0.7,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.isEditable
              ? primaryColor.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.showPercentage)
              Text(
                '${(_currentProgress * 100).toInt()}%',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            if (widget.isEditable)
              Icon(
                Icons.edit,
                size: 16,
                color: primaryColor.withOpacity(0.7),
              ),
          ],
        ),
      ),
    );
  }

  /// 构建编辑模式的中心内容
  Widget _buildEditingContent(ThemeData theme) {
    return Container(
      width: widget.size * 0.8,
      height: widget.size * 0.8,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 输入框
          Expanded(
            child: TextField(
              controller: _textController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '0-100',
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (_) => _finishEditing(),
            ),
          ),
          // 操作按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: _cancelEditing,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: theme.colorScheme.error,
                ),
              ),
              GestureDetector(
                onTap: _finishEditing,
                child: Icon(
                  Icons.check,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}