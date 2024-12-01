part of 'subscription_bloc.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object?> get props => [];
}

class CreatePaymentIntentEvent extends SubscriptionEvent {
  const CreatePaymentIntentEvent({
    required this.billingDetails,
    required this.subscription,
  });

  final BillingDetails billingDetails;
  final Subscription subscription;

  @override
  List<Object> get props => [billingDetails, subscription];
}

class ConfirmPaymentIntentEvent extends SubscriptionEvent {
  const ConfirmPaymentIntentEvent({
    required this.clientSecret,
    required this.subscription,
  });

  final String clientSecret;
  final Subscription subscription;

  @override
  List<Object> get props => [clientSecret, subscription];
}
