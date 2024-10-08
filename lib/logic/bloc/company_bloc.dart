import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/ompany_repository.dart';
import 'company_event.dart';
import 'company_state.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final CompanyRepository repository;

  CompanyBloc({required this.repository}) : super(CompanyInitial()) {
    on<FetchCompanies>(_onFetchCompanies);
    on<CreateCompany>(_onCreateCompany);
    on<UpdateCompany>(_onUpdateCompany);
    on<DeleteCompany>(_onDeleteCompany);
  }

  Future<void> _onFetchCompanies(
      FetchCompanies event,
      Emitter<CompanyState> emit,
      ) async {
    emit(CompanyLoading());
    try {
      final companies = await repository.getCompanies();
      emit(CompaniesLoaded(companies));
    } catch (e) {
      emit(CompanyError(e.toString()));
    }
  }

  Future<void> _onCreateCompany(
      CreateCompany event,
      Emitter<CompanyState> emit,
      ) async {
    emit(CompanyLoading());
    try {
      final result = await repository.createCompany(event.company);
      emit(CompanyCreated(result));
      add(FetchCompanies());
    } catch (e) {
      emit(CompanyError(e.toString()));
    }
  }

  Future<void> _onUpdateCompany(
      UpdateCompany event,
      Emitter<CompanyState> emit,
      ) async {
    emit(CompanyLoading());
    try {
      final result = await repository.updateCompany(event.id, event.company);

      // Fetch the updated list of companies
      final updatedCompanies = await repository.getCompanies();

      // Check if the updated company is reflected in the fetched data
      final updatedCompany = updatedCompanies.firstWhere(
            (company) => company.id == event.id,
        orElse: () => event.company,
      );

      if (updatedCompany.nameE != event.company.nameE ||
          updatedCompany.nameA != event.company.nameA ||
          updatedCompany.addressE != event.company.addressE ||
          updatedCompany.addressA != event.company.addressA ||
          updatedCompany.logo != event.company.logo) {
        emit(CompanyUpdatedButNotReflected(result, event.company));
      } else {
        emit(CompanyUpdated(result));
      }

      emit(CompaniesLoaded(updatedCompanies));
    } catch (e) {
      emit(CompanyError(e.toString()));
    }
  }

  Future<void> _onDeleteCompany(
      DeleteCompany event,
      Emitter<CompanyState> emit,
      ) async {
    emit(CompanyLoading());
    try {
      final result = await repository.deleteCompany(event.id);
      emit(CompanyDeleted(result));
      add(FetchCompanies());
    } catch (e) {
      emit(CompanyError(e.toString()));
    }
  }
}
