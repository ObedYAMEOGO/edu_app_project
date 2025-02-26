import 'dart:async';
import 'dart:io';
import 'package:edu_app_project/core/common/features/videos/data/models/video_model.dart';
import 'package:edu_app_project/core/common/features/videos/domain/entities/video.dart';
import 'package:edu_app_project/core/common/views/custom_circular_progress_bar.dart';
import 'package:edu_app_project/core/enums/notification_enum.dart';
import 'package:edu_app_project/core/extensions/string_extensions.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/src/notifications/data/models/notification_model.dart';
import 'package:edu_app_project/src/notifications/presentation/cubit/notification_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_metadata/youtube.dart';

class Utils {
  const Utils();

  static void showSnackBar(
    BuildContext context,
    String message,
    ContentType contentType, {
    String? title,
  }) {
    final IconData icon = _getIcon(contentType);
    final Color iconColor = _getIconColor(contentType);
    final Color backgroundColor = Colors.white;
    const Color textColor = Colours.darkColour;

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? _getTitle(contentType),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: Fonts.inter,
                        color: textColor,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: const TextStyle(
                        color: textColor,
                        fontFamily: Fonts.inter,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: backgroundColor,
          elevation: 0.2,
          dismissDirection: DismissDirection.startToEnd,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
              side: BorderSide(color: Colours.chatFieldColour)),
        ),
      );
  }

  static IconData _getIcon(ContentType contentType) {
    switch (contentType) {
      case ContentType.success:
        return Icons.check_circle;
      case ContentType.warning:
        return Icons.warning_amber_rounded;
      case ContentType.failure:
        return Icons.error;
      case ContentType.help:
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  static Color _getIconColor(ContentType contentType) {
    switch (contentType) {
      case ContentType.success:
        return Colors.green;
      case ContentType.warning:
        return Colors.orange;
      case ContentType.failure:
        return Colors.red;
      case ContentType.help:
        return Colors.blue;
      default:
        return Colours.primaryColour;
    }
  }

  static String _getTitle(ContentType contentType) {
    switch (contentType) {
      case ContentType.success:
        return 'Succès!';
      case ContentType.warning:
        return 'Attention!';
      case ContentType.failure:
        return 'Erreur!';
      case ContentType.help:
        return 'Info';
      default:
        return 'Notification';
    }
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => const Center(
        child: CustomCircularProgressBarIndicator(),
      ),
    );
  }

  static Future<Video?> getVideoFromYT(BuildContext context, String url) async {
    try {
      final metaData = await YoutubeMetaData.getData(url);

      debugPrint('Titre : ${metaData.title}');
      debugPrint('Auteur : ${metaData.authorName}');
      debugPrint('URL de l\'auteur : ${metaData.authorUrl}');
      debugPrint('Type : ${metaData.type}');
      debugPrint('Hauteur : ${metaData.height}');
      debugPrint('Largeur : ${metaData.width}');
      debugPrint('Version : ${metaData.version}');
      debugPrint('Nom du fournisseur : ${metaData.providerName}');
      debugPrint('URL du fournisseur : ${metaData.providerUrl}');
      debugPrint('Hauteur de la miniature : ${metaData.thumbnailHeight}');
      debugPrint('Largeur de la miniature : ${metaData.thumbnailWidth}');
      debugPrint('URL de la miniature : ${metaData.thumbnailUrl}');
      debugPrint('HTML : ${metaData.html}');
      debugPrint('URL : ${metaData.url}');
      debugPrint('Description : ${metaData.description}');

      if (metaData.thumbnailUrl == null ||
          metaData.title == null ||
          metaData.authorName == null) {
        final message =
            'Impossible de récupérer les données de la vidéo. Veuillez réessayer.\n'
            'Les données manquantes sont : ${metaData.thumbnailUrl == null ? 'miniature' : metaData.title == null ? 'titre' : 'nom de l\'auteur'}.';
        throw Exception(message);
      }

      return VideoModel.empty().copyWith(
        thumbnail: metaData.thumbnailUrl,
        videoURL: url,
        title: metaData.title,
        tutor: metaData.authorName,
      );
    } catch (e) {
      Utils.showSnackBar(
          context,
          'Une erreur s\'est produite lors de la récupération des données. Veuillez réessayer.\nErreur : $e',
          ContentType.failure,
          title: 'Erreur');
    }
    return null;
  }

  static Future<bool?> showConfirmationDialog(
    BuildContext context, {
    String? text,
    String? title,
    String? content,
    String? actionText,
    String? cancelText,
    Color? actionColor,
    Color? cancelColor,
  }) async {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            title ?? text!,
            style: TextStyle(color: Colours.primaryColour),
          ),
          content: Text(
            content ?? 'Êtes-vous sûr de vouloir $text ?',
            style: TextStyle(
              color: Colours.darkColour,

              fontFamily: Fonts.inter, // Texte légèrement plus clair
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context, false); // Return false if cancelled
              },
              child: Text(
                'Annuler',
                style: TextStyle(
                  color: Colours.darkColour,

                  fontFamily: Fonts.inter, // Texte légèrement plus clair
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context, true); // Return true if confirmed
              },
              child: Text(
                actionText ?? text!.split(' ')[0].trim().titleCase,
                style: TextStyle(color: Colours.redColour),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<File?> pickCustomFile({
    List<String>? allowedExtensions,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      // The difference between FileType.any and FileType.custom is that
      // FileType.any will allow you to pick any file type
      // while FileType.custom will only allow you to pick the file types you
      // specify in the allowedExtensions parameter
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );
    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  static void sendNotification(
    BuildContext context, {
    required String title,
    required String body,
    required NotificationCategory category,
  }) {
    context.read<NotificationCubit>().sendNotification(
          NotificationModel.empty().copyWith(
            title: title,
            body: body,
            category: category,
          ),
        );
  }
}

enum ContentType { success, warning, failure, help }
