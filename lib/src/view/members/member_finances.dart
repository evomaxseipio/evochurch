import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MemberFinances extends HookWidget {
  const MemberFinances({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Text('Member Finances', style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}