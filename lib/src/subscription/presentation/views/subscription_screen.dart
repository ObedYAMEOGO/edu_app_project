import 'package:edu_app_project/core/common/widgets/gradient_background.dart';
import 'package:edu_app_project/core/common/widgets/nested_back_button.dart';
import 'package:edu_app_project/core/enums/subscription_enum.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:edu_app_project/src/subscription/presentation/widgets/plan_card.dart';
import 'package:flutter/material.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  static const routeName = '/pricing';

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool showingLoader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text('Tarifs',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                color: Colours.darkColour)),
        leading: const NestedBackButton(),
      ),
      body: GradientBackground(
        image: Res.documentsGradientBackground,
        child: SafeArea(
          child: Center(
            child: ListView.builder(
              itemCount: Subscription.values.length,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemBuilder: (BuildContext context, int index) {
                final subscription = Subscription.values[index];
                return PlanCard(subscription: subscription);
              },
            ),
          ),
        ),
      ),
    );
  }
}
