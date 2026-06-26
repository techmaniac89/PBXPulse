import 'package:flutter/material.dart';

import '../../design_system/components/person_card.dart';
import '../../design_system/components/screen_scaffold.dart';
import '../../design_system/components/section_label.dart';
import '../../design_system/pbx_spacing.dart';
import '../../repositories/pulse_repository.dart';
import 'person_detail_screen.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({required this.repository, super.key});

  final PulseRepository repository;

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  var _query = '';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.repository,
      builder: (context, _) {
        final people = widget.repository.people.where((person) {
          final query = _query.toLowerCase();
          return query.isEmpty ||
              person.name.toLowerCase().contains(query) ||
              person.extension.toLowerCase().contains(query) ||
              person.statusText.toLowerCase().contains(query);
        }).toList();

        return PBXScreenScaffold(
          title: 'People',
          subtitle: 'Humans and devices, shown in human language.',
          children: [
            TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search people',
              ),
            ),
            const SectionLabel('Your PBX'),
            if (people.isEmpty)
              Text(
                'No people match that search.',
                style: Theme.of(context).textTheme.bodyLarge,
              )
            else
              for (final person in people) ...[
                PersonCard(
                  person: person,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => PersonDetailScreen(
                          person: person,
                          repository: widget.repository,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: PBXSpacing.sm),
              ],
          ],
        );
      },
    );
  }
}
