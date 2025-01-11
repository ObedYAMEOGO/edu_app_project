import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/services/injection_container.dart';
import 'package:edu_app_project/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:edu_app_project/src/profile/presentation/views/edit_profile_view.dart';
import 'package:edu_app_project/src/profile/presentation/widgets/popup_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // AppBar with transparent background
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            "Mon Profil",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: Fonts.merriweather,
              fontSize: 17,
              color: Colours.darkColour,
            ),
          ),
          actions: [
            PopupMenuButton(
              offset: Offset(0, 60),
              icon: const Icon(Icons.more_horiz_outlined),
              itemBuilder: (_) => [
                // Edit Profile Menu Item
                PopupMenuItem<void>(
                  child: PopupItem(
                    title: 'Modifier',
                    icon: Icon(
                      Icons.edit_outlined,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ),
                  onTap: () => context.push(
                    BlocProvider(
                      create: (_) => sl<AuthBloc>(),
                      child: const EditProfileView(),
                    ),
                  ),
                ),
                // Divider between sections
                const PopupMenuItem<void>(
                  height: 1,
                  padding: EdgeInsets.zero,
                  child: Divider(
                    height: 0,
                    color: Colors.grey,
                    indent: 0,
                    endIndent: 0,
                  ),
                ),
                // Notifications Menu Item
                PopupMenuItem<void>(
                  child: PopupItem(
                    title: 'Notifications',
                    icon: Icon(
                      Icons.notification_add_rounded,
                      size: 15,
                      color: Colors.grey,
                    ),
                  ),
                ),
                // Divider
                const PopupMenuItem<void>(
                  height: 1,
                  padding: EdgeInsets.zero,
                  child: Divider(
                    height: 0,
                    color: Colors.grey,
                    indent: 0,
                    endIndent: 0,
                  ),
                ),
                // Help Menu Item
                PopupMenuItem<void>(
                  child: PopupItem(
                    title: 'Aide',
                    icon: const Icon(
                      IconlyBroken.info_circle,
                      size: 15,
                    ),
                  ),
                ),
                // Divider
                const PopupMenuItem<void>(
                  height: 1,
                  padding: EdgeInsets.zero,
                  child: Divider(
                    height: 0,
                    color: Colors.grey,
                    indent: 0,
                    endIndent: 0,
                  ),
                ),
                PopupMenuItem<void>(
                  child: PopupItem(
                    title: 'Déconnexion',
                    icon: const Icon(
                      IconlyBroken.logout,
                      size: 15,
                    ),
                  ),
                  onTap: () async {
                    try {
                      context.read<AuthBloc>().add(SignOutEvent());

                      final navigator = Navigator.of(context);
                      navigator.pushNamedAndRemoveUntil(
                          '/sign-in', (route) => false);
                    } catch (e) {
                      print('Erreur lors de la déconnexion: $e');
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
