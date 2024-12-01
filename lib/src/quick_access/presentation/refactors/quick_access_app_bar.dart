import 'package:edu_app_project/core/common/app/providers/user_provider.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuickAccessAppBar extends StatelessWidget implements PreferredSizeWidget {
  const QuickAccessAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: const Text(
        'Documents',
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colours.primaryColour),
      ),
      actions: [
        Consumer<UserProvider>(builder: (_, provider, __) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 24,
              backgroundImage: provider.user!.profilePic != null
                  ? NetworkImage(provider.user!.profilePic!)
                  : const AssetImage(Res.user) as ImageProvider,
            ),
          );
        }),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
