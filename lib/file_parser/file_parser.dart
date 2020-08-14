import 'package:import_sorter/file_parser/internal/grammar.dart';
import 'package:import_sorter/file_parser/models/import_statement.dart';

import 'internal/file_parser_internal.dart';
import 'models/file_parser_result.dart';

FileParserResult parseFile(String fileText) {
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
    }
  }

  return FileParserResult(header, imports, body);
}

List<ParserOutput> _parseFile(String fileText) {
  final result = FILE_GRAMMAR.parse(fileText);
  final values = result.value;

  return [values[0], ...values[1], values[2]];
}
