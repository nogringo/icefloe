import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icefloe/dashboard/views/logs_view.dart';
import 'package:icefloe/dashboard/views/per_user_view.dart';
import 'package:icefloe/dashboard/views/relays_view.dart';
import 'package:icefloe/dashboard/views/statistiques_view.dart';
import 'package:icefloe/dashboard/views/users_view.dart';
import 'package:icefloe/repository.dart';

class DashboardSmallLayout extends StatelessWidget {
  const DashboardSmallLayout({super.key});

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
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const StatistiquesView(),
            const SizedBox(height: 12),
            Expanded(
              child: GetBuilder<Repository>(builder: (c) {
                return [
                  const UsersView(),
                  const RelaysView(),
                  const PerUserView(),
                  const LogsView()
                ][c.selectedIndex];
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GetBuilder<Repository>(builder: (c) {
        return NavigationBar(
          selectedIndex: c.selectedIndex,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.person_outlined),
              label: "Users",
            ),
            NavigationDestination(
              icon: Icon(Icons.cloud_outlined),
              label: "Relays",
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart),
              label: "Stats",
            ),
            NavigationDestination(
              icon: Icon(Icons.terminal),
              label: "Logs",
            ),
          ],
          onDestinationSelected: c.onDestinationSelected,
        );
      }),
    );
  }
}
