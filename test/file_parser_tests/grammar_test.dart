// 📦 Package imports:
import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';

import 'package:import_sorter/file_parser/grammar.dart';
import './data/import_statement_text.dart' as test_text;

void testParser(final Parser p, final String test, [ final String expected ]) {
  final parseResult = p.parse(test);

  expect(parseResult.isSuccess, true);
  expect(parseResult.value, expected ?? test);
}

void testToken(final Parser p, final String test, [final String expected]) {
  final parseResult = p.parse('   $test   ');

  testParser(p, test, expected);
  expect(parseResult.isSuccess, true);
  expect(parseResult.value, expected ?? test);
}

void parseShouldFail(final Parser p, final String test) {
  expect(p.parse(test).isFailure, true);
}

void singleQuoteStringTests(final Parser p) {
  testToken(p, '\'test\'');
  testToken(p, '\' test \'');
  testToken(p, '\'\'');
  testToken(p, '\'        \'');
  parseShouldFail(p, '\'1hello"'); // Mismatch quotes
  expect(p.parse('\'\'\'test\'\'\'').value, '\'\'');
}

void doubleQuoteStringTests(final Parser p) {
  testToken(SINGLE_LINE_STRING2, '"test"');
  testToken(SINGLE_LINE_STRING2, '" test "');
  testToken(SINGLE_LINE_STRING2, '""');
  testToken(SINGLE_LINE_STRING2, '"        "');
  parseShouldFail(SINGLE_LINE_STRING2, '\'1hello"'); // Mismatch quotes
  expect(SINGLE_LINE_STRING2.parse('"""test"""').value, '""');
}

void parseAndTestMappedResult(final Parser p, final ParseType type, final String value) {
  final result = p.parse(value).value as ParserOutput;

  expect(result.type, type);
  expect(result.value, value.trim());
}

void testMappedParseResult(final ParserOutput result, final ParseType type, final String value, {final trim = true}) {
  expect(result.type, type);
  expect(result.value, trim ? value.trim() : value);
}

void testMappedImportBlockResults(final List<ParserOutput> results) {
  expect(results[0].type, ParseType.Import);
  expect(results[0].value, test_text.importBlockStatement1);

  expect(results[1].type, ParseType.Import);
  expect(results[1].value, test_text.importBlockStatement2);

  expect(results[2].type, ParseType.Comment);
  expect(results[2].value, test_text.importBlockStatement3);

  expect(results[3].type, ParseType.Comment);
  expect(results[3].value, test_text.importBlockStatement4);

  expect(results[4].type, ParseType.Comment);
  expect(results[4].value, test_text.importBlockStatement5);

  expect(results[5].type, ParseType.Comment);
  expect(results[5].value, test_text.importBlockStatement6);

  expect(results[6].type, ParseType.Import);
  expect(results[6].value, test_text.importBlockStatement7);

  expect(results[7].type, ParseType.Comment);
  expect(results[7].value, test_text.importBlockStatement8);

  expect(results[8].type, ParseType.Comment);
  expect(results[8].value, test_text.importBlockStatement9);

  expect(results[9].type, ParseType.Comment);
  expect(results[9].value, test_text.importBlockStatement10);
}

