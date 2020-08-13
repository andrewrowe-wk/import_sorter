const importStatement1 = '''import
   
   'package:import_sorter/file_parser/utils/string_seeker.dart' as

   string_seeker       show StringSeeker hide           
   
   Nothing;


   ''';
const importStatement2 = ' import \"package:testing/test.dart\" deferred as testing_package hide Test;   ';
const importStatement3 = 'import \'package:test/test/test.dart\' show Bill;';

// A very wonky import block, but still valid
String get importBlock => '''
$importBlockStatement1
$importBlockStatement2$importBlockStatement3


    $importBlockStatement4







              $importBlockStatement5
                      $importBlockStatement6
$importBlockStatement7 $importBlockStatement8
              $importBlockStatement9
        $importBlockStatement10
''';

const importBlockStatement1 = '''import 'package:./test.dart'
;''';
const importBlockStatement2 = 'import \'package:test/test.dart\' as test hide Run;';
const importBlockStatement3 = '// This should be captured';
const importBlockStatement4 = '// this should be captured too';
const importBlockStatement5 = '/// And this';
const importBlockStatement6 = '''/* hello
*/''';
const importBlockStatement7 = '''import
'package:http/http.dart'
as http
show Http;''';
const importBlockStatement8 = '// Http Library';
const importBlockStatement9 = '// import \'test\'; this should not be import';
const importBlockStatement10 = '''/*
* import 'package:blah/blah.dart' as test; this should not be an import either
*/''';

String get sampleFileText => '$sampleFileHeader$importBlock$sampleFileBody';
String get sampleFileNoHeader => '$importBlock$sampleFileBody';
String get sampleFileNoImportBlock => '$sampleFileHeader$sampleFileBody';

const sampleFileHeader = '''
# Header directive
// Some comment
/* Another commment */
// Sample import statement, but not the start of the import block
// import 'dart:test/dart/test.dart

/* Licensing */

/*

                      hey



                    hello

*/






''';


const sampleFileBody = '''
export 'Test export';

void foo() {

}

void bar() {

}

import 'test'; // other imports get ignored

String get Test => 'Test'

// A closing comment
''';