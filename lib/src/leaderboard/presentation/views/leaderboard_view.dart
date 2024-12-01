// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:dartz/dartz.dart' as dz;
// import 'package:edu_app_project/core/common/widgets/gradient_background.dart';
// import 'package:edu_app_project/core/res/colours.dart';
// import 'package:edu_app_project/core/utils/core_utils.dart';
// import 'package:edu_app_project/src/leaderboard/domain/entities/leaderboard_user.dart';
// import 'package:edu_app_project/src/leaderboard/presentation/cubit/leaderboard_cubit.dart';
// import 'package:edu_app_project/src/leaderboard/presentation/views/empty_leaderboard_view.dart';
// import 'package:edu_app_project/src/leaderboard/presentation/widgets/leaderboard_tile.dart';
// import 'package:edu_app_project/src/leaderboard/presentation/widgets/top_three_balloon.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class LeaderboardView extends StatefulWidget {
//   const LeaderboardView({super.key});

//   @override
//   State<LeaderboardView> createState() => _LeaderboardViewState();
// }

// class _LeaderboardViewState extends State<LeaderboardView> {
//   late Stream<dz.Either<LeaderboardError, List<LeaderboardUser>>>
//       leaderboardStream;

//   void showSnackBar(String message) {
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       Utils.showSnackBar(context, message, ContentType.success);
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     leaderboardStream = context.read<LeaderboardCubit>().getLeaderboard();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: Colours.primaryColour,
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text(
//           'Meilleur Apprenant',
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//             fontSize: screenWidth * 0.04, // 8% of screen width
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: StreamBuilder<dz.Either<LeaderboardError, List<LeaderboardUser>>>(
//         stream: leaderboardStream,
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             showSnackBar(snapshot.error.toString());
//           } else if (snapshot.hasData && snapshot.data!.isLeft()) {
//             showSnackBar(
//               (snapshot.data!
//                       as dz.Left<LeaderboardError, List<LeaderboardUser>>)
//                   .value
//                   .message,
//             );
//           }
//           final users = snapshot.data?.getOrElse(() => const []);

//           return GradientBackground(
//             image: '',
//             child: users == null
//                 ? const EmptyLeaderboardView()
//                 : SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Column(
//                         children: [
//                           Builder(
//                             builder: (context) {
//                               final firstThreeUsers = users.take(3).toList();
//                               return Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   if (firstThreeUsers.length > 1)
//                                     Flexible(
//                                       child: TopThreeBalloon.second(
//                                         userName: users[1].name,
//                                         userImage: users[1].image,
//                                         points: users[1].points,
//                                       ),
//                                     ),
//                                   Flexible(
//                                     child: TopThreeBalloon.first(
//                                       userName: users.first.name,
//                                       userImage: users.first.image,
//                                       points: users.first.points,
//                                     ),
//                                   ),
//                                   if (firstThreeUsers.length > 2)
//                                     Flexible(
//                                       child: TopThreeBalloon.third(
//                                         userName: users[2].name,
//                                         userImage: users[2].image,
//                                         points: users[2].points,
//                                       ),
//                                     ),
//                                 ],
//                               );
//                             },
//                           ),
//                           SizedBox(height: screenHeight * 0.02), // 2% of height
//                           if (users.length > 3)
//                             ListView.builder(
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemCount: users.length - 3,
//                               itemBuilder: (_, index) {
//                                 final user = users.sublist(3)[index];
//                                 return LeaderboardTile(user, index: index + 4);
//                               },
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//           );
//         },
//       ),
//     );
//   }
// }
