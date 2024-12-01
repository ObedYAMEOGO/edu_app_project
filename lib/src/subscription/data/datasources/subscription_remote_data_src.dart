import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/core/enums/subscription_enum.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/core/utils/typedefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

abstract class SubscriptionRemoteDataSrc {
  Future<String?> createPaymentIntent({
    required BillingDetails billingDetails,
    required Subscription subscription,
  });

  Future<void> confirmPaymentIntent({
    required String clientSecret,
    required Subscription subscription,
  });
}

class SubscriptionRemoteDataSrcImpl implements SubscriptionRemoteDataSrc {
  const SubscriptionRemoteDataSrcImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required http.Client client,
  })  : _firestore = firestore,
        _auth = auth,
        _client = client;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final http.Client _client;

  @override
  Future<String?> createPaymentIntent({
    required BillingDetails billingDetails,
    required Subscription subscription,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const ServerException(
          message: 'User is not authenticated',
          statusCode: '401',
        );
      }
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(billingDetails: billingDetails),
        ),
      );
      final url = Uri.parse(
        'https://us-central1-fir-test-project-5.cloudfunctions.'
        'net/StripePayEndpointMethodId',
      );
      final response = await _client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'useStripeSdk': true,
          'paymentMethodId': paymentMethod.id,
          'currency': 'USD',
          'subscription': subscription.code,
        }),
      );
      if (response.statusCode != 200 && response.statusCode != 200) {
        throw ServerException(
          message: (jsonDecode(response.body) as DataMap)['error'] as String? ??
              response.body,
          statusCode: response.statusCode.toString(),
        );
      }
      final intent = jsonDecode(response.body) as DataMap;
      if (intent case {'error': final String error}) {
        debugPrint('ERROR: $error');
        throw ServerException(
          message: error,
          statusCode: 'PaymentMethodError',
        );
      } else if (intent case {'clientSecret': final String _}
          when intent['requiresAction'] == null ||
              intent['requiresAction'] == false) {
        await _upgradeUser(subscription);
        return null;
      } else if (intent
          case {
            'clientSecret': final String clientSecret,
            'requiresAction': true
          }) {
        return clientSecret;
      }
      throw const ServerException(
        message: 'Unknown error occurred',
        statusCode: 'PaymentMethodError',
      );
    } on ServerException {
      rethrow;
    } on FirebaseException catch (e) {
      debugPrint('ERROR: $e');
      throw ServerException(
        message: e.message ?? 'Unknown error',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrint('ERROR: $e');
      debugPrintStack(stackTrace: s);
      throw const ServerException.generic500();
    }
  }

  @override
  Future<void> confirmPaymentIntent({
    required String clientSecret,
    required Subscription subscription,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const ServerException(
          message: 'User is not authenticated',
          statusCode: '401',
        );
      }
      final intent = await Stripe.instance.handleNextAction(clientSecret);
      if (intent.status == PaymentIntentsStatus.RequiresConfirmation) {
        final url = Uri.parse(
          'https://us-central1-fir-test-project-5.'
          'cloudfunctions.net/StripePayEndpointIntentId',
        );
        final response = await _client.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'paymentIntentId': intent.id}),
        );
        if (response.statusCode != 200 && response.statusCode != 200) {
          throw ServerException(
            message:
                (jsonDecode(response.body) as DataMap)['error'] as String? ??
                    response.body,
            statusCode: response.statusCode.toString(),
          );
        }
        final intentData = jsonDecode(response.body) as DataMap;
        if (intentData case {'error': final String error}) {
          throw ServerException(
            message: error,
            statusCode: 'PaymentMethodError',
          );
        } else {
          await _upgradeUser(subscription);
        }
      } else if (intent.status == PaymentIntentsStatus.Succeeded) {
        await _upgradeUser(subscription);
      }
    } on ServerException {
      rethrow;
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrint('ERROR: $e');
      debugPrintStack(stackTrace: s);
      throw const ServerException.generic500();
    }
  }

  Future<void> _upgradeUser(Subscription subscription) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'dateSubscribed': FieldValue.serverTimestamp(),
      'subscription': subscription.code,
    });
  }
}
