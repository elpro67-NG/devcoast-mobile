# DevCoast Mobile — proyecto Flutter organizado sobre tu ZIP original

Se conservan las carpetas de plataformas (`android`, `ios`, `web`, `windows`, etc.) generadas por `flutter create`. Se reemplazó la pantalla de ejemplo por el código modular de DevCoast y se agregaron las dependencias `http` y `flutter_secure_storage` a `pubspec.yaml`.

## Abrir en VS Code

1. Descomprime el ZIP. Abre la carpeta **devcoast_mobile_organizado** (la que contiene `pubspec.yaml`).
2. Abre una terminal en esa carpeta.
3. Ejecuta:

```powershell
flutter pub get
flutter analyze
flutter run -d chrome --dart-define=API_URL=http://localhost:8080/api/mobile/v1
```

Si `flutter analyze` arroja errores, comparte su salida: esta entrega no ha sido compilada en un entorno Flutter.

## API

La app móvil es independiente del programa web. Necesita que **el backend Spring Boot de DevCoast esté ejecutándose** y tenga los endpoints `/api/mobile/v1`, tal como en la entrega anterior `DevCoast_Flutter_API_Integrado.zip`.

- Para Chrome en la misma computadora: `http://localhost:8080/api/mobile/v1`.
- Para emulador Android: `http://10.0.2.2:8080/api/mobile/v1`.
- Para celular físico: `http://IP_DE_TU_PC:8080/api/mobile/v1`.

**Advertencia:** en navegador, las sesiones basadas en cookies requieren configurar CORS/credenciales correctamente en Spring Boot; los navegadores no permiten establecer manualmente el header Cookie. Es posible que el login web necesite adaptación adicional del API client o un esquema de autenticación para que se mantenga la sesión.

La instalación de Android SDK es necesaria solo para compilar y probar en Android; Chrome ya está disponible según tu diagnóstico.
