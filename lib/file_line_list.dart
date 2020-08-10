/// A wrapper around a List<String> that provides some convenience
/// mechanisms for parsing.
class FileLineList {
  final List<String> _lines;
  int _counter = 0;

  FileLineList(final this._lines) { }

  String getNextLine() {
    final line = this._lines[this._counter];
    this._counter += 1;

    return line;
  }

  bool hasMoreLines() {
    return this._counter < this._lines.length;
  }
}