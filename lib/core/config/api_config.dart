
import 'package:flutter/foundation.dart';

const String _configuredApiUrl =
    String.fromEnvironment('API_URL');

final String apiUrl = _configuredApiUrl.isNotEmpty
    ? _configuredApiUrl
    : (kIsWeb
        ? 'http://localhost:8080/api/mobile/v1'
        : 'http://10.0.2.2:8080/api/mobile/v1');
