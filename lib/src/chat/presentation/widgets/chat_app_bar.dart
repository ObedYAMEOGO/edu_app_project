import 'package:edu_app_project/core/common/widgets/nested_back_button.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/chat/domain/entities/group.dart';
import 'package:edu_app_project/src/chat/presentation/app/cubit/chat_cubit.dart';
import 'package:edu_app_project/src/profile/presentation/widgets/popup_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ChatAppBar({
    required this.group,
    super.key,
  });

  final Group group;

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ChatAppBarState extends State<ChatAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0,
      leading: NestedBackButton(),
      backgroundColor: Colors.white,
      title: Row(
        children: [
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              widget.group.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                fontFamily: Fonts.merriweather, // Texte légèrement plus clair

                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
      foregroundColor: Colours.darkColour,
      actions: [
        PopupMenuButton(
          offset: const Offset(0, 60),
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          itemBuilder: (context) => [
            PopupMenuItem<void>(
              child: const PopupItem(
                title: 'Quitter',
                icon: Icon(
                  IconlyBroken.logout,
                  color: Colors.red,
                ),
              ),
              onTap: () async {
                final chatCubit = context.read<ChatCubit>();
                await Future<void>.delayed(
                  const Duration(
                    milliseconds: 200,
                  ),
                );
                if (!mounted) return;
                final result = await Utils.showConfirmationDialog(
                  context,
                  text: 'Quitter le groupe',
                );
                if (result ?? false) {
                  await chatCubit.leaveGroup(
                    groupId: widget.group.id,
                    userId: FirebaseAuth.instance.currentUser!.uid,
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
