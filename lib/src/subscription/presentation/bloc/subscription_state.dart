part of 'subscription_bloc.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object> get props => [];
}

class SubscriptionInitial extends SubscriptionState {
  const SubscriptionInitial();
}

class Subscribing extends SubscriptionState {
  const Subscribing();
}

class Subscribed extends SubscriptionState {
  const Subscribed();
}

class SubscriptionError extends SubscriptionState {
  const SubscriptionError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
