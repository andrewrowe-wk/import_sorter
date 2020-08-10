// 🌎 Project imports:
import 'package:import_sorter/file_parser/string_seeker.dart';

/// Should be used when whitespace is required
String parseWhitespace(final StringSeeker seeker) {
  final whitespace = seeker.takeAllWhitespace();
  if (whitespace.isEmpty) {
    throw FormatException('Expected: Whitespace at char ${seeker.previousIndex}');
  }

  return whitespace;
}