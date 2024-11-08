
import 'package:evochurch/src/constants/constant_index.dart';
import 'package:flutter/material.dart';
enum ModalType { large, extraLarge, normal }

class EvoModal {
  static Future<Object?> showModal({
    required BuildContext context,
    bool barrierDismissible = true,
    ModalType? modalType = ModalType.normal,
    Icon? leadingIcon,
    Widget? trailingIcon,
    required String title,
    required Widget content,
    List<Widget>? actions, required ModalType modelType,
  }) {
    return showGeneralDialog(
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Modal',
      context: context,
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          transformHitTests: false,
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: const Offset(0.0, 0.0),
          ).animate(animation),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        bool isWeb = MediaQuery.of(context).size.width >= 1100;

        double width = 0.0;

        if (modalType == ModalType.extraLarge && isWeb) {
          width = 1138.0;
        } else if (modalType == ModalType.large && isWeb) {
          width = 798.0;
        } else {
          width = 498;
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  width: width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDark
                          ? theme.colorScheme.outline
                          : theme.colorScheme.onSurface.withOpacity(0.25),
                    ),
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: isDark
                            ? theme.colorScheme.surfaceContainerHighest
                            :  theme.colorScheme.surface.withOpacity(0.94),
                        padding: const EdgeInsets.all(16),
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SelectionArea(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   if (leadingIcon != null)
                                    IconTheme(
                                      data: IconThemeData(
                                        color: isDark
                                            ? EvoColor.white
                                            : theme.colorScheme.onSurfaceVariant,
                                      ),
                                      child: leadingIcon,
                                    )
                                  else
                                    const SizedBox.shrink(),
                                  const SizedBox(width: 20),
                                  Text(
                                    title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color:theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: trailingIcon ?? const SizedBox.shrink(),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 0,
                        color: isDark
                            ? theme.colorScheme.outline
                            : theme.colorScheme.onSurface.withOpacity(0.25),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height - 178.0,
                        ),
                        child: SingleChildScrollView(
                            child: Column(
                          children: [
                            EvoBox.h16,
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: content,
                            ),
                            EvoBox.h16,
                          ],
                        )),
                      ),
                      if (actions != null) ...[
                        Divider(
                          height: 0,
                          color: isDark
                              ? theme.colorScheme.outline
                              : theme.colorScheme.secondary.withOpacity(0.25),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          height: 68,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: actions
                                .map((e) => Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: e,
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}