import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icefloe/database/database.dart';

class AddRelayPopup extends StatelessWidget {
  const AddRelayPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final urlController = TextEditingController();
    final aliasController = TextEditingController();

    return AlertDialog(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("New relay"),
          CloseButton(),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: urlController,
            decoration: const InputDecoration(
              labelText: "Url",
            ),
          ),
          TextField(
            controller: aliasController,
            decoration: const InputDecoration(
              labelText: "Alias",
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed:() {
            final aliasInput = aliasController.text.trim();
            String? alias;
            if (aliasInput.isNotEmpty) {
              alias = aliasInput;
            }

            final url = urlController.text;
            AppDatabase.to.addRelay(url, alias);

            Get.back();
          },
          child: const Text("Add relay"),
        ),
      ],
    );
  }
}
