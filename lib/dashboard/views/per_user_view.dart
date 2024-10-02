import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icefloe/dashboard/views/per_user_chart.dart';
import 'package:icefloe/database/database.dart';
import 'package:icefloe/repository.dart';

class PerUserView extends StatelessWidget {
  const PerUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.primaryContainer.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GetBuilder<Repository>(builder: (c) {
            return ListTile(
              title: Text(
                "${!c.chartMode ? "Bytes" : "Events"} per users",
                style: Get.textTheme.titleLarge,
              ),
              trailing: Switch(
                value: c.chartMode,
                onChanged: (value) {
                  c.chartMode = !c.chartMode;
                  c.update();
                },
              ),
            );
          }),
          Expanded(
            child: StreamBuilder(
              stream: AppDatabase.to.watchEventsPerUser(),
              builder: (context, snapshot) {
                return GetBuilder<Repository>(builder: (c) {
                  if (snapshot.data == null) return const SizedBox();

                  final eventsPerUser = snapshot.data!;

                  List<BarData> dataList;
                  if (c.chartMode) {
                    dataList = eventsPerUser
                        .map((e) => BarData(e.user, e.events.length.toDouble()))
                        .toList();
                  } else {
                    dataList = eventsPerUser.map((e) {
                      double count = 0;
                      if (e.events.isNotEmpty) {
                        count = e.events
                            .map((e) => e.content.length)
                            .reduce((a, b) => a + b)
                            .toDouble();
                      }

                      return BarData(
                        e.user,
                        count,
                      );
                    }).toList();
                  }

                  return PerUserChart(dataList);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
