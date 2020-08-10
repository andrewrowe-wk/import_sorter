

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
  if (wrappedInQuotes(uri)) {
    throw FormatException('Expected: Uri at char ${seeker.previousIndex} to be wrapped in quotes. (Note: This parser currently does not work with multiline strings)');
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
  final endOfImportStatement = parser.takeThrough(';');
  // Dispose of whitespace at end of import statement
  parser.takeAllWhitespace();

  return endOfImportStatement;
}

bool wrappedInQuotes(final String s) {
  const singleQuote = '\'';
  const doubleQuote = '\'';

  return s.startsWith(singleQuote) && s.endsWith(singleQuote) || s.startsWith(doubleQuote) && s.endsWith(doubleQuote);
}

ImportStatement parseImportStatement(final StringSeeker seeker) {
  String importString = '';
  String uri;
  String identifier;

  // Parse 'import' and following whitespace
  importString += parseSimpleToken(seeker, 'import');
  importString += parseWhitespace(seeker);

  // Parse 'uri' and following whitespace
  uri = parseUri(seeker);
  importString += uri;
  importString += parseWhitespace(seeker);

  // Optionally parse import identifier and following whitespace
  final nextToken = seeker.peekNextToken();
  if (nextToken == 'as') {
    // Parse 'as' and following whitespace
    importString += parseSimpleToken(seeker, 'as');
    importString += parseWhitespace(seeker);

    // Parse 'identifier' and following whitespace
    identifier = parseIdentifier(seeker);
    importString += identifier;
    importString += parseWhitespace(seeker);
  } else if (nextToken == 'deferred') {
    // Parse 'deferred' and following whitespace
    importString += parseSimpleToken(seeker, 'deferred');
    importString += parseWhitespace(seeker);

    // Parse 'as' and following whitespace
    importString += parseSimpleToken(seeker, 'as');
    importString += parseWhitespace(seeker);

    // Parse 'identifier' and following whitespace
    identifier = parseIdentifier(seeker);
    importString += identifier;
    importString += parseWhitespace(seeker);
  }

  // Parse until next statement
  importString += consumeUntilNextStatement(seeker);

  return ImportStatement(importString, uri, identifier);
}

List<String> parseBeforeImportBlock(final StringSeeker seeker) {
  return parser.takeUntil(RegExp)
}

ParsedFile parseFile(String fileText) {
  final seeker = StringSeeker(fileText);
}

class ParsedFile {
  final List<String> beforeImports;
  final List<ImportStatement> imports;
  final List<String> remainderOfFile;
}

class ImportStatement {
  final String importString;
  final String uri;
  final String identifier;

  ImportStatement(final this.importString, final this.uri, final this.identifier);
}

void main() {
  print('hello world');
}