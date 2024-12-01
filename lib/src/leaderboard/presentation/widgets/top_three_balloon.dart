// import 'package:edu_app_project/core/res/colours.dart';
// import 'package:edu_app_project/core/res/media_res.dart';
// import 'package:flutter/material.dart';

// class TopThreeBalloon extends StatelessWidget {
//   const TopThreeBalloon.first({
//     required this.userName,
//     required this.userImage,
//     required this.points,
//     super.key,
//   })  : radius = 50,
//         position = 1;

//   const TopThreeBalloon.second({
//     required this.userName,
//     required this.userImage,
//     required this.points,
//     super.key,
//   })  : radius = 40,
//         position = 2;

//   const TopThreeBalloon.third({
//     required this.userName,
//     required this.userImage,
//     required this.points,
//     super.key,
//   })  : radius = 30, // Réduction
//         position = 3;

//   final double radius;
//   final int position;
//   final String userName;
//   final String userImage;
//   final int points;

//   String get image => position == 1
//       ? Res.goldCrown
//       : position == 2
//           ? Res.silverMedal
//           : Res.bronzeMedal;

//   Size get imageSize => position == 1 ? const Size(50, 33) : const Size(40, 40);

//   double get baseline => position == 1 ? 0 : 100;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 2.0),
//       child: Baseline(
//         baselineType: TextBaseline.alphabetic,
//         baseline: baseline,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Center(
//               child: Container(
//                 width: 25, // Width of the circle
//                 height: 25, // Height of the circle
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colours.greenColour
//                       .withOpacity(0.9), // Circle background color
//                 ),
              
//                 alignment: Alignment.center,
//                 child: Text(
//                   position.toString(),
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 5,
//             ),
//             Image.asset(image,
//                 height: imageSize.height, width: imageSize.width),
//             const SizedBox(
//               height: 10,
//             ),
//             CircleAvatar(
//               radius: 30,
//               backgroundColor: Colors.white,
//               child: CircleAvatar(
//                 radius: radius - 2,
//                 backgroundImage: NetworkImage(userImage),
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Text(
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               userName,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.white,
//               ),
//             ),
//             Text(
//               '${points} pts',
//               style: const TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w500,
//                 color: Colours.greenColour,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
