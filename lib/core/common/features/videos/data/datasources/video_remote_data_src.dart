import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app_project/core/common/features/videos/data/models/video_model.dart';
import 'package:edu_app_project/core/common/features/videos/domain/entities/video.dart';
import 'package:edu_app_project/core/errors/exceptions.dart';
import 'package:edu_app_project/core/utils/datasource_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class VideoRemoteDataSrc {
  Future<void> addVideo(Video video);

  Future<List<VideoModel>> getVideos(String courseId);
}

class VideoRemoteDataSrcImpl implements VideoRemoteDataSrc {
  const VideoRemoteDataSrcImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required FirebaseStorage storage,
  })  : _firestore = firestore,
        _auth = auth,
        _storage = storage;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;

  @override
  Future<void> addVideo(Video video) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      final videoRef = _firestore
          .collection('courses')
          .doc(video.courseId)
          .collection('videos')
          .doc();
      var videoModel = (video as VideoModel).copyWith(id: videoRef.id);
      if (videoModel.videoIsFile) {
        final videoFileRef = _storage.ref().child(
              'courses/${videoModel.courseId}/videos/${videoModel.id}/video',
            );
        await videoFileRef
            .putFile(File(videoModel.videoURL))
            .then((value) async {
          final url = await value.ref.getDownloadURL();
          videoModel = videoModel.copyWith(videoURL: url);
        });
      }
      if (videoModel.thumbnailIsFile) {
        final thumbnailFileRef = _storage.ref().child(
              'courses/${videoModel.courseId}/videos/${videoModel.id}/thumbnail',
            );
        await thumbnailFileRef
            .putFile(File(videoModel.thumbnail!))
            .then((value) async {
          final url = await value.ref.getDownloadURL();
          videoModel = videoModel.copyWith(thumbnail: url);
        });
      }
      await videoRef.set(videoModel.toMap());

      await _firestore.collection('courses').doc(video.courseId).update({
        'numberOfVideos': FieldValue.increment(1),
      });
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Erreur Inconnue',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<List<VideoModel>> getVideos(String courseId) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      final videosRef =
          _firestore.collection('courses').doc(courseId).collection('videos');
      final videos = await videosRef.get();
      return videos.docs.map((e) => VideoModel.fromMap(e.data())).toList();
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Erreur Inconnue',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }
}
