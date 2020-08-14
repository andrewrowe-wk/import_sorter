class ImportStatement implements Comparable<ImportStatement> {
  final String _importString;
  final String _uri;

  ImportStatement(final this._importString, final this._uri);

  int compareTo(final ImportStatement that) {
    return this._uri.compareTo(that._uri);
  }

  String toString() => _importString;

  bool startsWith(final Pattern pattern) => _uri.startsWith(pattern);
}
