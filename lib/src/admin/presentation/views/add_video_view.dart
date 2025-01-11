import 'package:edu_app_project/core/common/features/course/domain/entities/course.dart';
import 'package:edu_app_project/core/common/features/videos/data/models/video_model.dart';
import 'package:edu_app_project/core/common/features/videos/presentation/app/cubit/video_cubit.dart';
import 'package:edu_app_project/core/common/features/videos/presentation/widgets/video_tile.dart';
import 'package:edu_app_project/core/common/widgets/reactive_button.dart';
import 'package:edu_app_project/core/enums/notification_enum.dart';
import 'package:edu_app_project/core/extensions/string_extensions.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/services/injection_container.dart';
import 'package:edu_app_project/core/utils/core_utils.dart';
import 'package:edu_app_project/src/admin/presentation/utils/admin_utils.dart';
import 'package:edu_app_project/src/admin/presentation/widgets/course_picker.dart';
import 'package:edu_app_project/src/admin/presentation/widgets/info_field.dart';
import 'package:edu_app_project/src/notifications/data/models/notification_model.dart';
import 'package:edu_app_project/src/notifications/presentation/cubit/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:flutter_link_previewer/flutter_link_previewer.dart';

class AddVideoView extends StatefulWidget {
  const AddVideoView({super.key});

  static const routeName = '/add-video';

  @override
  State<AddVideoView> createState() => _AddVideoViewState();
}

class _AddVideoViewState extends State<AddVideoView> {
  PreviewData? previewData;
  VideoModel? video;
  final urlController = TextEditingController();
  final tutorNameController = TextEditingController(text: 'Bassyam');
  final videoTitleController = TextEditingController();
  final courseController = TextEditingController();
  final courseNotifier = ValueNotifier<Course?>(null);

  final formKey = GlobalKey<FormState>();

  final tutorNameFocusNode = FocusNode();
  final videoTitleFocusNode = FocusNode();
  final urlFocusNode = FocusNode();

  bool getMoreDetails = false;

  bool get isYouTube => urlController.text.trim().isYouTubeVideo;
  bool loading = false;

  bool thumbnailIsFile = false;
  bool videoIsFile = false;

