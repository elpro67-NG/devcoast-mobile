import 'package:flutter/material.dart';
import 'package:devcoast_mobile/core/theme/app_colors.dart';
import 'package:devcoast_mobile/core/theme/mobile_tokens.dart';

void errorToast(BuildContext c, Object e) {
  if (!c.mounted) return;
  ScaffoldMessenger.of(c).showSnackBar(
    SnackBar(
      content: Text('$e'),
      backgroundColor: const Color(0xFF8B3040),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

Widget field(
  TextEditingController controller,
  String title, {
  bool secret = false,
  int maxLines = 1,
  TextInputType? keyboardType,
}) => Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        obscureText: secret,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: title),
      ),
    );

Widget sectionTitle(BuildContext context, String title, {String? subtitle}) => Padding(
      padding: EdgeInsets.fromLTRB(
        context.isCompactPhone ? 16 : 18,
        16,
        context.isCompactPhone ? 16 : 18,
        10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '// DEVCOAST',
            style: TextStyle(
              color: teal,
              fontSize: 10,
              letterSpacing: 1.7,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: context.isCompactPhone ? 24 : 26,
              fontWeight: FontWeight.w900,
              letterSpacing: -.6,
              height: 1.05,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(color: muted, height: 1.35),
            ),
          ],
        ],
      ),
    );
