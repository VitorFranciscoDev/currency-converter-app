import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  const ElevatedButtonWidget({
    super.key,
    required this.function,
    required this.text,
  });
  final VoidCallback function;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => function(),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(24),
        ),
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.grey[400]
      ),
      child: Text(text),
    );
  }
}