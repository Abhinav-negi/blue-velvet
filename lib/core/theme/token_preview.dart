import 'package:flutter/material.dart';

import 'tokens.dart';

/// Debug-only screen listing colours, type scale and motion tokens.
class TokenPreviewScreen extends StatelessWidget {
  const TokenPreviewScreen({super.key});

  static const _colors = <String, Color>{
    'darkBg': AppColors.darkBg,
    'darkSurface': AppColors.darkSurface,
    'darkSurfaceRaised': AppColors.darkSurfaceRaised,
    'darkText': AppColors.darkText,
    'darkTextSecondary': AppColors.darkTextSecondary,
    'lightBg': AppColors.lightBg,
    'lightSurface': AppColors.lightSurface,
    'paperBg': AppColors.paperBg,
    'paperSurface': AppColors.paperSurface,
    'paperInk': AppColors.paperInk,
    'paperInkSecondary': AppColors.paperInkSecondary,
    'paperRedPencil': AppColors.paperRedPencil,
    'amber': AppColors.amber,
    'tealText': AppColors.tealText,
    'tealFill': AppColors.tealFill,
    'sage': AppColors.sage,
    'emberText': AppColors.emberText,
    'emberFill': AppColors.emberFill,
  };

  static final _types = <String, TextStyle>{
    'display': AppType.display,
    'title': AppType.title,
    'heading': AppType.heading,
    'story': AppType.story,
    'body': AppType.body,
    'screenplay': AppType.screenplay,
    'label': AppType.label,
    'caption': AppType.caption,
    'proposal': AppType.proposal,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Token preview')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpace.s2),
        children: [
          Wrap(
            spacing: AppSpace.s1,
            runSpacing: AppSpace.s1,
            children: [
              for (final e in _colors.entries)
                Column(
                  children: [
                    Container(
                      width: AppSize.minTouch,
                      height: AppSize.minTouch,
                      decoration: BoxDecoration(
                        color: e.value,
                        borderRadius: BorderRadius.circular(AppRadius.control),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    Text(e.key, style: AppType.caption),
                  ],
                ),
            ],
          ),
          const SizedBox(height: AppSpace.s3),
          for (final e in _types.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.s1),
              child: Text('${e.key}: The quick brown fox', style: e.value),
            ),
        ],
      ),
    );
  }
}
