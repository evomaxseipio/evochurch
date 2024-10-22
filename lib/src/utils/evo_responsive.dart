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
