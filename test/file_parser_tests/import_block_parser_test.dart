// 📦 Package imports:
import 'package:test/test.dart';

import 'package:import_sorter/file_parser/import_block_parser.dart';
import 'package:import_sorter/file_parser/utils/string_seeker.dart';

import './data/import_statement_text.dart' as test_text;

void main() {
  group('Import Block Parser', () {
    test('parseImportStatement() should work as expected', () {
      // final seeker1 = StringSeeker(test_text.importStatement1);
      // final seeker2 = StringSeeker(test_text.importStatement2);
      // final seeker3 = StringSeeker(test_text.importStatement3);

      //final parsedImportStatement1 = parseImportStatement(test_text.importStatement1);
      //final parsedImportStatement2 = parseImportStatement(test_text.importStatement2);
      //final parsedImportStatement3 = parseImportStatement(test_text.importStatement3);
      // print(parseImportStatement(test_text.importStatement1));
      // print(parseImportStatement(test_text.importStatement2));
      // print(parseImportStatement(test_text.importStatement3));
      print(parseFile(test_text.importStatement4));
      print(parseFile(""));
      //print(parsedImportStatement1);
      //print(parsedImportStatement2);
      //print(parsedImportStatement3);

      // expect(parsedImportStatement1.importString, test_text.importStatement1);
      // expect(parsedImportStatement2.importString, test_text.importStatement2);
      // expect(parsedImportStatement3.importString, test_text.importStatement3);

      // expect(parsedImportStatement1.uri, '\'package:import_sorter/file_parser/utils/string_seeker.dart\'');
      // expect(parsedImportStatement2.uri, '\"package:testing/test.dart\"');
      // expect(parsedImportStatement3.uri, '\'package:test/test/test.dart\'');
    });
  });
}
