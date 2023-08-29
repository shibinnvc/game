import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class MenuBackgroundWidget extends StatelessWidget {
  const MenuBackgroundWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/${Constants.background}"),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      ),
    );
  }
}
