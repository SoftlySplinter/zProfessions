**********************************************************************
* SIMPLE ADDRESSING LOOP PROGRAM                                      
**********************************************************************
*                                                                     
* MAIN PROGRAM STARTS HERE                                            
*                                                                     
EX2      CSECT                                                        
EX2      AMODE 31                                                     
EX2      RMODE 24                                                     
* USUAL PROGRAM SETUP                                                 
         STM   14,12,12(13)                                           
         BALR  12,0                                                   
         USING *,12                                                   
*                                                                     
* SAVE REGISTER 1 SOMEWHERE BECAUSE IT MAY BE USED BY WTO             
* HERE...                                                             
*                                                                     
         LR    3,1                1 -> 3                              
         WTO   'HELLO'                                                
         LA    5,WTO_AR           5 -> WTO BUFFER                     
*                                                                     
* RESTORE THE SAVED VALUE TO REGISTER 1                               
* HERE...                                                             
*                                                                     
         LR    1,3                3 -> 1                              
         L     3,0(,1)            GET TO PARM LIST POINTER            
*                                                                     
* LOAD THE HALFWORD VALUE AT REGISTER 3 DISPLACEMENT 0 TO REGISTER 4  
* HERE...                                                             
*                                                                     
         LH    4,0(,3)            PARAMETER LENGTH -> 4               
*                                                                     
* LOAD THE ADDRESS AT REGISTER 3 DISPLACEMENT 2 TO REGISTER 3         
* HERE...                                                             
*                                                                     
         LA    3,2(,3)            PARAMETER VALUE -> 3                
*                                                                     
* CHANGE THE WXYZ TO SPECIFY A DISPLACEMENT 0 AND BASE REGISTER 3 IN  
* THE MVC INSTRUCTION BELOW.  NOTE THAT FOR THE MVC INSTRUCTION,      
* THERE IS NO INDEX PARAMETER (UNLIKE IN LA)                          
*                                                                     
LOOP     MVC   OUT_STRING(1),0(3)                                     
         WTO   TEXT=(5)                                               
         AHI   3,1                BUMP 3 TO NEXT CHARACTER            
         BCT   4,LOOP                                                 
LMRET    LM    14,12,12(13)                                           
*                                                                     
         XR    15,15                                                  
         BR    14                                                     
* ********************************************************************
* END OF PROGRAM                                                      
* ********************************************************************
WTO_AR     DC    H'1'                                                 
OUT_STRING DS    C                                                    
         LTORG ,                                                      
         END                                                          
