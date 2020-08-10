// 📦 Package imports:
import 'package:test/test.dart';

import 'package:import_sorter/file_parser/utils/parser_helpers.dart';
import 'package:import_sorter/file_parser/utils/string_seeker.dart';

void main() {
  group('Import Block Parser', () {
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
  });
}
