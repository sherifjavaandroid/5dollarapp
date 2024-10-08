import 'package:equatable/equatable.dart';

import '../../model/company.dart';

abstract class CompanyEvent extends Equatable {
  const CompanyEvent();

  @override
  List<Object> get props => [];
}

class FetchCompanies extends CompanyEvent {}

class CreateCompany extends CompanyEvent {
  final Company company;

  const CreateCompany(this.company);

  @override
  List<Object> get props => [company];
}

class UpdateCompany extends CompanyEvent {
  final String id;
  final Company company;

  const UpdateCompany(this.id, this.company);

  @override
  List<Object> get props => [id, company];
}

class DeleteCompany extends CompanyEvent {
  final String id;

  const DeleteCompany(this.id);

  @override
  List<Object> get props => [id];
}
