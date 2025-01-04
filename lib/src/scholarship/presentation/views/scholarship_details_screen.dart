import 'package:edu_app_project/core/common/widgets/expandable_text.dart';
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
            fontFamily: Fonts.montserrat,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colours.primaryColour,
          ),
        ),
        leading: const NestedBackButton(),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Scholarship Image with Video Icon
            SizedBox(
              height: context.height * .3,
              child: Stack(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      // ignore: unnecessary_null_comparison
                      child: scholarship.image != null
                          ? Image.network(
                              scholarship.image,
                              height: 400,
                              width: double.infinity,
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
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          Res.youtubeVideoIcon,
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Scholarship Name
            Text(
              scholarship.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colours.primaryColour,
              ),
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
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Host Country
                    _buildDetailRow(
                      icon: Icons.location_on_outlined,
                      label: 'Pays d\'accueil',
                      value: scholarship.country,
                    ),
                    const SizedBox(height: 10),

                    // Number of Recipients
                    _buildDetailRow(
                      icon: Icons.people_outline,
                      label: 'Nombre de places',
                      value: scholarship.numberOfRecipients.toString(),
                    ),
                    const SizedBox(height: 10),

                    // Application Deadline
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
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colours.primaryColour,
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
                        color: Colours.primaryColour,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      field,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colours.secondaryColour,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
      // WhatsApp Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: _launchWhatsApp,
        backgroundColor: Colours.successColor,
        elevation: 4,
        child: Image.asset(
          Res.whatsapp,
          width: 24,
          height: 24,
        ),
      ),
    );
  }

  // Helper method to build a detail row
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
          color: Colours.primaryColour,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colours.primaryColour,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colours.secondaryColour,
          ),
        ),
      ],
    );
  }
}
