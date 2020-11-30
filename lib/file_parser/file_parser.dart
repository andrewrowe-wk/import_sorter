import 'package:colorize/colorize.dart';
import 'package:import_sorter/file_parser/internal/grammar.dart';
import 'package:import_sorter/file_parser/models/import_statement.dart';

import 'internal/file_parser_internal.dart';
import 'models/file_parser_result.dart';

FileParserResult parseFile(final String fileText) {
  final results = _parseFile(fileText);
  final imports = List<ImportStatement>();
  final importBlockComments = List<String>();
  String header = '';
  String body = '';

  for (final r in results) {
    switch (r.type) {
      case ParseType.Header:
        header = r.value;
        break;
      case ParseType.Body:
        body = r.value;
        break;
      case ParseType.Import:
        imports.add(toImportStatement(r.value));
        break;
      case ParseType.ImportBlockComment:
        importBlockComments.add(r.value);
        break;
      case ParseType.Empty:
      default:
        break;
    }
  }

  return FileParserResult(
      header, imports, buildBody(body, importBlockComments));
}

List<ParserOutput> _parseFile(final String fileText) {
  final result = FILE_GRAMMAR.parse(fileText);

  if (result.isFailure) {
    color(
      'Error: Unable to parse',
      back: Styles.BOLD,
      front: Styles.GREEN,
      isBold: true,
    );
    return [];
  }
  final values = result.value;
  final imports = values[1] == null ? [] : values[1];

  return [values[0], ...imports, values[2]];
}
