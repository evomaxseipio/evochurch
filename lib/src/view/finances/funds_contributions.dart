

import 'package:evochurch/src/model/fund_model.dart';
import 'package:evochurch/src/view/finances/contribution_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FundsContributions extends HookWidget {
  final FundModel? fund;
  const FundsContributions({required this.fund, super.key});

  @override
  Widget build(BuildContext context) {
    return ContributionListView(fund: fund);
  }
}