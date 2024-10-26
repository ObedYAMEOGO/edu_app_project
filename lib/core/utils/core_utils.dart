import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class Utils {
  const Utils();

  static void showSnackBar(
      BuildContext context, String message, ContentType contentType) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: AwesomeSnackbarContent(
            title: _getTitle(contentType),
            message: message,
            messageTextStyle: const TextStyle(
              fontSize: 12,
            ),
            contentType: contentType,
            inMaterialBanner: true,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0, // Enlève l'effet d'ombre
          dismissDirection:
              DismissDirection.horizontal, // Permet de glisser pour fermer
        ),
      );
  }

  // Fonction privée pour retourner un titre basé sur le ContentType
  static String _getTitle(ContentType contentType) {
    switch (contentType) {
      case ContentType.success:
        return 'Success!';
      case ContentType.warning:
        return 'Warning!';
      case ContentType.failure:
        return 'Error!';
      case ContentType.help:
        return 'Info';
      default:
        return 'Oh Hey!!';
    }
  }
}
