
import 'package:flutter/material.dart';
import 'package:devcoast_mobile/core/widgets/common_widgets.dart';
import 'package:devcoast_mobile/core/widgets/data_page.dart';

class TalentsPage extends StatelessWidget {
  const TalentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DataPage(
      route: '/talents',
      builder: (data, reload) {
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            sectionTitle(
              context,
              'Talento tecnológico',
              subtitle:
                  'Explora perfiles registrados en DevCoast.',
            ),

            const SizedBox(height: 12),

            for (final u in data)
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),

                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),

                  title: Text(
                    '${u['nombre'] ?? 'Sin nombre'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${u['titulo'] ?? 'Sin título'}'
                      ' • ${u['ubicacion'] ?? 'Sin ubicación'}\n'
                      '${u['stack'] is List
                          ? (u['stack'] as List).join(', ')
                          : (u['stack'] ?? 'Sin tecnologías')}',
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            OutlinedButton.icon(
              onPressed: reload,
              icon: const Icon(Icons.refresh),
              label: const Text('Actualizar talentos'),
            ),
          ],
        );
      },
    );
  }
}
