const importStatement1 = '''import
   
   'package:import_sorter/file_parser/utils/string_seeker.dart' as

   string_seeker       show StringSeeker, hide Nothing;''';

const importStatement2 = 'import \"package:testing/test.dart\" deferred as testing_package hide Test;';

const importStatement3 = 'import \'package:test/test/test.dart\' show Bill;';