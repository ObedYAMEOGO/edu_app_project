import 'package:edu_app_project/core/common/features/course/domain/entities/course.dart';
import 'package:edu_app_project/core/common/features/materials/presentation/app/cubit/material_cubit.dart';
import 'package:edu_app_project/core/common/features/materials/presentation/app/providers/resource_controller.dart';
import 'package:edu_app_project/core/common/features/materials/presentation/widgets/resource_tile.dart';
import 'package:edu_app_project/core/common/views/loading_view.dart';
import 'package:edu_app_project/core/common/widgets/nested_back_button.dart';
import 'package:edu_app_project/core/common/widgets/not_found_text.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/services/injection_container.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:flutter/material.dart' hide MaterialState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CourseMaterialsView extends StatefulWidget {
  const CourseMaterialsView(this.course, {super.key});
  final Course course;

  static const routeName = '/course-materials';

  @override
  State<CourseMaterialsView> createState() => _CourseMaterialsViewState();
}

class _CourseMaterialsViewState extends State<CourseMaterialsView> {
  void getMaterials() {
    context.read<MaterialCubit>().getMaterials(widget.course.id);
  }

  @override
  void initState() {
    super.initState();
    getMaterials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Supports ${widget.course.title}',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            fontFamily: Fonts.inter,
            color: Colours.darkColour,
          ),
        ),
        leading: const NestedBackButton(),
        titleSpacing: 0,
      ),
      body: BlocConsumer<MaterialCubit, MaterialState>(
        listener: (_, state) {
          if (state is MaterialError) {
            Utils.showSnackBar(
                context,
                "Une erreur s\'est produite. Verifiez vos informations et réessayer !",
                ContentType.failure,
                title: "Oups!");
          }
        },
        builder: (context, state) {
          if (state is LoadingMaterials) {
            return const LoadingView();
          } else if ((state is MaterialsLoaded && state.materials.isEmpty) ||
              state is MaterialError) {
            return NotFoundText(
                'Pas de documents disponibles \npour le cours de ${widget.course.title} pour le moment');
          } else if (state is MaterialsLoaded) {
            final materials = state.materials
              ..sort(
                (a, b) => b.uploadDate.compareTo(a.uploadDate),
              );
            return SafeArea(
              child: ListView.separated(
                padding: const EdgeInsets.only(left: 7, right: 7),
                itemCount: materials.length,
                separatorBuilder: (_, __) => const SizedBox.shrink(),
                itemBuilder: (_, index) {
                  return ChangeNotifierProvider(
                    create: (_) =>
                        sl<ResourceController>()..init(materials[index]),
                    child: const ResourceTile(),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
