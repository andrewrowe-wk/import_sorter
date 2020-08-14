import 'package:import_sorter/file_parser/models/import_statement.dart';

class FileParserResult {
  final String header;
  final List<ImportStatement> imports;
  final String body;

  FileParserResult(final this.header, final this.imports, final this.body);
}