import 'package:chewie/chewie.dart';
import 'package:edu_app_project/core/common/views/custom_circular_progress_bar.dart';
import 'package:edu_app_project/core/common/widgets/nested_back_button.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({required this.videoURL, super.key});

  final String videoURL;

  static const routeName = '/video-player';

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  bool loop = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    // ignore: deprecated_member_use
    videoPlayerController = VideoPlayerController.network(widget.videoURL);
    await videoPlayerController.initialize();
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      hideControlsTimer: const Duration(seconds: 5),
      additionalOptions: (_) => <OptionItem>[
        OptionItem(
          title: '${loop ? 'Activer' : 'Désactiver'}',
          iconData: Icons.loop,
          onTap: () async {
            final navigator = Navigator.of(context);
            await chewieController!.setLooping(!loop);
            setState(() {
              loop = !loop;
            });
            navigator.pop();
          },
        ),
      ],
      // Try playing around with some of these other options:

      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colours.favoriteYellow,
        handleColor: Colors.white70,
        backgroundColor: Colours.primaryColour,
        bufferedColor: Colours.secondaryColour,
      ),
      placeholder: Container(color: Colours.primaryColour),
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        leading: const NestedBackButton(),
        backgroundColor: Colors.transparent,
      ),
      body: chewieController != null &&
              chewieController!.videoPlayerController.value.isInitialized
          ? Chewie(
              controller: chewieController!,
            )
          : const Center(
              child: CustomCircularProgressBarIndicator(),
            ),
    );
  }
}
