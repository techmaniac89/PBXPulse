import 'package:flutter/material.dart';

import '../pbx_colors.dart';
import '../pbx_spacing.dart';
import 'beating_icon.dart';

class GreetingCard extends StatelessWidget {
  const GreetingCard({
    required this.greeting,
    required this.mood,
    super.key,
  });

  final String greeting;
  final String mood;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PBXSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    greeting,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.pbxCardSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(PBXSpacing.sm),
                    child: PBXBeatingIcon(
                      icon: Icons.favorite,
                      color: context.pbxAccent,
                      size: 20,
                      duration: const Duration(milliseconds: 2200),
                      beginScale: 0.96,
                      endScale: 1.07,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: PBXSpacing.sm),
            Text(
              mood,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: context.pbxTextSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
