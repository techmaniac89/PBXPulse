import 'package:flutter/foundation.dart';

import '../models/call_activity.dart';
import '../models/connection_status.dart';
import '../models/person.dart';
import '../models/signal.dart';

abstract class PulseRepository extends ChangeNotifier {
  String get greeting;

  String get mood;

  ConnectionStatus get connection;

  CallActivity get now;

  List<PulseSignal> get signals;

  List<CallActivity> get calls;

  List<PBXPerson> get people;

  List<CallActivity> callsFor(PBXPerson person);

  List<PulseSignal> signalsFor(PBXPerson person);

  PBXPerson? personForSignal(PulseSignal signal);

  void dismissSignal(PulseSignal signal);
}
