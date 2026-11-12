import 'package:flutter/material.dart';
import 'package:devcoast_mobile/core/network/api_client.dart';
import 'package:devcoast_mobile/core/widgets/common_widgets.dart';
import 'package:devcoast_mobile/core/widgets/data_page.dart';
import 'package:devcoast_mobile/core/widgets/job_card.dart';
import 'package:devcoast_mobile/features/company/presentation/applicants_page.dart';

class CompanyJobs extends StatefulWidget {
  const CompanyJobs({super.key});

  @override
  State<CompanyJobs> createState() => _CompanyJobsState();
}

class _CompanyJobsState extends State<CompanyJobs> {
  int version = 0;
  bool publicando = false;

  Future<void> create() async {
    if (publicando) return;
    final datos = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const _CrearOfertaDialog(),
    );
    if (!mounted || datos == null) return;

    setState(() => publicando = true);
    try {
      await Api.request('POST', '/company/jobs', datos);
      if (!mounted) return;
      setState(() => version++);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Oferta publicada correctamente!')),
      );
    } catch (e) {
      if (mounted) errorToast(context, e);
    } finally {
      if (mounted) setState(() => publicando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: publicando ? null : create,
              icon: const Icon(Icons.add),
              label: Text(publicando ? 'Publicando...' : 'Crear oferta'),
            ),
          ),
        ),
        Expanded(
          child: DataPage(
            key: ValueKey(version),
            route: '/company/jobs',
            builder: (data, reload) {
              return ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  sectionTitle(context, 'Mis ofertas laborales', subtitle: 'Administra vacantes y revisa candidatos.'),
                  const SizedBox(height: 12),
                  for (final job in data)
                    jobCard(
                      context,
                      job,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ApplicantsPage(job: job)),
                        );
                      },
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CrearOfertaDialog extends StatefulWidget {
  const _CrearOfertaDialog();

  @override
  State<_CrearOfertaDialog> createState() => _CrearOfertaDialogState();
}

class _CrearOfertaDialogState extends State<_CrearOfertaDialog> {
  final formKey = GlobalKey<FormState>();
  final titulo = TextEditingController();
  final descripcion = TextEditingController();
  final stack = TextEditingController();
  final vacantes = TextEditingController(text: '1');

  String modalidad = 'REMOTO';
  String categoria = 'DESARROLLO';
  String seniority = 'JUNIOR';
  String contrato = 'INDEFINIDO';

  @override
  void dispose() {
    titulo.dispose();
    descripcion.dispose();
    stack.dispose();
    vacantes.dispose();
    super.dispose();
  }

  String? validarObligatorio(String? valor) {
    if (valor == null || valor.trim().isEmpty) return 'Este campo es obligatorio';
    return null;
  }

  void publicar() {
    if (!formKey.currentState!.validate()) return;
    final numeroVacantes = int.tryParse(vacantes.text.trim());
    if (numeroVacantes == null || numeroVacantes < 1) return;

    Navigator.pop(context, <String, dynamic>{
      'titulo': titulo.text.trim(),
      'descripcionRol': descripcion.text.trim(),
      'stack': stack.text.trim(),
      'modalidad': modalidad,
      'categoria': categoria,
      'seniority': seniority,
      'contrato': contrato,
      'vacantes': numeroVacantes,
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      title: const Text('Publicar oferta'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titulo,
                  decoration: const InputDecoration(labelText: 'Cargo', hintText: 'Desarrollador Flutter'),
                  validator: validarObligatorio,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descripcion,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Descripción del empleo'),
                  validator: validarObligatorio,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: stack,
                  decoration: const InputDecoration(labelText: 'Tecnologías', hintText: 'Flutter, Dart, Firebase'),
                  validator: validarObligatorio,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: modalidad,
                  decoration: const InputDecoration(labelText: 'Modalidad'),
                  items: const [
                    DropdownMenuItem(value: 'REMOTO', child: Text('Remoto')),
                    DropdownMenuItem(value: 'HIBRIDO', child: Text('Híbrido')),
                    DropdownMenuItem(value: 'PRESENCIAL', child: Text('Presencial')),
                  ],
                  onChanged: (v) => v != null ? setState(() => modalidad = v) : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: categoria,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  items: const [
                    DropdownMenuItem(value: 'DESARROLLO', child: Text('Desarrollo')),
                    DropdownMenuItem(value: 'DISENO', child: Text('Diseño')),
                    DropdownMenuItem(value: 'DATOS', child: Text('Datos')),
                    DropdownMenuItem(value: 'QA', child: Text('QA')),
                  ],
                  onChanged: (v) => v != null ? setState(() => categoria = v) : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: seniority,
                  decoration: const InputDecoration(labelText: 'Nivel de experiencia'),
                  items: const [
                    DropdownMenuItem(value: 'JUNIOR', child: Text('Junior')),
                    DropdownMenuItem(value: 'MID', child: Text('Intermedio')),
                    DropdownMenuItem(value: 'SENIOR', child: Text('Senior')),
                  ],
                  onChanged: (v) => v != null ? setState(() => seniority = v) : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: contrato,
                  decoration: const InputDecoration(labelText: 'Tipo de contrato'),
                  items: const [
                    DropdownMenuItem(value: 'INDEFINIDO', child: Text('Indefinido')),
                    DropdownMenuItem(value: 'FIJO', child: Text('Término fijo')),
                    DropdownMenuItem(value: 'FREELANCE', child: Text('Freelance')),
                  ],
                  onChanged: (v) => v != null ? setState(() => contrato = v) : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: vacantes,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Número de vacantes'),
                  validator: (valor) {
                    final numero = int.tryParse(valor?.trim() ?? '');
                    if (numero == null || numero < 1) return 'Ingresa al menos una vacante';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(onPressed: publicar, child: const Text('Publicar')),
      ],
    );
  }
}
