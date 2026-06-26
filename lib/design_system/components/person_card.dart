import 'package:flutter/material.dart';

import '../../models/person.dart';
import '../pbx_colors.dart';
import '../pbx_spacing.dart';

class PersonCard extends StatelessWidget {
  const PersonCard({required this.person, this.onTap, super.key});

  final PBXPerson person;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(person.status);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(PBXSpacing.md),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withValues(alpha: 0.18),
                child: Text(
                  person.name.substring(0, 1),
                  style: TextStyle(color: color, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: PBXSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: PBXSpacing.xs),
                    Text(
                      '${person.extension} - ${person.statusText}',
                      style: TextStyle(color: context.pbxTextSecondary),
                    ),
                    if (person.detail != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        person.detail!,
                        style: TextStyle(color: context.pbxTextMuted),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: context.pbxTextMuted),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(PersonStatus status) {
    return switch (status) {
      PersonStatus.online => PBXColors.pulseGreen,
      PersonStatus.talking => PBXColors.blue,
      PersonStatus.unavailable => PBXColors.attention,
      PersonStatus.quiet => PBXColors.lightTextMuted,
    };
  }
}
