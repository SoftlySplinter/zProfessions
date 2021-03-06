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

* LOAD &rarr; data is loaded into the processors registers
* STORE &rarr; data is stored to memory
* MOVE &rarr; Data is moved from one area of memory to another

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

* G &rarr; 64-bits
* H &rarr; 16-bits
* R &rarr; Register
* C &rarr; Character


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

* OBJECT DECKS &rarr; this is the object code that is used as input to binding
* Listing &rarr; this shows any errors, all diagnostics and human readable output from the assemble phase.

Binding is the process of combining object code into a LOAD MODULE. To bind use a Binder.

The Binder produces 2 outputs:

* LOAD MODULE &rarr; this is the bound object decks forming an assembler program
* LOAD MAP &rarr; this is the binder equivalent of an assembler listing

A LOAD MOUDLE can be loaded into memory by the operating system and run.

#### Syntax
Comments start with a `*` in column 1 or appear after free-form instructions operands until column 72.

```hlasm
* THIS IS A COMMENT
L 1,=F'12'  THIS IS ANOTHER COMMENT
```

Labels start in column 1, operation codes start after column 1 or a label (normally column 10). Operands come after the operation, usually starting in column 16.

#### CSECTS and DSECTS

CSECT &rarr; CONTROL SECTION (HLASM directive). A CSECT contains machine instructions to be run on the machine.

DSECT &rarr; DUMMY SECTION (HLASM directive). A DSECT is used to define the structure of data.

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
* `NOP` no operation &rarr; never take branch, used as a placeholder (`BC 0,`)
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

* `B` uses mask `15` or `0b1111` or `8 + 4 + 2 + 1`, i.e. branch on any CC &rarr;f always branch.
* `BE` uses mask `8` or `0b1000` or `8`, i.e. branch on CC 0.

```hlasm
L     1,NUMBER
LTR   1,1
BNZ   NONZERO      BRANCH TO NONZERO
B     COMMONCODE   REJOIN COMMON CODE
```



### Arithimetic
Arithmetic is performed in a wide variety of ways on z/Architecture:

* Fixed point (including logical) &rarr; performed in GPRs
* Packed decimal &rarr; performed in memory
* Binary and Hexidecimal floating point &rarr; performed in FPRs


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

* CC 0 &rarr; result is 0; no overflow
* CC 1 &rarr; result is less than 0; no overflow
* CC 2 &rarr; result is greater than 0; no overflow
* CC 3 &rarr; overflow occured

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

* `RR` Register-Register &rarr; this form usually manipulated registers.
* `RX` Register, Index, base displacement &rarr; usually moving between memory and registers
* `SS` Storage-Storage &rarr; acts on data in memory.

Diagrams show what the binary detail of the command, useful for problem diagnostics.

