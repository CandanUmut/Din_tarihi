import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/i18n/locale_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/prefs_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final prefsAsync = ref.watch(userPrefsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: prefsAsync.when(
        data: (prefs) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.language),
                DropdownButton<String>(
                  value: prefs.lang,
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'tr', child: Text('Türkçe')),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    final notifier = ref.read(userPrefsProvider.notifier);
                    notifier.update(prefs.copyWith(lang: value));
                    ref.read(localeProvider.notifier).setLocale(Locale(value));
                  },
                ),
                const SizedBox(height: 24),
                Text(l10n.dailyGoal),
                Slider(
                  value: prefs.dailyGoal.toDouble(),
                  min: 5,
                  max: 30,
                  divisions: 5,
                  label: '${prefs.dailyGoal} min',
                  onChanged: (value) {
                    final notifier = ref.read(userPrefsProvider.notifier);
                    notifier.update(prefs.copyWith(dailyGoal: value.round()));
                  },
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
      ),
    );
  }
}
