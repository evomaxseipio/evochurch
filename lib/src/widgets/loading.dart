

 // Custom loading UI with subtle animation
import 'package:flutter/material.dart';

Widget simpleLoadingUI(BuildContext context, String message) {
  return Container(
    height: 300,
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    ),
  );
}