  Future<void> fetchVideo() async {
    if (urlController.text.trim().isEmpty) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      video = null;
      thumbnailIsFile = false;
      videoIsFile = false;
      getMoreDetails = false;
      loading = true;
    });
    if (isYouTube) {
      video = await Utils.getVideoFromYT(context, urlController.text.trim())
          as VideoModel?;
      setState(() {
        loading = false;
      });
    }
  }

  void reset() {
    setState(() {
      urlController.clear();
      tutorNameController.text = 'bassyam Team';
      videoTitleController.clear();
      previewData = null;
      video = null;
      getMoreDetails = false;
      loading = false;
    });
    urlFocusNode.requestFocus();
  }

  bool showingDialog = false;

  @override
  void initState() {
    super.initState();
    urlController.addListener(() {
      if (urlController.text.trim().isEmpty) reset();
    });
  }

  @override
  void dispose() {
    urlController.dispose();
    tutorNameController.dispose();
    videoTitleController.dispose();
    tutorNameFocusNode.dispose();
    videoTitleFocusNode.dispose();
    urlFocusNode.dispose();
    courseController.dispose();
    courseNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VideoCubit, VideoState>(
      listener: (context, state) async {
        if (state is AddingVideo) {
          Utils.showLoadingDialog(context);
          showingDialog = true;
        } else if (state is VideoError) {
          if (showingDialog) {
            Navigator.of(context).pop();
            showingDialog = false;
          }
          Utils.showSnackBar(
            context,
            'Une erreur s\'est produite. Vérifiez votre connexion internet et réessayez!',
            ContentType.failure,
            title: 'Oups!',
          );
        } else if (state is VideoAdded) {
          if (showingDialog) {
            showingDialog = false;
            Navigator.pop(context);
          }
          Utils.showSnackBar(
              context, 'Vidéo ajoutée avec succès', ContentType.success,
              title: 'Parfait!');
          Utils.showLoadingDialog(context);
          final navigator = Navigator.of(context);
          await sl<NotificationCubit>().sendNotification(
            NotificationModel(
              id: 'id',
              title: '${courseNotifier.value!.title}',
              body: 'Une nouvelle vidéo vient d\'être ajoutée',
              category: NotificationCategory.VIDEO,
              sentAt: DateTime.now(),
            ),
          );
          navigator
            ..pop()
            ..pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          titleSpacing: 0,
          title: Text(
            'Ajouter une vidéo',
            style: TextStyle(
                color: Colours.darkColour,
                fontWeight: FontWeight.w600,
                fontFamily: Fonts.merriweather,
                fontSize: 17),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            shrinkWrap: true,
            children: [
              Form(
                key: formKey,
                child: CoursePicker(
                  controller: courseController,
                  notifier: courseNotifier,
                ),
              ),
              const SizedBox(height: 20),
              InfoField(
                border: true,
                controller: urlController,
                hintText: 'Entrez l’URL de la vidéo',
                hintStyle: TextStyle(
                  fontFamily: Fonts.merriweather,
                ),
                onEditingComplete: fetchVideo,
                focusNode: urlFocusNode,
                onTapOutside: (_) => urlFocusNode.unfocus(),
                autoFocus: false,
                keyboardType: TextInputType.url,
              ),
              ListenableBuilder(
                listenable: urlController,
                builder: (_, __) {
                  return Column(
                    children: [
                      if (urlController.text.trim().isNotEmpty) ...[
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: fetchVideo,
                          child: const Text(
                            'Rechercher la vidéo',
                            style: TextStyle(
                              color: Colours.secondaryColour,
                              fontFamily: Fonts.merriweather,
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
              if (loading && isYouTube)
                LinkPreview(
                  onPreviewDataFetched: (data) async {
                    setState(() {
                      thumbnailIsFile = false;
                      videoIsFile = false;
                      video = VideoModel.empty().copyWith(
                        thumbnail: data.image?.url,
                        videoURL: urlController.text.trim(),
                        title: data.title ?? 'Sans Titre',
                      );
                      if (data.image?.url != null) loading = false;
                      getMoreDetails = true;
                      videoTitleController.text = data.title ?? '';
                    });

                    if (data.image?.url == null) {
                      final thumbnail = await AdminUtils.getThumbnailFromUrl(
                        urlController.text.trim(),
                      );
                      if (thumbnail != null) {
                        setState(() {
                          video = video?.copyWith(thumbnail: thumbnail.path);
                          loading = false;
                          thumbnailIsFile = true;
                        });
                      }
                    }
                  },
                  previewData: previewData,
                  text: '',
                  width: 0,
                ),
              if (video != null)
                Builder(
                  builder: (_) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: VideoTile(
                        video: video!,
                        uploadTimePrefix: '~',
                        isYoutube: isYouTube,
                        isFile: thumbnailIsFile,
                        tappable: false,
                      ),
                    );
                  },
                )
              else
                const SizedBox.shrink(),
              if (getMoreDetails) ...[
                InfoField(
                  controller: tutorNameController,
                  keyboardType: TextInputType.name,
                  autoFocus: true,
                  focusNode: tutorNameFocusNode,
                  labelText: 'Nom du tuteur',
                  hintStyle: TextStyle(
                    fontFamily: Fonts.merriweather,
                  ),
                  onEditingComplete: () {
                    setState(() {});
                    videoTitleFocusNode.requestFocus();
                  },
                ),
                InfoField(
                  controller: videoTitleController,
                  labelText: 'Titre de la vidéo',
                  hintStyle: TextStyle(
                    fontFamily: Fonts.merriweather,
                  ),
                  focusNode: videoTitleFocusNode,
                  onEditingComplete: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {});
                  },
                ),
              ],
              const SizedBox(height: 20),
              Center(
                child: ReactiveButton(
                  disabled: video == null,
                  loading: loading,
                  text: 'Valider',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (courseNotifier.value != null && video != null) {
                        video = video!.copyWith(
                          title: isYouTube
                              ? videoTitleController.text.trim().isNotEmpty
                                  ? videoTitleController.text.trim()
                                  : video!.title
                              : videoTitleController.text.trim(),
                          tutor: tutorNameController.text.trim().isNotEmpty
                              ? tutorNameController.text.trim()
                              : video!.tutor,
                          courseId: courseNotifier.value!.id,
                          thumbnailIsFile: thumbnailIsFile,
                          videoIsFile: videoIsFile,
                          uploadDate: DateTime.now(),
                        );

                        // Vérifiez que les champs nécessaires sont bien remplis
                        if (video != null &&
                            video!.thumbnail != null &&
                            video!.tutor != null) {
                          context.read<VideoCubit>().addVideo(video!);
                        }
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  reset();
                  video = await AdminUtils.pickVideo() as VideoModel?;
                  if (video != null) {
                    setState(() {
                      getMoreDetails = true;
                      thumbnailIsFile = true;
                      videoIsFile = true;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colours.primaryColour,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.video_library, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      urlController.text.trim().isNotEmpty
                          ? 'Remplacer la vidéo par URL'
                          : 'Ajouter une vidéo depuis la galerie',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: Fonts.merriweather,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
