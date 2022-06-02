.MODEL SMALL
.STACK 100H ;160 size

.DATA
CR EQU 0DH;13
LF EQU 0AH;10
X DW ?
Y DB ?
Z DW ?
P DB ?
M DB ?
N DW 0
Q DW ?
ARR DW X DUP(0)
NEWLINE DB CR, LF, '$'

.CODE
MAIN PROC
    ;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
    
    LEA SI, ARR
    MOV Z, '1'
    AND Z, 000FH
    MOV BX, 1
    MOV X, 0
    
    TOTAL_NUM:
        MOV AH, 1
        INT 21H
        CMP AL, ' '
        JE INVALID_CHECK
        CMP AL, 2DH
        JE EXIT
    	MOV M, 10
    	AND M, 0FH
        AND AL, 0FH
        MOV DL, AL
        MOV AX, X
        MUL M
        ADD AX, DX
        MOV X, AX
        JMP TOTAL_NUM
    
    INVALID_CHECK:
        ;check for invalid input
        CMP X, 0
        JNG EXIT
        INC X
        MOV P, '2'
        AND P, 0FH
        JMP INIT_INPUT
    
    INIT_INPUT:
        XOR CX, CX
        ;MOV CL, AL
        ;MOV X, CL  
        ;AND CL, 000FH ;value of input "n" intact for future use
        ;AND X, 000FH  ;n in integer form
        ;INC X
        ;INC CL
        JMP INPUT
    INPUT:
        MOV AH, 1
        INT 21H
        CMP AL, 2DH
        JE NEGATIVE
        CMP AL, ' '
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
        MOV DX, BX
        ADD BX, N
    	MOV WORD PTR ARR[BX], CX
    	MOV BX, DX
    	MOV N, BX
    	INC BX
    	;XOR AX, AX
    	;MOV AL, BL
    	;MOV N, AX
    	;INC BL
    	;MOV DL, X
    	;XOR CX, CX
    	CMP X, BX
    	;CHANGED FOR TIME BEGIN -> JNG SORT
    	JNG PROCESS_DISPLAY
    	JMP INIT_INPUT

    NEGATIVE:
        MOV AH, 1
        INT 21H
        CMP AL, ' '
        JE PROCESS_NEGATIVE
        AND AL, 0FH
        XOR AH, AH
        MOV Q, AX
        MOV AX, CX
        MUL M
        ADD AX, Q
        MOV CX, AX
        JMP NEGATIVE

    PROCESS_NEGATIVE:
        NEG CX
	    JMP PROCESS_INPUT
	    
	PROCESS_DISPLAY:
	    MOV BX, '1'
	    AND BX, 000FH
	    MOV Z, 1
	    MOV Q, 0
	    JMP DISPLAY
	    
	DISPLAY:
	    MOV AX, Z
	    ADD Q, AX
        MOV BX, Q
        
        MOV AX, ARR[BX]
        CALL PRINT
        MOV DL, ' '
        MOV AH, 02H
        INT 21H
        
        MOV AX, Z
        MOV Q, AX
        INC Z
        MOV AX, Z
        CMP AX, X
        JNL EXIT
        JMP DISPLAY
        

    ;PROBLEM WITH REGISTER CL IN SORT SECTION   
    
    EXIT:
    	;DOS EXIT
    	MOV AH, 4CH
    	INT 21H
MAIN ENDP

PRINT PROC
    MOV CX, 0
    MOV DX, 0
    
    CMP AX, 0
    JNGE NEG_STEP1
    JMP STEP1
    
    NEG_STEP1:
        MOV BX, AX
        MOV DL, 2DH
        MOV AH, 02H
        INT 21H
        MOV AX, BX
        NEG AX
        MOV DX, 0
    
    STEP1:
        CMP AX, 0
        JE ZERO_INPUT
        
        MOV BX, 10
        DIV BX
        PUSH DX
        INC CX
        XOR DX, DX
        JMP STEP1
        
    ZERO_INPUT:
        CMP CX, 0
        JNE DISPLAY_INPUT
        MOV DX, 30H
        MOV AH, 02H
        INT 21H
        JMP EXIT_PROC
    
    DISPLAY_INPUT:
        CMP CX, 0
        JE EXIT_PROC
        
        POP DX
        ADD DX, 48
        MOV AH, 02H
        INT 21H
        DEC CX
        JMP DISPLAY_INPUT
        
    EXIT_PROC:
        RET
            
PRINT ENDP

END MAIN
