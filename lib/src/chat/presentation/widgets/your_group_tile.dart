import 'package:edu_app_project/core/common/app/providers/tab_navigator.dart';
import 'package:edu_app_project/core/services/injection_container.dart';
import 'package:edu_app_project/src/chat/domain/entities/group.dart';
import 'package:edu_app_project/src/chat/presentation/app/cubit/chat_cubit.dart';
import 'package:edu_app_project/src/chat/presentation/app/providers/chat_controller.dart';
import 'package:edu_app_project/src/chat/presentation/views/group_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class YourGroupTile extends StatelessWidget {
  const YourGroupTile(this.group, {super.key});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // Card blanc
// Pas de marge horizontale
      elevation: 0, // Pas d'ombre
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0), // Pas arrondi
        side: BorderSide(
          color: Color(0xFFE4E6EA),
        ), // Bord très fin gris
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
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
                        ),
                      )
                    : const Icon(Icons.group, size: 30, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black, // Texte noir
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  group.lastMessage != null
                      ? Text(
                          '~ ${group.lastMessageSenderName}: ${group.lastMessage}',
                          style: TextStyle(
                            color:
                                Colors.black54, // Texte légèrement plus clair
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          'Pas encore de message',
                          style: TextStyle(
                            color:
                                Colors.black54, // Texte légèrement plus clair
                            fontSize: 12,
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            group.lastMessageTimestamp != null
                ? Text(
                    '${group.lastMessageTimestamp}', // Affiche l'heure du dernier message
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 8,
                    ),
                  )
                : const Icon(
                    Icons.fiber_new,
                    color: Colors.black,
                    size: 20,
                  ),
          ],
        ),
        onTap: () {
          context.read<TabNavigator>().push(
                TabItem(
                  child: ChangeNotifierProvider(
                    create: (_) => sl<ChatController>(),
                    child: BlocProvider(
                      create: (_) => sl<ChatCubit>(),
                      child: GroupChatView(group: group),
                    ),
                  ),
                ),
              );
        },
      ),
    );
  }
}
