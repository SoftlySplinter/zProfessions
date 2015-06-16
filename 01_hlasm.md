# High Level Assembly Language (HLASM)

## Introduction to Assembler Programming
An introduction to assembler programming for those who have a basic understanding of computer science and System z.

4 excercises just to get going in assembler.

### Why assembler programming?
Assembler has been around since the start of computer languages as an easy way to understand and work directly with machine code.

Assembler programming *can* produce the most efficient code possible, but it trusts the programming. Assembler requires skill to write, but debugging can be easier.

Compilers *can* produce more optimised code, but they can make mistakes.

Assembler isn't portable, but no language truely is.

To program in assembler, you must be precise as you are programming the machine. You have total freedom to do what you want (*or mess up your system*). The code you write is the code that will run.

### Pre-requisites for assembler programming on System z
Knowledge of:

* Basic programming knowledge
* Binary and hexidecimal notation
* Computer organisation
* ISPF, JCL, SDSF

And a copy of z/Architecture Principles of Operation (POPs).

### z/Architecture
The processor architecture used for all System z Mainframes.

System z is 64-bit, big-endian, rich CISC (over 1000 instructions) architecture with:

* 16&times;64-bit General Purpose Registers (GPRs)
* 16&times;32-bit Access Registers (ARs)
* 16&times;64-bit Floating Point Registers (FPRs)
* 16&times;64-bit Control Registers (CRs)
* 1 Program Status Word (PSW)
* And others for crypto, I/O, etc.

Registered are numbered 0-15; the instructions used distringuish which 0-15 means which type of register.

Data lengths:

* WORD (4 bytes) 
* DOUBLEWORD (8 bytes)
* HALFWORD (2 bytes)

GPRs are used for arithmetic, logical operations, passing operands to instructions to subroutines, etc. Although they are DOUBLEWORD, they can be used as WORD.

ARs are used in Access Register mode, providing the ability to access another address space.

FPRs are used for floating point instructions.

CRs are used for controlling processor operations.

PSW provides the status of the processor consisting of 2 parts:

* PSW Flags show the state of the process during instruction execution
* Instruction address shows the next instruction to be executed

GPRs and FPRs can be paired, GPRs form even-odd pairs (0-1, 2-3, 14-15, etc.), FPRs pair evenly/oddly (0-2, 1-3, 13-15, etc.).

### Binary Numbers
All computers use binary as the internal "language".

Hex is eaier to read than binary (4 bits = 1 byte).

`0b0001 1000 1100 0011 = 0x18C7`

### Moving Data Around
One of the most common operations that *any* program performs.

Before any computations can be performed, data must be moved to the correct places.

* LOAD - data is loaded into the processors registers
* STORE - data is stored to memory
* MOVE - Data is moved from one area of memory to another

#### Loading from Register to Register

The LOAD REGISTER (LR) instruction is ued to load the 32-bit value stored in one register to another.

```hlasm
LR 1,2         LOAD REGISTER 2 INTO REGISTER 1 (32-BITS)
LR  R01,R02    USE SYMBOLIC REPRESENTATIONS R01 AND R02
x'1812'        MACHINE CODE
```

The LOAD GRAND REGISTER (LGR) is used to load the 64-bit value stored in one register to another.

```hlasm
LGR 1,2       LOAD REGISTER 2 INTO REGISTER 1 (64-BITS)
LGR GR1,GR2   USE SYMBOLIC REPRESENTATIONS GR1 AND GR2
x'B9040012'   MACHINE CODE
```

The LOAD HALFWORD REGISTER (LHR) is used to load the 16-bit value stored in one register to another.

```hlasm
LHR 1,2       LOAD REGISTER 2 INTO REGISTER 1 (16-BITES)
LHR R1,R2     USE SYMBOLIC REPRESENTATIONS R1 AND R2
x'B9270012'   MACHINE CODE
```

The LOAD (L) instruction is used to load the 32-bit value stored in memory to a register.

`L R,D(X,B)` where R (target register), X (index) and B (base) are registers. D (displacement).

