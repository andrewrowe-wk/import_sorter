

import 'package:import_sorter/file_parser/utils/string_seeker.dart';

/// Should be used when whitespace is required
String parseWhitespace(final StringSeeker seeker) {
  final whitespace = seeker.takeAllWhitespace();
  if (whitespace.isEmpty) {
    throw FormatException('Expected: Whitespace at char ${seeker.previousIndex}');
  }

  return whitespace;
}

String parseSimpleToken(final StringSeeker seeker, final String expectedValue) {
  final parsedToken = seeker.takeUntilWhitespace();
  if (expectedValue != parsedToken) {
    throw FormatException('Expected: \'$expectedValue\' at char ${seeker.previousIndex}, but got $parsedToken');
  }

  return parsedToken;
}

// String parsing is actually very complicated as it turns out
// This does not support multiline uris
String parseUri(final StringSeeker seeker) {
  final uri = seeker.takeUntilWhitespace();
  if (!isWrappedInQuotes(uri)) {
    throw FormatException('Expected: Uri at char ${seeker.previousIndex} to be wrapped in quotes.');
  }
  if (isMultiLineString(uri)) {
    throw FormatException('Expected: This parser currently does not work with multiline strings.');
  }

  return uri;
}

String parseIdentifier(final StringSeeker seeker) {
  final identifier = seeker.takeUntilWhitespace();
  if (identifier.isEmpty) {
    throw FormatException('Expected: Identifier at char ${seeker.previousIndex}');
  }

  return identifier;
}

String consumeUntilNextStatement(final StringSeeker seeker) {
  final endOfImportStatement = seeker.takeThrough(';');
  // Dispose of whitespace at end of import statement
  seeker.takeAllWhitespace();

  return endOfImportStatement;
}

bool isWrappedInQuotes(final String s) {
  const singleQuote = '\'';
  const doubleQuote = '\"';

  return s.startsWith(singleQuote) && s.endsWith(singleQuote) || s.startsWith(doubleQuote) && s.endsWith(doubleQuote);
}

bool isMultiLineString(final String s) {
  return s.startsWith('\'\'\'') || s.startsWith('\"\"\"');
}