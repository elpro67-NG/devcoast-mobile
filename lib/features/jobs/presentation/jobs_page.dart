import 'package:flutter/material.dart';
import 'package:devcoast_mobile/core/widgets/data_page.dart';
import 'package:devcoast_mobile/core/widgets/job_card.dart';
import 'package:devcoast_mobile/core/widgets/nautical_widgets.dart';
import 'package:devcoast_mobile/core/theme/app_colors.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});
  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  final search = TextEditingController();
  String query = '';

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const NauticalHeading('Empleos', subtitle: 'Encuentra tu próxima oportunidad.'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: TextField(
              controller: search,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search, color: teal),
                hintText: 'Cargo, empresa o tecnología',
              ),
              onChanged: (v) => setState(() => query = v),
            ),
          ),
          const SizedBox(height: 9),
          Expanded(
            child: DataPage(
              key: ValueKey(query),
              route: '/jobs?q=${Uri.encodeQueryComponent(query)}',
              builder: (data, reload) => RefreshIndicator(
                onRefresh: () async => reload(),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 17, 18, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SectionEyebrow('ofertas disponibles'),
                          Text(
                            '${data.length} resultados',
                            style: const TextStyle(color: muted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    for (final j in data) jobCard(context, j, canApply: true),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}
