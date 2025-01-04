import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/src/scholarship/domain/entities/scholarship.dart';
import 'package:edu_app_project/src/scholarship/presentation/views/scholarship_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScholarshipItems extends StatelessWidget {
  const ScholarshipItems({Key? key, required this.scholarships})
      : super(key: key);

  final List<Scholarship> scholarships;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: scholarships.map((scholarship) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 8),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                ScholarshipDetailsScreen.routeName,
                arguments: scholarship,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.2), // Bordure subtile
                    width: 1,
                  ),
                ),
                elevation: 3,
                shadowColor: Colors.black.withOpacity(0.1),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Application deadline at the top
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colours.primaryColour.withOpacity(0.1),
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[200]!),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: Colours.secondaryColour,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Date limite: ${DateFormat('dd MMM yyyy').format(scholarship.applicationDeadline)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colours.secondaryColour,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Scholarship details
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Scholarship details (left side)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Scholarship name
                                  Text(
                                    scholarship.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colours.primaryColour,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Category badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE4E6EA),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      scholarship.category,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colours.primaryColour,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Country
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 16,
                                        color: Colours.primaryColour,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        scholarship.country.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colours.primaryColour,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Logo (right side)
                            Container(
                              margin: const EdgeInsets.only(left: 12),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey
                                      .withOpacity(0.2), // Bordure subtile
                                  width: 1,
                                ),
                              ),
                              child: Image.network(
                                scholarship.logoImage,
                                height: 60, // Logo agrandi
                                width: 60, // Logo agrandi
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Divider for ticket effect
                      Container(
                        height: 1,
                        color: Colors.grey[200],
                      ),
                      // Details button
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pushNamed(
                              ScholarshipDetailsScreen.routeName,
                              arguments: scholarship,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colours.successColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Voir les détails',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
