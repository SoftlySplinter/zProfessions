**********************************************************************
* DOT-PRODUCT PROGRAM                                                 
**********************************************************************
*                                                                     
* MAIN PROGRAM STARTS HERE                                            
*                                                                     
EX3      CSECT                                                        
EX3      AMODE 31                                                     
EX3      RMODE 24                                                     
* USUAL PROGRAM SETUP                                                 
         STM   14,12,12(13)                                           
         BALR  12,0                                                   
         USING *,12                                                   
*                                                                     
* INITIALISE INDEX REGISTER 5 WITH VALUE 0                            
* HERE...                                                             
*                                                                     
         LA    5,0                                                    
*                                                                     
* INITIALISE AN ACCUMULATOR REGISTER OF YOUR CHOICE (NOT 12) WITH     
* VALUE 0                                                             
* HERE...                                                             
*                                                                     
         LA    6,0                                                    
LOOP     DS    0H                                                     
*                                                                     
* LOAD INTO REGISTER 3 THE VALUE OF A_ARR[I] WHERE I IS AN INDEX      
* HERE...                                                             
*                                                                     
         L     3,A_ARR(5)               A_ARR[I] -> 6                 
*                                                                     
* LOAD INTO ANOTHER REGISTER THE VALUE OF B_ARR[I]                    
* HERE...                                                             
*                                                                     
         L     4,B_ARR(5)               B_ARR[I] -> 8                 
*                                                                     
* MULTIPLY THE REGISTERS TOGETHER                                     
* HERE...                                                             
*                                                                     
         MR    2,4                      6*8 -> 6                      
*                                                                     
* ADD THE 32-BIT RESULT TO YOUR ACCUMULATOR                           
* HERE...                                                             
*                                                                     
         AR    6,3                                                    
         AHI   5,4                                                    
         CHI   5,16                                                   
*                                                                     
* BRANCH TO LOOP IF THE CC INDICATES A RESULT OF _LESS_               
* HERE...                                                             
*                                                                     
         BL    LOOP                                                   
*                                                                     
* STORE THE RESULT FROM YOUR ACCUMULATOR INTO RESULT                  
* HERE...                                                             
*                                                                     
         ST    6,RESULT                                               
LMRET    LM    14,12,12(13)                                           
*                                                                     
         XR    15,15                                                  
         LRL   15,RESULT                                              
         BR    14                                                     
* ********************************************************************
* END OF PROGRAM                                                      
* ********************************************************************
A_ARR     DC    A(12,3,12,10)                                         
B_ARR     DC    A(4,7,9,8)                                            
RESULT    DC    F'0'                                                  
         LTORG ,                                                      
         END                                                          
