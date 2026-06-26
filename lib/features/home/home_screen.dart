import 'package:flutter/material.dart';

import '../../design_system/components/greeting_card.dart';
import '../../design_system/components/now_card.dart';
import '../../design_system/components/screen_scaffold.dart';
import '../../design_system/components/section_label.dart';
import '../../design_system/components/signal_card.dart';
import '../../design_system/pbx_colors.dart';
import '../../design_system/pbx_spacing.dart';
import '../../models/signal.dart';
import '../../repositories/pulse_repository.dart';

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
        final signals = widget.repository.signals.where((signal) {
          return _selectedCategory == null ||
              signal.category == _selectedCategory;
        }).toList();

        return PBXScreenScaffold(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              child: GreetingCard(
                key: ValueKey(widget.repository.mood),
                greeting: widget.repository.greeting,
                mood: widget.repository.mood,
              ),
            ),
            const SectionLabel('Happening now'),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 450),
              child: NowCard(
                key: ValueKey(widget.repository.now.title),
                activity: widget.repository.now,
              ),
            ),
            const SectionLabel('Earlier today'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: _selectedCategory == null,
                    onSelected: () => setState(() => _selectedCategory = null),
                  ),
                  for (final category in const [
                    SignalCategory.activity,
                    SignalCategory.health,
                    SignalCategory.moment,
                    SignalCategory.insight,
                  ])
                    _FilterChip(
                      label: _categoryLabel(category),
                      selected: _selectedCategory == category,
                      onSelected: () {
                        setState(() => _selectedCategory = category);
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: PBXSpacing.sm),
            for (final signal in signals) ...[
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 380),
                child: SignalCard(
                  key: ValueKey('${signal.id}-${signal.title}-${signal.state}'),
                  signal: signal,
                  repository: widget.repository,
                ),
              ),
              const SizedBox(height: PBXSpacing.sm),
            ],
            if (signals.isEmpty)
              Text(
                'Nothing in this view needs attention right now.',
                style: TextStyle(color: context.pbxTextSecondary),
              ),
          ],
        );
      },
    );
  }

  String _categoryLabel(SignalCategory category) {
    return switch (category) {
      SignalCategory.activity => 'Activity',
      SignalCategory.health => 'Health',
      SignalCategory.moment => 'Moments',
      SignalCategory.insight => 'Insights',
      SignalCategory.security => 'Security',
      SignalCategory.recommendation => 'Recommendations',
    };
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: PBXSpacing.sm),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
      ),
    );
  }
}
