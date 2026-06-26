import 'package:flutter/material.dart';

import '../pbx_spacing.dart';

class PBXScreenScaffold extends StatelessWidget {
  const PBXScreenScaffold({
    required this.children,
    this.title,
    this.subtitle,
    super.key,
  });

  final String? title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        PBXSpacing.md,
        PBXSpacing.lg,
        PBXSpacing.md,
        PBXSpacing.xl,
      ),
      children: [
        if (title != null) ...[
          Text(title!, style: Theme.of(context).textTheme.headlineMedium),
          if (subtitle != null) ...[
            const SizedBox(height: PBXSpacing.xs),
            Text(subtitle!, style: Theme.of(context).textTheme.bodyLarge),
          ],
          const SizedBox(height: PBXSpacing.lg),
        ],
        ...children,
      ],
    );
  }
}
