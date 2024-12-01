import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:edu_app_project/core/enums/subscription_enum.dart';
import 'package:edu_app_project/src/subscription/domain/usecases/confirm_payment_intent.dart';
import 'package:edu_app_project/src/subscription/domain/usecases/create_payment_intent.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc({
    required CreatePaymentIntent createPaymentIntent,
    required ConfirmPaymentIntent confirmPaymentIntent,
  })  : _createPaymentIntent = createPaymentIntent,
        _confirmPaymentIntent = confirmPaymentIntent,
        super(const SubscriptionInitial()) {
    on<SubscriptionEvent>((event, emit) => emit(const Subscribing()));
    on<CreatePaymentIntentEvent>(_createPaymentIntentHandler);
    on<ConfirmPaymentIntentEvent>(_confirmPaymentIntentHandler);
  }

  final CreatePaymentIntent _createPaymentIntent;
  final ConfirmPaymentIntent _confirmPaymentIntent;

  Future<void> _createPaymentIntentHandler(
    CreatePaymentIntentEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    final result = await _createPaymentIntent(
      CreatePaymentIntentParams(
        billingDetails: event.billingDetails,
        subscription: event.subscription,
      ),
    );
    result.fold(
      (failure) => emit(SubscriptionError(failure.errorMessage)),
      (clientSecret) {
        if (clientSecret != null) {
          add(
            ConfirmPaymentIntentEvent(
              clientSecret: clientSecret,
              subscription: event.subscription,
            ),
          );
        } else {
          emit(const Subscribed());
        }
      },
    );
  }

  Future<void> _confirmPaymentIntentHandler(
    ConfirmPaymentIntentEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    final result = await _confirmPaymentIntent(
      ConfirmPaymentIntentParams(
        clientSecret: event.clientSecret,
        subscription: event.subscription,
      ),
    );
    result.fold(
      (failure) => emit(SubscriptionError(failure.errorMessage)),
      (_) => emit(const Subscribed()),
    );
  }
}
