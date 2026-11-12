import 'package:flutter/material.dart';
import 'package:devcoast_mobile/core/theme/app_colors.dart';
import 'package:devcoast_mobile/core/theme/mobile_tokens.dart';
import 'package:devcoast_mobile/features/jobs/presentation/job_details_page.dart';

Widget jobCard(
  BuildContext context,
  Map<String, dynamic> j, {
  bool canApply = false,
  VoidCallback? onTap,
}) {
  final title = '${j['titulo'] ?? j['nombre'] ?? 'Oferta laboral'}';
  final company = '${j['empresa'] ?? j['empresaNombre'] ?? 'Empresa DevCoast'}';
  final mode = '${j['modalidad'] ?? 'Por definir'}';
  final stack = '${j['stack'] ?? ''}';
  final compact = context.isCompactPhone;

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 18, vertical: 7),
    child: InkWell(
      onTap: onTap ??
          () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => JobDetails(job: j, canApply: canApply),
                ),
              ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: paper,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(compact ? 15 : 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '✦  OPORTUNIDAD DEVCOAST',
                      style: TextStyle(
                        color: Color(0xFF0F766E),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      title,
                      style: TextStyle(
                        color: dark,
                        fontSize: compact ? 18 : 20,
                        fontWeight: FontWeight.w900,
                        height: 1.08,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      company,
                      style: const TextStyle(
                        color: Color(0xFF5A5F6B),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (stack.isNotEmpty) ...[
                      const SizedBox(height: 9),
                      Text(
                        stack,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF5A5F6B),
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Container(
              width: compact ? 84 : 92,
              constraints: const BoxConstraints(minHeight: 138),
              decoration: const BoxDecoration(
                color: sea,
                borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.confirmation_num_outlined, color: teal, size: 29),
                  const SizedBox(height: 9),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      mode,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ink,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.arrow_forward, color: orange, size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
