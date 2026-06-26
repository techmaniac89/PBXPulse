import 'package:flutter/material.dart';

import '../../design_system/components/call_activity_card.dart';
import '../../design_system/components/screen_scaffold.dart';
import '../../design_system/components/section_label.dart';
import '../../design_system/pbx_spacing.dart';
import '../../models/call_activity.dart';
import '../../repositories/pulse_repository.dart';

class CallsScreen extends StatefulWidget {
  const CallsScreen({required this.repository, super.key});

  final PulseRepository repository;

  @override
  State<CallsScreen> createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  var _query = '';
  CallActivityKind? _selectedKind;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.repository,
      builder: (context, _) {
        final calls = widget.repository.calls.where((call) {
          final query = _query.toLowerCase();
          final matchesQuery = query.isEmpty ||
              call.title.toLowerCase().contains(query) ||
              (call.body?.toLowerCase().contains(query) ?? false);
          final matchesKind =
              _selectedKind == null || call.kind == _selectedKind;

          return matchesQuery && matchesKind;
        }).toList();
        final active = calls.where((call) => call.isActive);
        final earlier = calls.where((call) => !call.isActive);

        return PBXScreenScaffold(
          title: 'Calls',
          subtitle: "Who's talking and who called?",
          children: [
            TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search calls',
              ),
            ),
            const SizedBox(height: PBXSpacing.md),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _CallKindChip(
                    label: 'All',
                    selected: _selectedKind == null,
                    onSelected: () => setState(() => _selectedKind = null),
                  ),
                  for (final kind in const [
                    CallActivityKind.active,
                    CallActivityKind.missed,
                    CallActivityKind.voicemail,
                  ])
                    _CallKindChip(
                      label: _kindLabel(kind),
                      selected: _selectedKind == kind,
                      onSelected: () => setState(() => _selectedKind = kind),
                    ),
                ],
              ),
            ),
            const SectionLabel('Active now'),
            if (active.isEmpty)
              Text(
                'The office is quiet. Nobody is on a call right now.',
                style: Theme.of(context).textTheme.bodyLarge,
              )
            else
              for (final call in active) ...[
                CallActivityCard(activity: call),
                const SizedBox(height: PBXSpacing.sm),
              ],
            const SectionLabel('Earlier today'),
            if (earlier.isEmpty)
              Text(
                _query.isEmpty
                    ? 'No earlier calls need your attention.'
                    : 'No calls match that search.',
                style: Theme.of(context).textTheme.bodyLarge,
              )
            else
              for (final call in earlier) ...[
                CallActivityCard(activity: call),
                const SizedBox(height: PBXSpacing.sm),
              ],
          ],
        );
      },
    );
  }

  String _kindLabel(CallActivityKind kind) {
    return switch (kind) {
      CallActivityKind.active => 'Active',
      CallActivityKind.answered => 'Answered',
      CallActivityKind.missed => 'Missed',
      CallActivityKind.voicemail => 'Voicemail',
    };
  }
}

class _CallKindChip extends StatelessWidget {
  const _CallKindChip({
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
