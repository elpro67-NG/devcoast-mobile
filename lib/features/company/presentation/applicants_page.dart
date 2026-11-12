import 'package:flutter/material.dart';
import 'package:devcoast_mobile/core/network/api_client.dart';
import 'package:devcoast_mobile/core/widgets/common_widgets.dart';
import 'package:devcoast_mobile/core/widgets/data_page.dart';

class ApplicantsPage extends StatefulWidget {
  final Map<String, dynamic> job;
  const ApplicantsPage({super.key, required this.job});

  @override
  State<ApplicantsPage> createState() => _ApplicantsPageState();
}

class _ApplicantsPageState extends State<ApplicantsPage> {
  int version = 0;
  bool actualizando = false;

  Future<void> cambiarEstado(String solicitudId, String estado) async {
    if (actualizando) return;
    setState(() => actualizando = true);

    try {
      await Api.request(
        'PATCH',
        '/company/jobs/${widget.job['id']}/applications/$solicitudId',
        {'estado': estado},
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Estado actualizado correctamente')),
      );
      setState(() => version++);
    } catch (e) {
      if (mounted) errorToast(context, e);
    } finally {
      if (mounted) setState(() => actualizando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Candidatos',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: DataPage(
          key: ValueKey(version),
          route: '/company/jobs/${widget.job['id']}/applications',
          builder: (data, reload) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                sectionTitle(context, 'Candidatos recibidos', subtitle: 'Oferta: ${widget.job['titulo'] ?? ''}'),
                const SizedBox(height: 8),
                Text('Total de candidatos: ${data.length}'),
                const SizedBox(height: 20),
                for (final candidato in data)
                  Card(
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text('${candidato['candidato']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${candidato['correo'] ?? ''}'),
                          Text('Estado: ${candidato['estado']}'),
                          if (candidato['mensaje'] != null) Text('Mensaje: ${candidato['mensaje']}'),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        enabled: !actualizando,
                        onSelected: (estado) => cambiarEstado('${candidato['id']}', estado),
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'pendiente', child: Text('Pendiente')),
                          PopupMenuItem(value: 'aprobada', child: Text('Aprobar')),
                          PopupMenuItem(value: 'rechazada', child: Text('Rechazar')),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: reload,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Actualizar candidatos'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
