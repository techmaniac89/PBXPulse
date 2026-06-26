import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/call_activity.dart';
import '../models/connection_status.dart';
import '../models/person.dart';
import '../models/signal.dart';
import '../repositories/pulse_repository.dart';

class MockPulseRepository extends PulseRepository {
  MockPulseRepository({bool autoStart = true}) {
    _now = _initialNow;
    _signals = List.of(_initialSignals);
    _calls = List.of(_initialCalls);
    _people = List.of(_initialPeople);

    if (autoStart) {
      startGenesisPulse();
    }
  }

  final List<Timer> _timers = [];
  late CallActivity _now;
  late List<PulseSignal> _signals;
  late List<CallActivity> _calls;
  late List<PBXPerson> _people;
  var _mood = 'Everything looks healthy.';
  var _genesisMomentIndex = 0;

  @override
  String get greeting => 'Good evening';

  @override
  String get mood => _mood;

  @override
  ConnectionStatus get connection => const ConnectionStatus(
        kind: ConnectionKind.local,
        label: 'Connected locally',
        detail: 'Your phone is reaching the PBXPulse Agent on this network.',
        agentVersion: 'Genesis mock',
        lastContact: 'Just now',
      );

  @override
  CallActivity get now => _now;

  @override
  List<PulseSignal> get signals => List.unmodifiable(_signals);

  @override
  List<CallActivity> get calls => List.unmodifiable(_calls);

  @override
  List<PBXPerson> get people => List.unmodifiable(_people);

  @override
  List<CallActivity> callsFor(PBXPerson person) {
    return _calls.where((call) {
      return call.title.contains(person.name) ||
          (call.body?.contains(person.name) ?? false);
    }).toList();
  }

  @override
  List<PulseSignal> signalsFor(PBXPerson person) {
    return _signals.where((signal) {
      return signal.title.contains(person.name) ||
          (signal.body?.contains(person.name) ?? false) ||
          signal.technical['extension'] == person.extension ||
          signal.technical['endpoint'] == person.extension;
    }).toList();
  }

  @override
  PBXPerson? personForSignal(PulseSignal signal) {
    final extension =
        signal.technical['extension'] ?? signal.technical['endpoint'];

    if (extension == null) {
      return null;
    }

    for (final person in _people) {
      if (person.extension == extension) {
        return person;
      }
    }

    return null;
  }

  @override
  void dismissSignal(PulseSignal signal) {
    _signals = _signals.map((candidate) {
      if (candidate.id != signal.id) {
        return candidate;
      }

      return candidate.copyWith(
        state: SignalState.dismissed,
        body: 'Dismissed for now. PBXPulse will keep listening quietly.',
        timeLabel: 'Just now',
      );
    }).toList();
    notifyListeners();
  }

  void startGenesisPulse() {
    if (_timers.isNotEmpty) {
      return;
    }

    _timers
      ..add(Timer(const Duration(seconds: 5), _noticeDoorPhone))
      ..add(Timer(const Duration(seconds: 10), _resolveReceptionCall))
      ..add(Timer(const Duration(seconds: 15), _addCalmMoment));
  }

  @visibleForTesting
  void advanceGenesisPulseForTest() {
    switch (_genesisMomentIndex) {
      case 0:
        _noticeDoorPhone();
      case 1:
        _resolveReceptionCall();
      default:
        _addCalmMoment();
    }
    _genesisMomentIndex += 1;
  }

  void _noticeDoorPhone() {
    _signals = [
      const PulseSignal(
        id: 'sig_door_phone_checked_in',
        kind: 'device_healthy',
        category: SignalCategory.health,
        importance: SignalImportance.feed,
        state: SignalState.active,
        title: 'Door Phone checked in normally.',
        body: 'PBXPulse saw its regular heartbeat just now.',
        timeLabel: 'Just now',
        why: [
          'Door Phone refreshed its registration.',
          'The latest keepalive check received a response.',
        ],
        technical: {
          'endpoint': '105',
          'status': 'Reachable',
          'source': 'Genesis mock lifecycle',
        },
      ),
      ..._signals,
    ];
    _mood = 'One fresh heartbeat came in. Everything still looks calm.';
    notifyListeners();
  }

