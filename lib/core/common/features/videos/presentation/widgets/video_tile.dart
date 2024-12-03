import 'dart:io';

import 'package:edu_app_project/core/common/features/videos/domain/entities/video.dart';
import 'package:edu_app_project/core/common/widgets/time_tile.dart';
import 'package:edu_app_project/core/extensions/string_extensions.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:edu_app_project/src/profile/presentation/utils/home_utils.dart';
import 'package:flutter/material.dart';

class VideoTile extends StatelessWidget {
  const VideoTile({
    required this.video,
    this.isYoutube = false,
    this.isFile = false,
    this.tappable = true,
    this.uploadTimePrefix = 'Ajouté ',
    super.key,
  });

  final Video video;
  final bool isYoutube;
  final bool isFile;
  final bool tappable;
  final String uploadTimePrefix;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 108,
      child: Row(
        children: [
          GestureDetector(
            onTap: tappable
                ? () => HomeUtils.playVideo(context, video.videoURL)
                : null,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 108,
                  width: 130,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: video.thumbnail == null
                          ? const AssetImage(Res.thumbnailPlaceholder)
                          : isFile
                              ? FileImage(File(video.thumbnail!))
                              : NetworkImage(video.thumbnail!) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                if (tappable)
                  Container(
                    height: 108,
                    width: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color:  Colors.black.withOpacity(0.4)
                    ),
                    child: Center(
                      child: video.videoURL.isYouTubeVideo
                          ? Image.asset(Res.youtube, height: 40)
                          : const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color.fromARGB(255, 246, 181, 2),
                        size: 14,
                      ),
                      const Icon(
                        Icons.star_rounded,
                        color: Color.fromARGB(255, 246, 181, 2),
                        size: 14,
                      ),
                      const Icon(
                        Icons.star_rounded,
                        color: Color.fromARGB(255, 246, 181, 2),
                        size: 14,
                      ),
                      const Icon(
                        Icons.star_rounded,
                        color: Color.fromARGB(255, 246, 181, 2),
                        size: 14,
                      ),
                      // Text(
                      //   video.rating.toString(),
                      //   style: const TextStyle(
                      //     fontSize: 12,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    video.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Auteur: ${video.tutor}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colours.secondaryColour,
                    ),
                  ),
                ),
                // TODO(REPLACE): Replace with upload date
                Flexible(
                  child: TimeTile(
                    video.uploadDate,
                    prefixText: uploadTimePrefix,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
