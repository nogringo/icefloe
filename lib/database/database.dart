import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:get/instance_manager.dart';

part 'database.g.dart';

class NostrEvent extends Table {
  TextColumn get id => text()();
  TextColumn get pubkey => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get kind => integer()();
  TextColumn get tags => text()();
  TextColumn get content => text()();
  TextColumn get sig => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class NostrRelay extends Table {
  TextColumn get url => text()();
  TextColumn get alias => text().nullable()();

  @override
  Set<Column> get primaryKey => {url};
}

class NostrUser extends Table {
  TextColumn get pubkey => text()();
  TextColumn get alias => text().nullable()();

  @override
  Set<Column> get primaryKey => {pubkey};
}

class RelayEventLinks extends Table {
  TextColumn get eventId =>
      text().customConstraint('REFERENCES nostr_event(id) NOT NULL')();
  TextColumn get relayUrl =>
      text().customConstraint('REFERENCES nostr_relay(url) NOT NULL')();

  @override
  Set<Column> get primaryKey => {eventId, relayUrl};
}

@DriftDatabase(tables: [NostrEvent, NostrRelay, NostrUser, RelayEventLinks])
class AppDatabase extends _$AppDatabase {
  static AppDatabase get to => Get.find();

  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/getting-started/#open
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    // `driftDatabase` from `package:drift_flutter` stores the database in
    // `getApplicationDocumentsDirectory()`.
    return driftDatabase(
      name: 'icefloe_database',
      web: DriftWebOptions(
          sqlite3Wasm: Uri.parse('sqlite3.wasm'),
          driftWorker: Uri.parse('drift_worker.js'),
          onResult: (result) {
            if (result.missingFeatures.isNotEmpty) {
              debugPrint(
                  'Using ${result.chosenImplementation} due to unsupported '
                  'browser features: ${result.missingFeatures}');
            }
          }),
    );
  }

  Future<void> addRelay(String url, {String? alias}) async {
    into(nostrRelay).insert(
      NostrRelayCompanion(
        url: Value(url),
        alias: Value(alias),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<void> addUser(String pubkey, {String? alias}) async {
    into(nostrUser).insert(
      NostrUserCompanion(
        pubkey: Value(pubkey),
        alias: Value(alias),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<void> removeRelay(String url) async {
    await (delete(nostrRelay)..where((relay) => relay.url.equals(url))).go();
  }

  Future<void> removeUser(String pubkey) async {
    await (delete(nostrUser)..where((user) => user.pubkey.equals(pubkey))).go();
  }

  Future<List<NostrUserData>> getAllUsers() async {
    return select(nostrUser).get();
  }

  Future<int> getEventCount() async {
    final countQuery = await customSelect(
      'SELECT COUNT(*) AS count FROM nostr_event',
      readsFrom: {nostrEvent},
    ).getSingle();

    return countQuery.data['count'] as int;
  }

  Stream<List<NostrEventData>> watchEvents() {
    return select(nostrEvent).watch();
  }

  Stream<List<NostrRelayData>> watchRelays() {
    return select(nostrRelay).watch();
  }

  Stream<List<NostrUserData>> watchUsers() {
    return select(nostrUser).watch();
  }

  Stream<List<EventsPerUser>> watchEventsPerUser() {
    // First, join the NostrUser and NostrEvent tables on the pubkey
    final query = select(nostrUser).join([
      leftOuterJoin(nostrEvent, nostrEvent.pubkey.equalsExp(nostrUser.pubkey)),
    ]);

    // Watch the query and map the results into EventsPerUser
    return query.watch().map((rows) {
      // A map to store users and their corresponding events
      final Map<NostrUserData, List<NostrEventData>> userEventsMap = {};

      for (var row in rows) {
        final user = row.readTable(nostrUser);
        final event = row.readTableOrNull(nostrEvent);

        // Initialize the list of events for the user if not already done
        userEventsMap.putIfAbsent(user, () => []);

        // Add the event to the user's list if it's not null
        if (event != null) {
          userEventsMap[user]!.add(event);
        }
      }

      // Convert the map into a List<EventsPerUser>
      return userEventsMap.entries
          .map((entry) => EventsPerUser(user: entry.key, events: entry.value))
          .toList();
    });
  }
}

class EventsPerUser {
  NostrUserData user;
  List<NostrEventData> events;

  EventsPerUser({required this.user, required this.events});
}
