// // TODO: To support multiline strings, we just need to write another token parser for
// //       multiline strings and call it MULTI_LINE_STRING, then we can use it as follows:
// // TODO: Show/hide parsing needs to exclude 'show' and 'hide' keywords when attempting
// //       to parse variable name
// //       final URI = (SINGLE_LINE_STRING | MULTI_LINE_STRING).flatten();
// // TODO: Import grammar does not take inline comments into account
// // Using https://github.com/petitparser/dart-petitparser

import 'package:import_sorter/import_comments.dart';
import 'package:petitparser/petitparser.dart';

enum ParseType {
  Import,
  ImportBlockComment,
  Header,
  Body,
  Empty
}

class ParserOutput {
  final ParseType type;
  final String value;
  
  ParserOutput(final this.type, final this.value);
}

// Import Block Grammar
final FILE_GRAMMAR = (FILE_HEADER.optional() & IMPORT_BLOCK.castList<ParserOutput>().optional() & FILE_BODY.optional()).end();

// Parser for File Header
final FILE_HEADER = IMPORT_BLOCK.neg().star().flatten().trimWithComments().map((value) => ParserOutput(ParseType.Header, value));

// Parser for File Body
final FILE_BODY = any().star().flatten().map((value) => ParserOutput(ParseType.Body, value));

// Parser to Structured Import Mapping
final IMPORT_BLOCK = (IMPORT_STATEMENT & (IMPORT_STATEMENT | COMMENT).star()).map(_concat).castList<ParserOutput>();

// Import Statement Grammar
final IMPORT_STATEMENT = (IMPORT & URI & ALIAS.optional() & COMBINATOR_LIST.optional() & SEMI_COLON).flatten().map(mapImportStatement);//.flatten().trimWithComments().map((value) => ParserOutput(ParseType.Import, value.trim())); // This is .trim() on String, so does not need .trimWithComments()

// URI Grammar (Simpler than Dart specification. Does not care about content of URI)
final URI = STRING;

// Alias Grammar
final ALIAS = ((AS & IDENTIFIER) | (_DEFERRED_AS & IDENTIFIER)).flatten(); 
final _DEFERRED_AS = (DEFERRED & AS);

// Combinator List Grammar ('hide'/'show' list)
final COMBINATOR_LIST = _COMBINATOR.plus().flatten();
final _COMBINATOR = ((SHOW & _IDENTIFIER_LIST) | (HIDE & _IDENTIFIER_LIST));
final _IDENTIFIER_LIST = (IDENTIFIER & _MORE_IDENTIFIERS.star());
final _MORE_IDENTIFIERS = (COMMA & IDENTIFIER).map((values) => values[1]);

// Comment Grammar
final COMMENT = (_LINE_COMMENT | _BLOCK_COMMENT).flatten().map((value) => ParserOutput(ParseType.ImportBlockComment, value.trim())); // This is .trim() on String, so does not need .trimWithComments()
final _LINE_COMMENT = LINE_COMMENT_MARKER & NEWLINE.neg().star() & NEWLINE.optional();
final _BLOCK_COMMENT = BLOCK_COMMENT_START & BLOCK_COMMENT_END.neg().star() & BLOCK_COMMENT_END;

// String Grammar
final STRING = SINGLE_LINE_STRING1 | SINGLE_LINE_STRING2;

// Tokens
//
// All tokens are 'trimmed', because these are things that can validly live
// surrounded by whitespace
final COMMA = char(',').trimWithComments();
final SEMI_COLON = char(';').trimWithComments();
final IMPORT = string('import').trimWithComments();
final HIDE = string('hide').trimWithComments();
final SHOW = string('show').trimWithComments();
final DEFERRED = string('deferred').trimWithComments();
final AS = string('as').trimWithComments();
final SINGLE_LINE_STRING1 = (SINGLE_QUOTE & SINGLE_QUOTE.neg().star() & SINGLE_QUOTE).flatten().trimWithComments();
final SINGLE_LINE_STRING2 = (DOUBLE_QUOTE & DOUBLE_QUOTE.neg().star() & DOUBLE_QUOTE).flatten().trimWithComments();
final IDENTIFIER = _IDENTIFIER_GRAMMAR.trimWithComments();
final LINE_COMMENT_MARKER = string('//').trimWithComments();
final BLOCK_COMMENT_START = string('/*').trimWithComments();
final BLOCK_COMMENT_END = string('*/').trimWithComments();

// Identifier Grammar (Dart-style variable name)
final _IDENTIFIER_GRAMMAR = (_IDENTIFIER_START & _IDENTIFIER_PART.star()).flatten();
final _IDENTIFIER_START = _IDENTIFIER_START_NO_DOLLAR | DOLLAR;
final _IDENTIFIER_START_NO_DOLLAR = letter() | UNDERSCORE;
final _IDENTIFIER_PART = _IDENTIFIER_START | digit();

// Primatives
final DOLLAR = char('\$');
final UNDERSCORE = char('_');
final SINGLE_QUOTE = char("'");
final DOUBLE_QUOTE = char('"');
final NEWLINE = string('\n\r') | string('\r\n') | pattern('\n\r');

// Whitespace
// We treat the added import comments as whitespace so we can safely
// re-add them after 
//
// This is where new types of import comments should be added.
final WHITESPACE = whitespace() | 
                   string(dartEmojis) |
                   string(dartNoEmojis) |
                   string(flutterEmojis) |
                   string(flutterNoEmojis) |
                   string(packageEmojis) |
                   string(packageNoEmojis) |
                   string(projectEmojis) |
                   string(projectNoEmojis);

// [',', ['id']] -> [',', 'id']
List<dynamic> _concat(dynamic values) {
  return [values[0],...values[1]];
}

const rcrText = '($dartEmojis|$dartNoEmojis|$flutterEmojis|$flutterNoEmojis|$packageEmojis|$packageNoEmojis|$projectEmojis|$projectNoEmojis)';
final removeCommentRegex = RegExp(rcrText);
ParserOutput mapImportStatement(final String importPieces) {
  return ParserOutput(ParseType.Import, importPieces.replaceAll(removeCommentRegex, '').trim());
}

extension TrimmingParserExtensionWithComments<T> on Parser<T> {
  /// Works the same way as 'trim()' but includes the comments that we want to ignore
  Parser<T> trimWithComments([Parser left, Parser right]) =>
      TrimmingParser<T>(this, left ??= WHITESPACE, right ??= left);
}
