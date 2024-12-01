import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/enums/subscription_enum.dart';
import 'package:edu_app_project/src/subscription/domain/usecases/create_payment_intent.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'subscription_repo.mock.dart';

void main() {
  late MockSubscriptionRepo repo;
  late CreatePaymentIntent usecase;

  const tBillingDetails = BillingDetails();

  const tSubscription = Subscription.MONTHLY;

  const tResult = 'Test String';

  setUp(() {
    repo = MockSubscriptionRepo();
    usecase = CreatePaymentIntent(repo);
    registerFallbackValue(tBillingDetails);
    registerFallbackValue(tSubscription);
  });

  test(
    'should return [String?] from the repo',
    () async {
      when(
        () => repo.createPaymentIntent(
          billingDetails: any(named: 'billingDetails'),
          subscription: any(named: 'subscription'),
        ),
      ).thenAnswer(
        (_) async => const Right(tResult),
      );

      final result = await usecase(
        const CreatePaymentIntentParams(
          billingDetails: tBillingDetails,
          subscription: tSubscription,
        ),
      );
      expect(result, equals(const Right<dynamic, String?>(tResult)));
      verify(
        () => repo.createPaymentIntent(
          billingDetails: any(named: 'billingDetails'),
          subscription: any(named: 'subscription'),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
