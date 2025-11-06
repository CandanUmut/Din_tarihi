import 'package:flutter/material.dart';

class ProgressRing extends StatelessWidget {
  const ProgressRing({super.key, required this.percent, required this.label});

  final double percent;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 96,
          height: 96,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: percent.clamp(0, 1),
                strokeWidth: 8,
              ),
              Center(
                child: Text(
                  '${(percent * 100).round()}%',
                  style: theme.textTheme.headlineMedium,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: theme.textTheme.labelLarge),
      ],
    );
  }
}
