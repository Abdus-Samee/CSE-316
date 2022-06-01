.MODEL SMALL
.STACK 100H ;160 size

.DATA
CR EQU 0DH;13
LF EQU 0AH;10
X DB ?
Y DB ?
Z DB ?
P DB ?
M DB ?
N DW 0
ARR DW X DUP(0)
NEWLINE DB CR, LF, '$'

.CODE
MAIN PROC
    ;DATA SEGMENT INITIALIZATION
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
    CMP X, 0
    JNG EXIT
    JMP INIT_INPUT
    
    INIT_INPUT:
        XOR CX, CX
        JMP INPUT
    INPUT:
        MOV AH, 1
        INT 21H
        CMP AL, 2DH
        JE NEGATIVE
        CMP AL, CR
        JE PROCESS_INPUT
    	MOV M, 10
    	AND M, 0FH
        AND AL, 0FH
        MOV DL, AL
        MOV AX, CX
        MUL M
        ADD AX, DX
        MOV CX, AX
        JMP INPUT 
    
    PROCESS_INPUT:
        ;LEA DX, NEWLINE
        ;MOV AH, 09H
        ;INT 21H
        ADD BX, N
    	MOV WORD PTR ARR[BX], CX
    	XOR AX, AX
    	MOV AL, BL
    	MOV N, AX
    	INC BL
    	MOV DL, X
    	XOR CX, CX
    	CMP X, BL
    	;CHANGED FOR TIME BEGIN -> JNG SORT
    	JNG EXIT
    	JMP INPUT

    NEGATIVE:
        MOV AH, 1
        INT 21H
        CMP AL, CR
        JE NEG_DISPLAY
        AND AL, 0FH
        MOV BL, AL
        MOV AX, CX
        MUL DL
        ADD AX, BX
        MOV CX, AX
        JMP NEGATIVE

    NEG_DISPLAY:
        NEG CX
	    JMP PROCESS_INPUT

    ;PROBLEM WITH REGISTER CL IN SORT SECTION   
    
    EXIT:
    	;DOS EXIT
    	MOV AH, 4CH
    	INT 21H
MAIN ENDP
END MAIN
