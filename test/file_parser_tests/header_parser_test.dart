// 📦 Package imports:
import 'package:test/test.dart';

// 🌎 Project imports:
import 'package:import_sorter/file_parser/header_parser.dart';
import 'package:import_sorter/file_parser/string_seeker.dart';

import './header_text.dart' as test_text;


void main() {
  group('Header Parser', () {
    test('Should successfully parse all comments that appear before import', () {
      final seeker1 = StringSeeker(test_text.commentsBeforeImport1);
      final seeker2 = StringSeeker(test_text.commentsBeforeImport2);
      final seeker3 = StringSeeker(test_text.commentsBeforeImport3);

      // All returned values should be a list of String representing each
      // line, but should not contain the last 'import'
      final expectedReturnVal1 = test_text.commentsBeforeImport1ExpectedValue.split('\n');
      final expectedReturnVal2 = test_text.commentsBeforeImport2ExpectedValue.split('\n');
      final expectedReturnVal3 = test_text.commentsBeforeImport3ExpectedValue.split('\n');

      expect(parseHeader(seeker1), expectedReturnVal1);
      expect(parseHeader(seeker2), expectedReturnVal2);
      expect(parseHeader(seeker3), expectedReturnVal3);
      
      expect(seeker1.peekNextToken(), 'import');
      expect(seeker2.peekNextToken(), 'import');
      expect(seeker3.peekNextToken(), 'import');
    });
  });
}
