import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icefloe/database/database.dart';

class AddUserPopup extends StatelessWidget {
  const AddUserPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final pubkeyController = TextEditingController();
    final aliasController = TextEditingController();

    return AlertDialog(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("New user"),
          CloseButton(),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: pubkeyController,
            decoration: const InputDecoration(
              labelText: "Pubkey",
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

            AppDatabase.to.addUser(pubkeyController.text, alias: alias);

            Get.back();
          },
          child: const Text("Add user"),
        ),
      ],
    );
  }
}
