import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_apps/utils/notification_helper.dart';
import 'package:restaurant_apps/provider/scheduling_provider.dart';
import 'package:restaurant_apps/ui/detail_screen.dart';

class SettingsPage extends StatefulWidget {
  static const String settingsTitle = 'Settings';
  static const routeName = '/settings_page';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SettingsPage.settingsTitle),
      ),
      body: ChangeNotifierProvider<SchedulingProvider>(
        create: (_) => SchedulingProvider(),
        child: _buildList(context),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(DetailScreen.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  Widget _buildList(BuildContext context) {
    return ListView(
      children: [
        Material(
          child: ListTile(
            title: Text('Rekomendasi Reminder'),
            trailing: Consumer<SchedulingProvider>(
              builder: (context, scheduled, _) {
                return Switch.adaptive(
                  value: scheduled.isScheduled,
                  onChanged: (value) async {
                    if (scheduled.isScheduled == false) {
                      scheduled.scheduledNews(true);
                    } else {
                      scheduled.scheduledNews(false);
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
