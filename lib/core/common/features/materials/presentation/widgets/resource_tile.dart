import 'package:edu_app_project/core/common/features/materials/presentation/app/providers/resource_controller.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:file_icon/file_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResourceTile extends StatelessWidget {
  const ResourceTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ResourceController>(
      builder: (_, controller, __) {
        final resource = controller.resource!;
        final authorIsNull =
            resource.author == null || resource.author!.isEmpty;
        final descriptionIsNull =
            resource.description == null || resource.description!.isEmpty;

        final downloadButton = ElevatedButton(
          onPressed: controller.fileExists
              ? controller.openFile
              : controller.downloadAndSaveFile,
          child: Icon(
            controller.fileExists
                ? Icons.read_more_rounded
                : Icons.download_rounded,
            size: 17,
            color: Colors.white, // Icon color for contrast
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colours.redColour, // Vibrant Green
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90),
            ),
            padding: const EdgeInsets.all(9),
          ),
        );

        return ExpansionTile(
          iconColor: Colours.darkColour,
          shape: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          tilePadding: EdgeInsets.zero,
          expandedAlignment: Alignment.centerLeft,
          childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
          leading: FileIcon('.${resource.fileExtension}', size: 30),
          title: Text(
            resource.title!,
            style: TextStyle(
                color: Colours.darkColour,
                fontWeight: FontWeight.w500,
                fontFamily: Fonts.merriweather,
                letterSpacing: -0.5,
                fontSize: 14),
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (authorIsNull && descriptionIsNull) downloadButton,
                if (!authorIsNull)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Auteur',
                              style: TextStyle(
                                  color: Colours.redColour,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: Fonts.merriweather,
                                  fontSize: 12),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              resource.author!,
                              style: const TextStyle(
                                  fontFamily: Fonts.merriweather,
                                  fontSize: 10,
                                  color: Colours.darkColour),
                            ),
                          ],
                        ),
                      ),
                      downloadButton,
                    ],
                  ),
                if (!descriptionIsNull)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!authorIsNull) const SizedBox(height: 10),
                            const Text(
                              'Description',
                              style: TextStyle(
                                  color: Colours.redColour,
                                  fontFamily: Fonts.merriweather,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              resource.description!,
                              style: const TextStyle(
                                  fontFamily: Fonts.merriweather,
                                  fontSize: 10,
                                  color: Colours.darkColour),
                            ),
                          ],
                        ),
                      ),
                      if (authorIsNull) downloadButton,
                    ],
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
