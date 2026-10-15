import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynch/core/theme/app_theme.dart';
import 'package:lynch/core/theme/tokens.dart';

void main() {
  test('colour tokens match design.md hex', () {
    final expected = <(Color, int)>[
      (AppColors.darkBg, 0xFF16130F),
      (AppColors.darkSurface, 0xFF221E19),
      (AppColors.darkSurfaceRaised, 0xFF2E2A24),
      (AppColors.darkText, 0xFFEDE6D8),
      (AppColors.darkTextSecondary, 0xFFA89F90),
      (AppColors.darkDivider, 0x1AEDE6D8),
      (AppColors.lightBg, 0xFFEFE9DD),
      (AppColors.lightSurface, 0xFFF8F4EC),
      (AppColors.lightText, 0xFF1E1C19),
      (AppColors.lightTextSecondary, 0xFF6B6457),
      (AppColors.paperBg, 0xFFF4EFE4),
      (AppColors.paperSurface, 0xFFFBF8F2),
      (AppColors.paperInk, 0xFF1E1C19),
      (AppColors.paperInkSecondary, 0xFF6B6457),
      (AppColors.paperRedPencil, 0xFFA63A2B),
      (AppColors.amber, 0xFFE8A33D),
      (AppColors.tealText, 0xFF7FB0AD),
      (AppColors.tealFill, 0xFF5E8C8A),
      (AppColors.sage, 0xFF8DB38B),
      (AppColors.emberText, 0xFFE07A62),
      (AppColors.emberFill, 0xFFC2553F),
    ];
    for (final (c, hex) in expected) {
      expect(c.toARGB32(), hex);
    }
  });

  test('spacing, sizes, motion', () {
    expect(AppSpace.s2, 16);
    expect(AppSize.mic, 64);
    expect(AppMotion.fast.inMilliseconds, 120);
    expect(AppMotion.base.inMilliseconds, 240);
    expect(AppMotion.slow.inMilliseconds, 400);
  });

  test('type scale uses bundled fonts and 4dp line heights', () {
    for (final s in [
      AppType.display,
      AppType.title,
      AppType.heading,
      AppType.story,
      AppType.body,
      AppType.screenplay,
      AppType.label,
      AppType.caption,
    ]) {
      expect(['Literata', 'Inter', 'CourierPrime'], contains(s.fontFamily));
      expect((s.fontSize! * s.height!) % 4, closeTo(0, 1e-9));
    }
  });

  test('dark and light themes build', () {
    for (final t in [AppTheme.dark, AppTheme.light]) {
      expect(t.useMaterial3, isTrue);
      expect(t.extension<PaperColors>(), isNotNull);
      expect(t.extension<DiffColors>(), isNotNull);
      expect(t.extension<MicColors>(), isNotNull);
    }
    expect(AppTheme.dark.scaffoldBackgroundColor, AppColors.darkBg);
    expect(AppTheme.light.scaffoldBackgroundColor, AppColors.lightBg);
  });

  testWidgets('motion helper honours disableAnimations', (tester) async {
    Duration? got;
    Future<void> pump(bool off) => tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(disableAnimations: off),
        child: Builder(
          builder: (c) {
            got = AppMotion.of(c, AppMotion.base);
            return const SizedBox();
          },
        ),
      ),
    );
    await pump(true);
    expect(got, Duration.zero);
    await pump(false);
    expect(got, AppMotion.base);
  });
}
