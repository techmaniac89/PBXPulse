import 'package:flutter/material.dart';

import '../../features/calls/calls_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/people/people_screen.dart';
import '../../features/pulse/pulse_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../repositories/pulse_repository.dart';
import '../app_settings.dart';

class PBXPulseShell extends StatefulWidget {
  const PBXPulseShell({
    required this.repository,
    required this.settings,
    super.key,
  });

  final PulseRepository repository;
  final PBXAppSettings settings;

  @override
  State<PBXPulseShell> createState() => _PBXPulseShellState();
}

class _PBXPulseShellState extends State<PBXPulseShell> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(repository: widget.repository),
      CallsScreen(repository: widget.repository),
      PulseScreen(repository: widget.repository),
      PeopleScreen(repository: widget.repository),
      SettingsScreen(
        repository: widget.repository,
        settings: widget.settings,
      ),
    ];

    return Scaffold(
      body: SafeArea(child: screens[_selectedIndex]),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.call_outlined),
                  selectedIcon: Icon(Icons.call),
                  label: 'Calls',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_border),
                  selectedIcon: Icon(Icons.favorite),
                  label: 'Pulse',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: 'People',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
