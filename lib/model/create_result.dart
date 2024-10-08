class CreateResult {
  final String id;
  final String message;

  CreateResult({required this.id, required this.message});

  factory CreateResult.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CreateResult(id: '', message: 'Creation successful, but no details returned');
    }
    return CreateResult(
      id: json['id'] ?? '',
      message: json['message'] ?? 'Creation successful',
    );
  }
}