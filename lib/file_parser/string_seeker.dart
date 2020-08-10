final whitespaceRegex = RegExp(r'[\s\n]');

void wrapInRangeError(void Function() closure) {
  try {
      closure();
    } on RangeError {
      throw FormatException('Expected more tokens, but reached end of file');
    }
}

class StringSeeker {
  final String _fileText;
  int _previousIndex = -1;
  int _index = 0;

  StringSeeker(final this._fileText);

  int get previousIndex => _previousIndex;
  int get currentIndex => _index;
  String get currentChar => _fileText[_index];
  String get nextChar =>_fileText[_index + 1];

  String takeOne() {
    _previousIndex = _index;
    return _takeOne();
  }

  String takeAllWhitespace() {
    _previousIndex = _index;
    String returnVal = '';
    wrapInRangeError(() {
      while (whitespaceRegex.hasMatch(currentChar)) {
        returnVal += _takeOne();
      }
    });

    return returnVal;
  }

  String takeUntilWhitespace() {
    _previousIndex = _index;
    return _getNextToken();
  }

  String takeThrough(String pattern) {
    if (pattern.length > 1) {
      throw Exception('Pattern for \'takeThrough\' cannot be longer than length of 1.');
    }

    _previousIndex = _index;
    String returnVal = '';
    wrapInRangeError(() {
      do {
        returnVal += _takeOne();
      } while (pattern != currentChar);
      returnVal += _takeOne();
    });

    return returnVal;
  }

  String peekNextToken() {
    final indexBeforePeek = _index;
    final returnVal = _getNextToken();
    _index = indexBeforePeek;

    return returnVal;
  }

  // String takeUntil(RegExp pattern) {
  //   String returnVal = '';

  //   _previousIndex = _index;

  //   while (!pattern.hasMatch(_fileText.substring(_index))) {
  //     returnVal += _takeOne();
  //   }
  // }

  String _takeOne() {
    final returnVal = currentChar;
    _index++;
    return returnVal;
  }

  String _getNextToken() {
    String returnVal = '';
    wrapInRangeError(() {
      while (_index < _fileText.length && !whitespaceRegex.hasMatch(currentChar)) {
        returnVal += _takeOne();
      }
    });

    return returnVal;
  }
}