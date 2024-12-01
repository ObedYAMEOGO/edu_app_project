import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/src/leaderboard/domain/entities/leaderboard_user.dart';
import 'package:flutter/material.dart';

class LeaderboardTile extends StatelessWidget {
  const LeaderboardTile(this.user, {required this.index, super.key});

  final LeaderboardUser user;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Styled index
          Container(
            width: 25, // Circle width
            height: 25, // Circle height
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colours.greenColour.withOpacity(0.8), // Background color
            ),
            alignment: Alignment.center,
            child: Text(
              index.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white, // Text color for contrast
              ),
            ),
          ),
          const SizedBox(width: 5), // Reduced spacing
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(6)
                  .copyWith(right: 12), // Reduced padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(90),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18, // Reduced radius
                        backgroundImage: NetworkImage(user.image),
                      ),
                      const SizedBox(width: 6), // Reduced spacing
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 12, // Reduced font size
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${user.points} pts',
                    style: const TextStyle(
                      fontSize: 16, // Reduced font size
                      fontWeight: FontWeight.w500,
                      color: Colours.successColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8), // Reduced spacing
        ],
      ),
    );
  }
}
