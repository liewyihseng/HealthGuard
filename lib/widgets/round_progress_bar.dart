import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class RoundProgressBar extends StatelessWidget {
  final double value;
  final double max;
  final double size;
  final Color color;
  final Function innerWidget;

  RoundProgressBar(
      {this.size, this.color, this.innerWidget, this.max, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SleekCircularSlider(
        min: 0,
        max: max,
        initialValue: value,
        innerWidget: innerWidget,
        appearance: CircularSliderAppearance(
          animDurationMultiplier: 1.2,
          angleRange: 300,
          startAngle: 120,
          size: size,
          customWidths: CustomSliderWidths(
            progressBarWidth: size / 15,
            trackWidth: size / 20,
            handlerSize: 0,
            shadowWidth: size / 20,
          ),
          customColors: CustomSliderColors(
            trackColor: Colors.grey[300],
            progressBarColor: color,
          ),
        ),
      ),
    );
  }
}
