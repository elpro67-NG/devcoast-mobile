import 'package:flutter/material.dart';
import 'package:devcoast_mobile/core/widgets/common_widgets.dart';
import 'package:devcoast_mobile/core/widgets/data_page.dart';
import 'package:devcoast_mobile/core/theme/app_colors.dart';

class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  Color colorEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'aprobada':
      case 'aceptada':
        return Colors.green;
      case 'rechazada':
      case 'descartado':
        return Colors.red;
      case 'pendiente':
      case 'revision':
      case 'en_revision':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DataPage(
      route: '/applications/mine',
      builder: (data, reload) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            sectionTitle(context, 'Mis postulaciones', subtitle: 'Consulta el estado de cada solicitud.'),
            const SizedBox(height: 6),
            Text(
              'Total de postulaciones: ${data.length}',
              style: const TextStyle(fontSize: 15, color: muted),
            ),
            const SizedBox(height: 16),
            for (final solicitud in data)
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    leading: const CircleAvatar(child: Icon(Icons.work_outline)),
                    title: Text(
                      '${solicitud['titulo'] ?? 'Sin título'}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Text('${solicitud['empresa'] ?? 'Empresa'}'),
                        const SizedBox(height: 6),
                        if (solicitud['mensaje'] != null && solicitud['mensaje'].toString().isNotEmpty)
                          Text(
                            'Mensaje: ${solicitud['mensaje']}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                    trailing: Chip(
                      label: Text('${solicitud['estado'] ?? 'Pendiente'}'),
                      backgroundColor: colorEstado('${solicitud['estado'] ?? 'pendiente'}').withValues(alpha: 0.18),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: reload,
              icon: const Icon(Icons.refresh),
              label: const Text('Actualizar postulaciones'),
            ),
          ],
        );
      },
    );
  }
}
