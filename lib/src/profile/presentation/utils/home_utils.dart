import 'package:edu_app_project/src/home/presentation/views/video_player_view.dart';
import 'package:edu_app_project/core/extensions/string_extensions.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeUtils {
  static Future<void> playVideo(BuildContext context, String videoURL) async {
    if (!videoURL.isYouTubeVideo) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerView(videoURL: videoURL),
        ),
      );
    } else {
      final uri = Uri.tryParse(videoURL);
      if (uri == null || !uri.hasAbsolutePath) {
        Utils.showSnackBar(
          context,
          'URL YouTube invalide : $videoURL',
          ContentType.failure,
          title: 'Erreur!',
        );
        return;
      }

      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        Utils.showSnackBar(
          context,
          'Impossible de lire $videoURL',
          ContentType.failure,
          title: 'Oups!',
        );
      }
    }
  }
}
