class CreateResult {
  final String id;
  final String message;

  CreateResult({required this.id, required this.message});

  factory CreateResult.fromJson(Map<String, dynamic> json) {
    return CreateResult(
      id: json['id'],
      message: json['message'],
    );
  }
}