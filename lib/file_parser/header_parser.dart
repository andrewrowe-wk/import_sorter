// 🌎 Project imports:
// import 'package:import_sorter/file_parser/parser_helpers.dart';
import 'package:import_sorter/file_parser/string_seeker.dart';

List<String> parseHeader(final StringSeeker seeker) {
  String headerString = '';

  // Seek until first comment
  headerString += seeker.takeAllWhitespace();

  while (seeker.peekNextToken() != 'import') {
    final nextToken = seeker.peekNextToken();

    if (nextToken.startsWith('/*')) {
      headerString += _parseBlockComment(seeker);
    } else if (nextToken.startsWith('//')) {
      headerString += seeker.takeThrough('\n');
    } else {
      headerString += seeker.takeOne();
    }
  }
  
  return headerString.split('\n');
}

String _parseBlockComment(final StringSeeker seeker) {
  String returnString = '';

  // Consume character-by-character until we reach end of block comment
  while (_shouldStopConsumingBlockComment(seeker)) {
    returnString += seeker.takeOne();
  }

  returnString += seeker.takeThrough('*');
  returnString += seeker.takeThrough('/');

  return returnString;
}

bool _shouldStopConsumingBlockComment(final StringSeeker seeker) {
  return seeker.currentChar == '*' && seeker.nextChar == '/';
}

