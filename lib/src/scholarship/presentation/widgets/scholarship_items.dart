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
            padding: const EdgeInsets.only(bottom: 10, top: 1),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                ScholarshipDetailsScreen.routeName,
                arguments: scholarship,
              ),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Scholarship Image and Logo
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          child: Image.network(
                            scholarship.image,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 15,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Image.network(
                              scholarship.logoImage,
                              height: 50,
                              width: 90,
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                      ],
                    ),
                    // Scholarship Information
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name and Category in One Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  scholarship.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 8,
                                ),
                                color: Color(0xFFE4E6EA),
                                child: Text(
                                  scholarship.category,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colours.primaryColour,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // Country and Deadline in One Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pays: ${scholarship.country}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colours.primaryColour,
                                ),
                              ),
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
                          const SizedBox(height: 10),
                          // View Details Button
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pushNamed(
                                ScholarshipDetailsScreen.routeName,
                                arguments: scholarship,
                              ),
                              child: const Text(
                                'Voir les détails',
                                style: TextStyle(
                                  color: Colours.primaryColour,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
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
