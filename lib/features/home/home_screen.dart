import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/content_providers.dart';
import '../../providers/progress_providers.dart';
import '../../providers/streak_providers.dart';
import '../../widgets/app_card.dart';
import '../../widgets/progress_ring.dart';
import '../../widgets/section_header.dart';
import 'home_header.dart';
import 'progress_header.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progressAsync = ref.watch(overallProgressProvider);
    final streakAsync = ref.watch(streakStatsProvider);
    final lessonsAsync = ref.watch(lessonCardsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(overallProgressProvider);
          ref.invalidate(streakStatsProvider);
          ref.invalidate(lessonCardsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            HomeHeader(
              greeting: l10n.homeGreeting,
              streakAsync: streakAsync,
              streakLabelBuilder: (days) => l10n.streakDays(days),
            ),
            const SizedBox(height: 24),
            progressAsync.when(
              data: (percent) => ProgressHeader(
                percent: percent,
                label: l10n.completionRate,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text(error.toString()),
            ),
            const SizedBox(height: 24),
            SectionHeader(title: l10n.continueLearning, action: null),
            const SizedBox(height: 12),
            AppCard(
              onTap: () => context.go('/lessons'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.lessons, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(l10n.action_continue),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SectionHeader(title: l10n.explore, action: null),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _QuickLink(label: l10n.lessons, icon: Icons.menu_book, onTap: () => context.go('/lessons')),
                _QuickLink(label: l10n.history, icon: Icons.timeline, onTap: () => context.go('/history')),
                _QuickLink(label: l10n.research, icon: Icons.science, onTap: () => context.go('/research')),
                _QuickLink(label: l10n.flashcards, icon: Icons.bolt, onTap: () => context.go('/flashcards')),
              ],
            ),
            const SizedBox(height: 24),
            SectionHeader(title: l10n.lessons, action: null),
            const SizedBox(height: 12),
            lessonsAsync.when(
              data: (lessons) => Column(
                children: lessons
                    .take(3)
                    .map(
                      (lesson) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AppCard(
                          onTap: () => context.go('/lessons/${lesson.id}'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(lesson.title, style: Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 4),
                              Text(lesson.summary, maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 8),
                              Wrap(spacing: 6, children: lesson.tags.map((tag) => Chip(label: Text(tag))).toList()),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text(error.toString()),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickLink extends StatelessWidget {
  const _QuickLink({required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }
}
