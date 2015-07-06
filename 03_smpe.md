# System Modification Program/Extended (SMP/E)
* How software is build and shipped
* Outline of SMP/E
* Using SMP/E to install
* Overview of the service process
* Using SMP/E to apply fixes
* Demo of SMP/E ISPF panels

Similar in some regards to *NIX package managers.

## Pieces of a product
Plain text (instructions, JCL, samples), executable code (normally shipped as Objct Code Only (OCO), some customizable parts or REXX Clist scripts), message catalogs and other binaries.

A program directory is also shipped, primarily with SMP/E instructions *although usually online*. This describes the dependencies, which datasets to use, etc.

### Object Code Only (OCO)
Protects IBMs IP and prevents unauthorised or unexpected modification.

Source code is compiled by IBM and shipped as object code (`.o` files) in FB80 format. Linkedit is used on customer systems to pick up local levels of the Operation System, Language Environment, etc.

### Terminology
* Function (FMID) - a major component of a product,
* System Modification (SYSMOD) - Package containing information for SMP/E,
* Load Module (LMOD) - Code linkedited together,
* Module (MOD) - Object code,
* Source (SRC) - Program code shipped as source which needs to be assembled on the target system.

### Pre-requisites
Other products which must be available locally for the target product to work.

## How does SMP/E Work

SMP/E uses two libraries to store the elements

1. Distribution library - contains all the elements such as modules an macros. Can be used for backup purposes
2. Target library - contains the executable code

Consolidated Software Inventory (CSI) is used to track both of these libraries.

### SMP/E Zones
Entries representing elements in the distribution library are put in the distribution zone.

Entries representing elements in the target library are put in the target zone.

Additionally the CSI has a global zone, which contains

* Entries needed to describe the distribution and target zones.
* Information about SMP/E processing options
* Status information for all SYSMODs SMP/E has begun to process
* Exception data for SYSMODs requiring special handling or are in error

SMP/E contains HOLD information for a SYSMOD. The reasons for a HOLD are:
* ERROR HOLD
* SYSTEM HOLD
* USER HOLD

## Working with SMP/E
The SMP/E process can be performed with three commands:

1. RECEIVE
2. APPLY
3. ACCEPT

### RECEIVE command
Gets a SYSMOD from outside of SMP/E (either tape or web) and construct entries in the global zone to describe the SYSMOD. Ensures the SYSMOD, then installs the SYSMOD into the SMP/E temporary libraries.

SMP/E will check the HOLD data to ensure no errors are introduced.

### APPLY command
Specifis which of the received SYSMODs are to be installed in the target libraries.

SMP/E also ensures that prerequisites have been installed and that SYSMODs are applied in the correct order.

1. Install the SYSMOD into the target library
2. Ensure the relationship between the current SYSMOD and other SYSMODs in the target zone is correct
3. The CSI is updated displaying the updated modules

Backups of the target libraries and zones should be taken on a production system.

APPLY CHECK is a dummy run of a full APPLY.

### ACCEPT command
Used after the SYSMOD is installs to copy the target libraries into the distribution libraries.

1. Updates CSI entires in the distribution zones
2. Using the SYSMOD, the tageted elements in the distribution libraries are rebuilt or created
3. Cerfies target zone CSI entries againstdistribution library content
4. Perform housekeeping of obsolete or expiered elements

When ACCEPT processing is complete all changes are permenant.

Reports are provided to analyse the results.

### Other SMP/E commands
* LIST
* REPORT
* QUERY

There is also a SMP/E CSI API for writing application programs to query the content of the system.

### Data sets used by SMP/E
Target & distrbition libraries.

* SMPCSI
* SMPPTS - 
* SMPSCDS - backup copies of target zone entries modified by an apply
* SMPMTS - Macros
* SMPSTS - Source libraries
* SMPLTS- Base version of a load module
* Other datasets.

The datasets to be used by installation can be specified by JCL, however it is useful to have permanent definitions stored in SMP/E using dataset definitions (DDDEFS), mapping a DDNAME to dataset names. By convention target libraries being with an 'S'. Distribution libraries begin with an 'A'.

SMP/E zones also contains DDDEFs for its own datasets.

### JCLIN
Simplified JCL which could be used to build the product target libraries from distribution libraries. Inputs and outputs must reference libaries whose low level qualifiers are assumed to be DDNAMES.

SMP/E parses the assembler, copy and linkedit control statements to build information about how target libary entities are constructed.

### UCLIN
Think of this as the SMP/E database control language. Very easy to mess up SMP/E.

## Maintenance
The service team diagnose and fix problems.

### HOLDDATA
Includes ++HOLDs for ERROR (PE and Hiper), which includes fixing PTFs when available. HOLDDATA is updated daily. SMP/E RECEIVE command is used to receive HOLDDATA into the global CSI. One file is used for all z/OS products.

### IBM service process
* PTF is a fix which has been through the complete review cycle by L3.
* APAR is a temporary fix
* USERMOD is a fix similar to an APAR, but supplied by the user (CICS does not follow this definition, we supply a ++USERMOD not a ++APAR).

1. Customer raises PMR
2. L2/L3 diagnose a bug in IBM code
3. L2 raises an APAR
4. L3 accept APAR and code fix
5. L3 provide a USERMOD to eager customer
6. L3 reviews and tests APAR code
7. L3 closes APAR and sends to build
8. Build create PTF and ships to Boulder

Service supply a Recommended Service Upgrade (RSU) which is a level of maintenance for all z/OS products which have been tested tohether.

HIPER and PE APARs reviewed weekly and installed weekly-monthly.
