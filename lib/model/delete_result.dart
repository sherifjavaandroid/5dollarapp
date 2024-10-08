class DeleteResult {
  final String message;
  final int? rowsAffected;

  DeleteResult({required this.message, this.rowsAffected});

  factory DeleteResult.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return DeleteResult(message: 'Deletion successful, but no details returned');
    }
    return DeleteResult(
      message: json['message'] ?? 'Deletion successful',
      rowsAffected: json['rows_affected'],
    );
  }
}