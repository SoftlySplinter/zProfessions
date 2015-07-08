# Debugging and Problem Diagnosis
Think breadth first:

* What documentation is there, 
* What lead to the problem, 
* Why now? What's different?
* Build a hypothesis
* Predict consequences
* Look for evidence to support theory

z/OS has had Reliability Availability Servicability (RAS) designed in from birth.

Common facilities used by all z/OS produces provide the tools and data for diagnosis.

The common diagnosis process is:

* Find offset of ABEND in the object code
* Use program compilation listing to identify the failing statement
* Use program source (in CRUISE) together with the state from the dump to find the bug.

## Sources of Diagnosis Data
* [Message logs](#messages)
* [LOGREC](#logrec)
* [SMF](#system-measurement-facility)
* [Trace](#trace)
* [DUMP](#dump)

### Messages
Message logs:

* JOBLOG - all the messages written by the address space
* SYSLOG - amalgamation of all messages written by all jobs and other system information.

View output using SDSF.

### LOGREC
Hardware and software errors recorded by z/OS. May be used to analyse long term trends (particulary in hardware) or other failures leading up to the error that occured.

Useful to see what other errors have occured when using shared address spaces.

### System Measurement Facility
Most z/OS produces record statistics or accounting information to SMF. There are many different SMF types with their own formats. Useful for looking at performance.

Format the LOGREC with EREP (IFCERP1). A system dump contains the last x LOGREC entries.

### Trace
Most useful for detailed diagnosis, like a flight recorder.

There's many different levels including system trace (on all the time), component trace (enabled individually), GTF (long term recording of trace to disk) and many different product specific traces (CICS, MQ, Broker) which use the product specific formatters.

### DUMP
Snapshot of storage at the time of a problem (formatted or unformatted) which is written to a dataset.

Types of DUMPS:

* ABEND dump
  * SYSUDUMP (formatted)
  * SYSABEND (formatted)
  * SYSMDUMP (unformatted)
* SVC dump (unformatted), produced by the DUMP command, SLIP or the SDUMP/X macro. SDATA controls what storage is dumped.
* SNAP (formatted) using the SNAP macro (output to specified DD)
* Stand-alone, SADUMP (unformatted and big!) *whole LPAR*

Unformatted DUMPs are proccessed using IPCS. Products can provide formatting routines (the VERB EXITS), IPCS supports simple scripting with REXX.

Size of DUMPs can be controlled using MAXSPACE, if this exceeded a partial dump is produced.

DUMPs are normally generated because of ABENDs, or that System Recovery occured and part of the recovery is to take a DUMP.

z/OS provides a set of 'ignore ABEND' SLIP traps which inhibit dumps for common ABENDS.

#### DUMP ANALYSIS and ELIMINATION (DAE)
Suppresses SVC dumps with duplicate symptoms.

## Iteractive Problem Control System (IPCS) Tour
To make life easier:

* `SETDEF DISPLAY LENGTH(8192)`
* `SETDEF NOCONFIRM`

Customise the PF keys - make PF12 do RETRIEVE

Listing storage can be done using option 6, `IP L <addr> STR` (STR causes offsets from start to be displayed.

Remember the ? Operator e.g. `IP L 0 STR`, `IPL L 10? STR` look at offset 10 from absolute 0.

### Diagnosis data (revisited)
* Logs `VERBX MTRACE`
* LOGREC `VERBX LOGDATA`
* SMF (not available)
* TRACES
  * System trace `SYSTRACE`
  * Component trace `CTRACE COMP(xxxx)`
  * GTF is not normally in dump unless started with `MODE=INT`
  * Product traces usually via product supplied `VERBX` e.g. `DFHPDxx` for CICS or `CSQWDxx` for MQ.

## Servicability Level Indication Processing (SLIP) Traps
System command which can be run to trap system events and errors. Many options for tailoring to unique problems or conditions.

SLIP processing is a combination of hardware and software. It get invoked before FRRs and ESTAEs (recovery) which means than any converted (or changed by recovery) ABEND codes will not be seen by the SLIP - i.e. it traps the original ABEND code. In order to trace, the *original* ABENE code must be specified for the SLIP - look at the original source code.

Can be used for:

* Obtaining a dump or trace when in a particular scenario occurs:
  * An instruction is executed (Instruction Fetch, `IF`)
  * Storage area changed (Storage Alteration, `SA`)
  * Message issues (`MSGID=`)
  * ABEND (`COMP=`)
* Dump additional diagnostic information
  * Other address spaces
  * Dataspaces
  * CF structures
* Ensure DAE doesn't stop dumps
* Suppressing dumps
* Getting a dump before ESTAE or FRR recovert routines get invoked
* Repairing things (`REFBEFOR`/`REFAFTER`)
* Testing recovery

```
SLIP SET,Event,Conditions,Action,Tailor,END
```

* Event fires when a specific condition is met
 * `IF` fires when a specified instriction, or range of, is executed
 * `SA` fires when a specific storage address, or range of, is altered
 * `SBT` fires when a branch to a specified instruction, or range of, is successful
 * `COND=` fires when ABEND occurs
 * `MSGID=` fires when message is issued (by a WTO)
* Conditions, what needs to be true for the trap to fire
 * `DATA=` specifis contents of storage locations or registers
 * `JOBNAME=`/`ASID=` specifies address space
 * `PVTMOD=`/`LPAMOD=`/`NUCMOD` specifies instruction address range to be monitored (for `IF`).
 * `RANGE=`, specifies storage address range to be monitored (for `SA`).
* Action, what to do when the trap fires
 * `ACTION=`
   * `SVCD` (async)
   * `SYNCSVCD` (sync, PER only)
   * `NODUMP` don't take a dump
   * `TRACE` write a trace record to GTF
   * `RECORD` force logrec recording (override ESTA/FRR)
   * `RECOVERY` take a `06F` ABEND (PER only)
   * `REFBEFOR`/`REFAFTER` change ('refresh') storage or registers before or after SLIP takes other actions
   * `TARGETID` enable another SLIP trap
   * `STOPGTF` stop GTF tracint
* Tailor, extra stuff to go with the action
 * `JOBLIST=` jobnames to dump
 * `TRDATA=` specifies what to trace
 * `ASIDLST=` address spaces to dump
 * `STRLIST=` coupling facilities structures to dump
 * `DSPNAME=` dataspace to dump
 * `MATCHLIM=` number of times SLIP fires before automatically disabling

## Language Enclave (LE)
To review a SYSMDUMP, use VERBEXIT CEEERRIP (alias LEDATA). SUMMARY provides general info and run-time options. CEEDUMP is used for traceback report. CM for condition information such as condition codes, failing PSW and registers at time of error.
