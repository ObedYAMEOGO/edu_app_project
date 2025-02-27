import 'package:flutter/material.dart';
import 'package:edu_app_project/core/common/widgets/rounded_button.dart';
import 'package:edu_app_project/core/enums/subscription_enum.dart';
import 'package:edu_app_project/core/res/fonts.dart';

class PlanCard extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback onPressed;

  const PlanCard({
    required this.subscription,
    required this.onPressed,
    super.key,
  });

  Color _getGradientStart() {
    switch (subscription) {
      case Subscription.MONTHLY:
        return const Color.fromARGB(255, 48, 218, 189);
      case Subscription.QUARTERLY:
        return Colors.blue.shade400;
      case Subscription.ANNUALLY:
        return Colors.deepPurple;
    }
  }

  Color _getGradientEnd() {
    switch (subscription) {
      case Subscription.MONTHLY:
        return Colors.blue.shade300;
      case Subscription.QUARTERLY:
        return Colors.blue.shade600;
      case Subscription.ANNUALLY:
        return Colors.purple.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_getGradientStart(), _getGradientEnd()],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (subscription == Subscription.ANNUALLY)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Meilleur choix',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: Fonts.inter,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Text(
              subscription.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: Fonts.inter,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                subscription.star,
                (index) =>
                    const Icon(Icons.star, color: Colors.amber, size: 22),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${subscription.code} Mois(s)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontFamily: Fonts.inter,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                subscription.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontFamily: Fonts.inter,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${subscription.price} FCFA',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: Fonts.inter,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: RoundedButton(
                label: 'Je m\'abonne',
                buttonColour: Colors.white,
                labelColour: _getGradientEnd(),
                onPressed: onPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
