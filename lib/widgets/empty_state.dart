import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.menu_book, size: 48, color: theme.colorScheme.primary),
          const SizedBox(height: 12),
          Text(message, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
