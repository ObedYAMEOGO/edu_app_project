import 'package:edu_app_project/core/common/app/providers/user_provider.dart';
import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, provider, __) {
        final user = provider.user;
        final image = user?.profilePic == null || user!.profilePic!.isEmpty
            ? null
            : user.profilePic;
        return Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            CircleAvatar(
                radius: 50,
                backgroundImage: image != null
                    ? NetworkImage(image)
                    : Image.network(kDefaultAvatar) as ImageProvider),
            const SizedBox(
              height: 16,
            ),
            Text(
              user?.fullName ?? 'Pas d\'utilisateur',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            if (user?.bio != null && user!.bio!.isNotEmpty) ...[
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.width * .15,
                ),
                child: Text(
                  user.bio!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: Fonts.montserrat,
                      color: Colours.secondaryColour),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ],
        );
      },
    );
  }
}
