import 'package:flutter/material.dart';

import '../../models/call_activity.dart';
import '../pbx_colors.dart';
import '../pbx_spacing.dart';

class CallActivityCard extends StatelessWidget {
  const CallActivityCard({required this.activity, super.key});

  final CallActivity activity;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PBXSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: activity.isActive
                  ? PBXColors.pulseGreen
                  : context.pbxCardSoft,
              child: Icon(
                activity.isActive ? Icons.call : Icons.history,
                color: activity.isActive
                    ? PBXColors.background
                    : context.pbxTextSecondary,
              ),
            ),
            const SizedBox(width: PBXSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activity.title,
                      style: Theme.of(context).textTheme.titleMedium),
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
            const SizedBox(width: PBXSpacing.sm),
            Text(
              activity.timeLabel,
              style: TextStyle(color: context.pbxTextMuted),
            ),
          ],
        ),
      ),
    );
  }
}
