import 'package:flutter/material.dart';

class SubjectTile extends StatelessWidget {
  const SubjectTile({
    required this.name,
    required this.icon,
    required this.colour,
    super.key,
  });

  final String name;
  final String icon;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: colour,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Image.asset(
                icon,
                height: 32,
                width: 32,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
