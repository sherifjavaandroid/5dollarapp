import 'package:dio/dio.dart';
import '../model/company.dart';

import '../model/create_result.dart';
import '../model/delete_result.dart';
import '../model/update_result.dart';

class CompanyRepository {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://arvenscans.org/api.php';

  Future<Company> getCompany(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/$id');
      return Company.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load company data');
    }
  }

  Future<DeleteResult> deleteCompany(String id) async {
    try {
      final response = await _dio.delete('$_baseUrl/$id');
      return DeleteResult.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to delete company');
    }
  }
  Future<CreateResult> createCompany(Company company) async {
    try {
      final response = await _dio.post(
        _baseUrl,
        data: company.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return CreateResult.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        throw Exception(e.response!.data['error'] ?? 'Failed to create company');
      }
      throw Exception('Failed to create company');
    }
  }
  Future<UpdateResult> updateCompany(String id, Company company) async {
    try {
      final response = await _dio.patch(
        '$_baseUrl/$id',
        data: company.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return UpdateResult.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        throw Exception(e.response!.data['error'] ?? 'Failed to update company');
      }
      throw Exception('Failed to update company');
    }
  }
}