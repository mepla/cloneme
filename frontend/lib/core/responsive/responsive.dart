import 'package:flutter/material.dart';
import 'breakpoints.dart';

/// Responsive widget that adapts layout based on screen size
class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < Breakpoints.mobileNav;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < Breakpoints.desktopNav &&
      MediaQuery.of(context).size.width >= Breakpoints.mobileNav;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= Breakpoints.desktopNav;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    
    if (size.width >= Breakpoints.desktopNav) {
      return desktop;
    } else if (size.width >= Breakpoints.mobileNav && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}