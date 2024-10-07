import 'package:equatable/equatable.dart';

import '../../model/company.dart';
import '../../model/create_result.dart';
import '../../model/delete_result.dart';
import '../../model/update_result.dart';

abstract class CompanyState extends Equatable {
  const CompanyState();

  @override
  List<Object> get props => [];
}

class CompanyInitial extends CompanyState {}

class CompanyLoading extends CompanyState {}

class CompanyLoaded extends CompanyState {
  final Company company;

  const CompanyLoaded(this.company);

  @override
  List<Object> get props => [company];
}

class CompanyDeleted extends CompanyState {
  final DeleteResult result;

  const CompanyDeleted(this.result);

  @override
  List<Object> get props => [result];
}

class CompanyCreated extends CompanyState {
  final CreateResult result;

  const CompanyCreated(this.result);

  @override
  List<Object> get props => [result];
}

class CompanyUpdated extends CompanyState {
  final UpdateResult result;

  const CompanyUpdated(this.result);

  @override
  List<Object> get props => [result];
}

class CompanyError extends CompanyState {
  final String message;

  const CompanyError(this.message);

  @override
  List<Object> get props => [message];
}
