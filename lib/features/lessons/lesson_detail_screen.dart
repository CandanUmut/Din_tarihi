import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/lesson_card.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/bookmark_providers.dart';
import '../../providers/content_providers.dart';
import '../../providers/progress_providers.dart';
import '../../widgets/app_card.dart';
import '../../widgets/error_state.dart';
import '../../widgets/pill_button.dart';
import '../../widgets/section_header.dart';
import 'lesson_quiz_sheet.dart';

class LessonDetailScreen extends ConsumerWidget {
  const LessonDetailScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncCards = ref.watch(lessonCardsProvider);
    return asyncCards.when(
      data: (lessons) {
        final lessonIndex = lessons.indexWhere((element) => element.id == lessonId);
        if (lessonIndex == -1) {
          return Scaffold(
            body: ErrorState(message: l10n.errorState),
          );
        }
        final lesson = lessons[lessonIndex];
        final theme = Theme.of(context);
        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 220,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      lesson.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.85),
                            theme.colorScheme.secondary.withOpacity(0.75),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 80, 24, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lesson.tradition,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              lesson.summary,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                            const Spacer(),
                            Wrap(
                              spacing: 12,
                              children: [
                                Chip(
                                  label: Text(lesson.level.toUpperCase()),
                                  backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.2),
                                ),
                                ...lesson.tags
                                    .take(3)
                                    .map(
                                      (tag) => Chip(
                                        label: Text(tag),
                                        backgroundColor: theme.colorScheme.onPrimary.withOpacity(0.2),
                                      ),
                                    )
                                    .toList(growable: false),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      SectionHeader(
                        title: l10n.lessonOverview,
                        subtitle: l10n.lessonOverviewSubtitle,
                      ),
                      const SizedBox(height: 12),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(lesson.summary, style: theme.textTheme.bodyLarge),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                Chip(
                                  avatar: const Icon(Icons.school, size: 16),
                                  label: Text('${l10n.lessonLevelLabel}: ${lesson.level}'),
                                ),
                                Chip(
                                  avatar: const Icon(Icons.people_alt, size: 16),
                                  label: Text('${l10n.lessonTraditionLabel}: ${lesson.tradition}'),
                                ),
                                Chip(
                                  avatar: const Icon(Icons.menu_book, size: 16),
                                  label: Text(l10n.lessonCoreTextsCount(lesson.coreTexts.length)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      SectionHeader(
                        title: l10n.lessonKeyTakeaways,
                        subtitle: l10n.lessonKeyTakeawaysSubtitle,
                      ),
                      const SizedBox(height: 12),
                      AppCard(
                        child: Column(
                          children: lesson.keyPoints
                              .map(
                                (point) => ListTile(
                                  leading: const Icon(Icons.check_circle_outline),
                                  title: Text(point),
                                ),
                              )
                              .toList(growable: false),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SectionHeader(
                        title: l10n.lessonDiscussionPrompts,
                        subtitle: l10n.lessonDiscussionPromptsSubtitle,
                      ),
                      const SizedBox(height: 12),
                      AppCard(
                        child: Column(
                          children: lesson.discussionQuestions
                              .map(
                                (question) => ListTile(
                                  leading: const Icon(Icons.forum_outlined),
                                  title: Text(question),
                                ),
                              )
                              .toList(growable: false),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SectionHeader(
                        title: l10n.lessonPrimarySources,
                        subtitle: l10n.lessonPrimarySourcesSubtitle,
                      ),
                      const SizedBox(height: 12),
                      AppCard(
                        child: MarkdownBody(data: lesson.coreTexts.join('\n\n')),
                      ),
                      const SizedBox(height: 24),
                      SectionHeader(
                        title: l10n.lessonStudyTools,
                        subtitle: l10n.lessonStudyToolsSubtitle,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          PillButton(
                            label: l10n.markDone,
                            onPressed: () async {
                              final service = await ref.read(progressServiceProvider.future);
                              await service.mark(contentId: lesson.id, percent: 1);
                              ref.invalidate(overallProgressProvider);
                              ref.invalidate(progressEntriesProvider);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.markDoneSuccess)),
                                );
                              }
                            },
                          ),
                          PillButton(
                            label: l10n.bookmarkLabel,
                            variant: PillButtonVariant.secondary,
                            onPressed: () async {
                              final toggle = ref.read(bookmarkToggleProvider);
                              await toggle(lesson.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.bookmarkUpdated)),
                                );
                              }
                            },
                          ),
                          PillButton(
                            label: l10n.takeQuiz,
                            variant: PillButtonVariant.secondary,
                            onPressed: () => showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              builder: (context) => LessonQuizSheet(lesson: lesson),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(body: ErrorState(message: error.toString())),
    );
  }
}
