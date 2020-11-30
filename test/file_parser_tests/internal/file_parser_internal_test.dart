// 📦 Package imports:
import 'package:import_sorter/file_parser/internal/file_parser_internal.dart';
import 'package:test/test.dart';

void main() {
  group('File Parser Internal', () {
    test('buildBody should work as expected', () {
      expect(buildBody('hello', []), 'hello');

      expect(buildBody('hello', ['// one', '// two', '// three']),
          '''// START IMPORT BLOCK COMMENTS
// one

// two

// three
// END IMPORT BLOCK COMMENTS

hello''');
    });

    test('getUriFromImportString should work as expected', () {
      expect(
          getUriFromImportString('import \'package:test/test.dart\' as hello;'),
          'package:test/test.dart');
      expect(
          getUriFromImportString(
              'import \"package:test/test.dart\" deferred as hello hide test;'),
          'package:test/test.dart');
      expect(getUriFromImportString('''import


      'package:test/test.dart'

      hide test

      ;
      '''), 'package:test/test.dart');
    });
  });
}
