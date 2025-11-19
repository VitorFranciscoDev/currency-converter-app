import 'package:flutter/material.dart';

class OutlinedButtonWidget extends StatelessWidget {
  const OutlinedButtonWidget({ super.key, required this.function, required this.message1, required this.message2 });
  final VoidCallback function;
  final String message1;
  final String message2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton(
      onPressed: () => function(),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        side: BorderSide(
          color: theme.colorScheme.primary,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message1,
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          Text(
            message2,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}