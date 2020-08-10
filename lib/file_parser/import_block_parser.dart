import 'package:import_sorter/file_parser/models/import_statement.dart';
import 'package:import_sorter/file_parser/utils/parser_helpers.dart';
import 'package:import_sorter/file_parser/utils/string_seeker.dart';

List<ImportStatement> parseImportBlock(final StringSeeker seeker) {
  final returnVal = List<String>();
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