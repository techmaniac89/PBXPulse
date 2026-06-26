import 'package:flutter/material.dart';

import '../../design_system/components/beating_icon.dart';
import '../../design_system/components/connection_chip.dart';
import '../../design_system/pbx_colors.dart';
import '../../design_system/pbx_spacing.dart';
import '../../models/call_activity.dart';
import '../../models/connection_status.dart';
import '../../models/signal.dart';
import '../../repositories/pulse_repository.dart';
import '../signal_detail/signal_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.repository, super.key});

  final PulseRepository repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SignalCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.repository,
      builder: (context, _) {
        final signals = widget.repository.signals;
        final visibleSignals = _selectedCategory == null
            ? signals
            : signals
                .where((signal) => signal.category == _selectedCategory)
                .toList();

        return ListView(
          padding: const EdgeInsets.fromLTRB(
            PBXSpacing.lg,
            PBXSpacing.lg,
            PBXSpacing.lg,
            PBXSpacing.xl,
          ),
          children: [
            _BrandRow(status: widget.repository.connection),
            const SizedBox(height: PBXSpacing.xl),
            _GreetingHero(
              greeting: widget.repository.greeting,
              mood: widget.repository.mood,
              quietText: widget.repository.now.isActive
                  ? 'A call is active.'
                  : widget.repository.now.title,
            ),
            const SizedBox(height: PBXSpacing.xl),
            _CurrentCallCard(activity: widget.repository.now),
            const SizedBox(height: PBXSpacing.xl),
            _SignalsHeader(signalCount: signals.length),
            const SizedBox(height: PBXSpacing.sm),
            _HomeSignalCategories(
              signals: signals,
              selectedCategory: _selectedCategory,
              onSelected: (category) {
                setState(() => _selectedCategory = category);
              },
            ),
            const SizedBox(height: PBXSpacing.md),
            for (final signal in visibleSignals) ...[
              _CozySignalRow(
                signal: signal,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => SignalDetailScreen(
                        signal: signal,
                        repository: widget.repository,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: PBXSpacing.sm),
            ],
            if (visibleSignals.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(PBXSpacing.lg),
                  child: Text(
                    'No Signals in this category right now.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            const SizedBox(height: PBXSpacing.lg),
          ],
        );
      },
    );
  }
}

class _BrandRow extends StatelessWidget {
  const _BrandRow({required this.status});

  final ConnectionStatus status;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PBXBeatingIcon(
          icon: Icons.favorite,
          color: context.pbxAccent,
          size: 34,
          beginScale: 0.96,
          endScale: 1.08,
          duration: const Duration(milliseconds: 2200),
        ),
        const SizedBox(width: PBXSpacing.sm),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 31,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
            children: [
              const TextSpan(text: 'PBX'),
              TextSpan(
                text: 'Pulse',
                style: TextStyle(color: context.pbxAccent),
              ),
            ],
          ),
        ),
        const Spacer(),
        ConnectionChip(
          status: status,
          compact: true,
          icon: Icons.local_florist,
        ),
      ],
    );
  }
}

class _GreetingHero extends StatelessWidget {
  const _GreetingHero({
    required this.greeting,
    required this.mood,
    required this.quietText,
  });

