part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initOnBoarding();
  await _initAuthentication();
  await _initChat();
  await _initUser();
  await _initLeaderboard();
  await _initNotifications();
  await _initCourse();
  await _initVideo();
  await _initExam();
  await _initMaterial();
  await _initSubscription();
  await _initScholarship();
}

Future<void> _initScholarship() async {
  sl
    ..registerFactory(
      () => ScholarshipCubit(
        addScholarship: sl(),
        getScholarships: sl(),
      ),
    )
    ..registerLazySingleton(() => AddScholarship(sl()))
    ..registerLazySingleton(() => GetScholarships(sl()))
    ..registerLazySingleton<ScholarshipRepo>(() => ScholarshipRepoImpl(sl()))
    ..registerLazySingleton<ScholarshipRemoteDataSrc>(
      () => ScholarshipRemoteDataSrcImpl(
        firestore: sl(),
        storage: sl(),
        auth: sl(),
      ),
    );
}

Future<void> _initSubscription() async {
  sl
    ..registerFactory(
      () => SubscriptionBloc(
        createPaymentIntent: sl(),
        confirmPaymentIntent: sl(),
      ),
    )
    ..registerLazySingleton(() => CreatePaymentIntent(sl()))
    ..registerLazySingleton(() => ConfirmPaymentIntent(sl()))
    ..registerLazySingleton<SubscriptionRepo>(() => SubscriptionRepoImpl(sl()))
    ..registerLazySingleton<SubscriptionRemoteDataSrc>(
      () => SubscriptionRemoteDataSrcImpl(
        firestore: sl(),
        auth: sl(),
        client: sl(),
      ),
    )
    ..registerLazySingleton(http.Client.new);
}

Future<void> _initUser() async {
  sl
    ..registerFactory(
      () => UserCubit(
        addPoints: sl(),
        getUserById: sl(),
      ),
    )
    ..registerLazySingleton(() => AddPoints(sl()))
    ..registerLazySingleton(() => GetUserById(sl()))
    ..registerLazySingleton<UserRepo>(() => UserRepoImpl(sl()))
    ..registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(
        firestore: sl(),
        auth: sl(),
      ),
    );
}

Future<void> _initChat() async {
  sl
    ..registerFactory(
      () => ChatCubit(
        sendMessage: sl(),
        getMessages: sl(),
        getGroups: sl(),
        joinGroup: sl(),
        getPreviousMessages: sl(),
        leaveGroup: sl(),
      ),
    )
    ..registerFactory(() => ChatController(store: sl()))
    ..registerLazySingleton(() => SendMessage(sl()))
    ..registerLazySingleton(() => GetMessages(sl()))
    ..registerLazySingleton(() => GetGroups(sl()))
    ..registerLazySingleton(() => JoinGroup(sl()))
    ..registerLazySingleton(() => LeaveGroup(sl()))
    ..registerLazySingleton(() => GetPreviousMessages(sl()))
    ..registerLazySingleton<ChatRepo>(() => ChatRepoImpl(sl()))
    ..registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(
        firestore: sl(),
        auth: sl(),
        storage: sl(),
      ),
    );
}

Future<void> _initNotifications() async {
  sl
    ..registerFactory(
      () => NotificationCubit(
        clear: sl(),
        clearAll: sl(),
        getNotifications: sl(),
        markAsRead: sl(),
        sendNotification: sl(),
      ),
    )
    ..registerLazySingleton(() => Clear(sl()))
    ..registerLazySingleton(() => ClearAll(sl()))
    ..registerLazySingleton(() => GetNotifications(sl()))
    ..registerLazySingleton(() => MarkAsRead(sl()))
    ..registerLazySingleton(() => SendNotification(sl()))
    ..registerLazySingleton<NotificationRepo>(() => NotificationRepoImpl(sl()))
    ..registerLazySingleton<NotificationRemoteDataSrc>(
      () => NotificationRemoteDataSrcImpl(firestore: sl(), auth: sl()),
    );
}

