import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/streak.dart';
import '../../widgets/streak_heatmap.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.greeting,
    required this.streakAsync,
    required this.streakLabelBuilder,
  });

  final String greeting;
  final AsyncValue<StreakStats> streakAsync;
  final String Function(int days) streakLabelBuilder;

  @override
  Widget build(BuildContext context) {
    return streakAsync.when(
      data: (stats) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(greeting, style: Theme.of(context).textTheme.displayLarge),
          const SizedBox(height: 8),
          Text(streakLabelBuilder(stats.current)),
          const SizedBox(height: 16),
          StreakHeatmap(days: stats.days),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text(error.toString()),
    );
  }
}