  void _resolveReceptionCall() {
    _now = const CallActivity(
      title: 'The office is quiet.',
      body: 'Nobody is on a call right now.',
      timeLabel: 'Now',
    );
    _calls = [
      const CallActivity(
        title: 'Reception finished talking to Maria.',
        body: 'The call lasted about 7 minutes.',
        timeLabel: 'Just now',
        kind: CallActivityKind.answered,
      ),
      ..._calls.where((call) => !call.isActive),
    ];
    _people = [
      const PBXPerson(
        name: 'Reception',
        extension: '101',
        status: PersonStatus.online,
        statusText: 'Online',
        detail: 'Last call ended just now',
      ),
      ..._people.where((person) => person.extension != '101'),
    ];
    _signals = _signals.map((signal) {
      if (signal.id != 'sig_reception_maria') {
        return signal;
      }

      return signal.copyWith(
        state: SignalState.resolved,
        title: 'Reception finished talking to Maria.',
        body: 'The call lasted about 7 minutes.',
        timeLabel: 'Just now',
        why: [
          'The call reached Reception.',
          'Reception answered before the caller waited long.',
          'The call ended normally.',
        ],
        technical: {
          ...signal.technical,
          'final_state': 'Completed',
          'duration': '7 minutes',
        },
      );
    }).toList();
    _mood = 'The office is quiet now.';
    notifyListeners();
  }

  void _addCalmMoment() {
    _signals = [
      const PulseSignal(
        id: 'sig_genesis_quiet_day',
        kind: 'quiet_day',
        category: SignalCategory.moment,
        importance: SignalImportance.feed,
        state: SignalState.active,
        title: 'It has been a calm stretch.',
        body: 'No missed-call pattern or device trouble has appeared.',
        timeLabel: 'Just now',
        why: [
          'Recent calls completed normally.',
          'People and devices are checking in.',
          'PBXPulse has not seen anything that needs attention.',
        ],
        technical: {'source': 'Genesis mock lifecycle'},
      ),
      ..._signals,
    ];
    _mood = 'PBXPulse is listening quietly.';
    notifyListeners();
  }

  @override
  void dispose() {
    for (final timer in _timers) {
      timer.cancel();
    }
    super.dispose();
  }

  static const _initialNow = CallActivity(
    title: 'Reception is talking to Maria.',
    body: 'Started 2 minutes ago.',
    timeLabel: 'Now',
    isActive: true,
    kind: CallActivityKind.active,
  );

