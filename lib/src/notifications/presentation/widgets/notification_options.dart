import 'package:edu_app_project/core/common/app/providers/notifications_notifier.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/src/notifications/presentation/cubit/notification_cubit.dart';
import 'package:edu_app_project/src/profile/presentation/widgets/popup_item.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class NotificationsOptions extends StatelessWidget {
  const NotificationsOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationNotifier = context.read<NotificationsNotifier>();
    return PopupMenuButton(
      offset: const Offset(0, 50),
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<void>(
          onTap: notificationNotifier.toggleMuteNotifications,
          child: PopupItem(
            title: notificationNotifier.muteNotifications
                ? 'Désactiver'
                : 'Activer',
            icon: Icon(
              notificationNotifier.muteNotifications
                  ? Icons.notifications_off
                  : Icons.notifications_on,
              color: Colours.secondaryColour,
            ),
          ),
        ),
        PopupMenuItem<void>(
          onTap: context.read<NotificationCubit>().clearAll,
          child: const PopupItem(
            title: 'Tout suppimer',
            icon: Icon(IconlyBold.delete, color: Colours.primaryColour),
          ),
        ),
      ],
    );
  }
}