Future<void> _initMaterial() async {
  sl
    ..registerFactory(
      () => MaterialCubit(
        addMaterial: sl(),
        getMaterials: sl(),
      ),
    )
    ..registerLazySingleton(() => AddMaterial(sl()))
    ..registerLazySingleton(() => GetMaterials(sl()))
    ..registerLazySingleton<MaterialRepo>(() => MaterialRepoImpl(sl()))
    ..registerLazySingleton<MaterialRemoteDataSrc>(
      () => MaterialRemoteDataSrcImpl(
        firestore: sl(),
        auth: sl(),
        storage: sl(),
      ),
    )
    ..registerFactory(() => ResourceController(storage: sl(), prefs: sl()));
}

Future<void> _initExam() async {
  sl
    ..registerFactory(
      () => ExamCubit(
        getExams: sl(),
        getExamQuestions: sl(),
        getUserExams: sl(),
        getUserCourseExams: sl(),
        submitExam: sl(),
        uploadExam: sl(),
        updateExam: sl(),
      ),
    )
    ..registerLazySingleton(() => GetExams(sl()))
    ..registerLazySingleton(() => GetExamQuestions(sl()))
    ..registerLazySingleton(() => GetUserExams(sl()))
    ..registerLazySingleton(() => SubmitExam(sl()))
    ..registerLazySingleton(() => UploadExam(sl()))
    ..registerLazySingleton(() => UpdateExam(sl()))
    ..registerLazySingleton(() => GetUserCourseExams(sl()))
    ..registerLazySingleton<ExamRepo>(() => ExamRepoImpl(sl()))
    ..registerLazySingleton<ExamRemoteDataSrc>(
      () => ExamRemoteDataSrcImpl(firestore: sl(), auth: sl()),
    );
}

Future<void> _initVideo() async {
  sl
    ..registerFactory(() => VideoCubit(addVideo: sl(), getVideos: sl()))
    ..registerLazySingleton(() => AddVideo(sl()))
    ..registerLazySingleton(() => GetVideos(sl()))
    ..registerLazySingleton<VideoRepo>(() => VideoRepoImpl(sl()))
    ..registerLazySingleton<VideoRemoteDataSrc>(
      () => VideoRemoteDataSrcImpl(firestore: sl(), auth: sl(), storage: sl()),
    );
}

Future<void> _initCourse() async {
  sl
    ..registerFactory(
      () => CourseCubit(
        addCourse: sl(),
        getCourse: sl(),
        getCourses: sl(),
      ),
    )
    ..registerLazySingleton(() => AddCourse(sl()))
    ..registerLazySingleton(() => GetCourse(sl()))
    ..registerLazySingleton(() => GetCourses(sl()))
    ..registerLazySingleton<CourseRepo>(
      () => CourseRepoImpl(sl()),
    )
    ..registerLazySingleton<CourseRemoteDataSrc>(
      () => CourseRemoteDataSrcImpl(firestore: sl(), auth: sl(), storage: sl()),
    );
}

Future<void> _initLeaderboard() async {
  sl
    ..registerFactory(
      () => LeaderboardCubit(sl()),
    )
    ..registerLazySingleton(() => GetLeaderboard(sl()))
    ..registerLazySingleton<LeaderboardRepo>(() => LeaderboardRepoImpl(sl()))
    ..registerLazySingleton<LeaderboardRemoteDataSrc>(
      () => LeaderboardRemoteDataSrcImpl(firestore: sl(), auth: sl()),
    );
}

Future<void> _initAuthentication() async {
  sl
    ..registerFactory(
      () => AuthBloc(
        signIn: sl(),
        signUp: sl(),
        forgotPassword: sl(),
        updateUser: sl(),
      ),
    )
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()))
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        authClient: sl(),
        cloudStoreClient: sl(),
        dbClient: sl(),
      ),
    )
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance);
}

Future<void> _initOnBoarding() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl
    ..registerFactory(
      () => OnBoardingCubit(
        cacheFirstTimer: sl(),
        checkIfUserIsFirstTimer: sl(),
      ),
    )
    ..registerLazySingleton(() => CacheFirstTimer(sl()))
    ..registerLazySingleton(() => CheckIfUserIsFirstTimer(sl()))
    ..registerLazySingleton<OnBoardingRepo>(() => OnBoardingRepoImpl(sl()))
    ..registerLazySingleton<OnBoardingLocalDataSource>(
      () => OnBoardingLocalDataSrcImpl(sl()),
    )
    ..registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}
