# DevCoast Flutter - versión móvil iPhone 14 en adelante

Esta versión del proyecto fue ajustada en formato **mobile-first**, tomando como referencia un ancho base de **390 px** (iPhone 14) y escalando correctamente hacia:

- iPhone 14
- iPhone 14 Plus
- iPhone 15
- iPhone 15 Plus
- iPhone 15 Pro
- iPhone 15 Pro Max
- modelos posteriores con ancho similar o mayor

## Ajustes realizados

- Orientación bloqueada en **vertical**.
- Safe areas y espaciados optimizados para iPhone.
- Pantallas de acceso y bienvenida adaptadas a formato móvil.
- Tarjetas, encabezados y navegación inferior compactados para teléfono.
- Formularios emergentes ajustados para verse bien en pantalla pequeña.
- Conservación del branding DevCoast y de la conexión con la API existente.

## Cómo ejecutar

```bash
flutter pub get
flutter run
```

Si deseas probar en iPhone/iOS:

```bash
flutter run -d ios
```

O en simulador específico, por ejemplo:

```bash
open -a Simulator
flutter run -d ios
```

## Nota

La base visual fue adaptada para móvil. Si luego quieres, el siguiente paso puede ser:

1. crear una versión aún más fiel pantalla por pantalla al HTML/CSS original,
2. generar mockups en marco de iPhone 14 Pro,
3. o preparar exportables para Figma o presentación.
