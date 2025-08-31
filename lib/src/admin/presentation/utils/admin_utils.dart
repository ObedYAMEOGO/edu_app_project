import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:edu_app_project/core/common/features/videos/data/models/video_model.dart';
import 'package:edu_app_project/core/common/features/videos/domain/entities/video.dart';

class AdminUtils {
  const AdminUtils._();

  static Future<File?> getThumbnailFromUrl(String url) async {
    return _generateThumbnail(videoPath: url);
  }

  static Future<File?> getThumbnailFromFile(File file) async {
    return _generateThumbnail(videoPath: file.path);
  }

  static Future<Video?> pickVideo() async {
    final picker = ImagePicker();
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      final video = File(pickedVideo.path);
      final thumbnail = await getThumbnailFromFile(video);
      return VideoModel.empty().copyWith(
        thumbnail: thumbnail?.path,
        videoURL: video.path,
        title: 'Sans Titre', // Default title
      );
    }
    return null;
  }

  static Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  }

  static Future<File?> _generateThumbnail({required String videoPath}) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final thumbnailPath =
          '${tempDir.path}/thumb_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final command = "-i $videoPath -ss 00:00:01 -vframes 1 $thumbnailPath";
      await FFmpegKit.execute(command);

      final thumbnailFile = File(thumbnailPath);
      if (await thumbnailFile.exists()) {
        return thumbnailFile;
      }
    } catch (e) {
      print("Une erreur s'est produite: $e");
    }
    return null;
  }
}
