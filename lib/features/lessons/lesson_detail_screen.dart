import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final asyncCards = ref.watch(lessonCardsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: asyncCards.when(
        data: (lessons) {
          final lesson = lessons.firstWhere((element) => element.id == lessonId);
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(lesson.title, style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 16),
              Text(lesson.summary, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 24),
              SectionHeader(title: 'Key points', action: null),
              const SizedBox(height: 8),
              ...lesson.keyPoints.map((point) => ListTile(leading: const Icon(Icons.check), title: Text(point))),
              const SizedBox(height: 24),
              SectionHeader(title: 'Discussion', action: null),
              ...lesson.discussionQuestions
                  .map((question) => ListTile(leading: const Icon(Icons.question_answer), title: Text(question))),
              const SizedBox(height: 24),
              SectionHeader(title: 'Academic sidebar', action: null),
              AppCard(
                child: MarkdownBody(data: lesson.coreTexts.join('\n\n')),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  PillButton(
                    label: 'Mark done',
                    onPressed: () async {
                      final service = await ref.read(progressServiceProvider.future);
                      await service.mark(contentId: lesson.id, percent: 1);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Marked as completed')),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  PillButton(
                    label: 'Bookmark',
                    variant: PillButtonVariant.secondary,
                    onPressed: () async {
                      final toggle = ref.read(bookmarkToggleProvider);
                      await toggle(lesson.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Bookmark updated')),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  PillButton(
                    label: 'Quiz',
                    variant: PillButtonVariant.secondary,
                    onPressed: () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => LessonQuizSheet(lesson: lesson),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorState(message: error.toString()),
      ),
    );
  }
}
