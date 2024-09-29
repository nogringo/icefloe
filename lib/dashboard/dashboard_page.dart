import 'package:flutter/material.dart';
import 'package:icefloe/dashboard/layouts/dashboard_large_layout.dart';
import 'package:icefloe/dashboard/layouts/dashboard_medium_layout.dart';
import 'package:icefloe/dashboard/layouts/dashboard_small_layout.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 425 * 2.2) {
          return const DashboardLargeLayout();
        }
        if (constraints.maxWidth > 525) {
          return const DashboardMediumLayout();
        }
        return const DashboardSmallLayout();
      },
    );
  }
}
