
import 'package:flutter/material.dart';
import 'package:devcoast_mobile/core/network/api_client.dart';

class DataPage extends StatefulWidget {
  final String route;

  final Widget Function(
    List<Map<String, dynamic>>,
    VoidCallback,
  ) builder;

  const DataPage({
    super.key,
    required this.route,
    required this.builder,
  });

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late Future<List<Map<String, dynamic>>> future;

  @override
  void initState() {
    super.initState();
    future = cargarDatos();
  }

  Future<List<Map<String, dynamic>>> cargarDatos() async {
    final data = await Api.request('GET', widget.route);

    return (data as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  void refresh() {
    final nuevaPeticion = cargarDatos();

    setState(() {
      future = nuevaPeticion;
    });
  }

  @override
  void didUpdateWidget(covariant DataPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.route != widget.route) {
      refresh();
    }
  }

  Future<void> actualizar() async {
    final nuevaPeticion = cargarDatos();

    setState(() {
      future = nuevaPeticion;
    });

    try {
      await nuevaPeticion;
    } catch (_) {
      // FutureBuilder mostrará el error.
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: refresh,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        final data = snapshot.data ?? [];

        if (data.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('No hay registros todavía'),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: refresh,
                  child: const Text('Actualizar'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: actualizar,
          child: widget.builder(data, refresh),
        );
      },
    );
  }
}
