import 'package:flutter/material.dart';

import '../../design_system/components/pulse_card.dart';
import '../../design_system/components/screen_scaffold.dart';
import '../../design_system/components/section_label.dart';
import '../../design_system/pbx_colors.dart';
import '../../design_system/pbx_spacing.dart';
import '../../repositories/pulse_repository.dart';

class PulseScreen extends StatelessWidget {
  const PulseScreen({required this.repository, super.key});

  final PulseRepository repository;

  @override
  Widget build(BuildContext context) {
    return const PBXScreenScaffold(
      title: 'Pulse',
      subtitle: 'Everything is running smoothly.',
      children: [
        PulseCard(
          icon: Icons.favorite,
          title: 'Today',
          body: 'Your PBX has stayed reachable and calls are moving normally.',
          beating: true,
        ),
        SizedBox(height: PBXSpacing.sm),
        SectionLabel("Things we've noticed"),
        PulseCard(
          icon: Icons.auto_graph,
          title: 'Reception has been steady.',
          body:
              'Calls are a little quieter than usual, with no missed-call pattern.',
          accent: PBXColors.blue,
        ),
        SizedBox(height: PBXSpacing.sm),
        SectionLabel('Recommendations'),
        PulseCard(
          icon: Icons.tips_and_updates,
          title: 'Nothing urgent.',
          body: 'PBXPulse does not see anything that needs action right now.',
          accent: PBXColors.amber,
        ),
        SizedBox(height: PBXSpacing.sm),
        SectionLabel('Moments'),
        PulseCard(
          icon: Icons.nights_stay,
          title: 'Backups have been consistent.',
          body: 'Your nightly backup has completed successfully for 14 nights.',
        ),
      ],
    );
  }
}
