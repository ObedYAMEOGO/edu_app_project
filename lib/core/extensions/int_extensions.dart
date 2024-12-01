import 'package:edu_app_project/core/enums/subscription_enum.dart';

extension IntExt on int {
  String get estimate {
    if (this <= 10) return '$this';
    var data = this - (this % 10);
    if (data == this) data = this - 5;
    return 'over $data';
  }

  String get pluralize {
    return this > 1 ? 's' : '';
  }

  String get displayDuration {
    if (this <= 60) return '${this}s';
    if (this <= 3600) return '${(this / 60).round()}m';
    if (this <= 86400) return '${(this / 3600).round()}h';
    return '${(this / 86400).round()}d';
  }

  String get displayDurationLong {
    if (this <= 60) return '$this secondes';
    if (this <= 3600) return '${(this / 60).round()} minutes';
    if (this <= 86400) return '${(this / 3600).round()} heures';
    return '${(this / 86400).round()} jours';
  }

  Subscription? get subscription => switch (this) {
        1 => Subscription.MONTHLY,
        3 => Subscription.QUARTERLY,
        12 => Subscription.ANNUALLY,
        _ => null,
      };
}
