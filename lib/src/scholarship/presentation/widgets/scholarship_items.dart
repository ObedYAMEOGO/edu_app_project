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
            padding: const EdgeInsets.only(bottom: 9),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                ScholarshipDetailsScreen.routeName,
                arguments: scholarship,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        // Main Image
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(2),
                          ),
                          child: Image.network(
                            scholarship.image,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Logo Image
                        Positioned(
                          bottom: 12,
                          left: 15,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2)),
                            child: Image.network(
                              scholarship.logoImage,
                              height: 50,
                              width: 90,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Text(
                              '${scholarship.name}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Category
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            color: Colors.blue.withOpacity(0.05),
                            child: Text(
                              '${scholarship.category}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colours.primaryColour,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Country
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Text(
                              'Pays: ${scholarship.country}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colours.primaryColour,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Deadline
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            color: Colors.blue.withOpacity(0.05),
                            //color: const Color(0xFFE4E6EA),

                            child: Text(
                              'Date limite: ${DateFormat('dd MMM yyyy').format(scholarship.applicationDeadline)}',
                              style: const TextStyle(
                                fontFamily: Fonts.montserrat,
                                fontWeight: FontWeight.w500,
                                color: Colours.secondaryColour,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Button to View Details (Centered left aligned)
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pushNamed(
                                ScholarshipDetailsScreen.routeName,
                                arguments: scholarship,
                              ),
                              child: const Text(
                                'Voir les details',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
