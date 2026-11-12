import 'package:flutter/material.dart';
import 'package:devcoast_mobile/core/network/api_client.dart';
import 'package:devcoast_mobile/core/widgets/common_widgets.dart';
import 'package:devcoast_mobile/core/theme/app_colors.dart';
import 'package:devcoast_mobile/core/theme/mobile_tokens.dart';
import 'package:devcoast_mobile/core/widgets/nautical_widgets.dart';
import 'package:devcoast_mobile/features/navigation/presentation/home_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool register = false, busy = false, company = false;
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final place = TextEditingController();

  @override
  void dispose() {
    for (final c in [name, email, password, place]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> submit() async {
    setState(() => busy = true);
    try {
      final data = await Api.request(
        'POST',
        register ? '/auth/register' : '/auth/login',
        register
            ? {
                'nombre': name.text,
                'correo': email.text,
                'password': password.text,
                'ubicacion': place.text,
                'tipo': company ? 'EMPRESA' : 'TALENTO',
              }
            : {
                'correo': email.text,
                'password': password.text,
              },
      );
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(user: Map<String, dynamic>.from(data)),
        ),
        (_) => false,
      );
    } catch (e) {
      errorToast(context, e);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final logoHeight = context.isCompactPhone ? 78.0 : 90.0;
    return Scaffold(
      appBar: AppBar(title: Text(register ? 'Crear tu cuenta' : 'Iniciar sesión')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            context.isCompactPhone ? 20 : 24,
            18,
            context.isCompactPhone ? 20 : 24,
            22 + MediaQuery.of(context).padding.bottom,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DevCoastHorizontalLogo(height: logoHeight),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: panel,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: line),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          register ? 'Regístrate y navega nuevas oportunidades' : 'Ingresa a tu cuenta DevCoast',
                          style: TextStyle(
                            fontSize: context.isCompactPhone ? 22 : 24,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Diseñado para formato móvil tipo iPhone 14 y superiores.',
                          style: TextStyle(color: muted, height: 1.4),
                        ),
                        const SizedBox(height: 18),
                        if (register) ...[
                          field(name, 'Nombre o nombre de empresa'),
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Soy una empresa'),
                            value: company,
                            onChanged: (v) => setState(() => company = v),
                          ),
                          field(place, 'Ubicación'),
                        ],
                        field(email, 'Correo electrónico', keyboardType: TextInputType.emailAddress),
                        field(password, 'Contraseña', secret: true),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: busy ? null : submit,
                            child: Text(
                              busy ? 'Conectando...' : register ? 'Registrarme' : 'Ingresar',
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => setState(() => register = !register),
                          child: Text(
                            register ? 'Ya tengo cuenta' : '¿No tienes cuenta? Regístrate',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
