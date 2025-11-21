import 'package:flutter/material.dart';

class AlertDialogWidget extends StatelessWidget {
  const AlertDialogWidget({super.key, required this.title, this.action1, this.action1message, required this.action2, required this.action2message});
  final String title;
  final VoidCallback? action1;
  final String? action1message;
  final VoidCallback action2;
  final String action2message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.primary,
        ),
      ),
      actions: [
        if(action1 != null)
          TextButton(
            onPressed: action1, 
            child: Text(
              action1message!,
              style: TextStyle(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        TextButton(
          onPressed: action2, 
          style: TextButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.background,
          ),
          child: Text(action2message),
        ),
      ],
    );
  }
}