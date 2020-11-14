import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class RoundProgressBar extends StatelessWidget {
  final double size;
  final Color color;
  final Function innerWidget;

  RoundProgressBar({this.size, this.color, this.innerWidget});

  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
      appearance: CircularSliderAppearance(
        size: size,
        customWidths: CustomSliderWidths(
          progressBarWidth: size/12.5,
          trackWidth: size/20,
          handlerSize: 0,
          shadowWidth: size/20,
        ),
        customColors: CustomSliderColors(
            trackColor: Colors.grey[300],
            progressBarColor: color,
        ),
      ),
      min: 0,
      max: 100,
      initialValue: 60,
      innerWidget: innerWidget,
    );
  }
}
