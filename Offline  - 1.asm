.MODEL SMALL
.STACK 100H

.DATA
X DB ?
Y DB ?
Z DB ?
P DB ?
ARR DB X DUP(0) 

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    LEA SI, ARR
    MOV Z, '1'
    AND Z, 0FH
    MOV BL, '1'
    AND BL, 0FH
    
    
    MOV AH, 1
    INT 21H
    MOV CL, AL
    MOV X, CL  
    AND CL, 0FH ;value of input "n" intact for future use
    AND X, 0FH  ;n in integer form
    INC X
    INC CL
    MOV P, '2'
    AND P, 0FH
    
    ;check for invalid input
    CMP CL, 0
    JNG EXIT
    JMP INPUT
    
    INPUT:
        INT 21H
        AND AL, 0FH
        ;MOV IDX, BL
        ;MOV DL, IDX
        MOV BYTE PTR ARR[BX], AL
        ;MOV BL, IDX
        INC BL
        ;FOR TEST
        MOV DL, X
        ;MOV IDX, BL
        CMP X, BL
        JNG SORT
        JMP INPUT
        
    ;Insertion Sort
    ;for step from 2 to last index:
    ;   key=arr[step]
    ;   j=step-1
    ;   while(j>=1 and key<arr[j]):
    ;       arr[j+1]=arr[j]
    ;       j=j-1
    ;   arr[j+1]=key
    
    SORT:
        CMP P, CL
        JNL DISPLAY
        ;ADD P, 1
        ;sort the numbers here
        MOV BL, P
        MOV DL, ARR[BX]  ;key=array[step]
        ;MOV BL, P
        MOV Y, BL
        SUB Y, 1        ;j=step-1
        
        ;step->P
        ;j->Y
        ;key->DL
        WHILE:
            ;while(j>=1 and key<array[j])
            CMP Y, 1
            JNGE LABEL1
            MOV BL, Y
            CMP DL, ARR[BX]
            JNL LABEL1
            
            MOV AL, ARR[BX]
            MOV BL, Y
            ADD BX, 1
            MOV ARR[BX], AL        ;array[j+1]=array[j]
            SUB Y, 1               ;j=j-1
            JMP WHILE
                
        LABEL1:
            MOV BL, Y
            ADD BX, 1
            MOV ARR[BX], DL       ;array[j+1]=key
            ADD P, 1
            JMP SORT
    
    DISPLAY:
        MOV BX, 0
        MOV BL, Z
        MOV DL, ARR[BX]
        ADD DL, 30H
        MOV AH, 2
        INT 21H
        INC Z
        CMP Z, CL
        JNL EXIT
        JMP DISPLAY
        
    EXIT:
        MOV AH, 4CH
        INT 21H    
MAIN ENDP
END MAIN
