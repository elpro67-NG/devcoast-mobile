
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://localhost:8080';

  static Future<String> probarConexion() async {
    try {
      final respuesta = await http.get(
        Uri.parse('$baseUrl/api/test'),
      );

      if (respuesta.statusCode == 200) {
        final datos = jsonDecode(respuesta.body);
        return datos['mensaje'];
      }

      return 'Error HTTP: ${respuesta.statusCode}';
    } catch (e) {
      return 'Error de conexión: $e';
    }
  }
}
