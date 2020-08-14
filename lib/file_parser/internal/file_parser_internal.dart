
import 'package:import_sorter/file_parser/models/import_statement.dart';

String buildBody(final String body, final List<String> importBlockComments) {
  if (importBlockComments.isEmpty) { return body; }
  return '''// START IMPORT BLOCK COMMENTS
${importBlockComments.join('\n\n')}
// END IMPORT BLOCK COMMENTS

$body''';
}

ImportStatement toImportStatement(final String importString) {
  return ImportStatement(importString, getUriFromImportString(importString));
}

final newlinePattern = RegExp('\r\n|\r|\n');
final stringPattern = RegExp('\'(.*)\'|"(.*)"');
final quoteRegex = RegExp('\'|"');

String getUriFromImportString(final String importString) {
  final importStringNoNewlines = importString.replaceAll(newlinePattern, ' ');
  final uriWithQuotes = stringPattern.firstMatch(importStringNoNewlines).group(0);

  return uriWithQuotes.replaceAll(quoteRegex, '');
}
