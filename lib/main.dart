import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icefloe/dashboard/dashboard_page.dart';
import 'package:icefloe/database/database.dart';
import 'package:icefloe/desktop/desktop_layout.dart';
import 'package:icefloe/repository.dart';
import 'package:system_theme/system_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemTheme.fallbackColor = const Color(0xFF739AD6);
  await SystemTheme.accentColor.load();

  Get.put(AppDatabase());
  Get.put(Repository());

  runApp(const MainApp());

  doWhenWindowReady(() {
    const initialSize = Size(600, 450);
    appWindow.minSize = const Size(350, 500);
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget home;
    if (GetPlatform.isDesktop) {
      home = const DesktopLayout(child: DashboardPage());
    } else {
      home = const DashboardPage();
    }

    return SystemThemeBuilder(builder: (context, accent) {
      ThemeData getThemeData([Brightness brightness = Brightness.light]) {
        return ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
            seedColor: accent.accent,
            brightness: brightness,
          ),
        );
      }

      return GetMaterialApp(
        debugShowCheckedModeBanner: kDebugMode,
        theme: getThemeData(),
        darkTheme: getThemeData(Brightness.dark),
        themeMode: ThemeMode.system,
        home: home,
      );
    });
  }
}
