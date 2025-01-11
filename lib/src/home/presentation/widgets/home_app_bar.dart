import 'package:edu_app_project/core/common/app/providers/user_provider.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:edu_app_project/src/home/presentation/widgets/notification_bell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background layer with gradient and opacity
        Container(
          decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   colors: Colours.gradient²
              //       .map((color) => color.withOpacity(0.5))
              //       .toList(),
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              // ),
              ),
        ),
        // Transparent AppBar to show the gradient background
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            "Mes Cours",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              fontFamily: Fonts.merriweather,
              color: Colours.darkColour,
            ),
          ),
          actions: [
            NotificationBell(),
            Consumer<UserProvider>(builder: (_, provider, __) {
              return Padding(
                  padding: EdgeInsets.only(right: 20, left: 20),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: provider.user!.profilePic != null
                        ? NetworkImage(provider.user!.profilePic!)
                        : const AssetImage(Res.user) as ImageProvider,
                  ));
            })
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
