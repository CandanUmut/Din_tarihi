import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/history_providers.dart';
import '../../widgets/app_card.dart';
import '../../widgets/error_state.dart';

class ProphetDetailScreen extends ConsumerWidget {
  const ProphetDetailScreen({super.key, required this.prophetId});

  final String prophetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(prophetProfileProvider(prophetId));
    return profileAsync.when(
      data: (profile) {
        final theme = Theme.of(context);
        Widget buildVisual(String? assetPath, IconData icon) {
          final borderRadius = BorderRadius.circular(16);
          if (assetPath != null && assetPath.isNotEmpty) {
            return ClipRRect(
              borderRadius: borderRadius,
              child: Image.asset(
                assetPath,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: theme.colorScheme.surfaceVariant,
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 64, color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            );
          }

          return Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.secondaryContainer,
                ],
              ),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 64, color: theme.colorScheme.onPrimaryContainer),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text(profile.name)),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            children: [
              buildVisual(profile.heroImage, Icons.person_outline),
              const SizedBox(height: 16),
              Text(profile.title, style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('${profile.era} • ${profile.region}', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.lessonOverview, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(profile.summary),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (profile.themes.isNotEmpty) ...[
                Text(l10n.historyThemes, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: profile.themes
                      .map((themeLabel) => Chip(label: Text(themeLabel)))
                      .toList(growable: false),
                ),
                const SizedBox(height: 24),
              ],
              Text(l10n.historyKeyEvents, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              ...profile.keyEvents.map(
                (event) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    child: ListTile(
                      title: Text(event.title),
                      subtitle: Text(event.description),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.mapNotes, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              buildVisual(profile.mapImage, Icons.map_outlined),
              const SizedBox(height: 24),
              Text(l10n.historyVirtues, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              ...profile.virtues.map((virtue) => ListTile(
                    leading: const Icon(Icons.star_outline),
                    title: Text(virtue),
                  )),
              const SizedBox(height: 24),
              Text(l10n.historyStudyPrompts, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              ...profile.studyPrompts.map((prompt) => ListTile(
                    leading: const Icon(Icons.question_answer_outlined),
                    title: Text(prompt),
                  )),
              const SizedBox(height: 24),
              Text(l10n.historyFurtherReading, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: profile.furtherReading
                      .map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text('• $item'),
                          ))
                      .toList(growable: false),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(body: ErrorState(message: error.toString())),
    );
  }
}
