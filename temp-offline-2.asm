.MODEL SMALL
.STACK 100H ;160 size

.DATA
CR EQU 0DH;13
LF EQU 0AH;10
X DW ?
Y DW ?
Z DW ?
P DW ?
M DB ?
N DW ?
Q DW ?
LB DW ?
UB DW ?
NF DB 'NOT FOUND$'
SIZE_PROMPT DB 'ENTER SIZE OF ARRAY: $'
ENTER_PROMPT DB CR, LF, 'ENTER NUMBERS: $'
DISPLAY_PROMPT DB CR, LF, 'SORTED ARRAY: $'
SEARCH_PROMPT DB CR, LF, 'ENTER NUMBER TO SEARCH: $'
CONT_SEARCH DB CR, LF, 'DO YOU WANT TO CONTIUE SEARCHING(Y/N)? $'
IDX DW ?
ARR DW X DUP(0)
NEWLINE DB CR, LF, '$'

.CODE
MAIN PROC
    ;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX  
    
    START:    
        LEA SI, ARR
        MOV Z, '1'
        AND Z, 000FH
        MOV BX, 1
        MOV X, 0
        MOV LB, 1
        MOV N, 0
        LEA DX, SIZE_PROMPT
        MOV AH, 09H
        INT 21H
    
    TOTAL_NUM:
        MOV AH, 1
        INT 21H
        CMP AL, ' '
        JE INVALID_CHECK
        CMP AL, 2DH
        JE TOTAL_NUM_NEG
    	MOV M, 10
    	AND M, 0FH
        AND AL, 0FH
        MOV DL, AL
        MOV AX, X
        MUL M
        ADD AX, DX
        MOV X, AX
        JMP TOTAL_NUM
        
    TOTAL_NUM_NEG:
        MOV AH, 1
        INT 21H
        CMP AL, ' '
        JE NEG_INPUT
    	MOV M, 10
    	AND M, 0FH
        AND AL, 0FH
        MOV DL, AL
        MOV AX, X
        MUL M
        ADD AX, DX
        MOV X, AX
        JMP TOTAL_NUM_NEG
    
    NEG_INPUT:
        NEG X
        JMP INVALID_CHECK
        
    INVALID_CHECK:
        ;check for invalid input
        CMP X, 0
        JNG EXIT
        INC X
        MOV P, '3'
        AND P, 000FH
        LEA DX, ENTER_PROMPT
        MOV AH, 09H
        INT 21H
        JMP INIT_INPUT
    
    INIT_INPUT:
        XOR CX, CX
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
        MOV DX, BX
        ADD BX, N
    	MOV WORD PTR ARR[BX], CX
    	MOV BX, DX
    	MOV N, BX
    	INC BX
    	CMP X, BX 
    	JNG PRE_SORT
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
    
    ;Insertion Sort
    ;for step from 2 to last index:
    ;   key=arr[step]
    ;   j=step-1
    ;   while(j>=1 and key<arr[j]):
    ;       arr[j+1]=arr[j]
    ;       j=j-1
    ;   arr[j+1]=key                                                             
                                                                                  
                                                                                 
    PRE_SORT:                                                                      
        MOV CX, X                                                                   
        SUB CX, 1
        MOV IDX, 0
        JMP SORT    
    SORT:                                                                          
        ADD IDX, 1
        CMP IDX, CX
        JNL PROCESS_DISPLAY
        MOV BX, P
        MOV DX, ARR[BX]  ;key=array[step]
        MOV Y, BX
        SUB Y, 2         ;j=step-1
        
        ;step->P
        ;j->Y
        ;key->DX
        WHILE:
            ;while(j>=1 and key<array[j])
            MOV BX, Y
            CMP DX, ARR[BX]
            JNL LABEL1
            
            MOV AX, ARR[BX]
            MOV BX, Y
            ADD BX, 2
            MOV ARR[BX], AX        ;array[j+1]=array[j]
            CMP Y, 1
            JE SPECIAL
            SUB Y, 2
            JMP WHILE
                
        LABEL1:
            ADD BX, 2
            MOV ARR[BX], DX       ;array[j+1]=key
            ADD P, 2
            JMP SORT
            
        SPECIAL:
            MOV BX, 1
            MOV ARR[BX], DX
            ADD P, 2
            JMP SORT
	    
	PROCESS_DISPLAY:
	    LEA DX, DISPLAY_PROMPT
	    MOV AH, 09H
	    INT 21H
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
        JNL PROCESS_SEARCH
        JMP DISPLAY
        

    PROCESS_SEARCH:
        XOR DX, DX
        LEA DX, SEARCH_PROMPT
        MOV AH, 09H
        INT 21H
        CALL SEARCH_INPUT
        XOR DX, DX
        MOV DL, CR
        MOV AH, 2
        INT 21H
        MOV DL, LF
        INT 21H
        MOV DX, CX  ;INPUT IN DX
        CALL BINARY_SEARCH
        XOR DX, DX
        LEA DX, CONT_SEARCH
        MOV AH, 09H
        INT 21H
        MOV AH, 1
        INT 21H
        CMP AL, 'Y'
        JE PROCESS_SEARCH
        MOV DL, CR
        MOV AH, 2
        INT 21H
        MOV DL, LF
        INT 21H
        JMP START   
    
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

SEARCH_INPUT PROC
    XOR CX, CX
    INP:
        MOV AH, 1
        INT 21H
        CMP AL, 2DH
        JE NEGTV
        CMP AL, ' '
        JE EXIT_INP
    	MOV M, 10
    	AND M, 0FH
        AND AL, 0FH
        MOV DL, AL
        MOV AX, CX
        MUL M
        ADD AX, DX
        MOV CX, AX
        JMP INP

    NEGTV:
        MOV AH, 1
        INT 21H
        CMP AL, ' '
        JE PROCESS_NEGTV
        AND AL, 0FH
        XOR AH, AH
        MOV Q, AX
        MOV AX, CX
        MUL M
        ADD AX, Q
        MOV CX, AX
        JMP NEGTV
    
    PROCESS_NEGTV:
        NEG CX
	    JMP EXIT_INP
	        
    EXIT_INP:
        RET       
SEARCH_INPUT ENDP

BINARY_SEARCH PROC
    MOV AX, X
    SUB AX, 1
    MOV UB, AX
    MOV CL, 1
    
    SEARCH:
        MOV BX, 0
        ADD BX, UB
        CMP BX, LB
        JNGE UNEQUAL
        ADD BX, LB
        SHR BX, CL
        SHL BX, CL
        SUB BX, 1
        CMP DX, ARR[BX]
        JE EQUAL
        JL LESS
        JMP GREATER
    
    LESS:
        SHR BX, CL
        ADD BX, 1
        SUB BX, 1
        MOV UB, BX
        JMP SEARCH
        
    GREATER:
        SHR BX, CL
        ADD BX, 1
        ADD BX, 1
        MOV LB, BX
        JMP SEARCH
        
    EQUAL:
        ;PRINT INDEX BX
        MOV AX, BX
        CALL PRINT
        JMP EXIT_SEARCH
    
    UNEQUAL:
        LEA DX, NF
        MOV AH, 09H
        INT 21H
        JMP EXIT_SEARCH
        
    EXIT_SEARCH:
        RET    
BINARY_SEARCH ENDP

END MAIN
