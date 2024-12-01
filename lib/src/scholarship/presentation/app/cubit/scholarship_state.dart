import 'package:edu_app_project/src/scholarship/domain/entities/scholarship.dart';
import 'package:equatable/equatable.dart';

abstract class ScholarshipState extends Equatable {
  const ScholarshipState();

  @override
  List<Object> get props => [];
}

class ScholarshipInitial extends ScholarshipState {
  const ScholarshipInitial();
}

class LoadingScholarships extends ScholarshipState {
  const LoadingScholarships();
}

class AddingScholarship extends ScholarshipState {
  const AddingScholarship();
}

class ScholarshipAdded extends ScholarshipState {
  const ScholarshipAdded();
}

class ScholarshipsLoaded extends ScholarshipState {
  const ScholarshipsLoaded(this.scholarships);

  final List<Scholarship> scholarships;

  @override
  List<Object> get props => [scholarships];
}

class ScholarshipError extends ScholarshipState {
  const ScholarshipError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
