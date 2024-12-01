import 'package:flutter/material.dart';

extension RatingExtensions on double {
  String get formattedRating => toStringAsFixed(1);

  Color get ratingColor {
    if (this >= 4.5) return Colors.green;
    if (this >= 3.0) return Colors.orange;
    return Colors.red;
  }

  IconData get ratingIcon {
    if (this >= 4.5) return Icons.star_rounded;
    if (this >= 3.0) return Icons.star_half_rounded;
    return Icons.star_outline_rounded;
  }
}
