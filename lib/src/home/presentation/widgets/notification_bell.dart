import 'package:audioplayers/audioplayers.dart';
import 'package:badges/badges.dart';
import 'package:edu_app_project/core/common/app/providers/notifications_notifier.dart';
import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/services/injection_container.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/notifications/presentation/cubit/notification_cubit.dart';
import 'package:edu_app_project/src/notifications/presentation/views/notifications_view.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBell extends StatefulWidget {
  const NotificationBell({super.key});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  final newNotificationListenable = ValueNotifier<bool>(false);
  int? notificationCount;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().getNotifications();
    newNotificationListenable.addListener(() {
      if (newNotificationListenable.value) {
        if (!context.read<NotificationsNotifier>().muteNotifications) {
          player.play(AssetSource('sounds/notification.mp3'));
        }
        newNotificationListenable.value = false;
      }
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationCubit, NotificationState>(
      listener: (_, state) {
        if (state is NotificationsLoaded) {
          if (notificationCount != null) {
            if (notificationCount! < state.notifications.length) {
              newNotificationListenable.value = true;
            }
          }
          notificationCount = state.notifications.length;
        } else if (state is NotificationError) {
          Utils.showSnackBar(
              context,
              'Une erreur s\'est produite. Verifiez vos informations et réessayer!',
              ContentType.failure,
              title: 'Oups!');
        }
      },
      builder: (context, state) {
        if (state is NotificationsLoaded) {
          final unseenNotificationsLength = state.notifications
              .where((notification) => !notification.seen)
              .length;
          final showBadge = unseenNotificationsLength > 0;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                print("Icon tapped");
                context.push(
                  BlocProvider(
                    create: (_) => sl<NotificationCubit>(),
                    child: const NotificationsView(),
                  ),
                );
              },
              child: Badge(
                showBadge: showBadge,
                position: BadgePosition.topEnd(end: -1),
                badgeStyle: BadgeStyle(
                  badgeColor: Colours.pinkColour,
                  elevation: 3, // Adds depth to badge
                  borderSide: BorderSide(
                      color: Colors.white, width: 1), // Subtle border
                ),
                badgeAnimation: BadgeAnimation.slide(
                  // Use `slide` instead of unnamed constructor
                  animationDuration: Duration(milliseconds: 600),
                  curve: Curves.easeOutBack, // Smooth bounce effect
                ),
                badgeContent: Text(
                  unseenNotificationsLength.toString(),
                  style: const TextStyle(
                    fontFamily: Fonts.inter,
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold, // Make it more readable
                  ),
                ),
                child: Icon(
                  Icons.notifications,
                  color: const Color.fromARGB(255, 250, 219, 106),
                  size: 26, // Slightly larger for balance
                ),
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: const Icon(Icons.notifications_outlined,
              color: Colours.iconColor),
        );
      },
    );
  }
}
