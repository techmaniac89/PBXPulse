enum ConnectionKind { local, vpn, secureRemote, reconnecting }

class ConnectionStatus {
  const ConnectionStatus({
    required this.kind,
    required this.label,
    required this.detail,
    required this.agentVersion,
    required this.lastContact,
  });

  final ConnectionKind kind;
  final String label;
  final String detail;
  final String agentVersion;
  final String lastContact;
}
