/*
 * NOTE: Each test string has a corresponding 'expected result' string.
 *
 * If you made changes to one, you'll have to make changes to the other.
 *
 */

/// 'import' start on line after block comments.
/// It should ignore all 'imports' that are in comments
const commentsBeforeImport1 = '''
/* random block comment */
/******* multi
line
* block
comment *//*block comment starting on same line */

               /*arbitrary whitespacebefore*/
// Line comment

/// Line comment 2 :) // line comment that is also comment

/*block*/ /* import import import */
// import /* asdf 
/// import /* asdf */
import
''';

const commentsBeforeImport1ExpectedValue = '''
/* random block comment */
/******* multi
line
* block
comment *//*block comment starting on same line */

               /*arbitrary whitespacebefore*/
// Line comment

/// Line comment 2 :) // line comment that is also comment

/*block*/ /* import import import */
// import /* asdf 
/// import /* asdf */
''';

/// 'import' starts inline with block comments
const commentsBeforeImport2 = '''
/* block block block*/
/* this

/// Line comment
/// Again

// hello



 is a block comment */ import
''';

const commentsBeforeImport2ExpectedValue = '''
/* block block block*/
/* this

/// Line comment
/// Again

// hello



 is a block comment */ ''';

/// 'import' starts arbitrary whitespace amount after comments
const commentsBeforeImport3 = '''
/* block block block*/
/* this


///     xxxxx
///    x x x x
///    x  .  x
//     x --- x
//      xxxxx


 is a block comment */
 
 
 
 
             import''';

const commentsBeforeImport3ExpectedValue = '''
/* block block block*/
/* this


///     xxxxx
///    x x x x
///    x  .  x
//     x --- x
//      xxxxx


 is a block comment */
 
 
 
 
             ''';