```hlasm
L 1,500(3,12)         LOAD REGISTER 1 WITH 32-BITS (WORD)
L R1,NUMBER           USE SYMBOLICS - COMPILER WILL FILL IN INDEX AND BASE WHERE NEEDED
L R1,NUMBER(R3)       
L R1,NUMBER(R3,R12)   
x'58113C1F4'          MACHINE CODE
```

The LOAD GRANDE (LG) is used to load the 64-bit value stored in memory to a register.

```hlasm
LG 1,504(3,12)     LOAD REGISTER 1 WITH 64-BITS (DOUBLE WORD)
x'E313C001F804'    MACHINE CODE
```

The LOAD HALFWORD REGISTER (LH) is used to load the 16-bit value stored in memory to a register.

```hlasm
LH 1,200(3,12)   LOAD REGISTER 1 WITH 16-BITES (HALF WORD)
LH 1,NUMBER
x'4813C200'      MACHINE CODE
```

The STORE (ST) instruction is used to store the value from a register to memory.

```hlasm
ST 1,X'204'(3,12)
ST R1,NUMBER
ST R1,NUMBER(R3)       
ST R1,NUMBER(R3,R12)   
x'5013C204'
```

The STORE GRANDE (STG) instruction is used to store the 64-bit value from a register to memory.

```hlasm
STG 1,X'208'(3,12)   STORE REGISTER 1 WITH 64-BITS
x'E313C0020824'      MACHINE CODE
```

...

The MOVE (MVC) instruction can be used to move data in memory without the need for a register.

`MVC D1(L,B1),D2(B2)` L represents the length (8-bits). Limited to storing a length of `0xff` (256).

```hlasm
MVC X'100'(10,12),X'260'(12)   MOVE MEMORY
MVC OUTPUT,INPUT               MOVE INPUT TO OUTPUT
MVC OUTPUT(10),INPUT           MOVE INPUT TO OUTPUT (10-BITS)
x'D29C100C260'                 MACHINE CODE (NOTE: 9 IS USED INSTEAD OF 10).
```

DOUBLE WORD and HALF WORD variants are avalable:

MVC can move up to 256B, MVCL can move up to 16M, MVCLE can move up to 2G (or16EB in 64-bit addressing).

In all cases, the move instruction moves 1 byte at a time (left to right in memory).

**Note:** 12 is quite commonly used as the BASE register as it has 4k, but this isn't convention.

### Logical Instructions

The EXCLUSIVE OR instructions perform XOR bit-wise.

```hlasm
X   1,NUMBER    XOR REGISTER 1 WITH NUMBER (32-BITS)
XG  1,NUMBER    XOR REGISTER 1 WITH NUMBER (64-BITS)
XR  1,2         XOR REGISTER 1 WITH REGISTER 2 (32-BITS)
XGR 1,2         XOR REGISTER 1 WITH REGISTER 2 (64-BITS)
XC  NUM1,NUM2   XOR NUM1 WITH NUM2 (256-BITS)
```

Rules of thumb:

* G -> 64-bits
* H -> 16-bits
* R -> Register
* C -> Character


The AND instructions perform AND bit-wise

```hlasm
N   1,NUMBER
NG  1,NUMBER
NR  1,2
NGR 1,2
NC  NUM1,NUM2
```

The OR instructions perform bit-wise OR.

```hlasm
O   1,NUMBER
OG  1,NUMBER
OR  1,2
OGR 1,2
OC  NUM1,NUM2
```

The 5 basic operations (load, store, AND, OR, XOR) have over 25 instructions so far.

How to decide which instruction to use? Chose for:

