import 'package:edu_app_project/core/common/widgets/expandable_text.dart';
import 'package:edu_app_project/core/common/widgets/nested_back_button.dart';
import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:edu_app_project/src/scholarship/domain/entities/scholarship.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart'; // For opening the URL

class ScholarshipDetailsScreen extends StatelessWidget {
  const ScholarshipDetailsScreen(
    this.scholarship, {
    super.key,
  });

  static const routeName = '/scholarship-details';

  final Scholarship scholarship;

  Future<void> _launchURL() async {
    final Uri _url = Uri.parse(scholarship.videoUrl);
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  // Function to launch WhatsApp with a prefilled message
  Future<void> _launchWhatsApp() async {
    final String message =
        "Salut!\nJe suis intéressé par la bourse de ${scholarship.name}.\nPuis-je avoir les détails? Merci.";
    final String phoneNumber = "+22657226387";
    final Uri whatsappUrl = Uri.parse(
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      throw 'Impossible d\'ouvrir WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          scholarship.name,
          style: const TextStyle(
            fontFamily: Fonts.montserrat,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colours.primaryColour,
          ),
        ),
        leading: const NestedBackButton(),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SizedBox(
              height: context.height * .3,
              child: Stack(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      // ignore: unnecessary_null_comparison
                      child: scholarship.image != null
                          ? Image.network(
                              scholarship.image,
                              height: 400,
                              width: 400,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              Res.user,
                              height: 400,
                              width: 400,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: _launchURL,
                      child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            Res.youtubeVideoIcon,
                            width: 50
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scholarship.name,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colours.secondaryColour),
                ),
                const SizedBox(height: 10),
                ExpandableText(
                  context,
                  text: scholarship.description,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      'Pays d\'acceuil: ',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colours.secondaryColour),
                    ),
                    Text(
                      ' ${scholarship.country}',
                      style: const TextStyle(
                          fontSize: 13, color: Colours.secondaryColour),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description: ',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colours.secondaryColour),
                    ),
                    ExpandableText(
                        text: ' ${scholarship.description}', context),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    const Text(
                      'Nombre de places: ',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colours.secondaryColour),
                    ),
                    Text(
                      ' ${scholarship.numberOfRecipients}',
                      style: const TextStyle(
                          fontSize: 13, color: Colours.secondaryColour),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'Date limite: ',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colours.secondaryColour),
                    ),
                    Text(
                      ' ${DateFormat('dd MMM yyyy').format(scholarship.applicationDeadline)}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colours.secondaryColour,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Filières disponibles:',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colours.primaryColour),
                ),
                const SizedBox(height: 10),
                for (var field in scholarship.availableFields)
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colours.primaryColour,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            ' $field',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colours.secondaryColour,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _launchWhatsApp,
          backgroundColor: Colors.white,
          elevation: 0,
          child: Image.asset(Res.whatsapp)),
    );
  }
}
