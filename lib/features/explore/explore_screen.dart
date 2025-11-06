import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/content_providers.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import 'search_bar.dart';
import 'tag_chip.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  late final TextEditingController controller;
  final tags = const ['faith', 'prophets', 'law', 'spirituality', 'interfaith'];
  String activeTag = '';

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(searchQueryProvider);
    final asyncResults = ref.watch(searchResultsProvider(query));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.explore)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ExploreSearchBar(
              controller: controller,
              hint: l10n.searchHint,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: tags
                  .map(
                    (tag) => TagChip(
                      label: tag,
                      selected: activeTag == tag,
                      onSelected: (value) {
                        setState(() {
                          activeTag = value ? tag : '';
                        });
                        final next = value ? tag : controller.text;
                        ref.read(searchQueryProvider.notifier).state = next;
                      },
                    ),
                  )
                  .toList(growable: false),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                ref.read(searchQueryProvider.notifier).state = controller.text;
              },
              child: Text(l10n.searchResults),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: asyncResults.when(
                data: (lessons) {
                  if (lessons.isEmpty) {
                    return EmptyState(message: l10n.emptyState);
                  }
                  return ListView.builder(
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = lessons[index];
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
