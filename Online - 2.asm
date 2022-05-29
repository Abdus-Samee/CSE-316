.MODEL SMALL
.STACK 100H

.DATA
CR EQU 0DH
LF EQU 0AH
X DB ?
Y DB ?
Z DB ?
EQ DB 'EQUILATERAL TRIANGLE$'
IS DB 'ISOSCELES TRIANGLE$'
SC DB 'SCALENE TRIANGLE$'
NEWLINE DB CR, LF, '$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    MOV AH, 1
    INT 21H
    MOV BL, AL
    
    INT 21H
    MOV CL, AL
    
    INT 21H
    MOV DL, AL
    
    CMP BL, CL
    JNE LABEL1
    JMP LABEL2
    
    LABEL1:
    CMP BL, DL
    JNE LABEL3
    JMP ISO
    
    LABEL2:
    CMP BL, DL
    JNE ISO
    JMP EQUI
    
    LABEL3:
    CMP CL, DL
    JNE SCL
    JMP ISO
    
    EQUI:
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    LEA DX, EQ
    INT 21H
    JMP END
    
    ISO:
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    LEA DX, IS
    INT 21H
    JMP END
    
    SCL:
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H
    LEA DX, SC
    INT 21H
    
    END:
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN
