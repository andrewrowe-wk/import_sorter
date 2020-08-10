// 📦 Package imports:
import 'package:test/test.dart';

import 'package:import_sorter/file_parser/utils/parser_helpers.dart';
import 'package:import_sorter/file_parser/utils/string_seeker.dart';

void main() {
  group('Parser Helpers', () {
    test('parseWhitespace() should work as expected', () {
      final seeker1 = StringSeeker('     \n\tabcd');
      final seeker2 = StringSeeker('abcd');

      expect(parseWhitespace(seeker1), '     \n\t');
      try {
        parseWhitespace(seeker2);
      } on FormatException {
        // TODO: Add testing for parse error message
        expect(true, true);
      }
    });

    test('parseSimpleToken() should work as expected', () {
      final seeker1 = StringSeeker('import');
      final seeker2 = StringSeeker('test');

      expect(parseSimpleToken(seeker1, 'import'), 'import');
      try {
        parseSimpleToken(seeker2, 'import');
      } on FormatException {
        // TODO: Add testing for parse error message
        expect(true, true);
      }
    });

    test('parseUri() should work as expected', () {
      final seeker1 = StringSeeker('\'itdoesntmatterwhatsinhere\' ');
      final seeker2 = StringSeeker('\'\\\'\\\"\\\"\'');
      final seeker3 = StringSeeker('notwrappedinquotes');
      final seeker4 = StringSeeker('\'\'\'test\'\'\'');
      final seeker5 = StringSeeker('\"\"\"test\"\"\"');

      expect(parseUri(seeker1), '\'itdoesntmatterwhatsinhere\'');
      expect(parseUri(seeker2), '\'\\\'\\\"\\\"\''); 
      
      // If not wrapped in quotes, should fail
      try {
        parseUri(seeker3);
      } on FormatException catch(e) {
        // TODO: Add testing for parse error message
        expect(e.message.contains('wrapped in quotes'), true);
      }
      
      // If wrapped in ''', should fail
      try {
        parseUri(seeker4);
      } on FormatException catch(e) {
        // TODO: Add testing for parse error message
        expect(e.message.contains('does not work with multiline strings'), true);
      }

      // If wrapped in """, should fail
      try {
        parseUri(seeker5);
      } on FormatException catch(e) {
        // TODO: Add testing for parse error message
        expect(e.message.contains('does not work with multiline strings'), true);
      }
    });

    test('parseIdentifier() should work as expected', () {
      final seeker1 = StringSeeker('asdf');
      final seeker2 = StringSeeker('  ');

      expect(parseIdentifier(seeker1), 'asdf');

      try {
         parseIdentifier(seeker2);
      } on FormatException {
        // TODO: Add testing for parse error message
        expect(true, true);
      }
    });

    test('consumeUntilNextStatement() should work as expected', () {
      final seeker1 = StringSeeker('import ;       import2');
      final seeker2 = StringSeeker('import;import');

      expect(consumeUntilNextStatement(seeker1), 'import ;');
      expect(seeker1.peekNextToken(), 'import2');

      expect(consumeUntilNextStatement(seeker2), 'import;');
      expect(seeker2.peekNextToken(), 'import');
    });

    test('isWrappedInQuotes() should work as expected', () {
      expect(isWrappedInQuotes('\'sdf\''), true);
      expect(isWrappedInQuotes('\"\"'), true);
      expect(isWrappedInQuotes('asdf'), false);
      expect(isWrappedInQuotes('\'asdf'), false);
      expect(isWrappedInQuotes('asdf\''), false);
    });

    test('isWrappedInQuotes() should work as expected', () {
      expect(isWrappedInQuotes('\'\'\''), true);
      expect(isWrappedInQuotes('\"\"\"'), true);
      expect(isWrappedInQuotes('\'asdf'), false);
      expect(isWrappedInQuotes('asdf\"'), false);
    });
  });
}
