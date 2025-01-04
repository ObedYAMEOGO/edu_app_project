import 'package:edu_app_project/core/common/features/category/domain/entities/category.dart';
import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({required this.category, super.key, this.onTap});

  final Category category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    double tileSize = context.width * 0.4;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: tileSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE4E6EA),
                borderRadius: BorderRadius.circular(24),
              ),
              height: tileSize,
              width: tileSize,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image with a circular background
                  Image.network(
                    category.categoryImage ?? '',
                    height: tileSize * 0.3,
                    width: tileSize * 0.3,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image_not_supported,
                        size: tileSize * 0.2,
                        color: Colors.grey,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  // Category title with dynamic layout and maxLines
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      category.categoryTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
