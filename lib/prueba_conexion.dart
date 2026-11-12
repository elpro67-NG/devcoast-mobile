
import 'package:flutter/material.dart';
import 'services/api_service.dart';

class PruebaConexion extends StatefulWidget {
  const PruebaConexion({super.key});

  @override
  State<PruebaConexion> createState() =>
      _PruebaConexionState();
}

class _PruebaConexionState extends State<PruebaConexion> {
  String mensaje = 'Sin probar';

  Future<void> conectar() async {
    final resultado = await ApiService.probarConexion();
    setState(() {
      mensaje = resultado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conexión DevCoast'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: conectar,
              child: const Text('Probar API'),
            ),
            const SizedBox(height: 20),
            Text(mensaje),
          ],
        ),
      ),
    );
  }
}
