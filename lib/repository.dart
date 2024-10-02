import 'dart:convert';

import 'package:get/get.dart';
import 'package:icefloe/api.dart';
import 'package:icefloe/database/database.dart';
import 'package:icefloe/functions.dart';
import 'package:nostr/nostr.dart';

class Repository extends GetxController {
  static Repository get to => Get.find();

  int selectedIndex = 0;
  bool chartMode = true;
  List<String> logs = [];

  void startSyncTask() async {
    logs = [];
    update();

    addLog("Syncing task begin");

    final users = await AppDatabase.to.getAllUsers();
    final relays = await AppDatabase.to.getAllRelays();

    for (var relay in relays) {
      Request requestWithFilter = Request(generate64RandomHexChars(), [
        Filter(
          kinds: [1],
          authors: users.map((e) => e.pubkey).toList(),
        )
      ]);

      addLog("Fetch events in ${relay.alias ?? relay.url}");
      final events = await nostrFetchEvents(
        requestWithFilter.serialize(),
        relay.url,
      );

      for (var event in events) {
        final jsonEvent = Event.fromJson(jsonDecode(event));
        await AppDatabase.to.addEvent(
          id: jsonEvent.id,
          pubkey: jsonEvent.pubkey,
          createdAt: DateTime.fromMillisecondsSinceEpoch(
            jsonEvent.createdAt * 1000,
          ),
          kind: jsonEvent.kind,
          tags: convertTagsToJson(jsonEvent.tags),
          content: jsonEvent.content,
          sig: jsonEvent.sig,
        );
        await AppDatabase.to.joinEventToRelay(jsonEvent.id, relay.url);
      }
    }

    final eventsWithRelays = await AppDatabase.to.getEventsAndRelaysToSend();
    for (var eventWithRelays in eventsWithRelays) {
      final e = eventWithRelays.event;
      final serealizedEvent = Event(
        e.id,
        e.pubkey,
        e.createdAt.millisecondsSinceEpoch ~/ 1000,
        e.kind,
        convertJsonToTags(e.tags),
        e.content,
        e.sig,
      ).serialize();
      addLog("Send event ${e.id}");
      for (var url in eventWithRelays.missingRelays) {
        addLog("To $url");
        await nostrSendEvent(serealizedEvent, url);
      }
    }

    addLog("Job done");
  }

  void addLog(String log) {
    logs.add(log);
    update();
  }

  void onDestinationSelected(int value) {
    selectedIndex = value;
    update();
  }
}