  static const _initialSignals = [
    PulseSignal(
      id: 'sig_reception_maria',
      kind: 'call_answered',
      category: SignalCategory.activity,
      importance: SignalImportance.feed,
      state: SignalState.active,
      title: 'Reception answered Maria.',
      body: 'Maria waited only a few seconds.',
      timeLabel: '2 minutes ago',
      why: [
        'The call reached Reception.',
        'Reception answered before the caller waited long.',
      ],
      technical: {
        'channel': 'PJSIP/101-00000042',
        'caller': 'Maria',
        'extension': '101',
      },
    ),
    PulseSignal(
      id: 'sig_quiet_afternoon',
      kind: 'call_volume_quiet',
      category: SignalCategory.insight,
      importance: SignalImportance.feed,
      state: SignalState.active,
      title: 'Calls have been quieter than usual this afternoon.',
      body: 'Nothing needs your attention.',
      timeLabel: '18 minutes ago',
      why: [
        'PBXPulse compared today with recent afternoons.',
        'Call volume is lower, but missed calls are not increasing.',
      ],
      technical: {'comparison_window': 'last 14 weekdays'},
    ),
    PulseSignal(
      id: 'sig_backup_ok',
      kind: 'backup_success',
      category: SignalCategory.moment,
      importance: SignalImportance.feed,
      state: SignalState.resolved,
      title: 'Nightly backup completed successfully.',
      body: 'Your backup streak is now 14 nights.',
      timeLabel: 'Today, 03:12',
      why: [
        'The scheduled backup finished without errors.',
        'PBXPulse found a new backup file after the job completed.',
      ],
      technical: {
        'job': 'nightly-pbx-backup',
        'duration': '4 minutes 18 seconds',
      },
    ),
    PulseSignal(
      id: 'sig_warehouse_returned',
      kind: 'device_recovered',
      category: SignalCategory.health,
      importance: SignalImportance.attention,
      state: SignalState.resolved,
      title: 'Warehouse phone is back online.',
      body: 'It was unavailable for about 8 minutes.',
      timeLabel: '1 hour ago',
      actionLabel: 'Open person',
      why: [
        'The phone stopped refreshing its registration.',
        'Recent keepalive checks are responding again.',
      ],
      technical: {
        'endpoint': '203',
        'last_status': 'Reachable',
        'previous_status': 'Unreachable',
      },
    ),
    PulseSignal(
      id: 'sig_sales_ring_group_busy',
      kind: 'ring_group_busy',
      category: SignalCategory.activity,
      importance: SignalImportance.feed,
      state: SignalState.active,
      title: 'Sales had a short busy spell.',
      body: 'Three calls arrived close together, and all were answered.',
      timeLabel: '28 minutes ago',
      why: [
        'Sales received several calls within a few minutes.',
        'No caller abandoned before someone answered.',
      ],
      technical: {
        'ring_group': 'Sales',
        'extension': '130',
        'answered_calls': '3',
      },
    ),
    PulseSignal(
      id: 'sig_support_missed_pattern',
      kind: 'missed_call_pattern',
      category: SignalCategory.recommendation,
      importance: SignalImportance.attention,
      state: SignalState.active,
      title: 'Support missed two calls close together.',
      body: 'It may be worth checking whether someone is covering Support.',
      timeLabel: '36 minutes ago',
      actionLabel: 'Open person',
      why: [
        'Two callers reached Support and did not connect.',
        'Support has been quiet since then.',
      ],
      technical: {
        'extension': '120',
        'missed_calls': '2',
        'window': '14 minutes',
      },
    ),
    PulseSignal(
      id: 'sig_conference_room_awake',
      kind: 'device_healthy',
      category: SignalCategory.health,
      importance: SignalImportance.feed,
      state: SignalState.resolved,
      title: 'Conference Room woke up normally.',
      body: 'The room phone checked in after being idle overnight.',
      timeLabel: 'Today, 08:41',
      why: [
        'The endpoint refreshed its registration.',
        'Recent keepalive checks are responding.',
      ],
      technical: {
        'endpoint': '305',
        'status': 'Reachable',
        'idle_before': '12 hours',
      },
    ),
    PulseSignal(
      id: 'sig_after_hours_clean',
      kind: 'after_hours_clean',
      category: SignalCategory.moment,
      importance: SignalImportance.feed,
      state: SignalState.resolved,
      title: 'After-hours calls were handled cleanly.',
      body: 'Overnight callers reached the expected voicemail path.',
      timeLabel: 'Today, 07:55',
      why: [
        'The night route accepted calls.',
        'Voicemail recorded successfully.',
      ],
      technical: {
        'route': 'after-hours',
        'voicemails': '2',
      },
    ),
    PulseSignal(
      id: 'sig_billing_back_online',
      kind: 'device_recovered',
      category: SignalCategory.health,
      importance: SignalImportance.feed,
      state: SignalState.resolved,
      title: 'Billing phone is reachable again.',
      body: 'It missed one check-in and recovered on the next one.',
      timeLabel: '2 hours ago',
      actionLabel: 'Open person',
      why: [
        'Billing briefly stopped refreshing its registration.',
        'The next keepalive check received a response.',
      ],
      technical: {
        'endpoint': '142',
        'previous_status': 'Lagged',
        'last_status': 'Reachable',
      },
    ),
    PulseSignal(
      id: 'sig_ops_call_load_normal',
      kind: 'call_load_normal',
      category: SignalCategory.insight,
      importance: SignalImportance.feed,
      state: SignalState.active,
      title: 'Operations call load looks normal.',
      body: 'Today is close to the usual Friday rhythm.',
      timeLabel: '2 hours ago',
      why: [
        'PBXPulse compared Operations calls with recent Fridays.',
        'Answered and missed calls are within the normal range.',
      ],
      technical: {
        'department': 'Operations',
        'comparison_window': 'last 8 Fridays',
      },
    ),
    PulseSignal(
      id: 'sig_lobby_tablet_checked_in',
      kind: 'device_healthy',
      category: SignalCategory.health,
      importance: SignalImportance.feed,
      state: SignalState.active,
      title: 'Lobby tablet checked in.',
      body: 'The visitor device is online and reachable.',
      timeLabel: '3 hours ago',
      why: [
        'The device refreshed its registration.',
        'The latest keepalive check received a response.',
      ],
      technical: {
        'endpoint': '401',
        'status': 'Reachable',
      },
    ),
  ];

