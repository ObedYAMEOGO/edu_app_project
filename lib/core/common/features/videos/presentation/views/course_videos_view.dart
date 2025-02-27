import 'package:edu_app_project/core/common/features/course/domain/entities/course.dart';
import 'package:edu_app_project/core/common/features/videos/domain/entities/video.dart';
import 'package:edu_app_project/core/common/features/videos/presentation/app/cubit/video_cubit.dart';
import 'package:edu_app_project/core/common/features/videos/presentation/widgets/video_tile.dart';
import 'package:edu_app_project/core/common/views/loading_view.dart';
import 'package:edu_app_project/core/common/widgets/gradient_background.dart';
import 'package:edu_app_project/core/common/widgets/nested_back_button.dart';
import 'package:edu_app_project/core/common/widgets/not_found_text.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/res/media_res.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseVideosView extends StatefulWidget {
  const CourseVideosView(this.course, {super.key});

  static const routeName = '/course-videos';

  final Course course;

  @override
  State<CourseVideosView> createState() => _CourseVideosViewState();
}

class _CourseVideosViewState extends State<CourseVideosView> {
  late List<Video> filteredVideos;
  final TextEditingController searchController = TextEditingController();

  void getVideos() {
    context.read<VideoCubit>().getVideos(widget.course.id);
  }

  void _filterVideos(String query) {
    final lowerCaseQuery = query.toLowerCase(); // Query will never be null
    setState(() {
      final state = context.read<VideoCubit>().state;
      if (state is VideosLoaded) {
        filteredVideos = state.videos.where((video) {
          final videoTitle =
              video.title?.toLowerCase() ?? ''; // Handle nullable title
          return videoTitle.contains(lowerCaseQuery);
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    filteredVideos = [];
    getVideos();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const NestedBackButton(),
        titleSpacing: 0,
        title: Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colours.iconColor)),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: MediaQuery.of(context).size.width * 0.8,
            height: 36,
            child: TextField(
              controller: searchController,
              onChanged: _filterVideos,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Recherche...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontFamily: Fonts.inter,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colours.iconColor),
            onPressed: () {
              _filterVideos(searchController.text);
            },
          ),
        ],
      ),
      body: GradientBackground(
        image: Res.leaderboardGradientBackground,
        child: SafeArea(
          child: BlocConsumer<VideoCubit, VideoState>(
            listener: (context, state) {
              if (state is VideoError) {
                Utils.showSnackBar(context, state.message, ContentType.failure,
                    title: 'Oups!');
              }
            },
            builder: (context, state) {
              if (state is! VideosLoaded && state is! VideoError) {
                return const LoadingView();
              }

              if (state is VideosLoaded && state.videos.isNotEmpty) {
                if (filteredVideos.isEmpty && searchController.text.isEmpty) {
                  filteredVideos = state.videos;
                }
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.course.title}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colours.darkColour,
                          fontFamily: Fonts.inter,
                        ),
                      ),
                      Text(
                        '${filteredVideos.length} vidéos trouvées',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colours.primaryColour,
                          fontFamily: Fonts.inter,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredVideos.length,
                          itemBuilder: (context, index) {
                            final video = filteredVideos[index];
                            return VideoTile(video: video);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }

              return NotFoundText(
                'Pas de vidéos disponibles \n pour le cours de ${widget.course.title}',
              );
            },
          ),
        ),
      ),
    );
  }
}
