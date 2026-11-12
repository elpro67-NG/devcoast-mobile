import 'package:flutter/material.dart';
import 'package:devcoast_mobile/core/theme/mobile_tokens.dart';
import '../theme/app_colors.dart';

class NauticalBrand extends StatelessWidget {
  const NauticalBrand({super.key, this.size = 22});
  final double size;
  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(size * .24),
            child: Image.asset(
              'assets/images/devcoast_icon.png',
              width: size * 1.65,
              height: size * 1.65,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: size * .38),
          Flexible(
            child: Text(
              'DevCoast',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.w800,
                color: ink,
                letterSpacing: -.7,
              ),
            ),
          ),
        ],
      );
}

class DevCoastHorizontalLogo extends StatelessWidget {
  const DevCoastHorizontalLogo({super.key, this.height = 96});
  final double height;
  @override
  Widget build(BuildContext context) => Image.asset(
        'assets/images/devcoast_logo_horizontal.png',
        height: height,
        fit: BoxFit.contain,
        semanticLabel: 'DevCoast, logotipo con velero',
      );
}

class SectionEyebrow extends StatelessWidget {
  const SectionEyebrow(this.label, {super.key});
  final String label;
  @override
  Widget build(BuildContext context) => Text(
        '// ${label.toUpperCase()}',
        style: const TextStyle(
          color: teal,
          fontSize: 11,
          letterSpacing: 2,
          fontWeight: FontWeight.w800,
        ),
      );
}

class SeaHero extends StatelessWidget {
  const SeaHero({
    super.key,
    required this.title,
    required this.subtitle,
    this.onAction,
    this.actionLabel,
  });
  final String title, subtitle;
  final VoidCallback? onAction;
  final String? actionLabel;
  @override
  Widget build(BuildContext context) {
    final titleSize = context.isCompactPhone ? 26.0 : 30.0;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.isCompactPhone ? 20 : 23),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: sea,
        border: Border.all(color: teal.withValues(alpha: .22)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -6,
            top: 3,
            child: Icon(
              Icons.sailing,
              color: teal.withValues(alpha: .14),
              size: context.isCompactPhone ? 110 : 125,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionEyebrow('tu próxima travesía'),
              const SizedBox(height: 11),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: titleSize,
                  height: 1.08,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFFBFE9E3),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              if (onAction != null && actionLabel != null) ...[
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onAction,
                    child: Text(actionLabel!),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class NauticalHeading extends StatelessWidget {
  const NauticalHeading(this.title, {super.key, this.subtitle});
  final String title;
  final String? subtitle;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionEyebrow('devcoast'),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: context.isCompactPhone ? 28 : 30,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  subtitle!,
                  style: const TextStyle(color: muted, height: 1.35),
                ),
              ),
          ],
        ),
      );
}
