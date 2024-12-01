import 'package:edu_app_project/core/enums/subscription_enum.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

abstract class SubscriptionRepo {
  const SubscriptionRepo();

  ResultFuture<String?> createPaymentIntent({
    required BillingDetails billingDetails,
    required Subscription subscription,
  });

  ResultFuture<void> confirmPaymentIntent({
    required String clientSecret,
    required Subscription subscription,
  });
}
