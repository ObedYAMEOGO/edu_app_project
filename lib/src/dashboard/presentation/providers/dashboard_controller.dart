import 'package:edu_app_project/core/common/app/providers/tab_navigator.dart';
import 'package:edu_app_project/core/common/features/course/presentation/cubit/course_cubit.dart';
import 'package:edu_app_project/core/common/features/videos/presentation/app/cubit/video_cubit.dart';
import 'package:edu_app_project/core/common/views/persistent_view.dart';
import 'package:edu_app_project/core/services/injection_container.dart';
import 'package:edu_app_project/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:edu_app_project/src/chat/presentation/app/cubit/chat_cubit.dart';
import 'package:edu_app_project/src/chat/presentation/views/chat_view.dart';
import 'package:edu_app_project/src/home/presentation/views/home_view.dart';
import 'package:edu_app_project/src/notifications/presentation/cubit/notification_cubit.dart';
import 'package:edu_app_project/src/profile/presentation/views/profile_view.dart';
import 'package:edu_app_project/src/quick_access/presentation/providers/quick_access_tab_controller.dart';
import 'package:edu_app_project/src/quick_access/presentation/views/quick_access_view.dart';
import 'package:edu_app_project/src/scholarship/presentation/app/cubit/scholarship_cubit.dart';
import 'package:edu_app_project/src/scholarship/presentation/views/scholarship_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class DashboardController extends ChangeNotifier {
  List<int> _indexHistory = [0];
  final List<Widget> _screens = [
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<CourseCubit>()),
              BlocProvider(create: (_) => sl<VideoCubit>()),
              BlocProvider(create: (_) => sl<NotificationCubit>()),
            ],
            child: const HomeView(),
          ),
        ),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: BlocProvider(
            create: (context) => sl<CourseCubit>(),
            child: ChangeNotifierProvider(
              create: (_) => QuickAccessTabController(),
              child: const QuickAccessView(),
            ),
          ),
        ),
      ),
      child: const PersistentView(),
    ),
    BlocProvider(
      create: (context) => sl<ChatCubit>(),
      child: ChangeNotifierProvider(
        create: (_) => TabNavigator(TabItem(child: const ChatView())),
        child: const PersistentView(),
      ),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: BlocProvider(
            create: (_) => sl<ScholarshipCubit>(),
            child: const ScholarshipView(),
          ),
        ),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(TabItem(
          child: BlocProvider(
              create: (_) => sl<AuthBloc>(), child: ProfileView()))),
      child: const PersistentView(),
    ),
  ];

  List<Widget> get screens => _screens;
  int _currentIndex = 4;

  int get currentIndex => _currentIndex;

  void changeIndex(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    _indexHistory.add(index);
    notifyListeners();
  }

  void goBack() {
    if (_indexHistory.length == 1) return;
    _indexHistory.removeLast();
    _currentIndex = _indexHistory.last;
    notifyListeners();
  }

  void resetIndex() {
    _indexHistory = [0];
    _currentIndex = 0;
    notifyListeners();
  }
}
