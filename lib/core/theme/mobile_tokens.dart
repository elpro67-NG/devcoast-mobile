import 'dart:math' as math;
import 'package:flutter/material.dart';

const double kIphone14Width = 390;
const double kMobileContentMaxWidth = 430;

extension MobileLayout on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  bool get isCompactPhone => screenSize.width <= 390;
  bool get isLargePhone => screenSize.width >= 414;
  bool get isTabletLike => screenSize.width >= 768;

  double mobileScale([double baseWidth = kIphone14Width]) =>
      (screenSize.width / baseWidth).clamp(0.92, 1.12);

  double scaled(double value) => value * mobileScale();

  EdgeInsets get screenPadding => EdgeInsets.symmetric(
        horizontal: isCompactPhone ? 20 : 24,
        vertical: 18,
      );

  double get contentMaxWidth =>
      math.min(screenSize.width, kMobileContentMaxWidth);
}

class MobileFrame extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const MobileFrame({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: kMobileContentMaxWidth),
        child: Padding(
          padding: padding ?? context.screenPadding,
          child: child,
        ),
      ),
    );
  }
}
