import 'package:edu_app_project/core/common/views/loading_view.dart';
import 'package:edu_app_project/core/common/widgets/gradient_background.dart';
import 'package:edu_app_project/core/common/widgets/not_found_text.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/scholarship/presentation/app/cubit/scholarship_cubit.dart';
import 'package:edu_app_project/src/scholarship/presentation/app/cubit/scholarship_state.dart';
import 'package:edu_app_project/src/scholarship/presentation/widgets/scholarship_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScholarshipViewBody extends StatefulWidget {
  const ScholarshipViewBody({super.key});

  @override
  State<ScholarshipViewBody> createState() => _ScholarshipViewBodyState();
}

class _ScholarshipViewBodyState extends State<ScholarshipViewBody> {
  void getScholarships() {
    context.read<ScholarshipCubit>().getScholarships();
  }

  @override
  void initState() {
    super.initState();
    getScholarships();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScholarshipCubit, ScholarshipState>(
      listener: (_, state) {
        if (state is ScholarshipError) {
          Utils.showSnackBar(
            context,
            'Une erreur s\'est produite. Vérifiez votre connexion internet et réessayez!',
            ContentType.failure,
            title: 'Oups!',
          );
        } else if (state is ScholarshipsLoaded &&
            state.scholarships.isNotEmpty) {}
      },
      builder: (context, state) {
        if (state is LoadingScholarships) {
          return const LoadingView();
        } else if (state is ScholarshipsLoaded && state.scholarships.isEmpty ||
            state is ScholarshipError) {
          return const NotFoundText(
            'Pas de bourses disponible pour le moment \nVeuillez contacter l\'administrateur !',
          );
        } else if (state is ScholarshipsLoaded) {
          final scholarships = state.scholarships
            ..sort(
              (a, b) => b.updatedAt.compareTo(a.updatedAt),
            );
          return GradientBackground(
            image: Res.leaderboardGradientBackground,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              children: [
                const SizedBox(height: 5),
                ScholarshipItems(scholarships: scholarships),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
