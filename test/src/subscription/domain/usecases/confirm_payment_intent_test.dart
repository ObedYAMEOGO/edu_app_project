import 'package:dartz/dartz.dart';
import 'package:edu_app_project/core/enums/subscription_enum.dart';
import 'package:edu_app_project/src/subscription/domain/usecases/confirm_payment_intent.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'subscription_repo.mock.dart';

void main() {
  late MockSubscriptionRepo repo;
  late ConfirmPaymentIntent usecase;

  const tClientSecret = 'Test String';

  const tSubscription = Subscription.MONTHLY;

  setUp(() {
    repo = MockSubscriptionRepo();
    usecase = ConfirmPaymentIntent(repo);
    registerFallbackValue(tClientSecret);
    registerFallbackValue(tSubscription);
  });

  test(
    'should call the [SubscriptionRepo.confirmPaymentIntent]',
    () async {
      when(
        () => repo.confirmPaymentIntent(
          clientSecret: any(named: 'clientSecret'),
          subscription: any(named: 'subscription'),
        ),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(
        const ConfirmPaymentIntentParams(
          clientSecret: tClientSecret,
          subscription: tSubscription,
        ),
      );
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repo.confirmPaymentIntent(
          clientSecret: any(named: 'clientSecret'),
          subscription: any(named: 'subscription'),
        ),
      ).called(1);
      verifyNoMoreInteractions(repo);
    },
  );
}
