import 'package:evochurch/src/routes/app_route_constants.dart';
import 'package:evochurch/src/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/constant_index.dart';

class MemberTopMenu extends StatelessWidget {
  final VoidCallback onUpdate;
  final VoidCallback onPrint;



  const MemberTopMenu({
    super.key, required this.onUpdate, required this.onPrint,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Spacer(),
            EvoBox.w10,
            EvoButton(
                text: 'Back to List of Member',
                icon: const Icon(Icons.arrow_back_ios_sharp),
                onPressed: () => context.go('/members')),
            EvoBox.w10,
            EvoButton(
                text: 'Update Member',
                icon: const Icon(Icons.edit),
                onPressed: onUpdate),
            EvoBox.w10,
            EvoButton(
                text: 'Print Information',
                icon: const Icon(Icons.print),
                onPressed: onPrint),
          ],
        ),
      ),
    );
  }
}
