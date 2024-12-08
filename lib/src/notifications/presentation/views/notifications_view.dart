import 'package:badges/badges.dart';
import 'package:edu_app_project/core/common/views/loading_view.dart';
import 'package:edu_app_project/core/common/widgets/nested_back_button.dart';
import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/services/injection_container.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/notifications/presentation/cubit/notification_cubit.dart';
import 'package:edu_app_project/src/notifications/presentation/widgets/no_notifications.dart';
import 'package:edu_app_project/src/notifications/presentation/widgets/notification_tile.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edu_app_project/src/notifications/presentation/widgets/notification_options.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Notifications',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colours.primaryColour),
        ),
        centerTitle: false,
        leading: NestedBackButton(),
        actions: [NotificationsOptions()],
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state is NotificationError) {
            Utils.showSnackBar(
              context,
              'Une erreur s\'est produite. Verifier votre connexion internet puis réessayer!',
              ContentType.failure,
              title: 'Oups',
            );
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is GettingNotifications || state is ClearingNotifications) {
            return const LoadingView();
          } else if (state is NotificationsLoaded &&
              state.notifications.isEmpty) {
            return const NoNotifications();
          } else if (state is NotificationsLoaded) {
            return ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (_, index) {
                final notification = state.notifications[index];
                return Badge(
                  showBadge: !notification.seen,
                  position: BadgePosition.topEnd(top: 30, end: 20),
                  child: BlocProvider(
                    create: (context) => sl<NotificationCubit>(),
                    child: NotificationTile(notification),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
