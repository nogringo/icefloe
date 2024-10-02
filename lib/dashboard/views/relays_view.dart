import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icefloe/dashboard/views/add_relay_popup.dart';
import 'package:icefloe/dashboard/views/remove_relay_popup.dart';
import 'package:icefloe/database/database.dart';

class RelaysView extends StatelessWidget {
  const RelaysView({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: Get.height / 2,
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.primaryContainer.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                "Relays",
                style: Get.textTheme.titleLarge,
              ),
              trailing: IconButton(
                onPressed: () => Get.dialog(const AddRelayPopup()),
                icon: const Icon(Icons.add),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: AppDatabase.to.watchRelays(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const SizedBox();
                  }

                  final relays = snapshot.data!;
                  return ListView(
                    shrinkWrap: true,
                    children: relays
                        .map(
                          (relay) => ListTile(
                            title: SelectableText(relay.alias ?? relay.url),
                            subtitle:
                                relay.alias == null ? null : SelectableText(relay.url),
                            trailing: IconButton(
                              onPressed: () {
                                Get.dialog(RemoveRelayPopup(relay));
                              },
                              icon: const Icon(Icons.delete_outlined),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
