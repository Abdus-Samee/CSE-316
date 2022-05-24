.MODEL SMALL
.STACK 100H

.DATA
CR EQU 0DH
LF EQU 0AH
X DB ?
STR DB 'ENTER A NUMBER:$'
OT DB 'OUTPUT $'

.CODE
MAIN PROC
    ;obviously can be shortened a bit
    
    MOV AX, @DATA
    MOV DS, AX
    
    LEA DX, STR 
    MOV AH, 9H
    INT 21H
    
    MOV AH, 1
    INT 21H
    MOV X, AL
    MOV CL, X
    
    SUB CL, 41H
    MOV BL, 17H
    SUB BL, CL
    
    SUB BL, 10H
    ADD BL, 30H
    
    MOV DL, CR
    MOV AH, 2
    INT 21H
    
    MOV DL, LF
    MOV AH, 2
    INT 21H
    
    LEA DX, OT 
    MOV AH, 9H
    INT 21H
    
    MOV DL, 31H
    MOV AH, 2
    INT 21H
    
    MOV DL, BL
    MOV AH, 2
    INT 21H
    
    MOV AH, 4CH
    INT 21H
    
MAIN ENDP
END MAIN
