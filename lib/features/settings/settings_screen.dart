import 'package:flutter/material.dart';

import '../../design_system/components/screen_scaffold.dart';
import '../../design_system/components/section_label.dart';
import '../../design_system/pbx_colors.dart';
import '../../design_system/pbx_spacing.dart';
import '../../app/app_settings.dart';
import '../../repositories/pulse_repository.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    required this.repository,
    required this.settings,
    super.key,
  });

  final PulseRepository repository;
  final PBXAppSettings settings;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.settings,
      builder: (context, _) {
        return PBXScreenScaffold(
          title: 'Settings',
          subtitle: 'PBXPulse stays small here.',
          children: [
            const SectionLabel('Connection'),
            _SettingsTile(
              icon: Icons.router_outlined,
              title: 'Connected PBX',
              body: 'Genesis Office PBX',
              onTap: _showConnectionSheet,
            ),
            const SizedBox(height: PBXSpacing.sm),
            _SettingsTile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              body: widget.settings.meaningfulNotifications
                  ? 'Only meaningful Signals'
                  : 'Paused for now',
              onTap: _showNotificationSheet,
            ),
            const SizedBox(height: PBXSpacing.sm),
            _SettingsTile(
              icon: Icons.palette_outlined,
              title: 'Appearance',
              body: '${widget.settings.themeLabel} theme',
              onTap: _showAppearanceSheet,
            ),
            const SizedBox(height: PBXSpacing.sm),
            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy',
              body: widget.settings.localOnlyMode
                  ? 'Local-first and private'
                  : 'Standard privacy',
              onTap: _showPrivacySheet,
            ),
            const SizedBox(height: PBXSpacing.sm),
            _SettingsTile(
              icon: Icons.restart_alt,
              title: 'Reset Genesis demo',
              body: 'Start over with mock data',
              onTap: _showResetSheet,
            ),
            const SizedBox(height: PBXSpacing.sm),
            _SettingsTile(
              icon: Icons.info_outline,
              title: 'About',
              body: 'Genesis 0.1.0 alpha 3',
              onTap: _showAboutSheet,
            ),
          ],
        );
      },
    );
  }

  void _showAppearanceSheet() {
    _showSettingsSheet(
      title: 'Appearance',
      icon: Icons.palette_outlined,
      children: [
        AnimatedBuilder(
          animation: widget.settings,
          builder: (context, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.dark,
                      icon: Icon(Icons.dark_mode_outlined),
                      label: Text('Dark'),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      icon: Icon(Icons.light_mode_outlined),
                      label: Text('Light'),
                    ),
                    ButtonSegment(
                      value: ThemeMode.system,
                      icon: Icon(Icons.settings_suggest_outlined),
                      label: Text('System'),
                    ),
                  ],
                  selected: {widget.settings.themeMode},
                  onSelectionChanged: (selection) {
                    widget.settings.setThemeMode(selection.first);
                    setState(() {});
                  },
                ),
                const SizedBox(height: PBXSpacing.md),
                _PlainNote(
                  text: _modeNote(widget.settings.themeMode),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  String _modeNote(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.dark => 'Warm dark room colors with sage and coral accents.',
      ThemeMode.light => 'Cream, sage, coral, and amber for bright rooms.',
      ThemeMode.system => 'Brightness follows this device.',
    };
  }

  void _showConnectionSheet() {
    final connection = widget.repository.connection;

    _showSettingsSheet(
      title: 'Genesis Office PBX',
      icon: Icons.router_outlined,
      children: [
        _DetailRow(label: 'Connection', value: connection.label),
        const _DetailRow(label: 'Quality', value: 'Healthy'),
        _DetailRow(label: 'Agent', value: connection.agentVersion),
        _DetailRow(label: 'Last contact', value: connection.lastContact),
        const SizedBox(height: PBXSpacing.md),
        Text(
          connection.detail,
          style: TextStyle(color: context.pbxTextSecondary),
        ),
      ],
    );
  }

  void _showNotificationSheet() {
    _showSettingsSheet(
      title: 'Notifications',
      icon: Icons.notifications_outlined,
      children: [
        StatefulBuilder(
          builder: (context, setSheetState) {
            return Column(
              children: [
                SwitchListTile(
                  value: widget.settings.meaningfulNotifications,
                  onChanged: (value) {
                    widget.settings.setMeaningfulNotifications(value);
                    setSheetState(() {});
                  },
                  title: const Text('Meaningful Signals'),
                  subtitle: const Text(
                    'PBXPulse only speaks when something is worth attention.',
                  ),
                ),
                SwitchListTile(
                  value: widget.settings.quietMoments,
                  onChanged: widget.settings.meaningfulNotifications
                      ? (value) {
                          widget.settings.setQuietMoments(value);
                          setSheetState(() {});
                        }
                      : null,
                  title: const Text('Quiet healthy moments'),
                  subtitle: const Text(
                    'Include calm updates like successful backups and stable days.',
                  ),
                ),
                const SizedBox(height: PBXSpacing.md),
                const _NotificationPreviewCard(
                  icon: Icons.notifications_active_outlined,
                  title: 'Would notify',
                  body: 'Warehouse phone has been offline for several minutes.',
                ),
                const SizedBox(height: PBXSpacing.sm),
                const _NotificationPreviewCard(
                  icon: Icons.notifications_paused_outlined,
                  title: 'Would stay quiet',
                  body: 'Reception briefly refreshed its registration.',
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _showPrivacySheet() {
    _showSettingsSheet(
      title: 'Privacy',
      icon: Icons.privacy_tip_outlined,
      children: [
        StatefulBuilder(
          builder: (context, setSheetState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  value: widget.settings.localOnlyMode,
                  onChanged: (value) {
                    widget.settings.setLocalOnlyMode(value);
                    setSheetState(() {});
                  },
                  title: const Text('Local-first mode'),
                  subtitle: const Text(
                    'Genesis keeps all mock PBX activity on this device.',
                  ),
                ),
                const SizedBox(height: PBXSpacing.sm),
                const _PlainNote(
                  text:
                      'No mandatory cloud account. No required telemetry. Technical details stay one tap deeper.',
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _showResetSheet() {
    _showSettingsSheet(
      title: 'Reset Genesis demo',
      icon: Icons.restart_alt,
      children: [
        const _PlainNote(
          text:
              'This clears mock onboarding and Settings choices so you can replay Genesis from the beginning.',
        ),
        const SizedBox(height: PBXSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              widget.settings.resetGenesisDemo();
            },
            icon: const Icon(Icons.restart_alt),
            label: const Text('Reset demo'),
          ),
        ),
      ],
    );
  }

  void _showAboutSheet() {
    _showSettingsSheet(
      title: 'PBXPulse',
      icon: Icons.favorite,
      children: const [
        _PlainNote(
          text:
              "PBXPulse listens to your PBX, so you don't have to. Genesis is focused on making the app feel alive before it becomes useful.",
        ),
        SizedBox(height: PBXSpacing.lg),
        _DetailRow(label: 'Version', value: '0.1.0-alpha.3'),
        _DetailRow(label: 'Build', value: '3'),
        _DetailRow(label: 'Milestone', value: 'Genesis'),
        _DetailRow(label: 'Backend', value: 'Mock Signals only'),
        _DetailRow(label: 'Networking', value: 'Not yet'),
      ],
    );
  }

  void _showSettingsSheet({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: context.pbxCardSoft,
                        child: Icon(icon, color: context.pbxAccent),
                      ),
                      const SizedBox(width: PBXSpacing.md),
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Close',
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: PBXSpacing.lg),
                  ...children,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(PBXSpacing.md),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: context.pbxCardSoft,
                child: Icon(icon, color: context.pbxAccent),
              ),
              const SizedBox(width: PBXSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: PBXSpacing.xs),
                    Text(
                      body,
                      style: TextStyle(color: context.pbxTextSecondary),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: context.pbxTextMuted),
            ],
          ),
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

class _PlainNote extends StatelessWidget {
  const _PlainNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(color: context.pbxTextSecondary));
  }
}

class _NotificationPreviewCard extends StatelessWidget {
  const _NotificationPreviewCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(PBXSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: context.pbxAccent),
            const SizedBox(width: PBXSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: PBXSpacing.xs),
                  Text(body, style: TextStyle(color: context.pbxTextSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
