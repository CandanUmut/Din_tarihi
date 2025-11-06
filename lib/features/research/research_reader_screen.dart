import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/content_providers.dart';
import '../../widgets/error_state.dart';
import 'academic_sidebar_callout.dart';

class ResearchReaderScreen extends ConsumerStatefulWidget {
  const ResearchReaderScreen({super.key});

  @override
  ConsumerState<ResearchReaderScreen> createState() => _ResearchReaderScreenState();
}

class _ResearchReaderScreenState extends ConsumerState<ResearchReaderScreen> {
  bool showSidebar = true;
  String query = '';

  @override
  Widget build(BuildContext context) {
    final asyncSections = ref.watch(bookSectionsProvider);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.research),
        actions: [
          IconButton(
            icon: Icon(showSidebar ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => showSidebar = !showSidebar),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.searchHint,
              ),
              onChanged: (value) => setState(() => query = value),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: asyncSections.when(
                data: (sections) {
                  final filtered = query.isEmpty
                      ? sections
                      : sections.where((section) {
                          final text = '${section.heading}\n${section.body}'.toLowerCase();
                          return text.contains(query.toLowerCase());
                        }).toList();
                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final section = filtered[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (section.heading.isNotEmpty)
                            Text(section.heading, style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 8),
                          MarkdownBody(data: section.body),
                          if (showSidebar && section.body.contains('['))
                            AcademicSidebarCallout(text: section.body),
                          const Divider(height: 32),
                        ],
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
