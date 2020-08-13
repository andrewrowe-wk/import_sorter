import 'package:petitparser/petitparser.dart';

import 'package:import_sorter/file_parser/models/parsed_file.dart';
//import 'package:import_sorter/file_parser/string_seeker.dart';

Result<List<dynamic>> parseFile(String fileText) {
  return IMPORT_STATEMENT.parse(fileText);
}


final IMPORT = string('import');
final QUOTE = char('\'') | char('\"');
final COMMA = char(',');
final HIDE = string('hide');
final SHOW = string('show');
final URI = QUOTE & any() & QUOTE;
final DEFERRED = string('deferred');
final AS = string('as');
final DEFERRED_AS = DEFERRED & whitespace() & AS;
final IDENTIFIER = word();
final IMPORT_ALIAS = (AS & whitespace() & IDENTIFIER) | (DEFERRED_AS & whitespace() & IDENTIFIER);
final IDENTIFIER_LIST = IDENTIFIER & (COMMA & IDENTIFIER).star();
final COMBINATOR = (SHOW & IDENTIFIER_LIST) | (HIDE & IDENTIFIER_LIST);

final IMPORT_STATEMENT = IMPORT & URI & IMPORT_ALIAS.optional() & COMBINATOR.star();