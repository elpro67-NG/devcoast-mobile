
import 'package:flutter/material.dart';
import 'package:devcoast_mobile/core/network/api_client.dart';
import 'package:devcoast_mobile/core/widgets/common_widgets.dart';
import 'package:devcoast_mobile/core/widgets/data_page.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  int version = 0;
  bool procesando = false;

  Future<void> guardar([Map<String, dynamic>? proyecto]) async {
    if (procesando) return;

    final datos = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => _FormularioProyecto(proyecto: proyecto),
    );

    if (datos == null || !mounted) return;

    setState(() => procesando = true);

    try {
      final editando = proyecto != null;

      await Api.request(
        editando ? 'PUT' : 'POST',
        editando ? '/projects/${proyecto['id']}' : '/projects',
        datos,
      );

      if (!mounted) return;

      setState(() => version++);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            editando
                ? 'Proyecto actualizado correctamente'
                : 'Proyecto guardado correctamente',
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    } finally {
      if (mounted) setState(() => procesando = false);
    }
  }

  Future<void> eliminar(Map<String, dynamic> proyecto) async {
    if (procesando) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar proyecto'),
        content: Text(
          '¿Deseas eliminar "${proyecto['nombre']}"? '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    setState(() => procesando = true);

    try {
      await Api.request(
        'DELETE',
        '/projects/${proyecto['id']}',
      );

      if (!mounted) return;

      setState(() => version++);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Proyecto eliminado correctamente'),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    } finally {
      if (mounted) setState(() => procesando = false);
    }
  }

  String tecnologias(dynamic value) {
    if (value is List) {
      return value.join(', ');
    }
    return value?.toString() ?? '';
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
              onPressed: procesando ? null : () => guardar(),
              icon: const Icon(Icons.add),
              label: const Text('Agregar proyecto'),
            ),
          ),
        ),

        Expanded(
          child: DataPage(
            key: ValueKey(version),
            route: '/projects',
            builder: (data, reload) {
              return ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  sectionTitle(
                    context,
                    'Mis proyectos',
                    subtitle:
                        'Crea, edita y administra tu portafolio.',
                  ),

                  const SizedBox(height: 8),

                  for (final proyecto in data)
                    Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.folder_outlined),
                              ),
                              title: Text(
                                '${proyecto['nombre'] ?? 'Proyecto'}',
                              ),
                              subtitle: Text(
                                '${proyecto['descripcion'] ?? ''}\n'
                                '${tecnologias(proyecto['tecnologias'])}',
                              ),
                              isThreeLine: true,
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Chip(
                                label: Text(
                                  proyecto['publicado'] == true
                                      ? 'Público'
                                      : 'Borrador',
                                ),
                              ),
                            ),

                            Wrap(
                              alignment: WrapAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: procesando
                                      ? null
                                      : () => guardar(proyecto),
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                  ),
                                  label: const Text('Editar'),
                                ),

                                TextButton.icon(
                                  onPressed: procesando
                                      ? null
                                      : () => eliminar(proyecto),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                  ),
                                  label: const Text('Eliminar'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    onPressed: reload,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Actualizar'),
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

// FORMULARIO PARA CREAR Y EDITAR PROYECTOS

class _FormularioProyecto extends StatefulWidget {
  final Map<String, dynamic>? proyecto;

  const _FormularioProyecto({this.proyecto});

  @override
  State<_FormularioProyecto> createState() =>
      _FormularioProyectoState();
}

class _FormularioProyectoState
    extends State<_FormularioProyecto> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombre;
  late final TextEditingController _descripcion;
  late final TextEditingController _tecnologias;

  bool _publicado = true;

  @override
  void initState() {
    super.initState();

    final proyecto = widget.proyecto;

    _nombre = TextEditingController(
      text: proyecto?['nombre']?.toString() ?? '',
    );

    _descripcion = TextEditingController(
      text: proyecto?['descripcion']?.toString() ?? '',
    );

    final tech = proyecto?['tecnologias'];

    _tecnologias = TextEditingController(
      text: tech is List
          ? tech.join(', ')
          : (tech?.toString() ?? ''),
    );

    _publicado = proyecto?['publicado'] != false;
  }

  @override
  void dispose() {
    _nombre.dispose();
    _descripcion.dispose();
    _tecnologias.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final tecnologias = _tecnologias.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    Navigator.pop(context, {
      'nombre': _nombre.text.trim(),
      'descripcion': _descripcion.text.trim(),
      'tecnologias': tecnologias,
      'publicado': _publicado,
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
      title: Text(
        widget.proyecto == null
            ? 'Agregar proyecto'
            : 'Editar proyecto',
      ),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nombre,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del proyecto',
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Campo obligatorio'
                          : null,
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _descripcion,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Campo obligatorio'
                          : null,
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _tecnologias,
                  decoration: const InputDecoration(
                    labelText: 'Tecnologías',
                    hintText: 'Flutter, Dart, Firebase',
                  ),
                ),

                const SizedBox(height: 12),

                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Publicar proyecto'),
                  value: _publicado,
                  onChanged: (value) {
                    setState(() => _publicado = value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _guardar,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