  final String greeting;
  final String mood;
  final String quietText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                height: 1.02,
              ),
        ),
        const SizedBox(height: PBXSpacing.md),
        Text(
          mood,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: PBXSpacing.lg),
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.pbxCardSoft.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PBXSpacing.lg,
              vertical: PBXSpacing.md,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.apartment,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: PBXSpacing.md),
                Text(
                  quietText,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CurrentCallCard extends StatelessWidget {
  const _CurrentCallCard({required this.activity});

  final CallActivity activity;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: PBXColors.cozyTextMuted.withValues(alpha: 0.18),
      child: Padding(
        padding: const EdgeInsets.all(PBXSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: context.pbxCardSoft,
                  child: Icon(
                    Icons.call,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: PBXSpacing.md),
                Expanded(
                  child: Text(
                    activity.isActive ? 'Current Call' : 'Current Moment',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                _ActivePill(active: activity.isActive),
              ],
            ),
            const SizedBox(height: PBXSpacing.lg),
            Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: context.pbxCardSoft,
                  child: Icon(
                    activity.isActive ? Icons.person : Icons.spa_outlined,
                    size: 36,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: PBXSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      if (activity.body != null) ...[
                        const SizedBox(height: PBXSpacing.xs),
                        Text(
                          activity.body!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: context.pbxTextMuted),
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  activity.isActive ? '01:24' : activity.timeLabel,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: context.pbxTextMuted),
                ),
              ],
            ),
            const SizedBox(height: PBXSpacing.lg),
            Row(
              children: [
                Expanded(child: _Waveform(active: activity.isActive)),
                if (activity.isActive) ...[
                  const SizedBox(width: PBXSpacing.lg),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(74, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Icon(Icons.call_end, color: context.pbxAccent),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivePill extends StatelessWidget {
  const _ActivePill({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.pbxCardSoft.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Row(
          children: [
            Icon(
              Icons.circle,
              size: 10,
              color: active
                  ? Theme.of(context).colorScheme.primary
                  : context.pbxTextMuted,
            ),
            const SizedBox(width: 8),
            Text(
              active ? 'ACTIVE' : 'QUIET',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: active
                        ? Theme.of(context).colorScheme.primary
                        : context.pbxTextMuted,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Waveform extends StatelessWidget {
  const _Waveform({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    const heights = [6.0, 14.0, 20.0, 12.0, 24.0, 9.0, 18.0, 22.0, 12.0, 16.0];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final height in heights)
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: (active
                        ? Theme.of(context).colorScheme.primary
                        : context.pbxTextMuted)
                    .withValues(alpha: 0.62),
                borderRadius: BorderRadius.circular(99),
              ),
              child: SizedBox(width: 5, height: height),
            ),
          ),
      ],
    );
  }
}

class _SignalsHeader extends StatelessWidget {
  const _SignalsHeader({required this.signalCount});

  final int signalCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.notifications, color: PBXColors.cozyAmber),
        const SizedBox(width: PBXSpacing.sm),
        Expanded(
          child: Text(
            'Signals',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        Text(
          '$signalCount total',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.pbxTextMuted,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _HomeSignalCategories extends StatelessWidget {
  const _HomeSignalCategories({
    required this.signals,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<PulseSignal> signals;
  final SignalCategory? selectedCategory;
  final ValueChanged<SignalCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _HomeCategoryChip(
            label: 'All',
            count: signals.length,
            selected: selectedCategory == null,
            onSelected: () => onSelected(null),
          ),
          for (final category in SignalCategory.values) ...[
            const SizedBox(width: PBXSpacing.sm),
            _HomeCategoryChip(
              label: category.label,
              count:
                  signals.where((signal) => signal.category == category).length,
              selected: selectedCategory == category,
              onSelected: () => onSelected(category),
            ),
          ],
        ],
      ),
    );
  }
}

class _HomeCategoryChip extends StatelessWidget {
  const _HomeCategoryChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text('$label $count'),
      selected: selected,
      onSelected: (_) => onSelected(),
      labelStyle: TextStyle(
        color: selected
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
      selectedColor: Theme.of(context).colorScheme.primary,
      backgroundColor: context.pbxCardSoft,
      side: BorderSide(color: context.pbxDivider),
    );
  }
}

class _CozySignalRow extends StatelessWidget {
  const _CozySignalRow({required this.signal, required this.onTap});

  final PulseSignal signal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _accent(signal.category);

    return Card(
      elevation: 1,
      shadowColor: PBXColors.cozyTextMuted.withValues(alpha: 0.14),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(PBXSpacing.md),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: accent.withValues(alpha: 0.16),
                child: Icon(_icon(signal.category), color: accent, size: 30),
              ),
              const SizedBox(width: PBXSpacing.md),
              Expanded(
                child: Text(
                  signal.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.28,
                      ),
                ),
              ),
              const SizedBox(width: PBXSpacing.sm),
              Text(
                signal.timeLabel,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: context.pbxTextMuted),
              ),
              Icon(Icons.chevron_right, color: context.pbxTextMuted),
            ],
          ),
        ),
      ),
    );
  }

  IconData _icon(SignalCategory category) {
    return switch (category) {
      SignalCategory.activity => Icons.phone_missed_outlined,
      SignalCategory.insight => Icons.groups_2_outlined,
      SignalCategory.security => Icons.shield_outlined,
      SignalCategory.health => Icons.verified_outlined,
      SignalCategory.recommendation => Icons.tips_and_updates_outlined,
      SignalCategory.moment => Icons.storage_outlined,
    };
  }

  Color _accent(SignalCategory category) {
    return switch (category) {
      SignalCategory.activity => PBXColors.cozyCoral,
      SignalCategory.insight => PBXColors.cozySage,
      SignalCategory.security => PBXColors.cozyCoral,
      SignalCategory.health => PBXColors.cozySage,
      SignalCategory.recommendation => PBXColors.cozyAmber,
      SignalCategory.moment => PBXColors.cozyAmber,
    };
  }
}

extension _SignalCategoryLabel on SignalCategory {
  String get label {
    return switch (this) {
      SignalCategory.activity => 'Activity',
      SignalCategory.insight => 'Insights',
      SignalCategory.security => 'Security',
      SignalCategory.health => 'Health',
      SignalCategory.recommendation => 'Tips',
      SignalCategory.moment => 'Moments',
    };
  }
}
