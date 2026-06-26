import 'package:flutter/material.dart';

import '../pbx_colors.dart';
import '../pbx_spacing.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: PBXSpacing.lg,
        bottom: PBXSpacing.sm,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: context.pbxTextMuted,
            ),
      ),
    );
  }
}
