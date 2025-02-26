import 'package:edu_app_project/core/common/widgets/rounded_button.dart';
import 'package:edu_app_project/core/enums/subscription_enum.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({
    required this.subscription,
    required this.onPressed,
    super.key,
  });

  final Subscription subscription;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colours.whiteColour,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Badge "Meilleur choix" pour l'abonnement annuel
            if (subscription == Subscription.ANNUALLY)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colours.primaryColour,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Meilleur choix',
                  style: TextStyle(
                    color: Colours.whiteColour,
                    fontFamily: Fonts.inter,
                    fontSize: 10,
                  ),
                ),
              ),

            // Titre et durée
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  Text(
                    subscription.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colours.darkColour,
                      fontFamily: Fonts.inter,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Affichage dynamique des étoiles
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      subscription.star,
                      (index) => Icon(Icons.star,
                          color: Colours.primaryColour, size: 24),
                    ),
                  ),

                  const SizedBox(height: 4),
                  Text(
                    '${subscription.code} Mois(s)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color.fromARGB(171, 0, 0, 0),
                      fontFamily: Fonts.inter,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Description
            Container(
              color: const Color(0xFFE4E6EA),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Text(
                  subscription.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colours.darkColour,
                    fontFamily: Fonts.inter,
                  ),
                ),
              ),
            ),

            // Prix et bouton d’abonnement
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${subscription.price} FCFA',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      color: Colours.darkColour,
                      fontFamily: Fonts.inter,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: RoundedButton(
                      label: 'Je m\'abonne',
                      buttonColour: Colours.primaryColour,
                      labelColour: Colours.whiteColour,
                      onPressed: onPressed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
