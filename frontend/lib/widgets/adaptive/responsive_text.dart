import 'package:flutter/material.dart';
import '../../core/adaptive/breakpoints.dart';

class ResponsiveText extends StatelessWidget {
  const ResponsiveText(
    this.text, {
    this.style,
    this.maxLines,
    this.textAlign,
    this.overflow = TextOverflow.ellipsis,
    super.key,
  });
  
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    final breakpoint = ScreenInfo.getBreakpoint(context);
    final scaleFactor = ScreenInfo.getTextScaleFactor(breakpoint);
    
    return Text(
      text,
      style: (style ?? Theme.of(context).textTheme.bodyLarge)?.copyWith(
        fontSize: ((style?.fontSize ?? 16) * scaleFactor),
      ),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}