  static const _initialCalls = [
    CallActivity(
      title: 'Reception is talking to Maria.',
      body: 'Started 2 minutes ago.',
      timeLabel: 'Active now',
      isActive: true,
      kind: CallActivityKind.active,
    ),
    CallActivity(
      title: 'John called Reception.',
      body: 'Answered after 6 seconds.',
      timeLabel: '12 minutes ago',
      kind: CallActivityKind.answered,
    ),
    CallActivity(
      title: 'Maria left a voicemail.',
      body: 'The office line was already busy.',
      timeLabel: '42 minutes ago',
      kind: CallActivityKind.voicemail,
    ),
    CallActivity(
      title: 'Alex missed Support.',
      body: 'Support was quiet when the call arrived.',
      timeLabel: '1 hour ago',
      kind: CallActivityKind.missed,
    ),
    CallActivity(
      title: 'Nikos called Sales.',
      body: 'Answered by Elena after 9 seconds.',
      timeLabel: '16 minutes ago',
      kind: CallActivityKind.answered,
    ),
    CallActivity(
      title: 'Courier called Warehouse.',
      body: 'Warehouse answered while already busy.',
      timeLabel: '19 minutes ago',
      kind: CallActivityKind.answered,
    ),
    CallActivity(
      title: 'Support missed Anna.',
      body: 'The call rang out after 25 seconds.',
      timeLabel: '31 minutes ago',
      kind: CallActivityKind.missed,
    ),
    CallActivity(
      title: 'Support missed George.',
      body: 'No one picked up before voicemail.',
      timeLabel: '36 minutes ago',
      kind: CallActivityKind.missed,
    ),
    CallActivity(
      title: 'Anna left Support a voicemail.',
      body: 'The message is about a delivery question.',
      timeLabel: '37 minutes ago',
      kind: CallActivityKind.voicemail,
    ),
    CallActivity(
      title: 'Katerina called Billing.',
      body: 'Answered after 4 seconds.',
      timeLabel: '48 minutes ago',
      kind: CallActivityKind.answered,
    ),
    CallActivity(
      title: 'Operations called Conference Room.',
      body: 'Internal call lasted about 3 minutes.',
      timeLabel: '55 minutes ago',
      kind: CallActivityKind.answered,
    ),
    CallActivity(
      title: 'Dimitris called Parts Desk.',
      body: 'Answered after 11 seconds.',
      timeLabel: '1 hour ago',
      kind: CallActivityKind.answered,
    ),
    CallActivity(
      title: 'Night caller left voicemail.',
      body: 'The after-hours route handled it normally.',
      timeLabel: 'Today, 06:24',
      kind: CallActivityKind.voicemail,
    ),
    CallActivity(
      title: 'Service Desk called IT.',
      body: 'Internal check-in lasted under a minute.',
      timeLabel: 'Today, 09:12',
      kind: CallActivityKind.answered,
    ),
    CallActivity(
      title: 'Front Gate called Reception.',
      body: 'Reception opened the conversation immediately.',
      timeLabel: 'Today, 09:48',
      kind: CallActivityKind.answered,
    ),
    CallActivity(
      title: 'Vendor called Purchasing.',
      body: 'Purchasing was away, voicemail recorded.',
      timeLabel: 'Today, 10:05',
      kind: CallActivityKind.voicemail,
    ),
    CallActivity(
      title: 'CEO called Reception.',
      body: 'Answered after 2 seconds.',
      timeLabel: 'Today, 10:18',
      kind: CallActivityKind.answered,
    ),
    CallActivity(
      title: 'QA Lab missed Operations.',
      body: 'The call arrived during a short busy spell.',
      timeLabel: 'Today, 10:44',
      kind: CallActivityKind.missed,
    ),
    CallActivity(
      title: 'Sales is talking to Elena.',
      body: 'Started 1 minute ago.',
      timeLabel: 'Active now',
      isActive: true,
      kind: CallActivityKind.active,
    ),
  ];

