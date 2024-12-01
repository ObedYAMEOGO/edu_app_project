import 'package:edu_app_project/core/common/features/paywall/presentation/utils/paywall_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaywallService {
  const PaywallService._();

  static Future<void> init() async {
    await Purchases.setLogLevel(LogLevel.debug);
    final config = PurchasesConfiguration(PaywallConfig.googleApiKey);
    await Purchases.configure(config);
  }

  static Future<List<Offering>> getOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current == null ? [] : [offerings.current!];
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
