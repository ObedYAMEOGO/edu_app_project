import 'package:edu_app_project/core/common/widgets/expandable_text.dart';
import 'package:edu_app_project/core/common/widgets/gradient_background.dart';
import 'package:edu_app_project/core/common/widgets/nested_back_button.dart';
import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:edu_app_project/src/scholarship/domain/entities/scholarship.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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
            fontSize: 17,
            fontWeight: FontWeight.w600,
            fontFamily: Fonts.inter,
            color: Colours.darkColour,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        leading: const NestedBackButton(),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: GradientBackground(
        image: Res.leaderboardGradientBackground,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Scholarship Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                // ignore: unnecessary_null_comparison
                child: scholarship.image != null
                    ? Image.network(
                        scholarship.image,
                        height: context.height * .3,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        Res.user,
                        height: 250,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 20),

              // Scholarship Name & YouTube Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      scholarship.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colours.darkColour,
                        fontFamily: Fonts.inter,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _launchURL,
                    child: Image.asset(
                      Res.youtubeVideoIcon,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Scholarship Description
              ExpandableText(
                context,
                text: scholarship.description,
              ),
              const SizedBox(height: 20),

              // Scholarship Details Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colours.iconColor)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        icon: Icons.location_on_outlined,
                        label: 'Pays d\'accueil',
                        value: scholarship.country,
                      ),
                      const SizedBox(height: 10),
                      _buildDetailRow(
                        icon: Icons.people_outline,
                        label: 'Nombre de places',
                        value: scholarship.numberOfRecipients.toString(),
                      ),
                      const SizedBox(height: 10),
                      _buildDetailRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Date limite',
                        value: DateFormat('dd MMM yyyy')
                            .format(scholarship.applicationDeadline),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Available Fields
              const Text(
                'Filières disponibles:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colours.darkColour,
                  fontFamily: Fonts.inter,
                ),
              ),
              const SizedBox(height: 10),
              ...scholarship.availableFields.map((field) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colours.darkColour,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        field,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colours.darkColour,
                          fontWeight: FontWeight.w300,
                          fontFamily: Fonts.inter,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _launchWhatsApp,
        backgroundColor: Colors.white,
        elevation: 0,
        child: Image.asset(
          Res.whatsapp,
          width: 30,
          height: 35,
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colours.darkColour,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colours.darkColour,
            fontFamily: Fonts.inter,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colours.darkColour,
            fontFamily: Fonts.inter,
          ),
        ),
      ],
    );
  }
}
