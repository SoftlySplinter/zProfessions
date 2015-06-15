//ZEDEDNN3 JOB NOTIFY=&SYSUID                                        
//S1       EXEC PGM=ASMA90                                           
//* *****************************************************************
//* CHANGE THE FOLLOWING LINE TO REFLECT THE PROGRAM NAME            
//* *****************************************************************
// SET PRGNM=EX3                                                     
//* *****************************************************************
//* *****************************************************************
//* *****************************************************************
// SET     SRCLIB=&SYSUID..STAGE2.ASM0.SOURCE                        
//SYSLIB   DD DISP=SHR,DSN=SYS1.MACLIB                               
//SYSPRINT DD SYSOUT=*                                               
//SYSLIN   DD DSN=&&TEMP,DISP=(,PASS),SPACE=(CYL,1)                  
//SYSIN    DD DSN=&SRCLIB(&PRGNM),DISP=SHR                           
//S2       EXEC LKEDG,COND=(8,LE),                                   
//             PARM.LKED='XREF,LIST,NCAL,MAP'                        
//SYSLIN   DD DISP=OLD,DSN=*.S1.SYSLIN                               
//SYSPRINT DD SYSOUT=*                                               
//GO.SYSUDUMP DD SYSOUT=*                                            
//* *****************************************************************
//* *****************************************************************
//* *****************************************************************
