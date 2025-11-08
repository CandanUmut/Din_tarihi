import 'package:flutter/material.dart';

import '../../data/models/prophet_profile.dart';

class ProphetTimeline extends StatelessWidget {
  const ProphetTimeline({super.key, required this.profiles, required this.onTap});

  final List<ProphetProfile> profiles;
  final ValueChanged<ProphetProfile> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: profiles
          .map(
            (profile) => Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: _ProphetAvatar(profile: profile),
                title: Text(profile.name),
                subtitle: Text('${profile.era} • ${profile.region}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => onTap(profile),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _ProphetAvatar extends StatelessWidget {
  const _ProphetAvatar({required this.profile});

  final ProphetProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayLetter = profile.name.trim().isNotEmpty
        ? profile.name.trim()[0].toUpperCase()
        : '?';
    final placeholder = CircleAvatar(
      radius: 24,
      backgroundColor: theme.colorScheme.primaryContainer,
      child: Text(
        displayLetter,
        style: theme.textTheme.titleMedium
            ?.copyWith(color: theme.colorScheme.onPrimaryContainer),
      ),
    );

    final imagePath = profile.heroImage;
    if (imagePath == null || imagePath.isEmpty) {
      return placeholder;
    }

    return CircleAvatar(
      radius: 24,
      backgroundImage: AssetImage(imagePath),
      onBackgroundImageError: (_, __) {},
    );
  }
}
