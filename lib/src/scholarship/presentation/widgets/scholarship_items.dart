import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
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
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                elevation: 3,
                shadowColor: Colors.black.withOpacity(0.1),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(12), // Consistent rounding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Application deadline with gradient
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          gradient:
                              Colours.primaryGradient, // Apply gradient here
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10)), // Rounded top
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined,
                                size: 16, color: Colours.whiteColour),
                            const SizedBox(width: 8),
                            Text(
                              'Date limite: ${DateFormat('dd MMM yyyy').format(scholarship.applicationDeadline)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: Fonts.inter,
                                fontWeight: FontWeight.w500,
                                color: Colours.whiteColour,
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
                            // Left side: Scholarship details
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
                                      color: Colours.darkColour,
                                      fontFamily: Fonts.inter,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Category badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE4E6EA),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      scholarship.category,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: Fonts.inter,
                                        color: Colours.darkColour,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Country
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined,
                                          size: 16, color: Colours.darkColour),
                                      const SizedBox(width: 8),
                                      Text(
                                        scholarship.country.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: Fonts.inter,
                                          fontWeight: FontWeight.w600,
                                          color: Colours.darkColour,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Right side: Logo
                            Container(
                              margin: const EdgeInsets.only(left: 12),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Image.network(
                                scholarship.logoImage,
                                height: 60,
                                width: 60,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Divider
                      Container(
                        height: 1,
                        color: Colors.grey[200],
                      ),
                      // Details button with gradient
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: Colours
                                  .primaryGradient, // Apply gradient here
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pushNamed(
                                ScholarshipDetailsScreen.routeName,
                                arguments: scholarship,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .transparent, // Transparent to show gradient
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Voir les détails',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: Fonts.inter,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
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
