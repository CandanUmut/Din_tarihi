import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/history_providers.dart';
import 'prophet_timeline.dart';

class HistoryTimelineScreen extends ConsumerWidget {
  const HistoryTimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final prophetsAsync = ref.watch(prophetProfilesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.timelineTitle)),
      body: prophetsAsync.when(
        data: (profiles) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            ProphetTimeline(
              profiles: profiles,
              onTap: (profile) => context.go('/history/prophets/${profile.id}'),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
      ),
    );
  }
}
