import 'package:flutter/material.dart';
import 'package:icefloe/database/database.dart';

class StatistiquesView extends StatelessWidget {
  const StatistiquesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          EventChip(),
          SizedBox(width: 8),
          CharacterChip(),
          SizedBox(width: 8),
          UserChip(),
          SizedBox(width: 8),
          RelayChip(),
        ],
      ),
    );
  }
}

class RelayChip extends StatelessWidget {
  const RelayChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: StreamBuilder(
        stream: AppDatabase.to.watchRelays(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const SizedBox();
          }

          int count = snapshot.data!.length;
          return Text("$count Relay${count < 2 ? "" : "s"}");
        },
      ),
      avatar: const Icon(Icons.cloud_outlined),
    );
  }
}

class UserChip extends StatelessWidget {
  const UserChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: StreamBuilder(
        stream: AppDatabase.to.watchUsers(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const SizedBox();
          }

          int count = snapshot.data!.length;
          return Text("$count User${count < 2 ? "" : "s"}");
        },
      ),
      avatar: const Icon(Icons.person_outlined),
    );
  }
}

class CharacterChip extends StatelessWidget {
  const CharacterChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: StreamBuilder(
        stream: AppDatabase.to.watchEvents(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const SizedBox();
          }

          final events = snapshot.data!;
          int count;
          if (events.isEmpty) {
            count = 0;
          } else {
            count = events.map((e) => e.content.length).reduce((a, b) => a + b);
          }
          return Text(
            "$count Byte${count < 2 ? "" : "s"}",
          );
        },
      ),
      avatar: const Icon(Icons.storage_outlined),
    );
  }
}

class EventChip extends StatelessWidget {
  const EventChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: StreamBuilder(
        stream: AppDatabase.to.watchEvents(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const SizedBox();
          }

          final count = snapshot.data!.length;
          return Text("$count Event${count < 2 ? "" : "s"}");
        },
      ),
      avatar: const Icon(Icons.event_outlined),
    );
  }
}
