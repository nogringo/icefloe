import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:icefloe/desktop/window_buttons.dart';

class DesktopLayout extends StatelessWidget {
  final Widget child;

  const DesktopLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          child,
          WindowTitleBarBox(
            child: Row(
              children: [
                Expanded(child: MoveWindow()),
                const WindowButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