## What is the assemble trying to tell me?
All in the knowledge centre -> [here](http://www-03.ibm.com/systems/z/os/zos/library/bkserv/)

`DC X'00'` is useful to force an ABEND and most of the time a dump, and is easier than `WTO`ing all the registers.

Using map in the Assembly listing is useful to check when max displacement is approaching limits.

## HLASM Runtime Debugging
*Fixing the !!fun!! of programming in assembler.*

There's a rational explanation of every error message and problem. 

If you are lucky, the program with <abbr title="ABnormal END">ABEND</abbr>, giving a nice sympton dump. If not there is an internal tool.

Programs should normally run to completion and exit return code 0. Some reasons why not:

* Hardware detected error
* System detected error
* Application logic error

Program checks:

* 0C1 Operation Exception - CPU attempts to execute an instruction with an invalid op code.
* 0C2 Priviledged operation Exception.
* 0C3 Execute exception - target of an EXECUTE instruction is another EXECUTE.
* 0C4
  * 0C4-4 Protection Exception - Key of running program tries to access storage of another key.
  * 0C4-10 Segment Translation Exception - Program trying to access storage that has not been obtained
  * 0C4-11 Page Translation Exception - Program trying to access storage that has not been obtained.
* 0C5 Addressing Exception - CPU attempts to reference a main-storage location that is not availabe.
* 0C6
* 0C7
* 0C8
* 0C9

See MSV System codes in the knowledge centre.

When a program check or ABEND occurs, z/OS enters recovery process and will provide a Sympton Dump.

### Symptom Dumps

Provides the PSW at time of error which, most usefully, provides the address of the program at time of execution. Althought the address and offset are printed, they should not be trusted. They can be the next instruction or the instruction before.

Data at PSW provides a useful view of what was being executed, in the form `start address - instructions`.

### Program Status Word (PSW)

PSW is 128-bits in length.

* 0-32 contain flags indicating control information for the CPU
* 33-63 are 0
* 64-127 contain the instruction address

Can access the PSW in programs through using EPSW (Extract PSW) and set it using LPSW(E), replacing the entire PSW with the contents of storage, meaning you can do branching - but probably not a good idea if you really don't know what you're doing.

The BEAR (Branch ? Address Register) can be useful if the PSW is missing, or has an invalid address.

## System Data Areas and Services

Lots of information in the documentation (KC).

### System Data Areas
z/OS allocates data areas (control blocks) in each address block, used to:

* Keep state
* Store configuration
* Collect statistics
* Point to other data areas (anchor blocks)
* Point to system routines that can be called to request services
* Parameter areas

### System Services
z/OS manages all the resources in the system:

* Processors
* Storage
* I/O
* Links to communication networks
* Dispatching and balanching

Applications need to interace with z/OS to request services.


#### Processes and Threads
* Schedule work
* Start new processes or threads (TCBs, SRBs)
* Create and destroy address spaces
* Load executable modules into virtual storage
* Interrupt and resume processes
* Synchronise work between processes
* Priotise the work to optimise use of resources
* Handle exceptions and recover from failure

#### Storage
* Get and free storage (virtual and real, private or common)
* Protect storage
* Serialise access to storage
* Allocate and access common storage.

#### I/O
* Allocate datasets
* Read and write
* organise data in datasets
* Verify permissions

#### Other services
* Network communication (TCP/IP)
* Security (RACF)
* Sysplex (XES/XCF)
* Problem determination
  * Storage dumps
  * Trace
  * Slip traps

### System Macros
Request services from z/OS.

The main macro libraries are in:

* `SYS1.MACLIB`
* `SYS1.MODGEN`

There are other macros for specific components (RACF, RRS, XCF/XES, etc.)

### System data areas
Common systemn data areas:
 
#### Prefixed Save Area (PSA)
Located at virtual storage 0 in every address space.

Macro `IHAPSA` (DSECT PSA)

Used to save area of execution state address space during interruptions, anchor block for many key system control blocks, PSAAOLD point to current address space ASCB, PSATOLD point to current task TCB.

#### Communications Vector Table (CVA)
Absolute virtual address 16 contains the pointer to the CVA.

Used to locate entry point to many operating system service routings, pointers to many system control blocks, `CVTECVT` points to Extended CVT.

```hlasm
L      R03,16        CVT ADDRESS - NOTE: SHOULD USE CVT OFFSET FROM PSA
USING  CVT,R03
L      R04,CVTECVT   ECVT ADDRESS
USING  ECVT,R04
```

#### Address Space Control Block (ASCB)
Used to hold basic information about an address space; jobname, ASID. More infomration is held in ASCB extension ASXB.

```hlasm
L     R02,PSAAOLD-PSA   ASCB ADDRESS
USING ASCB,R02
LA    R02,ASCBASID      HOME ASID
```

#### Task Control Block (TCB)
Used to represent task or a dispatchable unit of work. Anchor to other task related control blocks.

#### Event Control Block (ECB)
Normally resides in user address space.

Represents an even that TCBs can wait form, when an event is completed, it is POSTed and the TCBs are resumed.

This is used to synchronise task.

Used with `WAIT`, `EVENTS`, `POST`, `ATTACH`, `ATTACHX` and `WTOR` macros.

### System macros

#### GETMAIN
Allocates virtual storage, equivalent to `STORAGE OBTAIN` macro.

Two types of linkage:

* SVC - Task only, no cross-memory. 24, 31 or 64 bit storage with no locks.
* Branch - Task or SRB, cross-memory. 24, 31 or 64 bit storage where locks can be held.

```hlasm
L       R00,=A(6000)             REQUEST AREA LENGTH
GETMAIN RU,LV=(R00),LOC=(31,31)  UNCONDITIONAL, 31 BIT
```

#### FREEMAIN
Frees virtual storage.

```hlasm
L        R01,AREA             AREA IS THE ADDRESS OF THE STORAGE
L        R00,=A(L'AREA)       LENGTH OF THE AREA
FREEMAIN RU,R=(R01),LV=(R00)  UNCONDITIONAL
```

*Note:* Unconditional means that if the storage cannot be (de)allocated, an ABEND occurs. Conditional give an RC 15.

#### Storage
This macro is used to obtain or release areas of virtual storage.

Two functions:

* `STORAGE OBTAIN`
* `STORAGE RELEASE`

Linkage types:

* `LINKAGE=SYSTEM` receives control through `PC`
* `LINKAGE=SVC` receives control through `SVC`
* `LINKAGE=BRANCH` receives control through branch

Obtaining virtual storage in requested subpool and location (24 or 31 bit storage). The real backing storage can be in 24, 31 or 64 bit storage.

To unconditionally obtain 1000 bytes of storage from `SP=0` using `LINKAGE=SYSTEM`, storage address is returned in R01.

```hlasm
STORAGE OBTAIN,
      LENGTH=1000,
      ADDR=(1),
      LOC(24,64),
      COND=NO
```

Releasing virtual storage of previously allocated storage (through STORAGE OBTAIN or GETMAIN).

To unconditionally release 1000 bytes pointed by address R01:

```hlasm
STORAGE RELEASE,
      LENGTH=1000,
      ADDR=(1),
      COND=NO
```

### DCB

Describe the attributes of a dataset, used with non-VSAM datasets. Must be allocated in 24 bit storage.

```hlasm
MYDCB   DCB   DSORG=PS,RECFM=VBA,MACRF=(W),
              BLKSIZE=882,LRECL=125,DDNAME=SNAPME
```

#### OPEN (datasets)

Prepares a dataset for processing

```hlasm
         LA    R03,MYDCB
         OPEN  ((R03),),
               MODE=31,
               MF=(E,L_OPEN)              EXECUTE FORM
               
L_OPEN   OPEN  (,(OUTPUT)),MODE=31,MF=L   LIST FORM
```

#### CLOSE (datasets)

```hlasm
LA    R03,MYDCB
CLOSE ((R03)),MODE=31
```

#### GET (dataset)

GET macro to retrieve records from QSAM dataset (Queued Sequential Access Method).

GET has two modes:

* Move mode: record is copied to buffer provided
* Locate mode: pointer to record in buffer

Move mode:

```hlasm
         GET   DCBNAME,RECBUF
         LA    R04,RECBUF
         GET   DCBNAME,(R04)
DCBNAME  DCB   MACRF=GM,...
```

Locate mode:

```hlasm
         GET   DCBNAME
DCBNAME  DBC   MACRF=GL,...
```

#### PUT (datasets)

Move mode:

```hlasm
         PUT   DCBNAME,RECBUF
         LA    Rxx,RECBUF
         PUT   DCBNAME,(Rxx)
DCBNAME  DCB   MACRF=PM,...
```

Locate mode
```hlasm
         LA    R01,RECBUF
         PUT   DCBNAME
DCBNAME  DCB   MACRF=PL,...
```

#### WTO
Write messages to operator console.

#### SNAPX
Dump virtual storage areas allocatored to current job. It can also dump areas in data spaces. Program execution continues after SNAPX.

```hlasm
         LA    R03,SNAPDCB POINTER TO DCB
         SNAPX DCB=(R03),
               STORAGE=(TCB_S,TCB_E),
               STRHDR=(SNAPH1)

TCB_S    DS    A                               SNAP AREA 1 START
TCB_E    DS    A                               SNAP AREA 1 END

SNAPH1   DC    AL1(L'SNAPT1)
SNAPT1   DC    C' TCB: '

SNAPDCB  DCB   DSORG=PS,RECFM=VBA,MACRF=(W),
               BLKSIZE=882,LRECL=125,
               DDNAME=SNAPME
```

### System macro forms

Standard form, List and execute (ensures re-entrant macros), List, Execute, Modify.

Example standard form:

```hlasm
          WTO   TEXT=L3_MSG1L
L3_MSG1L  DC    AL2(L'L3_MSG1)    LENGTH OF MESSAGE AREA
L3_MSG1   DC    CL80'MESSAGE1'    MESSAGE AREA
```

Example executed and list forms:

```hlasm
          WTO   TEXT=L3_MSG2L,MF=(E,WTOLST1)
WTOLST1   WTO   TEXT=,MF=L
L3_MSG2L  DC    AL2(L'L3_MSG2)                 LENGTH OF MESSAGE AREA
L3_MSG2   DC    CL80'MESSAGE2'                 MESSAGE AREA
```

## Relative Addressing
What happens when you run out of registers - there's only 16 of the buggers.

Absolute addressing with base registers makes it difficult to do some things - branching backwards.

`USING` and labelled values make things easy, so long as you stay with 4K.

(Contrived) Exmaple:

```hlasm
R6        EQU   6,,,,GR32
R8        EQU   8,,,,GR32
          USING WS,R6
          la    R6,WS_INIT
LABEL1    LA    R8,COUNT
...
WS_INIT   DC CL24' '        FILTER
          DC F'1'           COUNT
...
WSDSECT
FILTER    DS CL24
COUNT     DS F
```

So how do we address storage using a >12 bit displacement - use 2 (or more) base registers.

To fix this - relative addressing is needed.

Displacement values for new instructions because 20 (? - can be 16-bits and can be 32-bits) bits in length - and they're allowed to be positive or negative. *Note:* all instructions are halfword aligned.

Instead of `LA` you can use `LAR(L)` - Load Address Relative (Long), note the lack of base (and index) registers. There are a good number of relative addressing variants, but not for arithmetic or boolean operations, so you'll still need base registers for those, or just use register variants instead.

The main use of relative addressing is for branching. Use Jump not Branch in HLSAM.

### AMODE and RMODE
* AMODE - Addressing Mode. Where in memory can a program address.
* RMODE - Residency Mode. Where the program is loaded.

Most often the same and 31, unless there's a damn good reason not to.

## Multi-threading
*How to mess up many things at the same time*

In z/OS an Address Space is created for a program, synonymous with a process. A TCB is synonymous with a thread. z/OS core services run as address spaces too.

Address space is a virtual sandbox which contains the program, providing virtualised memory just for the program so one program cannot affect others (unless the program is authorised, and it's still difficult to do). Anything executing inside the address space is a TCB or SRB.

The main task is on a single TCB, which is allowed to spawn more TCBs (each of which can spawn TCBs). Parents are in charge of starting and stopping child tasks, the parent will ABEND if it finishes before its children.

### ATTACHX Macro
Creates a new task specified by the EP parameter (EP contains the load module to attach).

You can pass a parameter list to the attached load module, if the task is sucessfully attached, R1 contains the TCB address if the new subtask, which is required to control the subtask.

### Allowing TCBs to communicate
Inter-task communication allows co-ordination of the workload in the system - typically through ECBs.

An ECB is a full word (4 bytes) on a full word boundary. Bit 1 indicates someone is WAITing on the ECB, bit 2 indicates someone has POSTed the ECB. Optionally a completion code in the other 30 bits.

If someone POSTs before the WAIT, the WAIT immediately returns - the "waiter" must clear the ECB before waiting.

As with all multi-threading architectures, this must be designed correctly!

### POST and WAIT macros
Available in assembler and PLX.

### ATTACH with ECB parameter
Allows programs to be posted when the child task has terminated - much better than randomly sleeping.

Parent TCB must DETACH child TCBs when they are terminated.

### Serialisation
ATTACHed TCBs all compete for CPU and therefore run in parallel (interleaved or genuinly parellel, depending on CPUs available). Sometimes you may need them to serialise on a resource.

Programs may need to do the same whe:
* Writing to a file
* Accessing a shared resource
* Ensuring only a single instance is running
* etc.

ISGENQ macro allows a program to OBTAIN or RELEASE an enqueue.

The resource is named in QNAME. EXCLUSIVE or SHARED can be requested:

* SHARED - no other TCBs can be using the resource EXCLUSIVEly.
* EXCLUSIVE - no other resource can be using the resource.

When writing the macro, there are multiple paths for when the resource is unavailable:

* Get a RC
* Cause an ABEND
* Wait for the ENQ

Once the program has finished with the resource, it calls ISGENQ RELEASE. **Note:** automatically released (process/TCB?).

A scope can be set for the request:

* STEP - if the resource is only in the program's address space
* SYSTEM - if the resource is serialised across all address spaces in an LPAR.
* SYSTEMS/SYSPLEX - if the resource is serialised to more than one LPAR on the sysplex.

## Linkage Conventions
Conventions a linked program/subroutines should follow. Need to preserver registers from one program to another.

Saving 31-bit registers is now a de-facto standard. 64-bit gets more interesting.

Expect 31-bit registers 2-14 and 64-bit 2-13 unchanged. ARs 2-13 unchanged.

To do this - use the:

* caller provided save area
* system provided linkage stack

### Register Usage

* R0 - parameter/reason code
* **R1** - address of parameter list
* R12 - program base address
* **R13** - address of current save-area
* **R14** - return address
* **R15** - branch address/return code

### Caller provided save-areas

| (used by language products) |
|:---------------------------:|
| Backward pointer |
| Forward pointer |
| Register 14 |
| Register 15 |
| Register 0 |
| Register 1 |
| Register 2 |
| Register 3 |
| Register 4 |
| Register 5 |
| Register 6 |
| Register 7 |
| Register 8 |
| Register 9 |
| Register 10 |
| Register 11 |
| Register 12 |


```hlasm
* PROG A
BASR  R14,R15           BRANCH TO PROG B
```
```hlasm
* PROG B
STM   R14,R12,12(R13)   STORE REGISTERS IN PROG A
LR    R12,R15           COPY R15 AS GETMAIN USES IT
GETMAIN RU,LV=72        CREATE SAVE-AREA
ST    R13,4(,R1)        PUT SAVE-AREA ADDRESS IN FORWARD POINTER OF PROG A SAVE-AREA
ST    R1,8(,R13)        PUT PROG A SAVE-AREA ADDRESS IN BACKWARD POINTER
LR    R13,R1            CHANGE R13 TO POINT AT CURRENT SAVE AREA
* ...
LR    R1,R13            KEEP A COPY OF R13 FOR FREEMAIN
L     R13,SAVEAREA+4    POINT R13 AT PROG A SAVE AREA
FREEMAIN RU,A=(R1),LV=72
LM    R14,R12,12(R13)   RESTORE REGISTERS FOR PROG A
SR    R15,R15           SET R15 TO 0 (RETURN CODE)
BR    R14               RETURN CONTROL TO PROG A
```

Then along came 64-bit

For F4SA (64 replacement of 31 bit), the save area is 18 double-words (144 bytes). Backwards pointer is at offset x80 and forward pointer at 0x88.

| 0000 'F4SA' |
|:---------:|
| Register 14 |
| Register 15 |
| Regsiter 0 |
| Regsiter 1 |
| Regsiter 2 |
| Regsiter 3 |
| Regsiter 4 |
| Regsiter 5 |
| Regsiter 6 |
| Regsiter 7 |
| Regsiter 8 |
| Regsiter 9 |
| Register 10 |
| Register 11 |
| Register 12 |
| Backwards pointer |
| Forward pointer |

```hlasm
* PROG A64

```

```hlasm
* PROG B64
STMG  R14,R12,8(,R13)        SAVE REGISTERS TO CALLERS SAVE-AREA
GETMAIN RU,LV=144
STG   R13,128(,R1)         SAVE FORWARD POINTER TO CALLERS SAVE-AREA
STG   R1,136(,R13)         SAVE BACKWARD POINTER TO CURRENT SAVE-AREA
MVC   4(4,R1),=A(C'F4SA')  ADD EYECATCHER
LGR   R13,R1
```

Additional problems if a 64-bit aware program calls a 64-bit unaware program. In that case the old logic still works (31-bit pointers into 64-bit save area).

More problematic is if a 64-bit unaware program calls a 64-bit aware program. Check the save-area eye-catcher and so the save-area is too small to save 64-bit registers. But can't just ignore the 64-bit registers as the callers caller might use them:

F5SA: 27 double-words.

```hlasm
* POPULATE NORMAL SAVE AREA WITH LOW-ORDER BITS
STM   R14,R12,12(R13)              STORE BOTTOM 32-BITS OF REGISTERS INTO THE NORMAL SAVE AREA
SRLG  R0,R0,32                     KEEP TOP HALF OF R0, R1 AND R15 AS GETMAIN WILL MESS THEM UP
LR    R2,R0
SRLG  R1,R1                        
LR    R3,R1
SRLG  R15,R15,32
LR    R4,R15
GETMAIN RU,LV=216
* POPULATE BOTTOM OF NEW SAVE-AREA WITH HIGH-ORDER BITS
STG   R13,128(,R1)                  STORE R13 IN THE BACKWARDS POINTER OF THE NEW SAVE-AREA
STMH  R2,R14,152(,R1)               STORE THE TOP HALF OF REGISTERS INTO THE NEW SAVE-AREA (AT THE BOTTOM)
ST    R2,144(R1)                    STORE THE HIGH-ORDER BITS OF R0
ST    R3,148(R1)                    STORE THE HIGH-ORDER BITS OF R1
ST    R4,208(R1)                    STORE THE HIGH-ORDER BITS OF R15
ST    R1,8(R13)                     ONLY IF YOU HAVE MORE THAN 2G IN THE SAVE AREA
MVC   4(,4,R1),=A(C'F5SA')          EYECATCHER
LGR   R13,R1
* WEEP QUIETLY AND WAIT UNTIL YOU HAVE TO LOAD THIS ALL BACK
```

* F7SA - for programs which use 64-bit registers and ARs (27 double-words)
* F8SA - for programs which use 64-bit registers and ARs, and caller only provided 72-byte save area (36 double-words)

No logic for going from 64-bit no ARs to 64-bit ARs.

There are a few macros which do things for you:

* `SAVE` Save specified reange of registers in save-area addressed by R13 (SYSSTATE AMODE sensitive). **Gotcha:** R15 must point to it. `SAVE  (14,12),,*`
* `RETURN` Retores a specified range of registers and set a return code in R15 (SYSSTATE AMODE sensitve). `RETURN  (14,12),T,RC=0`
* `IHASAVEAR` (SYS`.MACLIB) is the DSECTs for save-area layout.


### Linkage Stack

System provided area were a target program can save the calling program's access registers and general purpose registers (ARs and GPRs). Saves both ARs and 64-bit GPRs, save areas are located in one place, rather than chained throughout the address space.

Finite size (defaults to 96 entries per TCBs - can expand LSEXPAND) and makes dump reading trickier.

Perform via Branch and Stack instruction `BAKR R1,R2`, create a new linkage stack entry and the contents of GPR 0-15 and AR 0-15. Can use with 0 to just save the registers.

Return via: `PR`, retoring GPRs 2-14 and ARs 2-14. Stack entries are removed.

Extract without branching via `EREG`.

### Parameter Lists

Register 1 points to a list of addresses and each address in the list points to the actual data. The end of the list *may* be indicated by the high order bit being on in the last entry. Parameter list are generally below the bar.

### Dumps

Find R13

* SVC - STATUS FAILDATA
* SLIP/ABEND - STATUS REGS
* Console dump - SUMMARY FORMAT

## Inter-language Communication
Each language has its own strenghts and weaknesses - choose the right tool for the job. Skill play a big part in the choice in language. Other choices such as cross-platform (shared modules between z/OS and distributed environments) play a factor as well.

Each program and module in a project can call another via a well defined API.

Java uses the Java Native Interface (JNI) in order to work with other language. C (and C++) use the `extern` keyword to define variables and functions defined externally in othe rmodules. These references are resolved at Link/Bind time.

Whenever modules areas are linked together, they must conform to a calling convention. z/OS has different conventions depending on what type of code is being run and the environment inside z/OS in which it is to be run.

C and C++ languages even provide directives in order to allow individual functions to be called with different linking conventions (e.g. `__cdecl`).

Normally assembler has to conform to the conventions of the caller.

| Environment                    | Linkage used  | C++ example                     |
|--------------------------------|---------------|---------------------------------|
| Non-LE ASsembler               | OS            | `extern "OS" { ... }`           |
| LE Assembler, non-XPLINK C/C++ | OS\_UPSTACK   | `extern "OS_UPSTACK" { ... }`   |
| Normal Assembler               | OS31\_NOSTACK | `extern "OS31_NOSTACK" { ... }` |
| XPLINK C/C++                   | OS\_DOWNSTACK | `extern "OS_DOWNSTACK" { ... }` |
| PL/I                           | PL/I          | `extern "PLI" { ... }`          |
| COBOL                          | COBOL         | `extern "COBOL" { ... }`        |
| FORTRAN                        | FORTRAN       | `extern "FORTRAN" { ... }`      |
| C                              | C             | `extern "C" { ... }`            |

After a module has been compiled or assembled, it is in a form called *object code*. Object code contains executable instructions, but:

* References to OS services may be unresolved - resolved at link and load
* Calls to other modules are unresolved - resolved at link
* Calls to subroutines within the same module have been resolved
* Relocatable variables in the code are unresolved - resolved at load

As well as linking, the linked changes the format of the program into a load module.

Example: C

```c
// file1.c
extern int gbl_tot = 0;
extern void prt_total();

int main(void) {
    gbl_tot = 10;
    prt_total();
    return 0;
}
```

```c
// file2.c
#include <stdio.h>
#include <stdlib.h>

extern int gbl_tot;
extern void prt_total();

void prt_total() {
    printf("%d", gbl_total);
}
```

```sh
# build_script.sh
c89 -c file1.c
c89 -c file2.c
c89 -o my_prog file1.o file2.o
./my_prog
```

HLASM uses V-type address constant in order to provide a pointer to an external subroutine.

```hlasm
          L     R12,=A(TOTAL)
          USING TOTAL,R12   
          STG   R11,TOTAL
          L     R15=V(PRT_TOTAL)
          BASR  R14,R15
          COM   ,
TOTAL     DS    FD
```

```HLASM
          ENTRY PRT_TOTAL
PRT_TOTAL DC    0H
          L     R12,=A(TOTAL)
          USING TOTAL,R12
          LA    R5,WTO_BUF
          LG    R6,TOTAL
          BAS   R14,CONV_TEXT
          WTO   TEXT=(5)
          COM   ,
TOTAL     DS    FD
```

Using C to call assembler.

```c
// main.c
// Will call assembler
#pragma linkage(CALLPRTF,OS)
int main(void) {
    CALLPRTF();
    return 0;
}
```

```c
// call.c
// Will be called from assembler

// Setup LINK conventions
#pragma linkage(_printf4, OS)

#include <stdio.h>

// Map _printf4 to @PRINTF4
#pragma map(_printf4, "@PRINTF4")

int _print4(char *str, int i) {
    return printf(str, i);
}
```

```hlasm
CALLPRTF  CSECT
          EDCPRLG
          LA    R1,ADDR_BLK
          L     R15,=V(@PRINTF4)
          BAsR  R14,R15
          EDCEPIL
ADDR_BLK  DC    A(FMTSTR)
          DC    A(X'80000000'+INTVAL)
FMTSTR    DC    C'Sample formatting string'
          DC    C' which includes an int -- %d --'
          DC    AL1(NEWLINE,NEWLINE)
          DC    C'and two newline characters'
          DC    AL1(NULL)
*
INTVAL    DC    F'222'
NULL      EQU   X'00'
NEWLINE   EQU   X'15'
          END
```

### Why Assembler and C should work.
Assembler is used to program the machine's hardware. C is a general purpose system programming language, designed in order to (re)write the UNIX operating system.

C++ is an extension to C, adding extra functionality (object-orientation, references, etc.)

Both C and C++ support the `asm` keyword in order to embed assembler (**note:** `__asm` is not part of C/C++, it is added by the z/OS compiler (which doesn't support `asm`).

The C standard would be:

```c
int main(void) {
    asm("xr 5,5");
    return 2;
}
```

Using the z/OS C compiler will not resolve the `asm` keyword. In z/Linux it might compile, but might not be as expected (compilers get in the way).

It's still not great even with `__asm`. You have to provide a special runtime environment: METAL option on the C compiler.

```c
__asm volatile ("assembler code"
                   :output
                   :input
                   :clobber_list
               );
```

`volatile` keyword stops compiler from optimising the ASM.

The modifiers on input/output are:

* `=` &rarr; operand is write-only (previous value is discarded)
* `+` &rarr; operand is read/write
* `&` &rarr; operand may be modified before the instruction finishes

The constraints are:

* `a` &rarr; GPR except for 0
* `d/r` &rarr; use a GPR
* `i` &rarr; use immediate (integer or string) operand
* `m` &rarr; memory operand
* `n` &rarr; immediate integer
* `s` &rarr; immediate string

```c
unsigned in strlen(const char * c) {
    unsigned int retval;
    __asm volatile(
                "          XR    r0,r0       \n"
                "          L     r5,%1       \n"
                "SRST_LOOP SRST  r0,r5       \n"
                "          BC    1,SRST_LOOP \n"
                "          SR    r0,r5       \n"
                "          ST    r0,%0       \n"
                :"=m"(retval)
                :"m"(c)
                :"r0","r5"
                  );
    return retval;
}
```

Using high-level languages means the code is only as good as the compiler, using HLASM means the codes is only as good as the code. Sometimes one of these are good, sometimes one of these are bad (and sometimes both)!
