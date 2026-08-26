import 'package:flutter/material.dart';

import 'package:charitask/modules/people/pages/add_person_page.dart';
import 'package:charitask/modules/people/widgets/people_header.dart';
import 'package:charitask/modules/people/widgets/people_metrics.dart';
import 'package:charitask/modules/people/widgets/people_table.dart';
import 'package:charitask/modules/people/widgets/people_toolbar.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F8FC),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PeopleHeader(
              onAddPerson: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddPersonPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            const PeopleToolbar(),

            const SizedBox(height: 24),

            const PeopleMetrics(),

            const SizedBox(height: 24),

            const PeopleTable(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
