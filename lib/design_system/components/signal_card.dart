import 'package:flutter/material.dart';

import '../../features/signal_detail/signal_detail_screen.dart';
import '../../models/signal.dart';
import '../../repositories/pulse_repository.dart';
import '../pbx_colors.dart';
import '../pbx_spacing.dart';

class SignalCard extends StatelessWidget {
  const SignalCard({required this.signal, this.repository, super.key});

  final PulseSignal signal;
  final PulseRepository? repository;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(signal.category);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => SignalDetailScreen(
                signal: signal,
                repository: repository,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(PBXSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: accent.withValues(alpha: 0.18),
                child: Icon(_icon(signal.category), color: accent, size: 22),
              ),
              const SizedBox(width: PBXSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            signal.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(width: PBXSpacing.sm),
                        Text(
                          signal.timeLabel,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: context.pbxTextMuted),
                        ),
                      ],
                    ),
                    if (signal.body != null) ...[
                      const SizedBox(height: PBXSpacing.xs),
                      Text(
                        signal.body!,
                        style: TextStyle(color: context.pbxTextSecondary),
                      ),
                    ],
                    const SizedBox(height: PBXSpacing.sm),
                    Row(
                      children: [
                        _StatePill(signal.state),
                        if (signal.actionLabel != null) ...[
                          const SizedBox(width: PBXSpacing.sm),
                          Text(
                            signal.actionLabel!,
                            style: TextStyle(
                              color: context.pbxAccent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _icon(SignalCategory category) {
    return switch (category) {
      SignalCategory.activity => Icons.bolt_outlined,
      SignalCategory.insight => Icons.auto_graph_outlined,
      SignalCategory.security => Icons.shield_outlined,
      SignalCategory.health => Icons.favorite_border,
      SignalCategory.recommendation => Icons.tips_and_updates_outlined,
      SignalCategory.moment => Icons.nights_stay_outlined,
    };
  }

  Color _accentColor(SignalCategory category) {
    return switch (category) {
      SignalCategory.activity => PBXColors.blue,
      SignalCategory.insight => PBXColors.mint,
      SignalCategory.security => PBXColors.attention,
      SignalCategory.health => PBXColors.pulseGreen,
      SignalCategory.recommendation => PBXColors.amber,
      SignalCategory.moment => PBXColors.mint,
    };
  }
}

class _StatePill extends StatelessWidget {
  const _StatePill(this.state);

  final SignalState state;

  @override
  Widget build(BuildContext context) {
    final text = switch (state) {
      SignalState.active => 'Active',
      SignalState.updated => 'Updated',
      SignalState.resolved => 'Resolved',
      SignalState.dismissed => 'Dismissed',
      SignalState.archived => 'Archived',
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.pbxCardSoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: context.pbxDivider),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: PBXSpacing.sm,
          vertical: 4,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.pbxTextMuted,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
