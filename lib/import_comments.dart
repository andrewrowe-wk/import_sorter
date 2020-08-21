/*
 * These are needed by the parser so they can be ignored as
 * 'whitespace' during a parse.
 * 
 * If you plan on adding any new comments, it is important
 * to add them to the grammar.dart file in the whitespace area.
 * 
 * Be careful if you plan on editing the strings too.
 * That could break backward compatibility.
 */


const dartNoEmojis = '// Dart imports:';
const dartEmojis = '// 🎯 Dart imports:';
const flutterNoEmojis = '// Flutter imports:';
const flutterEmojis = '// 🐦 Flutter imports:';
const packageNoEmojis = '// Package imports:';
const packageEmojis = '// 📦 Package imports:';
const projectNoEmojis = '// Project imports:';
const projectEmojis = '// 🌎 Project imports:';


String dartImportComment(bool emojis) =>
    emojis ? dartEmojis : dartNoEmojis;
String flutterImportComment(bool emojis) =>
    emojis ? flutterEmojis : flutterNoEmojis;
String packageImportComment(bool emojis) =>
    emojis ? packageEmojis : packageNoEmojis;
String projectImportComment(bool emojis) =>
    emojis ? projectEmojis : projectNoEmojis;
