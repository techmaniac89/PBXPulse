import 'package:flutter/material.dart';

import '../../models/connection_status.dart';
import '../pbx_colors.dart';
import '../pbx_spacing.dart';

class ConnectionChip extends StatelessWidget {
  const ConnectionChip({required this.status, super.key});

  final ConnectionStatus status;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(_icon, size: 18, color: context.pbxAccent),
      label: Text(status.label),
      onPressed: () => _showDetails(context),
      backgroundColor: context.pbxCardSoft,
      side: BorderSide(color: context.pbxDivider),
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: PBXSpacing.sm,
        vertical: PBXSpacing.xs,
      ),
    );
  }

  IconData get _icon {
    return switch (status.kind) {
      ConnectionKind.local => Icons.lan_outlined,
      ConnectionKind.vpn => Icons.lock_outline,
      ConnectionKind.secureRemote => Icons.public_outlined,
      ConnectionKind.reconnecting => Icons.sync_outlined,
    };
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
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
              Text(status.label, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: PBXSpacing.sm),
              Text(status.detail),
              const SizedBox(height: PBXSpacing.lg),
              _DetailRow(label: 'Agent', value: status.agentVersion),
              _DetailRow(label: 'Last contact', value: status.lastContact),
              const _DetailRow(label: 'Encryption', value: 'Protected'),
            ],
          ),
        );
      },
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
