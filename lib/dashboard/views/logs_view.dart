import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icefloe/repository.dart';

class LogsView extends StatelessWidget {
  const LogsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(
              "Logs",
              style: Get.textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: GetBuilder<Repository>(builder: (c) {
              return ListView.builder(
                itemCount: c.logs.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(c.logs[i]),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
