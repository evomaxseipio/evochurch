import 'package:flutter/material.dart';

class TranslateOnHover extends StatefulWidget {
  final Widget Function(bool isHover) builder;
  const TranslateOnHover({super.key, required this.builder});
  @override
  State<TranslateOnHover> createState() => _TranslateOnHoverState();
}

class _TranslateOnHoverState extends State<TranslateOnHover> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) => _mouserEnter(true),
      onExit: (e) => _mouserEnter(false),
      child: widget.builder(isHover),
    );
  }

  void _mouserEnter(bool isHovering) {
    setState(() {
      isHover = isHovering;
    });
  }
}

class EvoHover extends StatefulWidget {
  final Widget Function(bool isHover) builder;
  const EvoHover({super.key, required this.builder});
  @override
  State<EvoHover> createState() => _FxHoverState();
}

class _FxHoverState extends State<EvoHover> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) => _mouserEnter(true),
      onExit: (e) => _mouserEnter(false),
      child: widget.builder(isHover),
    );
  }

  void _mouserEnter(bool isHovering) {
    setState(() {
      isHover = isHovering;
    });
  }
}
