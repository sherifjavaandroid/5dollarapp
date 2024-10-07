import 'package:equatable/equatable.dart';

import '../../model/company.dart';


abstract class CompanyEvent extends Equatable {
  const CompanyEvent();

  @override
  List<Object> get props => [];
}

class FetchCompany extends CompanyEvent {
  final String id;

  const FetchCompany(this.id);

  @override
  List<Object> get props => [id];
}

class DeleteCompany extends CompanyEvent {
  final String id;

  const DeleteCompany(this.id);

  @override
  List<Object> get props => [id];
}

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