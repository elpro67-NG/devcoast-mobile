import 'package:flutter/material.dart';
import 'package:devcoast_mobile/core/theme/app_colors.dart';
import 'package:devcoast_mobile/core/widgets/common_widgets.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> user;
  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          sectionTitle(context, 'Mi perfil', subtitle: 'Información general de tu cuenta.'),
          const SizedBox(height: 12),
          const CircleAvatar(
            radius: 42,
            backgroundColor: teal,
            child: Icon(Icons.person, size: 48, color: dark),
          ),
          const SizedBox(height: 15),
          Center(
            child: Text(
              '${user['nombre']}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Center(child: Text('${user['correo']}', textAlign: TextAlign.center)),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              title: const Text('Tipo de cuenta'),
              subtitle: Text('${user['tipo']}'),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tu cuenta está conectada al mismo servidor y base de datos del DevCoast web.',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, height: 1.4),
          ),
        ],
      );
}
