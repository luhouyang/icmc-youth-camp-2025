import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:yc_icmc_2025/widgets/ui_color.dart';

class LoadingWidgetLarge extends StatelessWidget {
  const LoadingWidgetLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: AdaptiveTheme.of(context).mode.isLight ? UIColor().secondaryBlue : UIColor().secondaryOrange,
        size: 50,
      ),
    );
  }
}
