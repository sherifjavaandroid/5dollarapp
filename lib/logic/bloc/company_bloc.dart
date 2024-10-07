import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/ompany_repository.dart';
import 'company_event.dart';
import 'company_state.dart';
class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final CompanyRepository repository;

  CompanyBloc({required this.repository}) : super(CompanyInitial()) {
    on<FetchCompany>(_onFetchCompany);
    on<DeleteCompany>(_onDeleteCompany);
    on<CreateCompany>(_onCreateCompany);
    on<UpdateCompany>(_onUpdateCompany);
  }

  Future<void> _onFetchCompany(
      FetchCompany event,
      Emitter<CompanyState> emit,
      ) async {
    emit(CompanyLoading());
    try {
      final company = await repository.getCompany(event.id);
      emit(CompanyLoaded(company));
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
      emit(CompanyUpdated(result));
    } catch (e) {
      emit(CompanyError(e.toString()));
    }
  }
}