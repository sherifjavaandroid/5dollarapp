import 'package:dio/dio.dart';
import '../model/company.dart';
import '../model/create_result.dart';
import '../model/delete_result.dart';
import '../model/update_result.dart';

class CompanyRepository {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://arvenscans.org/api.php';

  CompanyRepository() {
    _dio.interceptors.add(LoggingInterceptor());
  }

  Future<List<Company>> getCompanies() async {
    try {
      final response = await _dio.get(_baseUrl);
      if (response.data is List) {
        return (response.data as List).map((json) => Company.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to load companies data: $e');
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
    } catch (e) {
      throw Exception('Failed to create company: $e');
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
    } catch (e) {
      throw Exception('Failed to update company: $e');
    }
  }

  Future<DeleteResult> deleteCompany(String id) async {
    try {
      final response = await _dio.delete('$_baseUrl/$id');
      return DeleteResult.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to delete company: $e');
    }
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    print('Headers:');
    options.headers.forEach((key, value) {
      print('$key: $value');
    });
    if (options.data != null) {
      print('Request Data:');
      print(options.data);
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    print('Response Data:');
    print(response.data);
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    print('Error Message: ${err.message}');
    if (err.response != null) {
      print('Error Response Data:');
      print(err.response!.data);
    }
    return super.onError(err, handler);
  }
}