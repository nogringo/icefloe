import 'package:icefloe/relay.dart';

class RelayManager {
  List<Relay> relays = [];

  void addRelay(String url) {
    if (relays.any((relay) => relay.url == url)) return;
    final relay = Relay(url: url);
    relays.add(relay);
  }

  void removeRelay(String url) {
    final foundIndex = relays.indexWhere((relay) => relay.url == url);
    if (foundIndex == -1) return;
    final relay = relays[foundIndex];
    relay.disconnect();
    relays.remove(relay);
  }

  void sendEvent(String event) {
    for (var relay in relays) {
      relay.sendEvent(event);
    }
  }
}