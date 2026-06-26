import 'package:flutter/material.dart';

import '../pbx_colors.dart';
import '../pbx_spacing.dart';
import 'beating_icon.dart';

class PulseCard extends StatelessWidget {
  const PulseCard({
    required this.icon,
    required this.title,
    required this.body,
    this.accent = PBXColors.pulseGreen,
    this.beating = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color accent;
  final bool beating;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PBXSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: accent.withValues(alpha: 0.18),
              child: beating
                  ? PBXBeatingIcon(icon: icon, color: accent)
                  : Icon(icon, color: accent),
            ),
            const SizedBox(width: PBXSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: PBXSpacing.xs),
                  Text(
                    body,
                    style: TextStyle(color: context.pbxTextSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
