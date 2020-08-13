import 'package:import_sorter/file_parser/models/import_statement.dart';
import 'package:petitparser/petitparser.dart';

// TODO: To support multiline strings, we just need to write another token parser for
//       multiline strings and call it MULTI_LINE_STRING, then we can use it as follows:
// TODO: Show/hide parsing needs to exclude 'show' and 'hide' keywords when attempting
//       to parse variable name
//       final URI = (SINGLE_LINE_STRING | MULTI_LINE_STRING).flatten();
// TODO: Import grammar does not take inline comments into account
// Using https://github.com/petitparser/dart-petitparser

// 

enum ParseType {
  Import,
  Comment
}

class ParserOutput {
  final ParseType type;
  final String value;
  ParserOutput(final this.type, final this.value);

  String toString() {
     return '$type: $value';
   }
}

class ParsedFileOutput {
  final String headerText;
  final List<ImportStatement> imports;
  final String bodyText;
  ParsedFileOutput(final this.headerText, final this.imports, final this.bodyText);

  String toString() {
    return '$headerText\n${imports.join('\n')}\n$bodyText';
  }
}

final newlinePattern = RegExp('\r\n|\r|\n');
final stringPattern = RegExp('\'(.*)\'|"(.*)"');
final quoteRegex = RegExp('\'|"');

String getUriFromImportString(String importString) {
  final importStringNoNewlines = importString.replaceAll(newlinePattern, ' ');
  final uriWithQuotes = stringPattern.firstMatch(importStringNoNewlines).group(0);

  return uriWithQuotes.replaceAll(quoteRegex, '');
}

String buildFileBodyFrom(final List<String> commentsInImportBlock, final String body) {
  if (commentsInImportBlock.isNotEmpty) {
    const commentBlockStart = '\n\n// COMMENTS FROM IMPORT BLOCK\n\n';
    const commentBlockEnd = '\n\n// END COMMENTS FROM IMPORT BLOCK\n\n';
    final comments = commentsInImportBlock.join('\n');

    return '$commentBlockStart$comments$commentBlockEnd$body';
  } else {
    return body;
  }
}

List<ImportStatement> getImportStatementsFromParserOurput(final List<ParserOutput> output) {
  return output
    .where((o) => o.type == ParseType.Import)
    .map((o) => ImportStatement(o.value, getUriFromImportString(o.value)))
    .toList();
}

List<String> getCommentsFromParserOutput(final List<ParserOutput> output) {
  return output
    .where((o) => o.type == ParseType.Comment)
    .map((o) => o.value)
    .toList();
}

ParsedFileOutput parseFile(final String fileText) {
  final parsedFileOutput = FILE_GRAMMAR.parse(fileText).value;
  final header = parsedFileOutput[0] as String;
  final importBlock = parsedFileOutput[1] as List<ParserOutput>;
  final imports = getImportStatementsFromParserOurput(importBlock);
  final commentsInImport = getCommentsFromParserOutput(importBlock);
  final body = buildFileBodyFrom(commentsInImport, parsedFileOutput[2] as String);

  return ParsedFileOutput(header, imports, body);
}

// Import Block Grammar
// final FILE_GRAMMAR = (IMPORT_BLOCK.neg().star().flatten() & IMPORT_BLOCK.castList<ParserOutput>().optional() & any().star().flatten()).end();

// // Parser to Structured Import Mapping
// final IMPORT_BLOCK = (IMPORT_STATEMENT & (IMPORT_STATEMENT | COMMENT).star()).map(concat);

// // Import Statement Grammar
// final IMPORT_STATEMENT = (IMPORT & URI & ALIAS.optional() & COMBINATOR_LIST.optional() & SEMI_COLON).flatten().map((value) => ParserOutput(ParseType.Import, value));

// // URI Grammar (Simpler than Dart specification. Does not care about content of URI)
// final URI = SINGLE_LINE_STRING; 

// // Alias Grammar
// final ALIAS = ((AS & IDENTIFIER) | (DEFERRED_AS & IDENTIFIER)); 
// final DEFERRED_AS = (DEFERRED & AS);

// // Combinator List Grammar ('hide'/'show' list)
// final COMBINATOR_LIST = COMBINATOR.star();
// final COMBINATOR = ((SHOW & IDENTIFIER_LIST) | (HIDE & IDENTIFIER_LIST));
// final IDENTIFIER_LIST = (IDENTIFIER & MORE_IDENTIFIERS.star());
// final MORE_IDENTIFIERS = (COMMA & IDENTIFIER).map((values) => values[1]);

// // Comment Grammar
// final COMMENT = (LINE_COMMENT | BLOCK_COMMENT).flatten().map((value) => ParserOutput(ParseType.Comment, value));
// final LINE_COMMENT = LINE_COMMENT_MARKER & NEWLINE.neg().star() & NEWLINE.optional();
// final BLOCK_COMMENT = BLOCK_COMMENT_START & BLOCK_COMMENT_END.neg().star() & BLOCK_COMMENT_END;

// // [',', 'id'] -> 'id'
// List<dynamic> concat(dynamic values) => [values[0],...values[1]];

// // Tokens
// //
// // All tokens are 'trimmed', because these are things that can validly live
// // surrounded by whitespace
// final COMMA = char(',').trim();
// final SEMI_COLON = char(';').trim();
// final IMPORT = string('import').trim();
// final HIDE = string('hide').trim();
// final SHOW = string('show').trim();
// final DEFERRED = string('deferred').trim();
// final AS = string('as').trim();
// final SINGLE_LINE_STRING = (QUOTE & any().plusLazy(QUOTE) & QUOTE).trim();
// final IDENTIFIER = IDENTIFIER_GRAMMAR.trim();
// final LINE_COMMENT_MARKER = (string('//') | string('///')).trim();
// final BLOCK_COMMENT_START = string('/*').trim();
// final BLOCK_COMMENT_END = string('*/').trim();

// // Identifier Grammar (Dart-style variable name)
// final IDENTIFIER_GRAMMAR = (IDENTIFIER_START & IDENTIFIER_PART.star()).flatten();
// final IDENTIFIER_START = IDENTIFIER_START_NO_DOLLAR | DOLLAR;
// final IDENTIFIER_START_NO_DOLLAR = letter() | UNDERSCORE;
// final IDENTIFIER_PART = IDENTIFIER_START | digit();

// // Primatives
// final DOLLAR = char('\$');
// final UNDERSCORE = char('_');
// final QUOTE = char("'") | char('"');
// final NEWLINE = pattern('\n\r');
