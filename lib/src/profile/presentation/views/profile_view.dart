import 'package:edu_app_project/core/common/app/providers/user_provider.dart';
import 'package:edu_app_project/core/enums/notification_enum.dart';
import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/services/injection_container.dart';
import 'package:edu_app_project/src/notifications/data/models/notification_model.dart';
import 'package:edu_app_project/src/notifications/presentation/cubit/notification_cubit.dart';
import 'package:edu_app_project/src/profile/presentation/refactor/profile_body.dart';
import 'package:edu_app_project/src/profile/presentation/refactor/profile_header.dart';
import 'package:edu_app_project/src/profile/presentation/widgets/profile_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, provider, __) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: ProfileAppBar(),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              ProfileHeader(),
              ProfileBody(),
            ],
          ),
          floatingActionButton: context.currentUser!.isAdmin
              ? FloatingActionButton(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  child: Icon(
                    Icons.notifications,
                    color: Color.fromARGB(255, 224, 148, 34),
                  ),
                  onPressed: () {
                    sl<NotificationCubit>().sendNotification(
                      NotificationModel.empty().copyWith(
                        title: 'Nouveau Message',
                        body: 'body',
                        category: NotificationCategory.NONE,
                      ),
                    );
                  },
                )
              : null, // No floatingActionButton if not admin
        );
      },
    );
  }
}
