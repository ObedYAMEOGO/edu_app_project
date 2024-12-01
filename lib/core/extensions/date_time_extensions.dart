import 'package:edu_app_project/core/extensions/int_extensions.dart';

extension DateTimeExt on DateTime {
  String get timeAgo {
    final nowUtc = DateTime.now().toUtc();

    final difference = nowUtc.difference(toUtc());

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'Il y\'a de cela $years an${years.pluralize}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'Il y\'a de cela $months month${months.pluralize}';
    } else if (difference.inDays > 0) {
      return 'Il y\'a de cela ${difference.inDays} jour${difference.inDays.pluralize} ';
    } else if (difference.inHours > 0) {
      return 'Il y\'a de cela ${difference.inHours} heure${difference.inHours.pluralize} ';
    } else if (difference.inMinutes > 0) {
      return 'Il y\'a de cela ${difference.inMinutes} '
          'minute${difference.inMinutes.pluralize} ';
    } else {
      return 'maintenant';
    }
  }
}
