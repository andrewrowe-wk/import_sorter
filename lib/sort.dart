// 🎯 Dart imports:
import 'dart:io';

// 📦 Package imports:
import 'package:colorize/colorize.dart';
import 'package:import_sorter/file_parser/file_parser.dart';
import 'package:import_sorter/file_parser/models/import_statement.dart';
import 'package:import_sorter/import_comments.dart';

List<String> _extractImportStatement(final List<ImportStatement> imports) {
  return imports.map((i) => i.toString()).toList();
}

// void _splitAndAddToFile(final List<String> fileOutput, final String text) {
//   if (text.isNotEmpty) 
// }

void _buildImportSection(final List<String> fileOutput, final List<ImportStatement> imports, final bool noComments, final String comment) {
  if (imports.isNotEmpty) {
    if (!noComments) fileOutput.add(comment);
    fileOutput.addAll([..._extractImportStatement(imports), '']);
  }
}

final packageStringRegex = RegExp('^.*:.+\/?[^\/]+\$');

/// Sort the imports
/// Returns the sorted file as a string at
/// index 0 and the number of sorted imports
/// at index 1
List sortImports(
  List<String> lines,
  String package_name,
  List dependencies,
  bool emojis,
  bool exitIfChanged,
  bool noComments,
) {
  final parserResult = parseFile(lines.join('\n'));
  final externalPackageRegex = RegExp('package:(?!(flutter|$package_name)).*');

  // Extract imports
  final imports = parserResult.imports;
  final dartImports = imports.where((i) => i.startsWith('dart:')).toList();
  final flutterImports = imports.where((i) => i.startsWith('package:flutter')).toList();
  final packageImports = imports.where((i) => i.startsWith(externalPackageRegex)).toList();
  final projectImports = imports.where((i) => i.startsWith('package:$package_name')).toList();
  final projectRelativeImports = imports.where((i) => !i.startsWith(packageStringRegex)).toList();

  // Sort imports
  dartImports.sort();
  flutterImports.sort();
  packageImports.sort();
  projectImports.sort();
  projectRelativeImports.sort();

  // Write new file
  final fileOutput = List<String>();

  if (parserResult.header.isNotEmpty) { fileOutput.addAll(parserResult.header.split('\n')); }
  _buildImportSection(fileOutput, dartImports, noComments, dartImportComment(emojis));
  _buildImportSection(fileOutput, flutterImports, noComments, flutterImportComment(emojis));
  _buildImportSection(fileOutput, packageImports, noComments, packageImportComment(emojis));
  _buildImportSection(fileOutput, projectImports + projectRelativeImports, noComments, projectImportComment(emojis));
  if (parserResult.body.isNotEmpty) { fileOutput.addAll(parserResult.body.split('\n')); }
  fileOutput.add(''); // Newline at end of file

  final sortedFile = fileOutput.join('\n');
  if (exitIfChanged && lines.join('\n') + '\n' != sortedFile) {
    stdout.write('\n┗━━🚨 ');
    color(
      'Please run import sorter!',
      back: Styles.BOLD,
      front: Styles.RED,
      isBold: true,
    );
    exit(1);
  }

  return [
    sortedFile,
    dartImports.length +
        flutterImports.length +
        packageImports.length +
        projectImports.length +
        projectRelativeImports.length
  ];
}