  static const _initialPeople = [
    PBXPerson(
      name: 'Reception',
      extension: '101',
      status: PersonStatus.talking,
      statusText: 'On a call',
      detail: 'Talking to Maria',
    ),
    PBXPerson(
      name: 'Warehouse',
      extension: '203',
      status: PersonStatus.online,
      statusText: 'Online',
      detail: 'Recovered about an hour ago',
    ),
    PBXPerson(
      name: 'Door Phone',
      extension: '105',
      status: PersonStatus.online,
      statusText: 'Online',
    ),
    PBXPerson(
      name: 'Support',
      extension: '120',
      status: PersonStatus.quiet,
      statusText: 'Quiet',
      detail: 'No calls yet today',
    ),
    PBXPerson(
      name: 'Sales',
      extension: '130',
      status: PersonStatus.talking,
      statusText: 'On a call',
      detail: 'Talking to Elena',
    ),
    PBXPerson(
      name: 'Elena',
      extension: '131',
      status: PersonStatus.online,
      statusText: 'Online',
      detail: 'Answered Sales calls today',
    ),
    PBXPerson(
      name: 'Billing',
      extension: '142',
      status: PersonStatus.online,
      statusText: 'Online',
      detail: 'Recovered 2 hours ago',
    ),
    PBXPerson(
      name: 'Purchasing',
      extension: '145',
      status: PersonStatus.quiet,
      statusText: 'Quiet',
      detail: 'Voicemail received today',
    ),
    PBXPerson(
      name: 'Operations',
      extension: '150',
      status: PersonStatus.online,
      statusText: 'Online',
      detail: 'Normal call load',
    ),
    PBXPerson(
      name: 'Service Desk',
      extension: '151',
      status: PersonStatus.online,
      statusText: 'Online',
    ),
    PBXPerson(
      name: 'IT',
      extension: '160',
      status: PersonStatus.online,
      statusText: 'Online',
      detail: 'Internal calls only today',
    ),
    PBXPerson(
      name: 'Security Desk',
      extension: '170',
      status: PersonStatus.online,
      statusText: 'Online',
      detail: 'Watching front access',
    ),
    PBXPerson(
      name: 'Parts Desk',
      extension: '204',
      status: PersonStatus.online,
      statusText: 'Online',
      detail: 'Answered Dimitris',
    ),
    PBXPerson(
      name: 'QA Lab',
      extension: '210',
      status: PersonStatus.quiet,
      statusText: 'Quiet',
    ),
    PBXPerson(
      name: 'Back Office',
      extension: '220',
      status: PersonStatus.online,
      statusText: 'Online',
    ),
    PBXPerson(
      name: 'Conference Room',
      extension: '305',
      status: PersonStatus.online,
      statusText: 'Online',
      detail: 'Checked in this morning',
    ),
    PBXPerson(
      name: 'Training Room',
      extension: '306',
      status: PersonStatus.quiet,
      statusText: 'Quiet',
    ),
    PBXPerson(
      name: 'Front Gate',
      extension: '402',
      status: PersonStatus.online,
      statusText: 'Online',
      detail: 'Called Reception today',
    ),
    PBXPerson(
      name: 'Lobby Tablet',
      extension: '401',
      status: PersonStatus.online,
      statusText: 'Online',
      detail: 'Visitor device reachable',
    ),
    PBXPerson(
      name: 'CEO Office',
      extension: '501',
      status: PersonStatus.online,
      statusText: 'Online',
    ),
    PBXPerson(
      name: 'Meeting Room East',
      extension: '502',
      status: PersonStatus.quiet,
      statusText: 'Quiet',
    ),
    PBXPerson(
      name: 'Meeting Room West',
      extension: '503',
      status: PersonStatus.quiet,
      statusText: 'Quiet',
    ),
    PBXPerson(
      name: 'Break Room',
      extension: '504',
      status: PersonStatus.online,
      statusText: 'Online',
    ),
    PBXPerson(
      name: 'Spare Desk',
      extension: '599',
      status: PersonStatus.unavailable,
      statusText: 'Unavailable',
      detail: 'Not assigned right now',
    ),
  ];
}
