import 'package:flutter/material.dart';

import '../../models/call_activity.dart';
import '../pbx_colors.dart';
import '../pbx_spacing.dart';

class NowCard extends StatelessWidget {
  const NowCard({required this.activity, super.key});

  final CallActivity activity;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PBXSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: PBXColors.pulseGreen,
              child: Icon(Icons.call, color: PBXColors.background),
            ),
            const SizedBox(width: PBXSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Now',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: context.pbxTextMuted,
                        ),
                  ),
                  const SizedBox(height: PBXSpacing.xs),
                  Text(
                    activity.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (activity.body != null) ...[
                    const SizedBox(height: PBXSpacing.xs),
                    Text(
                      activity.body!,
                      style: TextStyle(color: context.pbxTextSecondary),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
