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


### Working with HLASM


### Addressing data


### Branching


### Aritmetic


### Looping


### Calling conventions


### How to read principals of operations (POPs)

