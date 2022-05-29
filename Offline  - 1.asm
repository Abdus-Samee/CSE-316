.MODEL SMALL
.STACK 100H

.DATA
X DB ?
IDX EQU 1
ARR DB X DUP(0) 

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    LEA SI, ARR
    MOV BL, IDX
    
    MOV AH, 1
    INT 21H
    MOV CL, AL
    MOV X, CL
    AND X, 0FH ;n in integer form
    INC X
    
    CMP CL, 30H
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
    ;sort the numbers here
    MOV AX, [SI+3]
    
    EXIT:
    MOV AH, 4CH
    INT 21H    
MAIN ENDP
END MAIN