* Purpose (don't STORE to load a register)
* Data (32-bits, 16-bits, 64-bits).

Many iunstructions can perform similar operations, e.g.:

```hlasm
XR   15,15
L    15,=F'0'
LA   15,0
```

Different instructions **never** do the same thing, even if you think they do (the result doesn't justify the means).

### Working with HLASM
Available on all System z (z/OS z/VM, z/VSE, z/Linux, z/TPF).

HLASM provides a wider range of assembler directives. A directive is not an instruction, it is an instruction to the assembler during assembly of the program.

HLASM is an incredible macro programming facility.

HLASM allows for structured programming.

Assembling is the process of changing assembler source code into OBJECT DECKS, producing 2 outputs:

* OBJECT DECKS - this is the object code that is used as input to binding
* Listing - this shows any errors, all diagnostics and human readable output from the assemble phase.

Binding is the process of combining object code into a LOAD MODULE. To bind use a Binder.

The Binder produces 2 outputs:

* LOAD MODULE - this is the bound object decks forming an assembler program
* LOAD MAP - this is the binder equivalent of an assembler listing

A LOAD MOUDLE can be loaded into memory by the operating system and run.

#### Syntax
Comments start with a `*` in column 1 or appear after free-form instructions operands until column 72.

```hlasm
* THIS IS A COMMENT
L 1,=F'12'  THIS IS ANOTHER COMMENT
```

Labels start in column 1, operation codes start after column 1 or a label (normally column 10). Operands come after the operation, usually starting in column 16.

#### CSECTS and DSECTS

CSECT -> CONTROL SECTION (HLASM directive). A CSECT contains machine instructions to be run on the machine.

DSECT -> DUMMY SECTION (HLASM directive). A DSECT is used to define the structure of data.

Both CSECT and DSECT are terminated with the END statement.

```hlasm
MYPROG   CSECT
    ... program listings ...
MYSTRUCT DSECT
    ... data structures ...
END
```

#### Defining data

Data is defined via the DC and DS directives.

* `DC` Define Constant. Defines data and initialises it to a given value.
* `DS` Define Storage. Defines storage for data but does not give it a value.

```hlasm
NUMBER1   DC    F'12'
NUMBER2   DC    H'12'
TOTAL     DS    H
MYSTR     DC    C'HELLO WORLD'
MYHEX     DC    X'FFFF'
```

#### Literals

A literal is an inline definition of data used in an instruction but the space taken for the literal is in the nearest literal pool. A literal pool collects all previous literals and reserves the space for them.

By default HLASM produces an implicitly declared literal pool at the end of the CSECT.

To cause HLASM to produce a literal pool, use the `LTORG` directive.

```hlasm
L     1,=F'1'
X     1,=H'2'
...
LTORG ,
```

### Addressing data

There are 2 ways of accessing daa for manipulating:

* Base-displacement (and index) addressing
* Relative addressing


Relative addressing calculates the datas relative position from the current PSW.

```hlasm
LRL 1,NUMBER        LOAD RELATIVE REGISTER 1 WITH NUMBER
   ...
NUMBER DC   F'23'
```

#### Base+Displacement+Index addressing

Base+Displacement(+index) addressing involves using a register as a pointer to memory (the BASE register). The displacement is usually between 0 and 4095 bytes (max 4k). An index register is an additional register whose value is added to the base and displacement to address more memory.

The index register also allows the assembler programmer to cycle through an array whilst maintaining the same base+displacement.

**Note:** Register 0 cannot be used as a base or index register as it counts as *value* 0.

Base, displacement and indexes are optionally specified on an instruction, the implicit default value is 0.

#### Loading Addresses

The LOAD ADDRESS instruction is used to load an address into a register.

```hlasm
LA    1,MYDATA          LOAD ADDRESS OF MYDATA INTO REGISTER 1
```

`LA` Can be used to set a register to between 0 and 4095 by specifying a base index register of 0.

```hlasm
LA    1,12              base=0, index=0, displacement=12
LA    1,12(0,0)
```

Example: store the character 'O' at index 4, into the string MYDATA referneced by BASE register 12.

```hlasm
LA    4,4            LOAD ADDRESS 4 INTO REGISTER 4
IC    3,=C'O'        LOAD CHARACTER 'O' INTO REGISTER 3
STC   3,MYDATA(4)    base=12, index=4, displacement=5
```



### Branching
Branching allows control flow in the program, changing the sequence of execution, performed via the BRANCH instructions.

Most branch instructions are conditional, they will pass control to the branch target if a condition is met.

The condition is called the CONDITION CODE (CC), 2-bits stored in the PSW (value is 0-3). Machine instructions may (or may not) set the CC.

A branch insturction provides a branch mask

`BC M,D(X,B)`.

The branch mask instructs the processor that the branch will be taken if any of the bits in the CC match those in the branch mask.

Fortunately most code uses HLASM bracnh mnemonics to provide a branch mask.

* `B` branch unconditionally (`BC 15,`)
* `NOP` no operation - never take branch, used as a placeholder (`BC 0,`)
* `BE` branch on equal (`BC 8,`)
* `BL` branch on low (`BC 4,`)
* `BH` branch on high (`BC 2,`)
* `BNL` branch not low (`BC 11,`)
* `BNH` branch not high (`BC 13,`)
* `BZ` branch on zero (`BC 8,`)
* `BNZ` branch not zero (`BC 7,`)
* There are many other branch mnemonics
  * To be used after compare, arithmetic and test under mask instructions
  * Relative addressing uses JUMP not BRANCH.

Condition Code - Mask value:

* 0 - 8
* 1 - 4
* 2 - 2
* 3 - 1

How the mask works:

* `B` uses mask `15` or `0b1111` or `8 + 4 + 2 + 1`, i.e. branch on any CC - always branch.
* `BE` uses mask `8` or `0b1000` or `8`, i.e. branch on CC 0.

```hlasm
L     1,NUMBER
LTR   1,1
BNZ   NONZERO      BRANCH TO NONZERO
B     COMMONCODE   REJOIN COMMON CODE
```



### Arithimetic
Arithmetic is performed in a wide variety of ways on z/Architecture:

* Fixed point (including logical) -> performed in GPRs
* Packed decimal -> performed in memory
* Binary and Hexidecimal floating point -> performed in FPRs


Fixed point arithimetic:
* Normal (e.g. adding contents of 2 numbers)
* Signed with numbers stored in 2s complement form
* Logical fixed point is unsigned

Packaged decimal
* Numbers are packed in decimal form

#### ADD instructions

```hlasm
AR    1,2        ADD REGISTER 2 TO REGISTER 1 (32-BIT SIGNED)
ALR   1,2        ADD REGISTER 2 TO REGISTER 1 (32-BIT LOGICAL)
A     1,NUMBER   ADD NUMBER TO REGISTER 1 (32-BIT SIGNED)
AL    1,NUMBER   ADD NUMBER TO REGISTER 1 (32-BIT LOGICAL)
AFI   1,37       ADD 37 TO REGISTER 1 (IMMEDIATE)
```

**Note** immediate instructions, the operand is included in the instruction rather than needed to be obtained from memory.

At the end of the addition, the CC is updated:

* CC 0 -> result is 0; no overflow
* CC 1 -> result is less than 0; no overflow
* CC 2 -> result is greater than 0; no overflow
* CC 3 -> overflow occured

#### SUBTRACT instructions

```hlasm
SR    1,2        SUBTRACT REGISTER 2 FROM REGISTER 1 (SIGNED)
SLR   1,2        SUBTRACT REGISTER 2 FROM REGISTER 1 (LOGICAL)
S     1,NUMBER   SUBTRACT NUMBER FROM REGISTER 1 (SIGNED)
SL    1,NUMBER   SUBTRACT NUMBER FROM REGISTER 1 (LOGICAL)
AFI   1,-37      ADD -37 TO REGISTER 1 (IMMEDIATE)
```

* CC 0 -> result is 0; no overflow
* CC 1 -> result is less than 0; no overflow
* CC 2 -> result is greater than 0; no overflow
* CC 3 -> overflow occured

#### MULTIPLY instruction

```hlasm
MR    2,7        MULTIPLY REGISTER 2 BY REGISTER 7
M     2,NUMBER   MULTIPLY REGISTER 2 BY NUMBER
```

The first operand is an even-odd pair of registers:
* The multiplicand is tored in odd register of 1st operand - in R3 as 32-bit number
* The multiplier is stored in 2nd operand as 32-bit number
* The result of the multiply is stored in:
  * The even register (of the pair) - top 32-bits of the result
  * The odd register (of the pair) - bottom 32-bits of the result

CC is unchanged.

#### DIVIDE instruction

```hlasm
DR    2,7        DIVIDE REGISTER 2 BY REGISTER 7
D     2,NUMBER   DIVIDE REGISTER 2 BY NUMBER
```

The first operand is an even-odd pair of registers, the even (of the pair) is the top 32 bits, the odd register (of the pair) is the bottom 32-bits.

The second operand is the divisor (32-bits).

The quotient is stored in the odd register. The remainder in the even register.

CC is unchanged.

### Looping
A simple loog is formed by using a counter, a comparison and a branch:

```hlasm
       LA     2,0
MYLOOP AHI    2,1
       WTO    'HELLO'
       CHI    2,10
       BL     MYLOOP
```

There's a simple and better way:

```hlasm
       LA    2,10
MYLOOP WTO   'HELLO'
       BCT   2,MYLOOP
```

### Calling conventions
How to call other porgrams, and the conventions associated with this. Who saves the state of the caller, because when you call someone, you expect that your stuff hasn't been altered.

This isn't enforced, but is a bloody good idea to avoid undesirable and unpredicatble results.

In general when programming in assembler, the caller will provide a save area and the called program or routine will save all GPRs to that save area. The subroutine then executes itself and returns control to the caller by (typically):

* Setting a return code in a register
* Prepare the register on which it should branch back on
* Restore all other registers
* Branch

Although free to do as you please, the most common convention is as follows:

* Register 1 - parameter list pointer
* Register 13 - pointer to register save area
* Register 14 - return address
* Register 15 - entry point

Once the registers are save, the called subroutine will:

* Store R13 in new savearea + 4 (link backwards to callers save area)
* Store address of new savearea in caller's savearea + 8 (link forward)
* Update R13 to point to a new save area (so that it can call other programs/routines)
* Establish R12 as base register for the program

Upon termination, the called subroutine will:

* Set a return code in R15
* Restore R13 to the value it was previously (new savearea + 4)
* Restore R14,0,1,&hellip;,12 from save area pointed to by R13.
* Branch back to R14.

Caller:

```hlasm
       LA    1,PARAMS      POINT TO PARAMETERS
       LA    15,SUB1       LOAD ADDRESS OF SUBROUTINE
       BALR  14,15         BRANCH TO R15 AND SAVE
RETURN *                          IN R14
       LTR   15,15         CHECKS RETURN CODE 0?
```

Callee:

```hlasm
       STM   14,12,12(13)  STORE REGISTERS
       LR    12,15         GET ENTRY ADDRESS
       ...
       LM    14,12,12(13)  RESTORE REGISTERS
       XR    15,15         SET RETURN CODE (0)
       BR    14            BRANCH TO CALLER
```

Due to this convention, avoid using registers: 0, 1, 12, 13, 14, 15 in epilog and prologue.

z/OS services typically use R0, 1, 14, 15. See the man pages for more information.

### How to read principals of operations (POPs)
Explain everything: RTFM.

Each instruction is described in detail:

* Syntax
* Machine code
* Operation
* Condition code settings
* Programming exceptions

Instruction format used is generally related to the assembler syntaxt and the operation.

* `RR` Register-Register - this form usually manipulated registers.
* `RX` Register, Index, base displacement - usually moving between memory and registers
* `SS` Storage-Storage - acts on data in memory.

Diagrams show what the binary detail of the command, useful for problem diagnostics.

## What is the assemble trying to tell me?

All in the knowledge centre -> [here](http://www-03.ibm.com/systems/z/os/zos/library/bkserv/)

`DC X'00'` is useful to force an ABEND and most of the time a dump, and is easier than `WTO`ing all the registers.
