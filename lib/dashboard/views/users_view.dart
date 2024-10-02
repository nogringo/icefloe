import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icefloe/dashboard/views/add_user_popup.dart';
import 'package:icefloe/dashboard/views/remove_user_popup.dart';
import 'package:icefloe/database/database.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

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
                "Users",
                style: Get.textTheme.titleLarge,
              ),
              trailing: IconButton(
                onPressed: () => Get.dialog(const AddUserPopup()),
                icon: const Icon(Icons.add),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: AppDatabase.to.watchUsers(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const SizedBox();
                  }

                  final users = snapshot.data!;
                  return ListView(
                    children: users
                        .map(
                          (user) => ListTile(
                            title: SelectableText(user.alias ?? user.pubkey),
                            subtitle: user.alias == null
                                ? null
                                : SelectableText(user.pubkey),
                            trailing: IconButton(
                              onPressed: () {
                                Get.dialog(RemoveUserPopup(user));
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
