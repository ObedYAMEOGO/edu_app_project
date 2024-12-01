import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/src/chat/domain/entities/group.dart';
import 'package:edu_app_project/src/chat/presentation/app/cubit/chat_cubit.dart';
// import 'package:edu_app_project/src/subscription/presentation/views/subscription_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtherGroupTile extends StatelessWidget {
  const OtherGroupTile(this.group, {super.key});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: BorderSide(color: Colors.grey.shade300, width: 0.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(360),
              child: CircleAvatar(
                backgroundColor: Color(0xFFE4E6EA),
                child: group.groupImageUrl != null
                    ? Center(
                        child: Image.network(
                          group.groupImageUrl!,
                          fit: BoxFit.contain,
                          height: 32,
                          width: 32,
                        ),
                      )
                    : const Icon(Icons.group, size: 30, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                group.name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colours.primaryColour,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colours.primaryColour,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                // if (context.currentUser!.subscribed) {
                return context.read<ChatCubit>().joinGroup(
                      groupId: group.id,
                      userId: context.currentUser!.uid,
                    );
                // }
                // await Navigator.of(context)
                //     .pushNamed(SubscriptionScreen.routeName);
              },
              child: const Text(
                'Intégrer',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
