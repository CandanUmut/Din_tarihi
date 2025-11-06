import 'package:flutter/material.dart';

import '../../widgets/progress_ring.dart';

class ProgressHeader extends StatelessWidget {
  const ProgressHeader({super.key, required this.percent, required this.label});

  final double percent;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProgressRing(percent: percent, label: label),
        const SizedBox(width: 24),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
