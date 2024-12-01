import 'package:bloc/bloc.dart';
import 'package:edu_app_project/core/common/features/course/domain/entities/course.dart';
import 'package:edu_app_project/core/common/features/course/domain/usecases/add_course.dart';
import 'package:edu_app_project/core/common/features/course/domain/usecases/get_course.dart';
import 'package:edu_app_project/core/common/features/course/domain/usecases/get_courses.dart';
import 'package:equatable/equatable.dart';

part 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  CourseCubit({
    required AddCourse addCourse,
    required GetCourse getCourse,
    required GetCourses getCourses,
  })  : _addCourse = addCourse,
        _getCourse = getCourse,
        _getCourses = getCourses,
        super(const CourseInitial());

  final AddCourse _addCourse;
  final GetCourse _getCourse;
  final GetCourses _getCourses;

  Future<void> addCourse(Course course) async {
    emit(const AddingCourse());
    final result = await _addCourse(course);
    result.fold(
      (failure) => emit(CourseError(failure.errorMessage)),
      (_) => emit(const CourseAdded()),
    );
  }

  Future<void> getCourse(String courseId) async {
    emit(const LoadingCourses());
    final result = await _getCourse(courseId);
    result.fold(
      (failure) => emit(CourseError(failure.errorMessage)),
      (course) => emit(CourseLoaded(course)),
    );
  }

  Future<void> getCourses() async {
    emit(const LoadingCourses());
    final result = await _getCourses();
    result.fold(
      (failure) => emit(CourseError(failure.errorMessage)),
      (courses) => emit(CoursesLoaded(courses)),
    );
  }
}
