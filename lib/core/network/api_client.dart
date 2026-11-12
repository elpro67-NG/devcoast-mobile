
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/browser_client.dart';

import 'package:devcoast_mobile/core/config/api_config.dart';

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

class Api {
  static final BrowserClient _client =
      BrowserClient()..withCredentials = true;

  static Future<void> restore() async {
    // Chrome administra las cookies de sesión.
  }

  static Future<Map<String, dynamic>> _getCsrf() async {
    final response = await _client.get(
      Uri.parse('$apiUrl/auth/csrf'),
    );

    if (response.statusCode != 200) {
      throw ApiException(
        'No se pudo obtener el token CSRF: '
        '${response.statusCode}',
      );
    }

    return Map<String, dynamic>.from(
      jsonDecode(response.body),
    );
  }

  static Future<dynamic> request(
    String method,
    String route, [
    Map<String, dynamic>? payload,
  ]) async {
    final upperMethod = method.toUpperCase();

    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Obtener token antes de modificar datos.
      if ([
        'POST', 'PUT', 'PATCH', 'DELETE'
      ].contains(upperMethod)) {
        final csrf = await _getCsrf();

        headers[csrf['headerName'].toString()] =
            csrf['token'].toString();
      }

      final uri = Uri.parse('$apiUrl$route');

      final request = http.Request(
        upperMethod,
        uri,
      );

      request.headers.addAll(headers);

      if (payload != null) {
        request.body = jsonEncode(payload);
      }

      final streamed = await _client.send(request);
      final response =
          await http.Response.fromStream(streamed);

      dynamic data;

      try {
        data = jsonDecode(response.body);
      } catch (_) {
        throw ApiException(
          'El servidor no devolvió JSON válido. '
          'Código HTTP: ${response.statusCode}',
        );
      }

      if (response.statusCode >= 400) {
        final mensaje = data is Map
            ? data['error'] ?? data['message']
            : null;

        throw ApiException(
          mensaje?.toString() ??
              'Error HTTP ${response.statusCode}',
        );
      }

      return data;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Error de comunicación con DevCoast: $e',
      );
    }
  }

  static Future<void> signout() async {
    await request('POST', '/auth/logout');
  }
}
