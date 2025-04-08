import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

  enum ModalTypeMessage {
    success,
    error,
    warning,
    info,
    confirmation,
    deletion
  }
class CupertinoModalOptions {
  // Enum for modal types

  // Comprehensive modal with multiple configuration options
  static Future<bool?> show({
    // Required parameters
    required BuildContext context,
    
    // Modal content parameters
    String? title,
    String? message,
    
    // Modal type configuration
    ModalTypeMessage modalType = ModalTypeMessage.info,
    
    // Action buttons configuration
    List<ModalAction>? actions,
    
    // Visual and behavior options
    bool isDismissible = true,
    bool barrierDismissible = true,
    bool centerTitle = true,
    double? iconSize,
    
    // Callback options
    VoidCallback? onClose,
  }) {
    // Select icon based on modal type
    IconData getIconForModalType() {
      switch (modalType) {
        case ModalTypeMessage.success:
          return CupertinoIcons.check_mark_circled_solid;
        case ModalTypeMessage.error:
          return CupertinoIcons.clear_circled_solid;
        case ModalTypeMessage.warning:
          return CupertinoIcons.exclamationmark_triangle_fill;
        case ModalTypeMessage.info:
          return CupertinoIcons.info_circle_fill;
        case ModalTypeMessage.confirmation:
          return CupertinoIcons.question_circle_fill;
        case ModalTypeMessage.deletion:
          return CupertinoIcons.delete_solid;
      }
    }

    // Select color based on modal type
    Color getColorForModalType() {
      switch (modalType) {
        case ModalTypeMessage.success:
          return CupertinoColors.activeGreen;
        case ModalTypeMessage.error:
          return CupertinoColors.destructiveRed;
        case ModalTypeMessage.warning:
          return CupertinoColors.systemOrange;
        case ModalTypeMessage.info:
          return CupertinoColors.systemBlue;
        case ModalTypeMessage.confirmation:
          return CupertinoColors.systemPurple;
        case ModalTypeMessage.deletion:
          return CupertinoColors.destructiveRed;
      }
    }

    // Default actions if not provided
    final defaultActions = [
      ModalAction(
        text: 'OK',
        isDefaultAction: true,
        onPressed: () => true,
      )
    ];

    return showCupertinoDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: title != null
              ? Column(
                  mainAxisAlignment: centerTitle
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    Icon(
                      getIconForModalType(),
                      color: getColorForModalType(),
                      size: iconSize ?? 60,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: TextStyle(
                        color: getColorForModalType(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : null,
          content: message != null ? Text(message) : null,
          actions: (actions ?? defaultActions)
              .map(
                (action) => CupertinoDialogAction(
                  isDefaultAction: action.isDefaultAction,
                  isDestructiveAction: action.isDestructiveAction,
                  onPressed: () {
                    // Close the dialog and call the action's onPressed
                    Navigator.of(context).pop(
                      action.onPressed?.call() ?? false,
                    );
                    
                    // Call any additional onClose callback
                    onClose?.call();
                  },
                  child: Text(
                    action.text,
                    style: TextStyle(
                      color: action.isDestructiveAction
                          ? CupertinoColors.destructiveRed
                          : CupertinoColors.systemBlue,
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  // Example usage method
  static void showExampleModals(BuildContext context) {
    // Success Modal
    show(
      context: context,
      title: 'Success',
      message: 'Operation completed successfully!',
      modalType: ModalTypeMessage.success,
    );

    // Error Modal
    show(
      context: context,
      title: 'Error',
      message: 'Something went wrong.',
      modalType: ModalTypeMessage.error,
    );

    // Confirmation Modal with Custom Actions
    show(
      context: context,
      title: 'Confirm Action',
      message: 'Are you sure you want to proceed?',
      modalType: ModalTypeMessage.confirmation,
      actions: [
        ModalAction(
          text: 'Cancel',
          isDefaultAction: true,
          onPressed: () => false,
        ),
        ModalAction(
          text: 'Confirm',
          isDestructiveAction: true,
          onPressed: () => true,
        ),
      ],
    );
  }
}

// Custom class to define modal actions
class ModalAction {
  final String text;
  final bool isDefaultAction;
  final bool isDestructiveAction;
  final bool Function()? onPressed;

  ModalAction({
    required this.text,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    this.onPressed,
  });
}

// Example Widget to demonstrate usage
class CupertinoModalDemo extends StatelessWidget {
  const CupertinoModalDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Modal Options Demo'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success Modal Button
            CupertinoButton.filled(
              child: const Text('Show Success Modal'),
              onPressed: () => CupertinoModalOptions.show(
                context: context,
                title: 'Success',
                message: 'Operation completed successfully!',
                modalType: ModalTypeMessage.success,
              ),
            ),
            const SizedBox(height: 10),

            // Confirmation Modal Button  
            CupertinoButton(
              color: CupertinoColors.systemPurple,
              child: const Text('Show Confirmation Modal'),
              onPressed: () => CupertinoModalOptions.show(
                context: context,
                title: 'Confirm Action',
                message: 'Are you sure you want to proceed?',
                modalType: ModalTypeMessage.confirmation,
                actions: [
                  ModalAction(
                    text: 'Confirm',
                    isDefaultAction: true,
                    onPressed: () => false,
                  ),
                  ModalAction(
                    text: 'Cancel',
                    isDestructiveAction: true,
                    onPressed: () => true,
                  ),
                ],
              ),
            ),
            
            // Error Modal Button
            CupertinoButton(
              color: CupertinoColors.destructiveRed,
              child: const Text('Show Error Modal'),
              onPressed: () => CupertinoModalOptions.show(
                context: context,
                title: 'Error',
                message: 'Something went wrong.',
                modalType: ModalTypeMessage.error,
              ),
            ),
            const SizedBox(height: 10),
            
            // Deletion Confirmation Button
            CupertinoButton(
              color: CupertinoColors.systemRed,
              child: const Text('Show Delete Confirmation'),
              onPressed: () => CupertinoModalOptions.show(
                context: context,
                title: 'Delete Item',
                message: 'Are you sure you want to delete this item?',
                modalType: ModalTypeMessage.deletion,
                actions: [
                  ModalAction(
                    text: 'Cancel',
                    isDefaultAction: true,
                    onPressed: () => false,
                  ),
                  ModalAction(
                    text: 'Delete',
                    isDestructiveAction: true,
                    onPressed: () => true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const CupertinoApp(
      home: CupertinoModalDemo(),
    ),
  );
}