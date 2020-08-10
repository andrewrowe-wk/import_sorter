// 🎯 Dart imports:
import 'dart:io';

// 📦 Package imports:
import 'package:colorize/colorize.dart';

// 🌎 Project imports
import 'package:import_sorter/lib/file_line_list.dart';

class ParserState {
  final List<String> lines;
  final int index;
  final List<LineData> parsedData;

  ParserState(final this.lines, final this.index, final this.parsedData);
}

ParserState initializeParser(final List<String> lines) {
  return ParserState(lines, 0, []);
}

ParserState getNextParserState(final ParserState state) {
  return ParserState(state.lines, )
}

class LineData {
  final bool isImport;
  final List<String> lines;

  LineData(final this.isImport, final this.lines);
}

class ImportSection {
  final String 
}

final importMatcher = RegExp(r'^\s*import');
bool isImportLine(final String line) {
  return line.startsWith(importMatcher);
}

final multiLineStatementMatcher = RegExp(r';\s*$');
bool isMultiLineStatement(final String line) {
  return line.contains(multiLineStatementMatcher);
}

LineData getLineData(final FileLinesList lines) {
  final currentLine = lines.getNextLine();

  if (isImportLine(currentLine)) {
    if (isMultiLineStatement(currentLine)) {
      final allLines = [currentLine];
      return LineData(true, )
    } else {
      return LineData(true, [currentLine])
    }
  } else {
    return LineData(false, [currentLine]);
  }
}

List<LineData> toLineData(final List<String> lines) {

}

enum TypeOfLine {
  SingleLineImport,
  MultiLineImport,
  MultiLineStringImport,
  Other
}

/// Get the number of times a string contains another
/// string
int _timesContained(String string, String looking) =>
    string.split(looking).length - 1;

bool _isMultiLineString(final String line) {
  return _timesContained(lines[i], "'''") == 1 ||
    _timesContained(lines[i], '"""') == 1;
}

bool _isSingleLineImport(final String line) {
  return line.startsWith('import') && line.endsWith(';');
}



List<String> getAllLinesForImport(final FileLinesList fileLines) {
  final importLines = List<String>();

  while (fileLines.hasMoreLines()) {

  }

  return importLines;
}

TypeOfImport getTypeOfImportFromLine(final String line) {
  if (_isSingleLineImport) {
    return TypeOfImport.Singl
  }
}

String dartImportComment(bool emojis) =>
    '//${emojis ? ' 🎯 ' : ' '}Dart imports:';
String flutterImportComment(bool emojis) =>
    '//${emojis ? ' 🐦 ' : ' '}Flutter imports:';
String packageImportComment(bool emojis) =>
    '//${emojis ? ' 📦 ' : ' '}Package imports:';
String projectImportComment(bool emojis) =>
    '//${emojis ? ' 🌎 ' : ' '}Project imports:';

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
  final fileLines = FileLinesList(lines);
  final beforeImportLines = <String>[];
  final afterImportLines = <String>[];

  final dartImports = <String>[];
  final flutterImports = <String>[];
  final packageImports = <String>[];
  final projectRelativeImports = <String>[];
  final projectImports = <String>[];

  bool noImports() =>
      dartImports.isEmpty &&
      flutterImports.isEmpty &&
      packageImports.isEmpty &&
      projectImports.isEmpty &&
      projectRelativeImports.isEmpty;

  var isSingleLineImport = false;
  var isMultiLineString = false;
  var isMultiLineImport = false;

  while (fileLines.hasMoreLines()) {
    final line = fileLines.getCurrentLine();


  }

  for (var i = 0; i < lines.length; i++) {
    isSingleLineImport = isSingleLineImport(lines[i]);
    isMultiLineString = isMultiLineString(lines[i]);
    isMultiLineImport = isMultiLineImport(lines[i]);

    // If line is an import line
    if (isSingleLineImport || isMultiLineImport) {
      if (lines[i].contains('dart:')) {
        dartImports.add(lines[i]);
      } else if (lines[i].contains('package:flutter/')) {
        flutterImports.add(lines[i]);
      } else if (lines[i].contains('package:$package_name/')) {
        projectImports.add(lines[i]);
      } else if (!lines[i].contains('package:')) {
        projectRelativeImports.add(lines[i]);
      }
      for (final dependency in dependencies) {
        if (lines[i].contains('package:$dependency/') &&
            dependency != 'flutter') {
          packageImports.add(lines[i]);
        }
      }
    } else if (i != lines.length - 1 &&
        (lines[i] == dartImportComment(false) ||
            lines[i] == flutterImportComment(false) ||
            lines[i] == packageImportComment(false) ||
            lines[i] == projectImportComment(false) ||
            lines[i] == dartImportComment(true) ||
            lines[i] == flutterImportComment(true) ||
            lines[i] == packageImportComment(true) ||
            lines[i] == projectImportComment(true) ||
            lines[i] == '// 📱 Flutter imports:') &&
        lines[i + 1].startsWith('import ') &&
        lines[i + 1].endsWith(';')) {
          // Does this do anything?
    } else if (noImports()) {
      beforeImportLines.add(lines[i]);
    } else {
      afterImportLines.add(lines[i]);
    }
  }

  // If no import return original string of lines
  if (noImports()) {
    if (lines.length > 1) {
      if (lines.last != '') {
        return [
          [...lines, ''].join('\n'),
          0
        ];
      }
    }
    return [lines.join('\n'), 0];
  }

  // Remove spaces
  if (beforeImportLines.isNotEmpty) {
    if (beforeImportLines.last.trim() == '') {
      beforeImportLines.removeLast();
    }
  }

  final sortedLines = <String>[...beforeImportLines];

  // Adding content conditionally
  if (beforeImportLines.isNotEmpty) {
    sortedLines.add('');
  }
  if (dartImports.isNotEmpty) {
    if (!noComments) sortedLines.add(dartImportComment(emojis));
    dartImports.sort();
    sortedLines.addAll(dartImports);
  }
  if (flutterImports.isNotEmpty) {
    if (dartImports.isNotEmpty) sortedLines.add('');
    if (!noComments) sortedLines.add(flutterImportComment(emojis));
    flutterImports.sort();
    sortedLines.addAll(flutterImports);
  }
  if (packageImports.isNotEmpty) {
    if (dartImports.isNotEmpty || flutterImports.isNotEmpty) {
      sortedLines.add('');
    }
    if (!noComments) sortedLines.add(packageImportComment(emojis));
    packageImports.sort();
    sortedLines.addAll(packageImports);
  }
  if (projectImports.isNotEmpty || projectRelativeImports.isNotEmpty) {
    if (dartImports.isNotEmpty ||
        flutterImports.isNotEmpty ||
        packageImports.isNotEmpty) {
      sortedLines.add('');
    }
    if (!noComments) sortedLines.add(projectImportComment(emojis));
    projectImports.sort();
    projectRelativeImports.sort();
    sortedLines.addAll(projectImports);
    sortedLines.addAll(projectRelativeImports);
  }

  sortedLines.add('');

  var addedCode = false;
  for (var j = 0; j < afterImportLines.length; j++) {
    if (afterImportLines[j] != '') {
      sortedLines.add(afterImportLines[j]);
      addedCode = true;
    }
    if (addedCode && afterImportLines[j] == '') {
      sortedLines.add(afterImportLines[j]);
    }
  }
  sortedLines.add('');

  final sortedFile = sortedLines.join('\n');
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
        projectImports.length
  ];
}

