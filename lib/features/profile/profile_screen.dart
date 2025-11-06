import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/bookmark_providers.dart';
import '../../providers/prefs_providers.dart';
import '../../providers/streak_providers.dart';
import '../../widgets/app_card.dart';
import '../../widgets/error_state.dart';
import 'streak_calendar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final streakAsync = ref.watch(streakStatsProvider);
    final prefsAsync = ref.watch(userPrefsProvider);
    final bookmarksAsync = ref.watch(bookmarksProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          streakAsync.when(
            data: (stats) => AppCard(child: StreakCalendar(stats: stats)),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => ErrorState(message: error.toString()),
          ),
          const SizedBox(height: 24),
          prefsAsync.when(
            data: (prefs) => AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${l10n.dailyGoal}: ${prefs.dailyGoal}'),
                  Text('${l10n.language}: ${prefs.lang}'),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => ErrorState(message: error.toString()),
          ),
          const SizedBox(height: 24),
          bookmarksAsync.when(
            data: (bookmarks) => AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.bookmarks, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  if (bookmarks.isEmpty)
                    Text(l10n.emptyState)
                  else
                    ...bookmarks.map((bookmark) => Text(bookmark.contentId)),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => ErrorState(message: error.toString()),
          ),
        ],
      ),
    );
  }
}
