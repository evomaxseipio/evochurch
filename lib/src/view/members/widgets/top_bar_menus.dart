import 'package:evochurch/src/routes/app_route_constants.dart';
import 'package:evochurch/src/utils/utils_index.dart';
import 'package:evochurch/src/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/constant_index.dart';

class MemberTopMenu extends StatelessWidget {
  final VoidCallback onUpdate;
  final VoidCallback onPrint;

  const MemberTopMenu({
    super.key,
    required this.onUpdate,
    required this.onPrint,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child:
            // Evaluate the screen mobile size and adjust the layout accordingly
            Responsive.isMobile(context)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: topBarMenuButtons(context, onUpdate, onPrint).map(
                      (button) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Tooltip(
                            message: button.text ?? '',
                            child: IconButton.filled(
                              onPressed: button.onPressed,
                              icon:
                                  button.icon ?? const Icon(Icons.help_outline),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  )
                :
                // For larger screens, use a Row layout with buttons
                // insert Spacer() between buttons
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    const Spacer(),
                    ...topBarMenuButtons(context, onUpdate, onPrint)
                        .expand((widget) => [
                              Tooltip(message: widget.text!, child: widget),
                              EvoBox.w10
                            ])
                        .toList()
                      ..removeLast(),
                  ]),
        // children: [
      ),
    );
  }
}

// List of EvoButton widgets for the top bar menu with tooltips
// This function returns a list of EvoButton widgets with tooltips and icons
// The buttons are used for navigation and actions in the top bar menu

List<EvoButton> topBarMenuButtons(
    BuildContext context, VoidCallback onUpdate, VoidCallback onPrint) {
  return [
    EvoButton(
      text: 'Back to List of Member',
      icon: const Icon(Icons.arrow_back_ios_sharp),
      onPressed: () => context.go('/members'),
    ),
    // EvoBox.w10,
    EvoButton(
      text: 'Update Member',
      icon: const Icon(Icons.edit),
      onPressed: onUpdate,
    ),
    // EvoBox.w10,
    EvoButton(
        text: 'Print Information',
        icon: const Icon(Icons.print),
        onPressed: onPrint),
  ];
}
