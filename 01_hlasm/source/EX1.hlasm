**********************************************************************
* SIMPLE HELLO WORLD PROGRAM                                          
**********************************************************************
*                                                                     
* MAIN PROGRAM STARTS HERE                                            
*                                                                     
EX1      CSECT                                                        
EX1      AMODE 31                                                     
EX1      RMODE 24                                                     
* USUAL PROGRAM SETUP    <- FIX THIS COMMENT                          
         STM   14,12,12(13)                                           
         BALR  12,0                                                   
         USING *,12                                                   
*                                                                     
* ********************************************************************
* WRITE YOUR CODE HERE                                                
* MOVE THE DATA IN_STRING TO OUT_STRING                               
* HERE...                                                             
* ********************************************************************
*                                                                     
         MVC   OUT_STRING,IN_STRING                                   
         LA    5,WTO_AR                                               
         WTO   TEXT=(5)                                               
LMRET    LM    14,12,12(13)                                           
*                                                                     
* ********************************************************************
* WRITE YOUR CODE HERE                                                
* THE RETURN CODE OF THE PROGRAM IS HANDED BACK IN REGISTER 15        
* PROVIDE A RETURN CODE OF 0 IN REGISTER 15                           
* HERE...                                                             
* ********************************************************************
*                                                                     
         L     15,=F'0'                                               
         BR    14                                                     
* ********************************************************************
* END OF PROGRAM                                                      
* ********************************************************************
         LTORG ,                                                      
IN_STRING  DC    C'HELLO WORLD!'                                      
WTO_AR     DC    AL2(L'OUT_STRING)                                    
OUT_STRING DS    CL(L'IN_STRING)                                      
         END                                                          
