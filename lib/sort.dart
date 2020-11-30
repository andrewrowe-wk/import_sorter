// 📦 Package imports:
import 'dart:io';

import 'package:import_sorter/file_parser/file_parser.dart';
import 'package:import_sorter/file_parser/models/import_statement.dart';
import 'package:import_sorter/import_comments.dart';

List<String> _extractImportStatement(final List<ImportStatement> imports) {
  return imports.map((i) => i.toString()).toList();
}

void _buildImportSection(
    final List<String> fileOutput,
    final List<ImportStatement> imports,
    final bool noComments,
    final String comment) {
  if (imports.isNotEmpty) {
    if (!noComments) fileOutput.add(comment);
    fileOutput.addAll([..._extractImportStatement(imports), '']);
  }
}

final packageStringRegex = RegExp('^.*:.+\/?[^\/]+\$');

class SortReturnPayload {
  /// 'true' if file imports were out of order and sorting applied
  /// 'false' if file imports were in order, so no sorting applied
  final bool fileWasSorted;
  final String sortedFileText;
  final int numberOfImportsSorted;

  SortReturnPayload(final this.fileWasSorted, final this.sortedFileText,
      final this.numberOfImportsSorted);

  @override
  bool operator ==(Object other) => other is SortReturnPayload && _equal(other);

  bool _equal(final SortReturnPayload other) {
    return fileWasSorted == other.fileWasSorted &&
      sortedFileText == other.sortedFileText &&
      numberOfImportsSorted == other.numberOfImportsSorted;
  }
}

SortReturnPayload sortImports(
    final List<String> lines,
    final String packageName,
    final bool shouldIncludeEmojis,
    final bool shouldMakeImportBlockComments) {
  final parserResult = parseFile(lines.join('\n'));
  final externalPackageRegex = RegExp('package:(?!(flutter|$packageName)).*');

  // Extract imports
  final imports = parserResult.imports;
  final dartImports = imports.where((i) => i.startsWith('dart:')).toList();
  final flutterImports =
      imports.where((i) => i.startsWith('package:flutter')).toList();
  final packageImports =
      imports.where((i) => i.startsWith(externalPackageRegex)).toList();
  final projectImports =
      imports.where((i) => i.startsWith('package:$packageName')).toList();
  final projectRelativeImports =
      imports.where((i) => !i.startsWith(packageStringRegex)).toList();

  // Sort imports
  dartImports.sort();
  flutterImports.sort();
  packageImports.sort();
  projectImports.sort();
  projectRelativeImports.sort();

  // Write new file
  final fileOutput = List<String>();

  if (parserResult.header.isNotEmpty) {
    fileOutput.addAll(parserResult.header.split('\n'));
  }
  _buildImportSection(fileOutput, dartImports, shouldMakeImportBlockComments,
      dartImportComment(shouldIncludeEmojis));
  _buildImportSection(fileOutput, flutterImports, shouldMakeImportBlockComments,
      flutterImportComment(shouldIncludeEmojis));
  _buildImportSection(fileOutput, packageImports, shouldMakeImportBlockComments,
      packageImportComment(shouldIncludeEmojis));
  _buildImportSection(fileOutput, projectImports + projectRelativeImports,
      shouldMakeImportBlockComments, projectImportComment(shouldIncludeEmojis));
  if (parserResult.body.isNotEmpty) {
    fileOutput.addAll(parserResult.body.split('\n'));
  }
  fileOutput.add(''); // Newline at end of file

  final sortedFile = fileOutput.join('\n');
  final originalFile = lines.join('\n') + '\n';

  final fileWasSorted = originalFile == sortedFile;

  final numberOfImportsSorted = dartImports.length +
      flutterImports.length +
      packageImports.length +
      projectImports.length +
      projectRelativeImports.length;

  return SortReturnPayload(fileWasSorted, sortedFile, numberOfImportsSorted);
}
