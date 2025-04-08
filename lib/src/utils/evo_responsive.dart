import 'package:flutter/material.dart';

class EvoResponsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget smallWeb;
  final Widget mediumWeb;
  final Widget largeWeb;

  const EvoResponsive({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.smallWeb,
    required this.mediumWeb,
    required this.largeWeb,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 425 &&
      MediaQuery.of(context).size.width >= 320;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 768 &&
      MediaQuery.of(context).size.width >= 425;

  static bool isSmallWeb(BuildContext context) =>
      MediaQuery.of(context).size.width < 1024 &&
      MediaQuery.of(context).size.width >= 768;

  static bool isMediumWeb(BuildContext context) =>
      MediaQuery.of(context).size.width < 1440 &&
      MediaQuery.of(context).size.width >= 1024;

  static bool isLargeWeb(BuildContext context) =>
      MediaQuery.of(context).size.width < 2560 &&
      MediaQuery.of(context).size.width >= 1440;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1440) {
          return largeWeb;
        } else if (constraints.maxWidth >= 1024) {
          return mediumWeb;
        } else if (constraints.maxWidth >= 768) {
          return smallWeb;
        } else if (constraints.maxWidth >= 425) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}


class EvoLayoutResponsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget smallDesktop;
  final Widget largeDesktop;

  // Standard breakpoints
  static const double mobileMaxWidth = 599;
  static const double tabletMaxWidth = 1023;
  static const double smallDesktopMaxWidth = 1439;

  const EvoLayoutResponsive({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.smallDesktop,
    required this.largeDesktop,
  });

  // Helper methods to check screen size
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= mobileMaxWidth;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width > mobileMaxWidth &&
      MediaQuery.of(context).size.width <= tabletMaxWidth;

  static bool isSmallDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > tabletMaxWidth &&
      MediaQuery.of(context).size.width <= smallDesktopMaxWidth;

  static bool isLargeDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > smallDesktopMaxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        if (width <= mobileMaxWidth) {
          return mobile;
        } else if (width <= tabletMaxWidth) {
          return tablet;
        } else if (width <= smallDesktopMaxWidth) {
          return smallDesktop;
        } else {
          return largeDesktop;
        }
      },
    );
  }
}
