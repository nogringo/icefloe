import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icefloe/database/database.dart';

class RemoveUserPopup extends StatelessWidget {
  final NostrUserData user;

  const RemoveUserPopup(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Remove user"),
          CloseButton(),
        ],
      ),
      content: Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: "You are about to delete "),
            if (user.alias != null) TextSpan(
              text: "${user.alias} ",
              style: TextStyle(color: Get.theme.colorScheme.primary),
            ),
            TextSpan(
              text: user.pubkey,
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
            AppDatabase.to.removeUser(user.pubkey);
            Get.back();
          },
          child: const Text("Remove user"),
        ),
      ],
    );
  }
}
