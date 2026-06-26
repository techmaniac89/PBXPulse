import 'package:flutter/material.dart';

import '../../design_system/components/section_label.dart';
import '../../design_system/pbx_colors.dart';
import '../../design_system/pbx_spacing.dart';
import '../../features/people/person_detail_screen.dart';
import '../../models/person.dart';
import '../../models/signal.dart';
import '../../repositories/pulse_repository.dart';

class SignalDetailScreen extends StatelessWidget {
  const SignalDetailScreen({required this.signal, this.repository, super.key});

  final PulseSignal signal;
  final PulseRepository? repository;

  @override
  Widget build(BuildContext context) {
    final listenable = repository;

    if (listenable == null) {
      return _SignalDetailBody(signal: signal);
    }

    return AnimatedBuilder(
      animation: listenable,
      builder: (context, _) {
        final liveSignal = listenable.signals.firstWhere(
          (candidate) => candidate.id == signal.id,
          orElse: () => signal,
        );

        return _SignalDetailBody(signal: liveSignal, repository: listenable);
      },
    );
  }
}

class _SignalDetailBody extends StatelessWidget {
  const _SignalDetailBody({required this.signal, this.repository});

  final PulseSignal signal;
  final PulseRepository? repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signal')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          PBXSpacing.md,
          PBXSpacing.md,
          PBXSpacing.md,
          PBXSpacing.xl,
        ),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(PBXSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    signal.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (signal.body != null) ...[
                    const SizedBox(height: PBXSpacing.sm),
                    Text(
                      signal.body!,
                      style: TextStyle(color: context.pbxTextSecondary),
                    ),
                  ],
                  const SizedBox(height: PBXSpacing.md),
                  Text(
                    signal.timeLabel,
                    style: TextStyle(color: context.pbxTextMuted),
                  ),
                ],
              ),
            ),
          ),
          const SectionLabel('What you can do'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(PBXSpacing.md),
              child: Wrap(
                spacing: PBXSpacing.sm,
                runSpacing: PBXSpacing.sm,
                children: [
                  FilledButton.icon(
                    onPressed: repository == null
                        ? null
                        : () => _showDiagnosis(context, signal),
                    icon: const Icon(Icons.health_and_safety_outlined),
                    label: const Text('Diagnose'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _relatedPerson(context) == null
                        ? null
                        : () => _openPerson(context),
                    icon: const Icon(Icons.person_outline),
                    label: const Text('Open person'),
                  ),
                  TextButton.icon(
                    onPressed: repository == null ||
                            signal.state == SignalState.dismissed
                        ? null
                        : () => repository!.dismissSignal(signal),
                    icon: const Icon(Icons.done),
                    label: const Text('Dismiss'),
                  ),
                ],
              ),
            ),
          ),
          const SectionLabel('Why?'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(PBXSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final reason in signal.why) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Icon(
                            Icons.check_circle,
                            size: 18,
                            color: PBXColors.pulseGreen,
                          ),
                        ),
                        const SizedBox(width: PBXSpacing.sm),
                        Expanded(child: Text(reason)),
                      ],
                    ),
                    const SizedBox(height: PBXSpacing.sm),
                  ],
                ],
              ),
            ),
          ),
          const SectionLabel('Technical details'),
          Card(
            child: ExpansionTile(
              tilePadding:
                  const EdgeInsets.symmetric(horizontal: PBXSpacing.lg),
              childrenPadding: const EdgeInsets.fromLTRB(
                PBXSpacing.lg,
                0,
                PBXSpacing.lg,
                PBXSpacing.lg,
              ),
              title: const Text('Show technical evidence'),
              children: [
                for (final entry in signal.technical.entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: PBXSpacing.sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            entry.key,
                            style: TextStyle(color: context.pbxTextMuted),
                          ),
                        ),
                        const SizedBox(width: PBXSpacing.md),
                        Expanded(
                          child: Text(
                            entry.value,
                            textAlign: TextAlign.end,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openPerson(BuildContext context) {
    final person = _relatedPerson(context);
    final activeRepository = repository;

    if (person == null || activeRepository == null) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PersonDetailScreen(
          person: person,
          repository: activeRepository,
        ),
      ),
    );
  }

  void _showDiagnosis(BuildContext context, PulseSignal signal) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              PBXSpacing.lg,
              0,
              PBXSpacing.lg,
              PBXSpacing.xl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Diagnosis',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: PBXSpacing.sm),
                Text(
                  'Genesis is not running real diagnostics yet. PBXPulse would check reachability, registration state, and recent related Signals here.',
                  style: TextStyle(color: context.pbxTextSecondary),
                ),
                const SizedBox(height: PBXSpacing.lg),
                for (final reason in signal.why)
                  Padding(
                    padding: const EdgeInsets.only(bottom: PBXSpacing.sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 18,
                          color: context.pbxAccent,
                        ),
                        const SizedBox(width: PBXSpacing.sm),
                        Expanded(child: Text(reason)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  PBXPerson? _relatedPerson(BuildContext context) {
    return repository?.personForSignal(signal);
  }
}
