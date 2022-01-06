import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_apps/data/model/favorite.dart';
import 'package:restaurant_apps/ui/detail_screen_fav.dart';
import 'package:restaurant_apps/ui/favorite_page.dart';
import 'package:restaurant_apps/utils/background_service.dart';
import 'package:restaurant_apps/data/model/restaurant.dart';
import 'package:restaurant_apps/navigation.dart';
import 'package:restaurant_apps/utils/notification_helper.dart';
import 'package:restaurant_apps/ui/detail_screen.dart';
import 'package:restaurant_apps/ui/main_screen.dart';
import 'package:restaurant_apps/ui/search_screen.dart';
import 'package:restaurant_apps/ui/settings_page.dart';
import 'package:restaurant_apps/ui/splash_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();
  _service.initializeIsolate();
  await AndroidAlarmManager.initialize();

  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Apps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      initialRoute: SplashPage.routeName,
      routes: {
        SplashPage.routeName: (context) => SplashPage(),
        MainScreen.routeName: (context) => MainScreen(),
        DetailScreen.routeName: (context) => DetailScreen(
              data: ModalRoute.of(context)?.settings.arguments as Restaurant,
            ),
        SearchScreen.routeName: (context) => SearchScreen(
            nameRestaurant:
                ModalRoute.of(context)?.settings.arguments as String),
        SettingsPage.routeName: (context) => SettingsPage(),
        FavoritePage.routeName: (context) => FavoritePage(),
        DetailScreenFav.routeName: (context) => DetailScreenFav(
            data: ModalRoute.of(context)?.settings.arguments as Favorite),
      },
    );
  }
}
