import 'package:flutter/material.dart';
import 'package:icefloe/dashboard/views/logs_view.dart';
import 'package:icefloe/dashboard/views/per_user_view.dart';
import 'package:icefloe/dashboard/views/relays_view.dart';
import 'package:icefloe/dashboard/views/statistiques_view.dart';
import 'package:icefloe/dashboard/views/users_view.dart';

class DashboardLargeLayout extends StatelessWidget {
  const DashboardLargeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("./logo.png", height: kToolbarHeight - 16),
            ),
            const Text("Icefloe"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const StatistiquesView(),
            const SizedBox(height: 12),
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: PerUserView(),
                          ),
                          SizedBox(height: 12),
                          Expanded(
                            child: LogsView(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: constraints.maxWidth * 0.4,
                      child: const Column(
                        children: [
                          Expanded(
                            child: UsersView(),
                          ),
                          SizedBox(height: 12),
                          Expanded(
                            child: RelaysView(),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
