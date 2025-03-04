const kDefaultImage =
    "https://firebasestorage.googleapis.com/v0/b/education-app-f3e01.appspot.com/o/docs.png?alt=media&token=8cb67eb7-1ae6-4ed2-8208-cce2dc4e7c8d";

const kAdmins = [
  'obedyameogo4@gmail.com',
  'kofrathur@gmail.com',
  "danielborishounouvi@gmail.com",
  "eruditio.contacts@gmail.com"
];

const kDefaultAvatar =
    'https://firebasestorage.googleapis.com/v0/b/education-app-f3e01.appspot.com/o/user.png?alt=media&token=3da99e97-56a7-4559-99f0-397ab3493d38';




// import 'dart:ui';

// import 'package:edu_app_project/core/common/features/videos/domain/entities/video.dart';
// import 'package:edu_app_project/core/res/colours.dart';
// import 'package:edu_app_project/core/res/media_res.dart';
// import 'package:edu_app_project/src/leaderboard/domain/entities/leaderboard_user.dart';

// const List<(String name, String imagePath, Color colour)> kSubjects = [
//   ('Physics', Res.physicsIcon, Colours.physicsTileColour),
//   ('Science', Res.scienceIcon, Colours.scienceTileColour),
//   ('Chemistry', Res.chemistryIcon, Colours.chemistryTileColour),
//   ('Biology', Res.biologyIcon, Colours.biologyTileColour),
//   ('Math', Res.mathIcon, Colours.mathTileColour),
//   ('Language', Res.languageIcon, Colours.languageTileColour),
//   ('Literature', Res.literatureIcon, Colours.literatureTileColour),
// ];

// const List<LeaderboardUser> kTempLeaderboardUsers = [
//   LeaderboardUser(
//     name: 'Sanderly',
//     userId: 'userId',
//     points: 90,
//     image: kDefaultImage,
//   ),
//   LeaderboardUser(
//     name: 'Cris Jeny',
//     userId: 'userId',
//     points: 88,
//     image: kDefaultImage,
//   ),
//   LeaderboardUser(
//     name: 'Deviyani',
//     userId: 'userId',
//     points: 100,
//     image: kDefaultImage,
//   ),
//   LeaderboardUser(
//     name: 'Daud Tros',
//     userId: 'userId',
//     points: 85,
//     image: kDefaultImage,
//   ),
//   LeaderboardUser(
//     name: 'Miami dondo',
//     userId: 'userId',
//     points: 80,
//     image: kDefaultImage,
//   ),
//   LeaderboardUser(
//     name: 'Roberter',
//     userId: 'userId',
//     points: 96,
//     image: kDefaultImage,
//   ),
//   LeaderboardUser(
//     name: 'Julian Fox',
//     userId: 'userId',
//     points: 86,
//     image: kDefaultImage,
//   ),
//   LeaderboardUser(
//     name: 'Jacobaa',
//     userId: 'userId',
//     points: 98,
//     image: kDefaultImage,
//   ),
//   LeaderboardUser(
//     name: 'John Klink',
//     userId: 'userId',
//     points: 77,
//     image: kDefaultImage,
//   ),
//   LeaderboardUser(
//     name: 'Danielle Fox',
//     userId: 'userId',
//     points: 77,
//     image: kDefaultImage,
//   ),
// ];


// final List<Video> kVideos = [
//   Video(
//     thumbnail: 'https://i.ytimg.com/vi/4AoFA19gbLo/hqdefault.jpg',
//     videoURL: 'https://www.youtube.com/watch?v=4AoFA19gbLo',
//     title: 'Welcome to Flutter',
//     tutor: 'Flutter',
//     courseId: 'courseId',
//     id: 'id',
//     uploadDate: DateTime.now(),
//   ),
//   Video(
//     thumbnail: 'https://i.ytimg.com/vi/HQT8ABlgsq0/hqdefault.jpg',
//     videoURL: 'https://www.youtube.com/watch?v=HQT8ABlgsq0&list='
//         'PLjxrf2q8roU1523hIgnNX4r6ukX72QYLg&index=12',
//     title: 'How to build next-gen UIs in Flutter',
//     tutor: 'Flutter',
//     courseId: 'courseId',
//     id: 'id',
//     uploadDate: DateTime.now().subtract(
//       const Duration(hours: 1),
//     ),
//   ),
//   Video(
//     thumbnail: 'https://i.ytimg.com/vi/8sAyPDLorek/hqdefault.jpg',
//     videoURL: 'https://www.youtube.com/watch?v=8sAyPDLorek',
//     title: 'Building your first Flutter App - with a Codelab!',
//     tutor: 'Flutter',
//     courseId: 'courseId',
//     id: 'id',
//     uploadDate: DateTime.now().subtract(
//       const Duration(hours: 2),
//     ),
//   ),
//   Video(
//     thumbnail: 'https://i.ytimg.com/vi/6SaCntGgi5o/hqdefault.jpg',
//     videoURL: 'https://www.youtube.com/watch?v=6SaCntGgi5o',
//     title: 'Flutter App Using Sqlite & Sqflite CRUD With Local Scheduled '
//         'Notifications | GetX Listview | Part 2',
//     tutor: 'dbestech',
//     courseId: 'courseId',
//     id: 'id',
//     uploadDate: DateTime.now().subtract(
//       const Duration(minutes: 30),
//     ),
//   ),
//   Video(
//     id: 'id',
//     videoURL:
//         'https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4',
//     title: 'Spinning around the earth',
//     tutor: 'mixkit.co',
//     uploadDate: DateTime.now().subtract(
//       const Duration(minutes: 30),
//     ),
//     courseId: 'courseId',
//   ),
//   Video(
//     id: 'id',
//     videoURL:
//         'https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4',
//     title: 'Daytime city traffic aerial view',
//     tutor: 'mixkit.co',
//     uploadDate: DateTime.now().subtract(
//       const Duration(minutes: 30),
//     ),
//     courseId: 'courseId',
//   ),
//   Video(
//     id: 'id',
//     videoURL:
//         'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4',
//     title: 'Blowing a bubble gum at an amusement park',
//     tutor: 'mixkit.co',
//     uploadDate: DateTime.now().subtract(
//       const Duration(minutes: 30),
//     ),
//     courseId: 'courseId',
//   ),
// ];
