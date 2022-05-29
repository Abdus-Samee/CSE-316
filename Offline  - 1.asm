.MODEL SMALL
.STACK 100H

.DATA
X DB ?
Y DB ?
Z DB ?
IDX EQU 1
ARR DB X DUP(0) 

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    LEA SI, ARR
    MOV BL, IDX
    MOV Z, '1'
    AND Z, 0FH
    
    MOV AH, 1
    INT 21H
    MOV CL, AL
    MOV X, CL  
    AND CL, 0FH ;value of input "n" intact for future use
    AND X, 0FH  ;n in integer form
    INC X
    
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
    
    SORT:
        CMP X, 0
        JE DISPLAY
        DEC X
        ;sort the numbers here
        MOV DL, [SI+X]          ;key=array[step]
        MOV BL, X
        MOV Y, BL
        SUB Y, 1               ;j=step-1
        
            WHILE:
                ;while(j>=0 and key<array[j])
                CMP Y, 0
                JNGE LABEL1
                MOV BL, Y
                CMP DL, ARR[BX]
                JNL LABEL1
                
                MOV AL, ARR[BX]
                MOV BL, Y
                ADD BX, 1
                MOV ARR[BX], AL         ;array[j+1]=array[j]
                SUB Y, 1               ;j=j-1
                JMP WHILE
                
            LABEL1:
                MOV BL, Y
                ADD BX, 1
                MOV ARR[BX], DL       ;array[j+1]=key
                JMP SORT
    
    DISPLAY:
        MOV BL, Z
        MOV DL, ARR[BX]
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
