import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/content_providers.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';

class LessonListScreen extends ConsumerStatefulWidget {
  const LessonListScreen({super.key});

  @override
  ConsumerState<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends ConsumerState<LessonListScreen> {
  String activeTag = '';
  final tags = const ['faith', 'prophets', 'law', 'spirituality', 'interfaith'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final asyncCards = ref.watch(lessonCardsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.lessons)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              children: tags
                  .map(
                    (tag) => FilterChip(
                      label: Text(tag),
                      selected: tag == activeTag,
                      onSelected: (value) => setState(() => activeTag = value ? tag : ''),
                    ),
                  )
                  .toList(growable: false),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: asyncCards.when(
                data: (lessons) {
                  final filtered = activeTag.isEmpty
                      ? lessons
                      : lessons.where((lesson) => lesson.tags.contains(activeTag)).toList();
                  if (filtered.isEmpty) {
                    return EmptyState(message: l10n.emptyState);
                  }
                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final lesson = filtered[index];
                      return Padding(
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
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => ErrorState(message: error.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
