// // TODO: To support multiline strings, we just need to write another token parser for
// //       multiline strings and call it MULTI_LINE_STRING, then we can use it as follows:
// // TODO: Show/hide parsing needs to exclude 'show' and 'hide' keywords when attempting
// //       to parse variable name
// //       final URI = (SINGLE_LINE_STRING | MULTI_LINE_STRING).flatten();
// // TODO: Import grammar does not take inline comments into account
// // Using https://github.com/petitparser/dart-petitparser

import 'package:petitparser/petitparser.dart';

enum ParseType {
  Import,
  ImportBlockComment,
  Header,
  Body
}

class ParserOutput {
  final ParseType type;
  final String value;
  ParserOutput(final this.type, final this.value);

  String toString() {
     return '$type: $value';
   }
}

// Import Block Grammar
final FILE_GRAMMAR = (FILE_HEADER.optional() & IMPORT_BLOCK.castList<ParserOutput>().optional() & FILE_BODY.optional()).end();//.map(_concat2).castList<ParserOutput>();

// Parser for File Header
final FILE_HEADER = IMPORT_BLOCK.neg().star().trim().flatten().map((value) => ParserOutput(ParseType.Header, value));

// Parser for File Body
final FILE_BODY = any().star().flatten().map((value) => ParserOutput(ParseType.Body, value));

// Parser to Structured Import Mapping
final IMPORT_BLOCK = (IMPORT_STATEMENT & (IMPORT_STATEMENT | COMMENT).star()).map(_concat).castList<ParserOutput>();

// Import Statement Grammar
final IMPORT_STATEMENT = (IMPORT & URI & ALIAS.optional() & COMBINATOR_LIST.optional() & SEMI_COLON).flatten().map((value) => ParserOutput(ParseType.Import, value.trim()));

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
final COMMENT = (_LINE_COMMENT | _BLOCK_COMMENT).flatten().map((value) => ParserOutput(ParseType.ImportBlockComment, value.trim()));
final _LINE_COMMENT = LINE_COMMENT_MARKER & NEWLINE.neg().star() & NEWLINE.optional();
final _BLOCK_COMMENT = BLOCK_COMMENT_START & BLOCK_COMMENT_END.neg().star() & BLOCK_COMMENT_END;

// String Grammar
final STRING = SINGLE_LINE_STRING1 | SINGLE_LINE_STRING2;

// [',', ['id']] -> [',', 'id']
List<dynamic> _concat(dynamic values) {
  return [values[0],...values[1]];
}

// // ['', [''], ''] -> ['', '', '']
// List<dynamic> _concat2(dynamic values) {
//   return [values[0], ...values[1], values[2]];
// }

// Tokens
//
// All tokens are 'trimmed', because these are things that can validly live
// surrounded by whitespace
final COMMA = char(',').trim();
final SEMI_COLON = char(';').trim();
final IMPORT = string('import').trim();
final HIDE = string('hide').trim();
final SHOW = string('show').trim();
final DEFERRED = string('deferred').trim();
final AS = string('as').trim();
final SINGLE_LINE_STRING1 = (SINGLE_QUOTE & SINGLE_QUOTE.neg().star() & SINGLE_QUOTE).flatten().trim();
final SINGLE_LINE_STRING2 = (DOUBLE_QUOTE & DOUBLE_QUOTE.neg().star() & DOUBLE_QUOTE).flatten().trim();
final IDENTIFIER = _IDENTIFIER_GRAMMAR.trim();
final LINE_COMMENT_MARKER = string('//').trim();
final BLOCK_COMMENT_START = string('/*').trim();
final BLOCK_COMMENT_END = string('*/').trim();

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
