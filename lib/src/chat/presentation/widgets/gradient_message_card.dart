import 'package:edu_app_project/core/common/app/providers/user_provider.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/src/authentication/domain/entities/user.dart';
import 'package:edu_app_project/src/chat/domain/entities/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GradientMessageCard extends StatefulWidget {
  const GradientMessageCard({
    required this.message,
    required this.scrollController,
    super.key,
  });

  final Message message;
  final ScrollController scrollController;

  @override
  State<GradientMessageCard> createState() => _GradientMessageCardState();
}

class _GradientMessageCardState extends State<GradientMessageCard> {
  final auth = FirebaseAuth.instance;
  LocalUser? user;
  late bool isCurrentUser;

  @override
  void initState() {
    super.initState();
    if (widget.message.senderId == auth.currentUser!.uid) {
      user = context.read<UserProvider>().user;
      isCurrentUser = true;
    }
    widget.scrollController.position.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      key: ValueKey(widget.message.timestamp.millisecondsSinceEpoch),
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(24), // Plus arrondi pour adoucir l'effet
        gradient: LinearGradient(
          colors: [
            if (isCurrentUser) ...[
              Colours.primaryColour.withOpacity(0.8), // Opacité douce
              Colours.successColor.withOpacity(0.7), // Opacité douce
            ] else ...[
              Colours.successColor.withOpacity(0.7),
              Colours.primaryColour.withOpacity(0.8),
            ],
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [
            0,
            if (widget.scrollController.position.maxScrollExtent != 0)
              widget.scrollController.position.pixels /
                  widget.scrollController.position.maxScrollExtent
            else
              0,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Ombre douce
            blurRadius: 8,
            offset: Offset(0, 4), // Décalage de l'ombre pour un effet léger
          ),
        ],
      ),
      child: Text(
        widget.message.message,
        style: TextStyle(
          fontSize:
              16, // Taille de texte plus grande pour une meilleure lisibilité
          fontWeight: FontWeight.w400, // Police plus légère
          color: isCurrentUser
              ? Colors.white
              : Colours.primaryColour, // Couleur plus douce pour le texte
          letterSpacing: 0.5, // Espacement des lettres plus léger
        ),
      ),
    );
  }
}
