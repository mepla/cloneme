import 'package:flutter/material.dart';
import '../../core/adaptive/breakpoints.dart';

class AdaptiveButton extends StatefulWidget {
  const AdaptiveButton({
    required this.onPressed,
    required this.child,
    this.style,
    this.tooltip,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;
  final String? tooltip;

  @override
  State<AdaptiveButton> createState() => _AdaptiveButtonState();
}

class _AdaptiveButtonState extends State<AdaptiveButton> {
  bool _isHovered = false;
  
  @override
  Widget build(BuildContext context) {
    final isTouchPrimary = ScreenInfo.isTouchPrimary(context);
    
    Widget button = ElevatedButton(
      onPressed: widget.onPressed,
      style: (widget.style ?? ElevatedButton.styleFrom()).copyWith(
        visualDensity: isTouchPrimary ? VisualDensity.comfortable : VisualDensity.compact,
      ),
      child: widget.child,
    );
    
    // Enhanced mouse support for non-touch devices
    if (!isTouchPrimary) {
      button = MouseRegion(
        cursor: widget.onPressed != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: _isHovered && widget.onPressed != null ? [
              BoxShadow(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ] : null,
          ),
          child: button,
        ),
      );
      
      if (widget.tooltip != null) {
        button = Tooltip(
          message: widget.tooltip!,
          child: button,
        );
      }
    }
    
    return button;
  }
}