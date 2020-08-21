import 'package:import_sorter/import_comments.dart';

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

const sampleFileHeaderClassOnly = '''class Foo {
  final String bar;
  final String baz;
  final int bop;
  final String bing;
  final int burb;

  Foo(this.bar, this.baz, this.bop, this.bing,
      {this.burb});
}
''';

const sampleFileHeaderRandomCode = '''@Deprecated('blah blah blah')
const FOO = 'hello-hi-:';

const String bar = 'test-file';
const String baz = 'asoij39230990uer';
const String bing = 'test-css-class';

const double bam = 1024.0;
const double boom =
    120 * 2 * 3 * 4 * 5;
const double kapow =
    100 * 6 * 7 * 8;

const int test = 50;

const String test1 =
    'aopsdifjaospdi-asdo0fijaopsdfijadopsifj-230894u290u34';
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

const sampleFileHeaderImportComments = '''
$dartEmojis
import 'dart:io';

$flutterEmojis
import 'flutter:flutter.dart';

$packageEmojis
import 'package:args/args.dart';
import 'package:colorize/colorize.dart';
import 'package:yaml/yaml.dart';

$projectNoEmojis
import 'package:import_sorter/args.dart' as local_args;
import 'package:import_sorter/files.dart' as files;
import 'package:import_sorter/sort.dart' as sort;
''';