void main() {
  group('Grammars', () {
    test('NEWLINE should work as expected', () {
      testParser(NEWLINE, '\n');
      testParser(NEWLINE, '\r');
      testParser(NEWLINE, '\n\r');
      testParser(NEWLINE, '\r\n');
    });

    test('SINGLE_QUOTE should work as expected', () {
      testParser(SINGLE_QUOTE, '\'');
      testParser(SINGLE_QUOTE, '\'\'\'', '\'');
    });

    test('DOUBLE_QUOTE should work as expected', () {
      testParser(DOUBLE_QUOTE, '\"');
      testParser(DOUBLE_QUOTE, '"""', '"');
    });

    test('UNDERSCORE should work as expected', () {
      testParser(UNDERSCORE, '_');
    });

    test('DOLLAR should work as expected', () {
      testParser(DOLLAR, '\$');
    });

    test('BLOCK_COMMENT_START should work as expected', () {
      testToken(BLOCK_COMMENT_START, '/*');
    });

    test('BLOCK_COMMENT_END should work as expected', () {
      testToken(BLOCK_COMMENT_END, '*/');
    });

    test('LINE_COMMENT_MARKER should work as expected', () {
      testToken(LINE_COMMENT_MARKER, '//');
      testToken(LINE_COMMENT_MARKER, '///', '//');
    });

    test('IDENTIFIER should work as expected', () {
      testToken(IDENTIFIER, 'var1');
      testToken(IDENTIFIER, '_private_var');
      testToken(IDENTIFIER, '\$dollar_sign_var1');
      testToken(IDENTIFIER, '_\$testingBoth');

      parseShouldFail(IDENTIFIER, '1hello');
    });



    test('SINGLE_LINE_STRING1 should work as expected', () {
      singleQuoteStringTests(SINGLE_LINE_STRING1);
    });

    test('SINGLE_LINE_STRING2 should work as expected', () {
      doubleQuoteStringTests(SINGLE_LINE_STRING2);
    });

    test('AS should work as expected', () {
      testToken(AS, 'as');
    });

    test('DEFERRED should work as expected', () {
      testToken(DEFERRED, 'deferred');
    });

    test('SHOW should work as expected', () {
      testToken(SHOW, 'show');
    });

    test('HIDE should work as expected', () {
      testToken(HIDE, 'hide');
    });

    test('IMPORT should work as expected', () {
      testToken(IMPORT, 'import');
    });

    test('SEMI_COLON should work as expected', () {
      testToken(SEMI_COLON, ';');
    });

    test('COMMA should work as expected', () {
      testToken(COMMA, ',');
    });

    test('STRING should work as expected', () {
      singleQuoteStringTests(STRING);
      doubleQuoteStringTests(STRING);
    });

    test('COMMENT should work as expected', () {
      parseAndTestMappedResult(COMMENT, ParseType.Comment, '/* testing */');
      parseAndTestMappedResult(COMMENT, ParseType.Comment, ' /*testing //fake comment inside */ ');
      parseAndTestMappedResult(COMMENT, ParseType.Comment, '/**/');
      parseAndTestMappedResult(COMMENT, ParseType.Comment, '''

      /*
       * multiline
       */
      
      ''');
      parseAndTestMappedResult(COMMENT, ParseType.Comment, '// Test');
      parseAndTestMappedResult(COMMENT, ParseType.Comment, ' //hello ');
      parseAndTestMappedResult(COMMENT, ParseType.Comment, '/// this is the best  ');
      parseAndTestMappedResult(COMMENT, ParseType.Comment, '/// comment // comment //comment should only be one');
    });

    test('COMBINATOR_LIST should work as expected', () {
      testParser(COMBINATOR_LIST, 'show test,one,two');
      testParser(COMBINATOR_LIST, 'show test hide one, two,     three  ');
    });

    test('ALIAS should work as expected', () {
      testParser(ALIAS, 'as test_import');
      testParser(ALIAS, '  deferred   as    _test_import  ');
    });

    test('URI should work as expected', () {
      singleQuoteStringTests(URI);
      doubleQuoteStringTests(URI);
    });

    test('IMPORT_STATEMENT should work as expected', () {
      parseAndTestMappedResult(IMPORT_STATEMENT, ParseType.Import, test_text.importStatement1);
      parseAndTestMappedResult(IMPORT_STATEMENT, ParseType.Import, test_text.importStatement2);
      parseAndTestMappedResult(IMPORT_STATEMENT, ParseType.Import, test_text.importStatement3);
    });

    test('IMPORT_BLOCK should work as expected', () {
      final results = IMPORT_BLOCK.parse(test_text.importBlock).value;

      testMappedImportBlockResults(results);
    });

    test('FILE_GRAMMAR should work as expected', () {
      final results = FILE_GRAMMAR.parse(test_text.sampleFileText).value;
      
      // File with header, import block and body
      testMappedParseResult(results[0], ParseType.Header, test_text.sampleFileHeader, trim: false);
      testMappedImportBlockResults(results[1]);
      testMappedParseResult(results[2], ParseType.Body, test_text.sampleFileBody, trim: false);

      // File with no header
      final results2 = FILE_GRAMMAR.parse(test_text.sampleFileNoHeader).value;

      testMappedParseResult(results2[0], ParseType.Header, '', trim: false);
      testMappedImportBlockResults(results2[1]);
      testMappedParseResult(results2[2], ParseType.Body, test_text.sampleFileBody, trim: false);

      // File with no import
      final results3 = FILE_GRAMMAR.parse('').value;
      expect(results3[0].value, '');
      expect(results3[1], null);
      expect(results3[2].value, '');
    });
  });
}
