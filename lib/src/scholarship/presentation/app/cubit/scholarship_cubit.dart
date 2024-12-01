import 'package:bloc/bloc.dart';
import 'package:edu_app_project/src/scholarship/domain/entities/scholarship.dart';
import 'package:edu_app_project/src/scholarship/domain/usecases/add_scholarship.dart';
import 'package:edu_app_project/src/scholarship/domain/usecases/get_scholarships.dart';
import 'package:edu_app_project/src/scholarship/presentation/app/cubit/scholarship_state.dart';

class ScholarshipCubit extends Cubit<ScholarshipState> {
  ScholarshipCubit({
    required AddScholarship addScholarship,
    required GetScholarships getScholarships,
  })  : _addScholarship = addScholarship,
        _getScholarships = getScholarships,
        super(const ScholarshipInitial());

  final AddScholarship _addScholarship;
  final GetScholarships _getScholarships;

  Future<void> addScholarship(Scholarship scholarship) async {
    emit(
      const AddingScholarship(),
    );
    final result = await _addScholarship(scholarship);
    result.fold(
      (failure) => emit(
        ScholarshipError(failure.errorMessage),
      ),
      (_) => emit(
        const ScholarshipAdded(),
      ),
    );
  }

  Future<void> getScholarships() async {
    emit(
      const LoadingScholarships(),
    );
    final result = await _getScholarships();
    result.fold(
      (failure) => emit(
        ScholarshipError(failure.errorMessage),
      ),
      (scholarships) => emit(
        ScholarshipsLoaded(scholarships),
      ),
    );
  }
}
