import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class TopIcons extends StatelessWidget {
  const TopIcons({
    required this.icon,
    required this.press,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final dynamic press;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 50,
        onPressed: press,
        icon: Icon(
          icon,
          color: AppColors.white,
        ));
  }
}
