import 'package:edu_app_project/src/admin/presentation/models/resource.dart';
import 'package:edu_app_project/src/admin/presentation/widgets/picked_resource_horizontal_text.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class PickedResourceTile extends StatelessWidget {
  const PickedResourceTile(
    this.resource, {
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final Resource resource;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Image.asset(Res.material),
            ),
            title: Text(
              resource.path.split('/').last,
              maxLines: 1,
            ),
            contentPadding: const EdgeInsets.only(left: 16, right: 5),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(IconlyBroken.edit),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    IconlyBroken.close_square,
                    color: Colours.redColour,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          PickedResourceHorizontalText(label: 'Auteur', value: resource.author),
          PickedResourceHorizontalText(label: 'Titre', value: resource.title),
          PickedResourceHorizontalText(
            label: 'Description',
            value: resource.description.trim().isEmpty
                ? '"None"'
                : resource.description,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
