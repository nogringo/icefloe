import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icefloe/dashboard/views/logs_view.dart';
import 'package:icefloe/dashboard/views/per_user_view.dart';
import 'package:icefloe/dashboard/views/relays_view.dart';
import 'package:icefloe/dashboard/views/statistiques_view.dart';
import 'package:icefloe/dashboard/views/users_view.dart';
import 'package:icefloe/repository.dart';

class DashboardMediumLayout extends StatelessWidget {
  const DashboardMediumLayout({super.key});

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
      body: GetBuilder<Repository>(builder: (c) {
        return Row(
          children: [
            NavigationRail(
              selectedIndex: c.selectedIndex,
              labelType: NavigationRailLabelType.selected,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.person_outlined),
                  label: Text("Users"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.cloud_outlined),
                  label: Text("Relays"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.bar_chart),
                  label: Text("Stats"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.terminal),
                  label: Text("Logs"),
                ),
              ],
              onDestinationSelected: c.onDestinationSelected,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const StatistiquesView(),
                    const SizedBox(height: 12),
                    Expanded(
                      child: [
                        const UsersView(),
                        const RelaysView(),
                        const PerUserView(),
                        const LogsView()
                      ][c.selectedIndex],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
