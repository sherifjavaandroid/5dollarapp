class UpdateResult {
  final String message;
  final int rowsAffected;

  UpdateResult({required this.message, required this.rowsAffected});

  factory UpdateResult.fromJson(Map<String, dynamic> json) {
    return UpdateResult(
      message: json['message'],
      rowsAffected: json['rows_affected'],
    );
  }
}