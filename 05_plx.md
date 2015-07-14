# Programming Language/Cross Systems (PL/X)
PL/X source is converted into optimised assembler, which *should* be easier to maintatin than bare assembler.

PL/X provides full access to the hardware of the target machine with the full flexibility of assembler, but with the benefits of a high-level language.

Significant parts of PL/X langauge are specific to z Systems.

Does not support recursion (except in macros)

The compiler optimisation is not perfect, as expected. But it can use optimising techniques which are confusing.

It can leverage new instructions just by recompiling a module.

PL/X bears resemblance to <abbr title="Programming Language 1">PL/1</abbr>, <abbr title="Basic System Language">BSL</abbr>, <abbr title="Programming Language Systems">PL/S</abbr> and <abbr title="Programming Language Advanced Systems">PL/AS</abbr>

PL/X has object-orientated and procedural paradigms.

## Modules

Typical module structure:

```plx
@PROCESS
/* Prolog */
Mainline: PROCEDURE
    %INCLUDE system mappings
    DECLARE of local variables
    Mainline code
    Subroutines
End of Mainline
```

Full example:

```plx
 @Process Title('Simple PL/X Program') Env(z/OS) Format Compile(N); 
  /*****************************************************************/
  /* Prolog - Description of Module                                */ 
  /*****************************************************************/
 SimpProc: Procedure Options(Amode(31));
 %INCLUDE Syslib(CVT);
 
  /*****************************************************************/
  /* Local Declares                                                */
  /*****************************************************************/
 Dcl AVariable Fixed;
 Dcl kContinue Constant(1);
 Dcl kStop Constant(2);
 Dcl CVTPtr Ptr(31) Location(16) Readonly;
  /*****************************************************************/
  /* Mainline of SimpProc                                          */
  /*****************************************************************/
 AVariable = kContinue;          /* Assume we want to continue     */
 Do While(AVariable=kContinue);  /* Loop while we need to continue */
   Call Test_And_Set(inoutVar := AVariable); /* Process the
                                                variable           */
 End;                            /* End of looping                 */
  /*****************************************************************/
  /* All done processing. Return to caller.                        */
  /*****************************************************************/
 Return;
 
 @Eject;
  /*---------------------------------------------------------------*/
  /* Name : Test_And_Set                                           */
  /* Function: Test the input parameter and set it if appropriate  */
  /*---------------------------------------------------------------*/
   Dcl Test_And_Set ENTRY(inoutVar := Fixed ByAddr Input Output);
 Test_And_Set:
   Procedure(inoutVar);
     Dcl inoutVar Fixed;          ! Input variable
     If inoutVar = kContinue Then /* Input indicates we should
                                     continue?                     */
       inoutVar = kStop;          /* Yes. Ignore it. We need to
                                     stop                          */
   End Test_And_Set;
 End SimpProc;
```

Do not confuse prolog (comment describing what the module does) and prologue(/epilogue) which are inserted by macros.

Statements prefixed with a `%` are processed by the compilers macro phase.

Semicolons are not allowed in block comments. To temporarily remove code use the `@LOGIC` and `@ENDLOGIC` options or just use proper version control ;-).

### Hello World

```plx
 @PROCESS Format Env(z/OS) Title('Hello World') Compile(N);
 HelloW: Procedure;
 ?WTO ('Hello world, my name is ...') ROUTCDE(11);
 Return Code(0);
 ?EPILOG
 End HelloW;
```

In PL/X statements must appear in columns 2-72 (80 characters fixed width, with line numbers).

## Data Types

* Arithmetic
* String
  * Character
  * Bit
* Locator
* Program
* Area
* Generic
* User-defined

### Declaration

`DECLARE variable-name attributes`. `DCL` shorthand.

The variable name must be between 1 and 40 characters long. First character must be alphabetic, `$` or `#`. Remaining characters can be alphnumeric, `@`, `$`, `#` or `_`. Not case sensitive. Cannot conflict with a reserved keywords.

Extenral variables are limited to 8 characters and cannot include an `_`.

Attributes are the attributes of the variable (typically `FIXED`, `POINTER`, `CHARACTER`, etc.).

Can be grouped:

```plx
DECLARE (variable-name1, variable-name2, ..., variable-nameN) attributes; ! Will have the same attributes
DERLARE variable-name1 attributes,
        variable-name2 attributes,
        ...
        variabler-nameN attributes; ! shows variables are linked, but do not have the same attributes.
```

### Arithmetic Data Types

| Precision | #Bytes | Sign     | Min Value                  | Max Value                  | Boundary                             |
|-----------|--------|----------|----------------------------|----------------------------|--------------------------------------|
| 8         | 1      | Unsigned | 0                          | 255                        | Byte                                 |
| 15        | 2      | Signed   | -32768                     | 32767                      | Halfword                             |
| 15        | 2      | Unsigned | 0                          | 32767                      | Halfword                             |
| 16        | 2      | Unsigned | 0                          | 65,535                     | Halfword                             |
| 24        | 3      | Unsigned | 0                          | 16,777,215                 | Word (starts in 2<sup>nd</sup> byte) |
| 31        | 4      | Signed   | -2,147,483,648             | 2,147,483,647              | Word                                 |
| 31        | 4      | Unigned  | 0                          | 2,147,483,647              | Word                                 |
| 32        | 4      | Unsigned | 0                          | 4,294,967,295              | Word                                 |
| 63        | 8      | Signed   | -9,223,372,036,854,775,808 | 9,223,372,036,854,775,807  | Doubleword                           |
| 63        | 8      | Unsigned | 0                          | 9,223,372,036,854,775,807  | Doubleword                           |
| 64        | 8      | Unsigned | 0                          | 18,446,744,073,709,551,615 | Doubleword                           |

## Arrays

Default low index is 1 (unlike C-style language).

Maximum of 15 dimensions. Can have negative indecies. PL/X doesn't check the index.

`DCL CharArray(0:4) CHAR(5);` uses low boundary 0 and high boundary 4.

`DCL FixedArray(5) FIXED(31);` uses default low boundary (1) and high boundary 5.

`DCL MultArray(5,4) CHAR(6);` creates a multidimensional array

`DCL TwoDimArray(0:4,1:5) FIXED(31);` creates a multidimensional array.

Indexing the array is done using `CharArray(1) = 'RAB';`. Can be done using variable. To substring the code is: `CharArray(1,2:3) = 'AB';`. In multidimensional arrays, all indexes must be specified.
