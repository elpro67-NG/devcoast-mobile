import 'package:flutter/material.dart';
import 'package:devcoast_mobile/core/widgets/data_page.dart';
import 'package:devcoast_mobile/core/widgets/job_card.dart';

class PublicJobsPage extends StatelessWidget {
  const PublicJobsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Empleos disponibles')),
        body: SafeArea(
          child: DataPage(
            route: '/jobs',
            builder: (data, reload) => ListView(
              children: [
                for (final j in data) jobCard(context, j),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      );
}
