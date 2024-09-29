import 'package:get/get.dart';
import 'package:icefloe/database/database.dart';

class Repository extends GetxController {
  static Repository get to => Get.find();

  int selectedIndex = 0;
  bool chartMode = true;
  List<String> logs = [
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
    "Logs",
  ];

  void addUser(String pubkey, [String? alias]) {
    
  }

  void addRelay() {
    
  }

  removeRelay(NostrRelayData relay) {
    AppDatabase.to.removeRelay(relay.url);
  }

  void onDestinationSelected(int value) {
    selectedIndex = value;
    update();
  }
}