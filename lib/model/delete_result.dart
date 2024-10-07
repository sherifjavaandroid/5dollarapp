class DeleteResult {
  final String message;
  final int? rowsAffected;

  DeleteResult({required this.message, this.rowsAffected});

  factory DeleteResult.fromJson(Map<String, dynamic> json) {
    return DeleteResult(
      message: json['message'],
      rowsAffected: json['rows_affected'],
    );
  }

}