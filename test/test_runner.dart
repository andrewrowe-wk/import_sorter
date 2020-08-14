import './sort_test.dart' as sort_test;
import './file_parser_tests/file_parser_test.dart' as file_parser_test;
import './file_parser_tests/internal/file_parser_internal_test.dart' as file_parser_internal_test;
import './file_parser_tests/internal/grammar_test.dart' as grammar_test;

void main() {
  sort_test.main();
  file_parser_test.main();
  file_parser_internal_test.main();
  grammar_test.main();
}