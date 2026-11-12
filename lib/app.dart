import 'package:flutter/material.dart';
import 'package:devcoast_mobile/core/theme/app_colors.dart';
import 'package:devcoast_mobile/features/auth/presentation/entry_page.dart';

class DevCoastApp extends StatelessWidget {
  const DevCoastApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'DevCoast', debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: dark,
      colorScheme: const ColorScheme.dark(primary: orange, secondary: teal, surface: panel, onSurface: ink),
      appBarTheme: const AppBarTheme(backgroundColor: deepPanel, foregroundColor: ink, elevation: 0, centerTitle: false),
      textTheme: ThemeData.dark().textTheme.apply(bodyColor: ink, displayColor: ink),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: panel,
        hintStyle: const TextStyle(color: muted), labelStyle: const TextStyle(color: muted),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: line)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: teal, width: 1.5)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
        backgroundColor: orange, foregroundColor: dark, minimumSize: const Size.fromHeight(50),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
      outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(
        foregroundColor: ink, side: const BorderSide(color: line), minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
      cardTheme: CardThemeData(color: panel, elevation: 0, margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(side: const BorderSide(color: line), borderRadius: BorderRadius.circular(14))),
      navigationBarTheme: NavigationBarThemeData(backgroundColor: deepPanel, indicatorColor: sea,
        labelTextStyle: WidgetStateProperty.all(const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
        iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(color: states.contains(WidgetState.selected) ? teal : muted))),
      chipTheme: ChipThemeData(backgroundColor: panel, selectedColor: sea, labelStyle: const TextStyle(color: ink),
        side: const BorderSide(color: line), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    ),
    home: const EntryPage(),
  );
}
