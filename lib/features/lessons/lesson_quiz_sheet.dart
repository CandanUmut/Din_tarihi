import 'package:flutter/material.dart';

import '../../data/models/lesson_card.dart';
import '../../l10n/app_localizations.dart';

class LessonQuizSheet extends StatefulWidget {
  const LessonQuizSheet({super.key, required this.lesson});

  final LessonCard lesson;

  @override
  State<LessonQuizSheet> createState() => _LessonQuizSheetState();
}

class _LessonQuizSheetState extends State<LessonQuizSheet> {
  final Map<int, String> answers = {};
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.lesson.title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          ...List.generate(widget.lesson.quiz.length, (index) {
            final question = widget.lesson.quiz[index];
            final selected = answers[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(question.question, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...question.options.map(
                  (option) => RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: selected,
                    onChanged: submitted
                        ? null
                        : (value) => setState(() {
                              answers[index] = value ?? '';
                            }),
                  ),
                ),
                if (submitted)
                  Text(
                    selected == question.answer ? l10n.answerCorrect : l10n.answerIncorrect,
                    style: TextStyle(
                      color: selected == question.answer ? Colors.green : Colors.red,
                    ),
                  ),
                const SizedBox(height: 12),
              ],
            );
          }),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: submitted
                ? () => Navigator.pop(context)
                : () => setState(() {
                      submitted = true;
                    }),
            child: Text(submitted ? l10n.actionContinue : l10n.quiz),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
