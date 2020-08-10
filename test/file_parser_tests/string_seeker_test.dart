// 📦 Package imports:
import 'package:test/test.dart';

// 🌎 Project imports:
import 'package:import_sorter/file_parser/string_seeker.dart';


void main() {
  group('String Seeker', () {
    test('currentChar should work as expected', () {
      final seeker = StringSeeker('abcd');

      expect(seeker.currentChar, 'a');
      // Index should not move
      expect(seeker.currentIndex, 0);
      expect(seeker.previousIndex, -1);
    });

    test('nextChar should work as expected', () {
      final seeker = StringSeeker('abcd');

      expect(seeker.nextChar, 'b');
      // Index should not move
      expect(seeker.currentIndex, 0);
      expect(seeker.previousIndex, -1);
    });

    test('takeOne() should work as expected', () {
      final seeker = StringSeeker('abcd');

      // Return expected and increment index
      expect(seeker.takeOne(), 'a');
      expect(seeker.currentIndex, 1);
      expect(seeker.previousIndex, 0);

      // Return expected and increment index
      expect(seeker.takeOne(), 'b');
      expect(seeker.currentIndex, 2);
      expect(seeker.previousIndex, 1);

      // Return expected and increment index
      expect(seeker.takeOne(), 'c');
      expect(seeker.currentIndex, 3);
      expect(seeker.previousIndex, 2);

      // Return expected and increment index
      expect(seeker.takeOne(), 'd');
      expect(seeker.currentIndex, 4);
      expect(seeker.previousIndex, 3);
    });

    test('takeAllWhitespace() should work as expected', () {
      const whitespaceString = '''              


              hello''';
      final seeker = StringSeeker(whitespaceString);

      // Return everything except the 'hello'
      expect(seeker.takeAllWhitespace(), whitespaceString.replaceFirst('hello', ''));
      expect(seeker.currentIndex, whitespaceString.length - 5); // subtract 5 for 'hello'
      expect(seeker.previousIndex, 0);
      expect(seeker.peekNextToken(), 'hello');
    });

    test('takeUntilWhitespace() should work as expected', () {
      // Space
      final seeker1 = StringSeeker('abcd ');
      // Tab
      final seeker2 = StringSeeker('abcd\t');
      // Newline
      final seeker3 = StringSeeker('''abcd
      ''');
      // End-of-string
      final seeker4 = StringSeeker('abcd');

      // Should read up to whitespace
      expect(seeker1.takeUntilWhitespace(), 'abcd');
      expect(seeker1.currentIndex, 4);
      expect(seeker1.previousIndex, 0);
      expect(seeker1.peekNextToken(), '');

      expect(seeker2.takeUntilWhitespace(), 'abcd');
      expect(seeker2.currentIndex, 4);
      expect(seeker2.previousIndex, 0);
      expect(seeker2.peekNextToken(), '');

      expect(seeker3.takeUntilWhitespace(), 'abcd');
      expect(seeker3.currentIndex, 4);
      expect(seeker3.previousIndex, 0);
      expect(seeker3.peekNextToken(), '');

      expect(seeker4.takeUntilWhitespace(), 'abcd');
      expect(seeker4.currentIndex, 4);
      expect(seeker4.previousIndex, 0);
      expect(seeker4.peekNextToken(), '');
    });

    test('takeThrough() should work as expected', () {
      final seeker = StringSeeker('abcd;import');

      // Should get through the semicolon and move the index
      expect(seeker.takeThrough(';'), 'abcd;');
      expect(seeker.currentIndex, 5);
      expect(seeker.previousIndex, 0);
      expect(seeker.peekNextToken(), 'import');
    });

    test('peekNextToken() should work as expected', () {
      final seeker1 = StringSeeker('     \t\nimport');
      final seeker2 = StringSeeker('import ');
      final seeker3 = StringSeeker('/*');

      // Should return empty string on whitespace or full word otherwise
      expect(seeker1.peekNextToken(), '');
      expect(seeker1.currentIndex, 0);
      expect(seeker1.previousIndex, -1);

      expect(seeker2.peekNextToken(), 'import');
      expect(seeker2.currentIndex, 0);
      expect(seeker2.previousIndex, -1);

      expect(seeker3.peekNextToken(), '/*');
      expect(seeker3.currentIndex, 0);
      expect(seeker3.previousIndex, -1);
    });
  });
}
