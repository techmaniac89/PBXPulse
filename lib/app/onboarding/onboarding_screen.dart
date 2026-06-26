import 'package:flutter/material.dart';

import '../../design_system/pbx_colors.dart';
import '../../design_system/pbx_spacing.dart';
import '../app_settings.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({required this.settings, super.key});

  final PBXAppSettings settings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(PBXSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.pbxCardSoft,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(PBXSpacing.lg),
                  child: Icon(
                    Icons.favorite,
                    size: 44,
                    color: context.pbxAccent,
                  ),
                ),
              ),
              const SizedBox(height: PBXSpacing.lg),
              Text(
                'Connect your PBX',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: PBXSpacing.sm),
              Text(
                'Genesis uses a mock PBX so you can feel how PBXPulse will work before an agent exists.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: context.pbxTextSecondary),
              ),
              const SizedBox(height: PBXSpacing.xl),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(PBXSpacing.lg),
                  child: Row(
                    children: [
                      Icon(Icons.qr_code_2, color: context.pbxAccent, size: 42),
                      const SizedBox(width: PBXSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'QR pairing will live here.',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: PBXSpacing.xs),
                            Text(
                              'For now, PBXPulse connects to Genesis mock Signals.',
                              style: TextStyle(color: context.pbxTextSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: settings.completeOnboarding,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Use Genesis mock PBX'),
                ),
              ),
              const SizedBox(height: PBXSpacing.sm),
              Center(
                child: Text(
                  'No backend. No Asterisk. Just the product feeling.',
                  style: TextStyle(color: context.pbxTextMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
