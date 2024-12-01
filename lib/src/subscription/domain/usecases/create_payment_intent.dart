import 'package:edu_app_project/core/enums/subscription_enum.dart';
import 'package:edu_app_project/core/usecases/usecases.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:edu_app_project/src/subscription/domain/repos/subscription_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CreatePaymentIntent
    extends FutureUsecaseWithParams<String?, CreatePaymentIntentParams> {
  const CreatePaymentIntent(this._repo);

  final SubscriptionRepo _repo;

  @override
  ResultFuture<String?> call(CreatePaymentIntentParams params) =>
      _repo.createPaymentIntent(
        billingDetails: params.billingDetails,
        subscription: params.subscription,
      );
}

class CreatePaymentIntentParams extends Equatable {
  const CreatePaymentIntentParams({
    required this.billingDetails,
    required this.subscription,
  });

  final BillingDetails billingDetails;
  final Subscription subscription;

  @override
  List<dynamic> get props => [
        billingDetails,
        subscription,
      ];
}
