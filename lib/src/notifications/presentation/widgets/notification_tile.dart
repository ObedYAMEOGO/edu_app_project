import 'package:edu_app_project/core/res/fonts.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:edu_app_project/core/common/widgets/time_text.dart';
import 'package:edu_app_project/core/extensions/enum_extensions.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/src/notifications/domain/entities/notification.dart';
import 'package:edu_app_project/src/notifications/presentation/cubit/notification_cubit.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile(this.notification, {super.key});

  final Notification notification;

  @override
  Widget build(BuildContext context) {
    if (!notification.seen) {
      context.read<NotificationCubit>().markAsRead(notification.id);
    }

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(),
      onDismissed: (_) {
        context.read<NotificationCubit>().clear(notification.id);
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 16),
        leading: _buildAvatar(notification.category.image),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colours.darkColour,
            fontFamily: Fonts.inter,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Text(
                notification.body, // Affiche le contenu de la notification
                style: TextStyle(
                  fontSize: 11,
                  color: Colours.darkColour.withOpacity(0.8),
                  fontFamily: Fonts.inter,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: TimeText(notification.sentAt),
                ),
              ],
            ), // Affiche l'heure
          ],
        ),
      ),
    );
  }

  /// Construction de l'avatar avec des dimensions personnalisées
  Widget _buildAvatar(String imagePath) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Center(
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// Construit l'arrière-plan de suppression pour le glissement
  Widget _buildDismissBackground() {
    return Container(
      color: Colours.pinkColour,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 16),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }
}
