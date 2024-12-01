import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:edu_app_project/core/common/widgets/gradient_background.dart';
import 'package:edu_app_project/core/common/widgets/nested_back_button.dart';
import 'package:edu_app_project/core/common/widgets/rounded_button.dart';
import 'package:edu_app_project/core/enums/subscription_enum.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:edu_app_project/core/services/injection_container.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class BillingFormScreen extends StatefulWidget {
  const BillingFormScreen({required this.subscription, super.key});

  static const routeName = '/billing';

  final Subscription subscription;

  @override
  State<BillingFormScreen> createState() => _BillingFormScreenState();
}

class _BillingFormScreenState extends State<BillingFormScreen> {
  bool showingLoader = false;
  late CardFormEditController cardController;

  @override
  void initState() {
    super.initState();
    cardController = CardFormEditController(
      initialDetails: const CardFieldInputDetails(complete: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('${widget.subscription.title} Billing'),
        leading: const NestedBackButton(),
      ),
      body: GradientBackground(
        image: Res.documentsGradientBackground,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<SubscriptionBloc, SubscriptionState>(
              listener: (_, state) {
                if (showingLoader) {
                  Navigator.pop(context);
                  showingLoader = false;
                }
                if (state is SubscriptionError) {
                  Utils.showSnackBar(
                      context,
                      'Une erreur s\'est produite. Vérifiez votre connexion internet et Réessayez',
                      ContentType.failure,
                      title: 'Oups!');
                } else if (state is Subscribing) {
                  Utils.showLoadingDialog(context);
                  showingLoader = true;
                }
              },
              builder: (_, state) {
                if (state is Subscribed) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('The payment is successful.'),
                      const SizedBox(height: 10),
                      RoundedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        label: 'Back to Home',
                      ),
                    ],
                  );
                }
                return ListView(
                  children: [
                    Text(
                      'Card Form',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    CardFormField(
                      controller: cardController,
                      style: CardFormStyle(
                        backgroundColor: Colors.grey,
                        borderRadius: 16,
                        placeholderColor: Colours.primaryColour,
                        cursorColor: Colours.primaryColour,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RoundedButton(
                      onPressed: () {
                        // 4000 0027 6000 3184
                        if (cardController.details.complete) {
                          final currentUser = sl<FirebaseAuth>().currentUser!;
                          context.read<SubscriptionBloc>().add(
                                CreatePaymentIntentEvent(
                                  billingDetails: BillingDetails(
                                    email: currentUser.email,
                                    name: currentUser.displayName,
                                    phone: currentUser.phoneNumber,
                                  ),
                                  subscription: widget.subscription,
                                ),
                              );
                        } else {
                          Utils.showSnackBar(
                              context,
                              'Le formulaire n\'est pas complet',
                              ContentType.failure,
                              title: 'Oups!');
                        }
                      },
                      label: 'Payer',
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
