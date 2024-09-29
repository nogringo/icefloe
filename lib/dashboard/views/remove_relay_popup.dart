import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icefloe/database/database.dart';

class RemoveRelayPopup extends StatelessWidget {
  final NostrRelayData relay;

  const RemoveRelayPopup(this.relay, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Remove relay"),
          CloseButton(),
        ],
      ),
      content: Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: "You are about to delete "),
            if (relay.alias != null) TextSpan(
              text: "${relay.alias} ",
              style: TextStyle(color: Get.theme.colorScheme.primary),
            ),
            TextSpan(
              text: relay.url,
              style: TextStyle(color: Get.theme.colorScheme.primary),
            ),
            const TextSpan(text: '. Do you want to continue ?'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed:() {
            AppDatabase.to.removeRelay(relay.url);
            Get.back();
          },
          child: const Text("Remove relay"),
        ),
      ],
    );
  }
}
