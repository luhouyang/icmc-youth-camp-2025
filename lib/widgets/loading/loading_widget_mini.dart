import 'dart:async';
import 'dart:math';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/widgets.dart';
import 'package:yc_icmc_2025/widgets/ui_color.dart';

class LoadingWidgetMini extends StatefulWidget {
  final double height;

  const LoadingWidgetMini({super.key, required this.height});

  @override
  State<LoadingWidgetMini> createState() => _LoadingWidgetMiniState();
}

class _LoadingWidgetMiniState extends State<LoadingWidgetMini> {
  // set colours
  final List _colorsLight = [
    UIColor().transparentPrimaryBlue,
    UIColor().secondaryBlue.withOpacity(0.75),
    UIColor().secondaryBlue.withOpacity(0.85),
    UIColor().secondaryBlue.withOpacity(0.95),
  ];

  final List _colorsDark = [
    UIColor().transparentPrimaryOrange,
    UIColor().secondaryOrange.withOpacity(0.75),
    UIColor().secondaryOrange.withOpacity(0.85),
    UIColor().secondaryOrange.withOpacity(0.95),
  ];

  // track colour
  int _currentColorIndex = 0;

  // set text message
  List<String> getMssg(double timeElapsed) {
    if (timeElapsed <= 5.0) {
      return [
        "Crunching numbers for you      ",
        "Crunching numbers for you .    ",
        "Crunching numbers for you . .  ",
        "Crunching numbers for you . . .",
      ];
    } else if (timeElapsed <= 15.0) {
      return [
        "Will be ready in a while      ",
        "Will be ready in a while .    ",
        "Will be ready in a while . .  ",
        "Will be ready in a while . . .",
      ];
    } else {
      return [
        "Wow it's taking a while      ",
        "Wow it's taking a while .    ",
        "Wow it's taking a while . .  ",
        "Wow it's taking a while . . .",
      ];
    }
  }

  // track text message
  int textListLength = 4;
  int _currentTextMssg = 0;
  double _timeElapsed = 0;

  // animation timing
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  // Start the timer
  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 350), (timer) {
      setState(() {
        _currentColorIndex = (_currentColorIndex + 1) % _colorsLight.length;
        _currentTextMssg = (_currentTextMssg + 1) % textListLength;
        _timeElapsed += 0.5;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLightMode = AdaptiveTheme.of(context).mode.isLight;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: AnimatedContainer(
        height: widget.height,
        duration: const Duration(milliseconds: 700),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          gradient: LinearGradient(
            colors: [
              isLightMode ? _colorsLight[_currentColorIndex] : _colorsDark[_currentColorIndex], // Use the current color
              isLightMode
                  ? _colorsLight[(_currentColorIndex + 1) % _colorsLight.length]
                  : _colorsDark[(_currentColorIndex + 1) % _colorsDark.length], // Use the next color in the list
            ],
            transform: GradientRotation(Random().nextDouble()), // add position variation
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            getMssg(_timeElapsed)[_currentTextMssg],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
