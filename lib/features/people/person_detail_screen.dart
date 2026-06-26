import 'package:flutter/material.dart';

import '../../design_system/components/call_activity_card.dart';
import '../../design_system/components/section_label.dart';
import '../../design_system/components/signal_card.dart';
import '../../design_system/pbx_colors.dart';
import '../../design_system/pbx_spacing.dart';
import '../../models/person.dart';
import '../../repositories/pulse_repository.dart';

enum _PersonDetailView { activity, signals, details }

class PersonDetailScreen extends StatefulWidget {
  const PersonDetailScreen({
    required this.person,
    required this.repository,
    super.key,
  });

  final PBXPerson person;
  final PulseRepository repository;

  @override
  State<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends State<PersonDetailScreen> {
  var _selectedView = _PersonDetailView.activity;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.repository,
      builder: (context, _) {
        final currentPerson = widget.repository.people.firstWhere(
          (candidate) => candidate.extension == widget.person.extension,
          orElse: () => widget.person,
        );
        final calls = widget.repository.callsFor(currentPerson);
        final signals = widget.repository.signalsFor(currentPerson);

        return Scaffold(
          appBar: AppBar(title: Text(currentPerson.name)),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(
              PBXSpacing.md,
              PBXSpacing.md,
              PBXSpacing.md,
              PBXSpacing.xl,
            ),
            children: [
              _PersonSummary(person: currentPerson),
              const SizedBox(height: PBXSpacing.lg),
              SegmentedButton<_PersonDetailView>(
                segments: const [
                  ButtonSegment(
                    value: _PersonDetailView.activity,
                    icon: Icon(Icons.history),
                    label: Text('Activity'),
                  ),
                  ButtonSegment(
                    value: _PersonDetailView.signals,
                    icon: Icon(Icons.bolt_outlined),
                    label: Text('Signals'),
                  ),
                  ButtonSegment(
                    value: _PersonDetailView.details,
                    icon: Icon(Icons.info_outline),
                    label: Text('Details'),
                  ),
                ],
                selected: {_selectedView},
                onSelectionChanged: (selection) {
                  setState(() => _selectedView = selection.first);
                },
              ),
              const SizedBox(height: PBXSpacing.md),
              if (_selectedView == _PersonDetailView.activity) ...[
                const SectionLabel('Recent activity'),
                if (calls.isEmpty)
                  const _QuietCard(
                    title: 'Nothing recent.',
                    body: 'PBXPulse has not seen call activity here today.',
                  )
                else
                  for (final call in calls) ...[
                    CallActivityCard(activity: call),
                    const SizedBox(height: PBXSpacing.sm),
                  ],
              ],
              if (_selectedView == _PersonDetailView.signals) ...[
                const SectionLabel('Related Signals'),
                if (signals.isEmpty)
                  const _QuietCard(
                    title: 'Everything looks calm.',
                    body: 'No Signals are currently attached to this person.',
                  )
                else
                  for (final signal in signals) ...[
                    SignalCard(signal: signal, repository: widget.repository),
                    const SizedBox(height: PBXSpacing.sm),
                  ],
              ],
              if (_selectedView == _PersonDetailView.details) ...[
                const SectionLabel('Technical details'),
                Card(
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: PBXSpacing.lg,
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(
                      PBXSpacing.lg,
                      0,
                      PBXSpacing.lg,
                      PBXSpacing.lg,
                    ),
                    title: const Text('Show device evidence'),
                    children: [
                      _DetailRow(
                        label: 'Extension',
                        value: currentPerson.extension,
                      ),
                      _DetailRow(
                        label: 'Status',
                        value: currentPerson.statusText,
                      ),
                      const _DetailRow(
                        label: 'Source',
                        value: 'Genesis mock People',
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _PersonSummary extends StatelessWidget {
  const _PersonSummary({required this.person});

  final PBXPerson person;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(person.status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PBXSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withValues(alpha: 0.18),
              child: Text(
                person.name.substring(0, 1),
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: PBXSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(person.name,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: PBXSpacing.xs),
                  Text(
                    '${person.extension} - ${person.statusText}',
                    style: TextStyle(color: context.pbxTextSecondary),
                  ),
                  if (person.detail != null) ...[
                    const SizedBox(height: PBXSpacing.sm),
                    Text(
                      person.detail!,
                      style: TextStyle(color: context.pbxTextMuted),
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

  Color _statusColor(PersonStatus status) {
    return switch (status) {
      PersonStatus.online => PBXColors.pulseGreen,
      PersonStatus.talking => PBXColors.blue,
      PersonStatus.unavailable => PBXColors.attention,
      PersonStatus.quiet => PBXColors.lightTextMuted,
    };
  }
}

class _QuietCard extends StatelessWidget {
  const _QuietCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PBXSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: PBXSpacing.xs),
            Text(body, style: TextStyle(color: context.pbxTextSecondary)),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: PBXSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: context.pbxTextMuted),
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
