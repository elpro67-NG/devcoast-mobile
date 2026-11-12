
import 'package:flutter/material.dart';
import 'package:devcoast_mobile/core/network/api_client.dart';
import 'package:devcoast_mobile/core/theme/app_colors.dart';
import 'package:devcoast_mobile/core/theme/mobile_tokens.dart';
import 'package:devcoast_mobile/core/widgets/nautical_widgets.dart';
import 'package:devcoast_mobile/features/auth/presentation/auth_page.dart';
import 'package:devcoast_mobile/features/navigation/presentation/home_page.dart';
import 'package:devcoast_mobile/features/jobs/presentation/public_jobs_page.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({super.key});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    try {
      await Api.restore();

      final user = await Api.request('GET', '/auth/me');

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            user: Map<String, dynamic>.from(user),
          ),
        ),
      );
      return;
    } catch (_) {
      // Si no existe una sesión válida, mostrar bienvenida.
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = context.isCompactPhone;
    final headline = isCompact ? 40.0 : 46.0;
    final logoHeight = isCompact ? 88.0 : 100.0;

    return Scaffold(
      backgroundColor: dark,
      body: SafeArea(
        child: loading
            ? const Center(
                child: CircularProgressIndicator(color: teal),
              )
            : LayoutBuilder(
                builder: (context, bounds) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: bounds.maxHeight,
                      ),
                      child: MobileFrame(
                        padding: EdgeInsets.fromLTRB(
                          isCompact ? 22 : 24,
                          20,
                          isCompact ? 22 : 24,
                          24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // LOGO DEVCOAST
                            Center(
                              child: DevCoastHorizontalLogo(
                                height: logoHeight,
                              ),
                            ),

                            SizedBox(
                              height: isCompact ? 28 : 34,
                            ),

                            // BIENVENIDA
                            const SectionEyebrow(
                              'bienvenido a bordo',
                            ),

                            const SizedBox(height: 14),

                            Text(
                              'Tu talento.\nTu próximo\npuerto.',
                              style: TextStyle(
                                fontSize: headline,
                                height: 1.0,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -2.0,
                                color: ink,
                              ),
                            ),

                            const SizedBox(height: 16),

                            const Text(
                              'Conectamos talento y empresas '
                              'para crear nuevas oportunidades.',
                              style: TextStyle(
                                color: muted,
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // TARJETA CON VELERO
                            Container(
                              height: isCompact ? 140 : 152,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: sea,
                                borderRadius:
                                    BorderRadius.circular(20),
                                border: Border.all(
                                  color: teal.withValues(alpha: 0.35),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(20),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                      bottom: -70,
                                      left: -30,
                                      child: Icon(
                                        Icons.waves,
                                        size: 230,
                                        color: teal.withValues(
                                          alpha: 0.13,
                                        ),
                                      ),
                                    ),

                                    Image.asset(
                                      'assets/images/devcoast_icon.png',
                                      height: isCompact ? 98 : 112,
                                      width: isCompact ? 98 : 112,
                                      fit: BoxFit.contain,
                                    ),

                                    const Positioned(
                                      right: 16,
                                      top: 12,
                                      child: Text(
                                        '01 / EXPLORA',
                                        style: TextStyle(
                                          color: teal,
                                          fontSize: 11,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // ESPACIADO CORREGIDO
                            const SizedBox(height: 28),

                            // BOTÓN INICIAR SESIÓN
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const AuthPage(),
                                    ),
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text('SUBE A BORDO'),
                                    SizedBox(width: 9),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // BOTÓN EXPLORAR OFERTAS
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const PublicJobsPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Explorar ofertas laborales',
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // PIE DE PÁGINA
                            const Center(
                              child: Text(
                                'DEVCOAST / TALENTO QUE CONECTA',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: muted,
                                  fontSize: 10,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
