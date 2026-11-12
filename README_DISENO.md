# DevCoast Flutter — diseño adaptado desde el proyecto HTML/CSS

Esta entrega **modifica el Flutter original**, no lo reemplaza con una webview. Se conserva la conexión HTTP, endpoints, autenticación y operaciones de la app.

## Diseño aplicado
- Paleta exacta de `static/CSS/nautico.css`: fondo `#101114`, panel `#15171C`, coral `#FF7B4F`, turquesa `#2DD4BF`, mar `#0E2A2D`.
- Pantalla de bienvenida con identidad náutica y bloques tipo hero.
- Navegación inferior adaptada, marca DevCoast y tema Material 3.
- Tarjetas de empleos como tickets de dos cuerpos, inspiradas en `nautico-pase.css`.
- Estilos globales para formularios, tarjetas y componentes compartidos.

## Uso
1. Descomprime el ZIP. Abre `devcoast_mobile_diseno_web` en VS Code.
2. Ejecuta `flutter pub get`.
3. Inicia el backend Spring Boot y configura su URL en `lib/core/config/api_config.dart` o con `--dart-define=API_URL=http://...`.
4. Ejecuta `flutter run -d chrome` o el emulador adecuado.

**Alcance:** es una primera adaptación visual de las pantallas y componentes principales; las pantallas de detalle, creación y edición siguen con los formularios existentes, bajo el tema global nuevo. No se ha ejecutado `flutter analyze` porque Flutter no está instalado en este entorno.
