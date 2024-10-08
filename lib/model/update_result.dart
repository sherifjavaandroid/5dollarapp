class UpdateResult {
  final String message;
  final int? rowsAffected;

  UpdateResult({required this.message, this.rowsAffected});

  factory UpdateResult.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return UpdateResult(message: 'Update successful, but no details returned');
    }
    return UpdateResult(
      message: json['message'] ?? 'Update successful',
      rowsAffected: json['rows_affected'],
    );
  }
}