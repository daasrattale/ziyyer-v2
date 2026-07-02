import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loader extends StatelessWidget {
  final Color? color;
  final double? size;
  const Loader({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    Color defaultColor = color ?? Theme.of(context).primaryColor;
    double defaultSize = size ?? MediaQuery.of(context).size.width * .1;

    return LoadingAnimationWidget.threeRotatingDots(color: defaultColor, size: defaultSize);
  }
}
