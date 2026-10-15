import 'package:flutter/material.dart';

import 'tokens.dart';

/// Paper work surfaces (screenplay, storyboard, reading). Same in both themes.
@immutable
class PaperColors extends ThemeExtension<PaperColors> {
  const PaperColors({
    this.bg = AppColors.paperBg,
    this.surface = AppColors.paperSurface,
    this.ink = AppColors.paperInk,
    this.inkSecondary = AppColors.paperInkSecondary,
    this.redPencil = AppColors.paperRedPencil,
  });
  final Color bg, surface, ink, inkSecondary, redPencil;

  @override
  PaperColors copyWith({
    Color? bg,
    Color? surface,
    Color? ink,
    Color? inkSecondary,
    Color? redPencil,
  }) => PaperColors(
    bg: bg ?? this.bg,
    surface: surface ?? this.surface,
    ink: ink ?? this.ink,
    inkSecondary: inkSecondary ?? this.inkSecondary,
    redPencil: redPencil ?? this.redPencil,
  );

  @override
  PaperColors lerp(PaperColors? other, double t) => other == null
      ? this
      : PaperColors(
          bg: Color.lerp(bg, other.bg, t)!,
          surface: Color.lerp(surface, other.surface, t)!,
          ink: Color.lerp(ink, other.ink, t)!,
          inkSecondary: Color.lerp(inkSecondary, other.inkSecondary, t)!,
          redPencil: Color.lerp(redPencil, other.redPencil, t)!,
        );
}

/// Diff colours: added = sage (on frame), removed on paper = red pencil, pending = amber rule.
@immutable
class DiffColors extends ThemeExtension<DiffColors> {
  const DiffColors({
    this.added = AppColors.sage,
    this.removedOnPaper = AppColors.paperRedPencil,
    this.removedOnFrame = AppColors.emberText,
    this.proposalRule = AppColors.amber,
  });
  final Color added, removedOnPaper, removedOnFrame, proposalRule;

  @override
  DiffColors copyWith({
    Color? added,
    Color? removedOnPaper,
    Color? removedOnFrame,
    Color? proposalRule,
  }) => DiffColors(
    added: added ?? this.added,
    removedOnPaper: removedOnPaper ?? this.removedOnPaper,
    removedOnFrame: removedOnFrame ?? this.removedOnFrame,
    proposalRule: proposalRule ?? this.proposalRule,
  );

  @override
  DiffColors lerp(DiffColors? other, double t) => other == null
      ? this
      : DiffColors(
          added: Color.lerp(added, other.added, t)!,
          removedOnPaper: Color.lerp(removedOnPaper, other.removedOnPaper, t)!,
          removedOnFrame: Color.lerp(removedOnFrame, other.removedOnFrame, t)!,
          proposalRule: Color.lerp(proposalRule, other.proposalRule, t)!,
        );
}

/// Mic dock: amber idle, ember while recording.
@immutable
class MicColors extends ThemeExtension<MicColors> {
  const MicColors({
    this.idle = AppColors.amber,
    this.onIdle = AppColors.darkBg,
    this.recording = AppColors.emberFill,
    this.recordingText = AppColors.emberText,
  });
  final Color idle, onIdle, recording, recordingText;

  @override
  MicColors copyWith({
    Color? idle,
    Color? onIdle,
    Color? recording,
    Color? recordingText,
  }) => MicColors(
    idle: idle ?? this.idle,
    onIdle: onIdle ?? this.onIdle,
    recording: recording ?? this.recording,
    recordingText: recordingText ?? this.recordingText,
  );

  @override
  MicColors lerp(MicColors? other, double t) => other == null
      ? this
      : MicColors(
          idle: Color.lerp(idle, other.idle, t)!,
          onIdle: Color.lerp(onIdle, other.onIdle, t)!,
          recording: Color.lerp(recording, other.recording, t)!,
          recordingText: Color.lerp(recordingText, other.recordingText, t)!,
        );
}

TextTheme _textTheme(Color primary, Color secondary) {
  TextStyle c(TextStyle s, [Color? col]) => s.copyWith(color: col ?? primary);
  return TextTheme(
    displayLarge: c(AppType.display),
    displayMedium: c(AppType.display),
    displaySmall: c(AppType.display),
    headlineLarge: c(AppType.title),
    headlineMedium: c(AppType.title),
    headlineSmall: c(AppType.title),
    titleLarge: c(AppType.title),
    titleMedium: c(AppType.heading),
    titleSmall: c(AppType.heading),
    bodyLarge: c(AppType.body),
    bodyMedium: c(AppType.body),
    bodySmall: c(AppType.caption, secondary),
    labelLarge: c(AppType.label),
    labelMedium: c(AppType.label),
    labelSmall: c(AppType.caption, secondary),
  );
}

ThemeData _build({
  required Brightness brightness,
  required Color bg,
  required Color surface,
  required Color raised,
  required Color text,
  required Color textSecondary,
  required Color divider,
  required Color teal,
  required Color ember,
}) {
  final scheme = ColorScheme(
    brightness: brightness,
    primary: AppColors.amber,
    onPrimary: AppColors.darkBg,
    secondary: teal,
    onSecondary: AppColors.darkBg,
    tertiary: AppColors.sage,
    onTertiary: AppColors.darkBg,
    error: ember,
    onError: AppColors.darkBg,
    surface: surface,
    onSurface: text,
    onSurfaceVariant: textSecondary,
    surfaceContainerHighest: raised,
    outline: textSecondary,
    outlineVariant: divider,
  );
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: bg,
    canvasColor: bg,
    dividerColor: divider,
    textTheme: _textTheme(text, textSecondary),
    fontFamily: AppType.sans,
    splashFactory: InkRipple.splashFactory,
    extensions: const [PaperColors(), DiffColors(), MicColors()],
  );
}

abstract final class AppTheme {
  static final ThemeData dark = _build(
    brightness: Brightness.dark,
    bg: AppColors.darkBg,
    surface: AppColors.darkSurface,
    raised: AppColors.darkSurfaceRaised,
    text: AppColors.darkText,
    textSecondary: AppColors.darkTextSecondary,
    divider: AppColors.darkDivider,
    teal: AppColors.tealText,
    ember: AppColors.emberText,
  );

  static final ThemeData light = _build(
    brightness: Brightness.light,
    bg: AppColors.lightBg,
    surface: AppColors.lightSurface,
    raised: AppColors.lightSurfaceRaised,
    text: AppColors.lightText,
    textSecondary: AppColors.lightTextSecondary,
    divider: AppColors.lightDivider,
    teal: AppColors.tealFill,
    ember: AppColors.emberFill,
  );
}
