// 📦 Package imports:
import 'package:import_sorter/file_parser/file_parser.dart';
import 'package:test/test.dart';

final header = '// This is the start of the file';

final importBlock = [
  'import \'package\' as test hide bill;',
  '// test comment in block',
  '''/*
  * block comment
  */''',
  'import \'package\' as final_import show blah;'
];

final body = '''
void main() {
  print('hello world');
}
''';

void main() {
  group('File Parser', () {
    test('parseFile should work as expected', () {
      final result = parseFile('$header${importBlock.join('\n')}$body');

      expect(result.header, header);
      expect(result.body, '''// START IMPORT BLOCK COMMENTS
${importBlock[1]}

${importBlock[2]}
// END IMPORT BLOCK COMMENTS

$body''');
      expect(result.imports[0].toString(), importBlock[0]);
      expect(result.imports[1].toString(), importBlock[3]);
    });
  });
}
