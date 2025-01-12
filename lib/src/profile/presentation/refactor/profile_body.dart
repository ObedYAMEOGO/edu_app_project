import 'package:edu_app_project/core/common/app/providers/user_provider.dart';
import 'package:edu_app_project/core/common/features/category/presentation/cubit/category_cubit.dart';
import 'package:edu_app_project/core/common/features/category/presentation/widgets/add_category_sheet.dart';
import 'package:edu_app_project/core/common/features/course/presentation/cubit/course_cubit.dart';
import 'package:edu_app_project/core/common/features/course/presentation/widgets/add_course_sheet.dart';
import 'package:edu_app_project/src/admin/presentation/views/add_materials_view.dart';
import 'package:edu_app_project/src/admin/presentation/views/add_video_view.dart';
import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/services/injection_container.dart';
import 'package:edu_app_project/src/admin/presentation/views/add_exam_view.dart';
import 'package:edu_app_project/src/notifications/presentation/cubit/notification_cubit.dart';
import 'package:edu_app_project/src/profile/presentation/widgets/admin_button.dart';
import 'package:edu_app_project/src/profile/presentation/widgets/user_info_card.dart';
import 'package:edu_app_project/src/scholarship/presentation/app/cubit/scholarship_cubit.dart';
import 'package:edu_app_project/src/scholarship/presentation/widgets/add_scholarship_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, provider, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                UserInfoCard(
                  infoTitle: 'Formations',
                  infoValue: provider.user!.enrolledCourseIds.length.toString(),
                  infoIcon: const Icon(
                    Icons.document_scanner,
                    color: Colours.darkColour,
                    size: 24,
                  ),
                  infoThemeColour: Colours.inforThemeColor3,
                ),
                const SizedBox(
                  height: 5,
                ),
                UserInfoCard(
                  infoTitle: 'Points',
                  infoValue: provider.user!.points.toString(),
                  infoIcon: const Icon(
                    Icons.score,
                    color: Colours.darkColour,
                    size: 24,
                  ),
                  infoThemeColour: Colours.inforThemeColor3,
                ),
                const SizedBox(
                  height: 5,
                ),
                UserInfoCard(
                  infoTitle: 'Followers',
                  infoValue: provider.user!.followers.length.toString(),
                  infoIcon: const Icon(
                    Icons.people_alt,
                    color: Colours.darkColour,
                    size: 24,
                  ),
                  infoThemeColour: Colours.inforThemeColor3,
                ),
                const SizedBox(
                  height: 5,
                ),
                UserInfoCard(
                  infoTitle: 'Following',
                  infoValue: provider.user!.following.length.toString(),
                  infoIcon: const Icon(
                    Icons.person,
                    color: Colours.darkColour,
                    size: 24,
                  ),
                  infoThemeColour: Colours.inforThemeColor4,
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            if (context.currentUser!.isAdmin) ...[
              AdminButton(
                  label: 'Nouveau Cours',
                  icon: IconlyBold.paper_download,
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        isScrollControlled: true,
                        showDragHandle: true,
                        elevation: 0,
                        useSafeArea: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                                0), // Définit un rayon de 0 pour les coins
                          ),
                        ),
                        builder: (_) => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (_) => sl<CourseCubit>(),
                                ),
                                BlocProvider(
                                  create: (_) => sl<NotificationCubit>(),
                                ),
                              ],
                              child: AddCourseSheet(),
                            ));
                  }),
              AdminButton(
                  label: 'Nouvelle Catégorie',
                  icon: IconlyBold.paper_download,
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        isScrollControlled: true,
                        showDragHandle: true,
                        elevation: 0,
                        useSafeArea: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                                0), // Définit un rayon de 0 pour les coins
                          ),
                        ),
                        builder: (_) => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (_) => sl<CategoryCubit>(),
                                ),
                                BlocProvider(
                                  create: (_) => sl<NotificationCubit>(),
                                ),
                              ],
                              child: AddCategorySheet(),
                            ));
                  }),
              AdminButton(
                  label: 'Nouvelle Vidéo',
                  icon: IconlyBold.video,
                  onPressed: () {
                    Navigator.pushNamed(context, AddVideoView.routeName);
                  }),
              AdminButton(
                  label: 'Nouveaux Documents',
                  icon: Icons.document_scanner,
                  onPressed: () {
                    Navigator.pushNamed(context, AddMaterialsView.routeName);
                  }),
              AdminButton(
                  label: 'Nouveau Quizz',
                  icon: IconlyBold.paper,
                  onPressed: () {
                    Navigator.pushNamed(context, AddExamView.routeName);
                  }),
              AdminButton(
                  label: 'Nouvelle Bourse',
                  icon: Icons.school,
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      backgroundColor: Colors.white,
                      isScrollControlled: true,
                      elevation: 0,
                      useSafeArea: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(
                              0), // Définit un rayon de 0 pour les coins
                        ),
                      ),
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider(create: (_) => sl<ScholarshipCubit>()),
                          BlocProvider(create: (_) => sl<NotificationCubit>()),
                        ],
                        child: const AddScholarshipSheet(),
                      ),
                    );
                  }),
            ]
          ],
        );
      },
    );
  }
}
