class ConnectionException implements Exception {
  final String message;

  const ConnectionException(this.message);

  @override
  String toString() => 'ConnectionException: ';
}
