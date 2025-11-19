import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey)),
        const SizedBox(width: 8),
        const Text("or"),
        const SizedBox(width: 8),
        Expanded(child: Divider(color: Colors.grey)),
      ],
    );
  }
}