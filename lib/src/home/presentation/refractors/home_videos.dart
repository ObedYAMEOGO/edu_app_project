import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:edu_app_project/core/common/features/videos/presentation/app/cubit/video_cubit.dart';
import 'package:edu_app_project/core/common/features/videos/presentation/views/course_videos_view.dart';
import 'package:edu_app_project/core/common/features/videos/presentation/widgets/video_tile.dart';
import 'package:edu_app_project/core/common/views/loading_view.dart';
import 'package:edu_app_project/core/common/widgets/not_found_text.dart';
import 'package:edu_app_project/core/extensions/context_extension.dart';
import 'package:edu_app_project/core/services/injection_container.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/home/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeVideos extends StatefulWidget {
  const HomeVideos({super.key});

  @override
  State<HomeVideos> createState() => _HomeVideosState();
}

class _HomeVideosState extends State<HomeVideos> {
  void getVideos() {
    context.read<VideoCubit>().getVideos(context.courseOfTheDay!.id);
  }

  @override
  void initState() {
    super.initState();
    getVideos();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideoCubit, VideoState>(
      listener: (context, state) {
        if (state is VideoError) {
          Utils.showSnackBar(
              context, "Une erreur s\'est produite", ContentType.failure,
              title: 'Oups!');
        }
      },
      builder: (context, state) {
        if (state is LoadingVideos) {
          return const LoadingView();
        } else if ((state is VideosLoaded && state.videos.isEmpty) ||
            state is VideoError) {
          return NotFoundText(
              'Aucune vidéo sur ${context.courseOfTheDay!.title} disponible');
        } else if (state is VideosLoaded) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                sectionTitle: 'Videos ${context.courseOfTheDay!.title} ',
                seeAll: state.videos.length > 4,
                onSeeAll: () => context.push(
                  BlocProvider(
                    create: (_) => sl<VideoCubit>(),
                    child: CourseVideosView(context.courseOfTheDay!),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              for (final video in state.videos.take(5)) VideoTile(video: video),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
