import 'package:flutter/widgets.dart';

/// Spacing scale (design.md 4.2). Name = multiplier of 8 dp.
abstract final class AppSpace {
  static const double s05 = 4;
  static const double s1 = 8;
  static const double s2 = 16;
  static const double s3 = 24;
  static const double s4 = 32;
  static const double s6 = 48;
  static const double s8 = 64;
}

/// Element sizes (design.md 4.3).
abstract final class AppSize {
  static const double minTouch = 48;
  static const double button = 48;
  static const double chip = 32;
  static const double mic = 64;
  static const double bottomBar = 64;
  static const double iconInline = 16;
  static const double icon = 24;
  static const double iconEmpty = 32;
  static const double sideMargin = 16;
  static const double sideMarginWide = 24;
  static const double maxTextColumn = 640;
}

/// Corner radii (design.md 4.3).
abstract final class AppRadius {
  static const double control = 8;
  static const double card = 16;
  static const double full = 999;
}

/// Motion (design.md 9).
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration base = Duration(milliseconds: 240);
  static const Duration slow = Duration(milliseconds: 400);

  static const Curve fastCurve = Curves.easeOut;
  static const Curve baseCurve = Curves.easeInOutCubicEmphasized;
  static const Curve slowCurve = Curves.easeInOut;

  /// Returns [d], or [Duration.zero] when the system "Remove animations" is on.
  static Duration of(BuildContext context, Duration d) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : d;
}

/// Colours (design.md 5 and 13). The only place hex values live.
abstract final class AppColors {
  // Darkroom frame.
  static const Color darkBg = Color(0xFF16130F);
  static const Color darkSurface = Color(0xFF221E19);
  static const Color darkSurfaceRaised = Color(0xFF2E2A24);
  static const Color darkText = Color(0xFFEDE6D8);
  static const Color darkTextSecondary = Color(0xFFA89F90);
  static const Color darkDivider = Color(0x1AEDE6D8); // text at 10%

  // Light frame (13). design.md gives no raised value; derived, slightly darker than surface.
  static const Color lightBg = Color(0xFFEFE9DD);
  static const Color lightSurface = Color(0xFFF8F4EC);
  static const Color lightSurfaceRaised = Color(0xFFE6DFD0);
  static const Color lightText = Color(0xFF1E1C19);
  static const Color lightTextSecondary = Color(0xFF6B6457);
  static const Color lightDivider = Color(0x1A1E1C19); // text at 10%

  // Paper (same in both themes).
  static const Color paperBg = Color(0xFFF4EFE4);
  static const Color paperSurface = Color(0xFFFBF8F2);
  static const Color paperInk = Color(0xFF1E1C19);
  static const Color paperInkSecondary = Color(0xFF6B6457);
  static const Color paperRedPencil = Color(0xFFA63A2B);

  // Accents.
  static const Color amber = Color(0xFFE8A33D);
  static const Color tealText = Color(0xFF7FB0AD);
  static const Color tealFill = Color(0xFF5E8C8A);
  static const Color sage = Color(0xFF8DB38B);
  static const Color emberText = Color(0xFFE07A62);
  static const Color emberFill = Color(0xFFC2553F);
}

/// Type scale (design.md 6.3). height = lineHeight / fontSize.
abstract final class AppType {
  static const String serif = 'Literata';
  static const String sans = 'Inter';
  static const String mono = 'CourierPrime';

  static TextStyle _s(String family, double size, double line, FontWeight w) =>
      TextStyle(
        fontFamily: family,
        fontSize: size,
        height: line / size,
        fontWeight: w,
      );

  static const _r = FontWeight.w400;
  static const _m = FontWeight.w500;

  static final TextStyle display = _s(serif, 32, 40, _m);
  static final TextStyle title = _s(sans, 22, 28, _m);
  static final TextStyle heading = _s(sans, 18, 24, _m);
  static final TextStyle story = _s(serif, 18, 28, _r);
  static final TextStyle body = _s(sans, 16, 24, _r);
  static final TextStyle screenplay = _s(mono, 16, 24, _r);
  static final TextStyle label = _s(sans, 14, 20, _m);
  static final TextStyle caption = _s(sans, 12, 16, _r);

  /// AI-suggested text before approval (6.1): Literata italic.
  static final TextStyle proposal = story.copyWith(fontStyle: FontStyle.italic);
}
