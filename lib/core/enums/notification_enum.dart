// ignore_for_file: constant_identifier_names

enum NotificationCategory {
  TEST('test'),
  VIDEO('video'),
  MATERIAL('material'),
  SUBSCRIPTION_MONTH('subscription_1'),
  SUBSCRIPTION_YEAR('subscription_2'),
  COURSE('course'),
  SCHOLARSHIP('scholarship'),
  NONE('none');

  const NotificationCategory(this.value);

  final String value;
}
