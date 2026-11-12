import 'package:flutter/material.dart';
import 'package:devcoast_mobile/core/network/api_client.dart';
import 'package:devcoast_mobile/core/theme/app_colors.dart';
import 'package:devcoast_mobile/core/widgets/common_widgets.dart';

class JobDetails extends StatefulWidget {
  final Map<String, dynamic> job;
  final bool canApply;

  const JobDetails({
    super.key,
    required this.job,
    required this.canApply,
  });

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  bool enviando = false;
  bool postulado = false;

  String texto(dynamic valor, [String defecto = '-']) {
    if (valor == null) return defecto;
    if (valor is List) return valor.map((e) => e.toString()).join(', ');
    final resultado = valor.toString().trim();
    return resultado.isEmpty ? defecto : resultado;
  }

  Future<void> postularse() async {
    if (enviando || postulado) return;
    final empleoId = widget.job['id']?.toString();
    if (empleoId == null || empleoId.isEmpty) {
      errorToast(context, 'La oferta no tiene un ID válido');
      return;
    }

    final controlador = TextEditingController();
    try {
      final mensaje = await showDialog<String>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            title: const Text('Enviar postulación'),
            content: TextField(
              controller: controlador,
              maxLines: 4,
              maxLength: 2000,
              decoration: const InputDecoration(
                labelText: 'Mensaje de motivación',
                hintText: 'Explica por qué te interesa esta oferta',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext, controlador.text.trim()),
                child: const Text('Enviar'),
              ),
            ],
          );
        },
      );

      if (!mounted || mensaje == null) return;
      setState(() => enviando = true);
      try {
        await Api.request('POST', '/jobs/$empleoId/apply', {'mensaje': mensaje});
        if (!mounted) return;
        setState(() => postulado = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Postulación enviada correctamente!'),
            backgroundColor: Colors.green,
          ),
        );
      } on ApiException catch (e) {
        if (!mounted) return;
        if (e.message.contains('Ya te postulaste') || e.message.contains('Ya existe una postulación')) {
          setState(() => postulado = true);
        }
        errorToast(context, e);
      } catch (e) {
        if (mounted) errorToast(context, e);
      } finally {
        if (mounted) setState(() => enviando = false);
      }
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) => controlador.dispose());
    }
  }

  Widget infoTile(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: panel,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    final titulo = texto(job['titulo'], 'Empleo');
    final empresa = texto(job['empresaNombre'] ?? job['empresa'], 'Empresa no especificada');
    final descripcion = texto(job['descripcionRol'] ?? job['descripcion'], 'Descripción no disponible');

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de empleo')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            sectionTitle(context, titulo, subtitle: empresa),
            const SizedBox(height: 10),
            infoTile('Modalidad', texto(job['modalidad'])),
            infoTile('Categoría', texto(job['categoria'])),
            infoTile('Nivel', texto(job['seniority'])),
            infoTile('Contrato', texto(job['contrato'])),
            const SizedBox(height: 16),
            const Text('Descripción del empleo', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(descripcion, style: const TextStyle(height: 1.5)),
            const SizedBox(height: 24),
            const Text('Tecnologías requeridas', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(texto(job['stack']), style: const TextStyle(height: 1.5)),
            if (job['requisitosDeseables'] != null) ...[
              const SizedBox(height: 24),
              const Text('Requisitos deseables', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(texto(job['requisitosDeseables']), style: const TextStyle(height: 1.5)),
            ],
            if (job['salarioMin'] != null) ...[
              const SizedBox(height: 24),
              const Text('Salario', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(
                '${texto(job['salarioMin'])} - ${texto(job['salarioMax'], 'No especificado')} ${texto(job['moneda'], '')}',
                style: const TextStyle(height: 1.5),
              ),
            ],
            const SizedBox(height: 28),
            if (widget.canApply)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (enviando || postulado) ? null : postularse,
                  child: enviando
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(postulado ? 'Ya te postulaste' : 'Postularme'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
