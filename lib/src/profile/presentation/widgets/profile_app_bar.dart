import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/services/injection_container.dart';
import 'package:edu_app_project/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:edu_app_project/src/profile/presentation/views/edit_profile_view.dart';
import 'package:edu_app_project/src/profile/presentation/widgets/popup_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(),
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            "Mon Profil",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colours.primaryColour),
          ),
          actions: [
            PopupMenuButton(
              offset: Offset(0, 60),
              icon: Icon(Icons.more_horiz_outlined),
              itemBuilder: (_) => [
                PopupMenuItem<void>(
                  child: PopupItem(
                    title: 'Modifier',
                    icon: Icon(
                      Icons.edit_outlined,
                      color: Colours.primaryColour,
                      size: 15,
                    ),
                  ),
                  onTap: () => context.push(BlocProvider(
                    create: (_) => sl<AuthBloc>(),
                    child: const EditProfileView(),
                  )),
                ),
                PopupMenuItem<void>(
                    height: 1,
                    padding: EdgeInsets.zero,
                    child: Divider(
                      height: .0,
                      color: Colors.grey.shade100,
                      endIndent: 0,
                      indent: 0,
                    )),
                PopupMenuItem<void>(
                  child: PopupItem(
                    title: 'Notifications',
                    icon: Icon(
                      Icons.notification_add_rounded,
                      size: 15,
                      color: Colors.red,
                    ),
                  ),
                ),
                PopupMenuItem<void>(
                    height: 1,
                    padding: EdgeInsets.zero,
                    child: Divider(
                      height: .0,
                      color: Colors.grey.shade100,
                      endIndent: 0,
                      indent: 0,
                    )),
                PopupMenuItem<void>(
                  child: PopupItem(
                    title: 'Aide',
                    icon: Icon(
                      IconlyBroken.info_circle,
                      size: 15,
                    ),
                  ),
                ),
                PopupMenuItem<void>(
                    height: 1,
                    padding: EdgeInsets.zero,
                    child: Divider(
                      height: .0,
                      color: Colors.grey.shade100,
                      endIndent: 0,
                      indent: 0,
                    )),
                PopupMenuItem<void>(
                  child: PopupItem(
                    title: 'Déconnexion',
                    icon: Icon(
                      IconlyBroken.logout,
                      size: 15,
                    ),
                  ),
                  onTap: () async {
                    final navigator = Navigator.of(context);
                    navigator.pushNamedAndRemoveUntil(
                        '/sign-in', (route) => false);

                    // Déconnecter l'utilisateur après avoir démarré la navigation
                    await FirebaseAuth.instance.signOut();
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
