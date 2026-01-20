ORG 100h

JMP CODE_START

msg_prompt       DB 0Dh, 0Ah, "Rock, Paper, Scissors? (r/p/s): ", "$"
msg_invalid      DB 0Dh, 0Ah, "Invalid key! Use r/p/s only.", 0Dh, 0Ah, "$"
msg_you_rock     DB 0Dh, 0Ah, "You say Rock and CPU say $"
msg_you_paper    DB 0Dh, 0Ah, "You say Paper and CPU say $"
msg_you_scissors DB 0Dh, 0Ah, "You say Scissors and CPU say $"
msg_cpu_rock     DB "Rock. $"
msg_cpu_paper    DB "Paper. $"
msg_cpu_scissors DB "Scissors. $"
msg_win          DB "You WIN!", 0Dh, 0Ah, "$"
msg_lose         DB "You LOSE!", 0Dh, 0Ah, "$"
msg_draw         DB "It's a DRAW!", 0Dh, 0Ah, "$"
msg_game_over    DB 0Dh, 0Ah, "--- GAME OVER ---", 0Dh, 0Ah, "$"

SEG7_CODES       DB 00111111b, 00000110b, 01011011b 

round_counter    DB 0
user_wins        DB 0
cpu_wins         DB 0
draws            DB 0
user_choice      DB 0
cpu_choice       DB 0

DOTS_U_WINS      DB 01111111b, 01000000b, 01000000b, 01000000b, 01111111b
                 DB 0,0,0,0,0
                 DB 01111111b, 00100000b, 00011000b, 00100000b, 01111111b
                 DB 0,0,0,0,0
                 DB 00000000b, 00000000b, 01111111b, 00000000b, 00000000b
                 DB 0,0,0,0,0
                 DB 01111111b, 00000100b, 00001000b, 00010000b, 01111111b
                 DB 0,0,0,0,0
                 DB 01001111b, 01001001b, 01001001b, 01001001b, 01111001b

DOTS_C_WINS      DB 00111110b, 01000001b, 01000001b, 01000001b, 00100010b
                 DB 0,0,0,0,0
                 DB 01111111b, 00100000b, 00011000b, 00100000b, 01111111b
                 DB 0,0,0,0,0
                 DB 00000000b, 00000000b, 01111111b, 00000000b, 00000000b
                 DB 0,0,0,0,0
                 DB 01111111b, 00000100b, 00001000b, 00010000b, 01111111b
                 DB 0,0,0,0,0
                 DB 01001111b, 01001001b, 01001001b, 01001001b, 01111001b

DOTS_TIE         DB 00000001b, 00000001b, 01111111b, 00000001b, 00000001b
                 DB 0,0,0,0,0
                 DB 00000000b, 00000000b, 01111111b, 00000000b, 00000000b
                 DB 0,0,0,0,0
                 DB 01111111b, 01001001b, 01001001b, 01001001b, 01000001b
                 DB 0,0,0,0,0
                 DB 0,0,0,0,0

CODE_START:
    CALL CLEAR_DEVICES
    CALL UPDATE_LCD

GAME_LOOP:
    CMP round_counter, 10
    JAE END_GAME

    LEA DX, msg_prompt
    MOV AH, 09h
    INT 21h

INPUT_CHAR:
    MOV AH, 07h
    INT 21h
    
    CMP AL, 'r'
    JE  SET_ROCK
    CMP AL, 'p'
    JE  SET_PAPER
    CMP AL, 's'
    JE  SET_SCISSORS
    
    LEA DX, msg_invalid
    MOV AH, 09h
    INT 21h
    JMP GAME_LOOP

SET_ROCK:
    MOV user_choice, 0
    JMP INPUT_DONE
SET_PAPER:
    MOV user_choice, 1
    JMP INPUT_DONE
SET_SCISSORS:
    MOV user_choice, 2
    JMP INPUT_DONE

INPUT_DONE:
    MOV AH, 02h
    MOV DL, AL
    INT 21h
    
    MOV AH, 00h
    INT 1Ah
    MOV AX, DX
    MOV DX, 0
    MOV CX, 3
    DIV CX
    MOV cpu_choice, DL

    LEA BX, SEG7_CODES
    MOV AL, user_choice
    XLAT
    MOV DX, 2030h
    OUT DX, AL
    
    LEA BX, SEG7_CODES
    MOV AL, cpu_choice
    XLAT
    MOV DX, 2031h
    OUT DX, AL

    CMP user_choice, 0
    JE P_ROCK_MSG
    CMP user_choice, 1
    JE P_PAPER_MSG
    JMP P_SCISSORS_MSG

P_ROCK_MSG:
    LEA DX, msg_you_rock
    JMP SHOW_CPU_MSG
P_PAPER_MSG:
    LEA DX, msg_you_paper
    JMP SHOW_CPU_MSG
P_SCISSORS_MSG:
    LEA DX, msg_you_scissors

SHOW_CPU_MSG:
    MOV AH, 09h
    INT 21h

    CMP cpu_choice, 0
    JE C_ROCK_MSG
    CMP cpu_choice, 1
    JE C_PAPER_MSG
    JMP C_SCISSORS_MSG

C_ROCK_MSG:
    LEA DX, msg_cpu_rock
    JMP EVALUATE
C_PAPER_MSG:
    LEA DX, msg_cpu_paper
    JMP EVALUATE
C_SCISSORS_MSG:
    LEA DX, msg_cpu_scissors

EVALUATE:
    MOV AH, 09h
    INT 21h

    MOV AL, user_choice
    MOV BL, cpu_choice
    
    CMP AL, BL
    JE IS_DRAW
    
    CMP AL, 0
    JNE CHECK_PAPER
    CMP BL, 2
    JE IS_WIN
    JMP IS_LOSE
    
CHECK_PAPER:
    CMP AL, 1
    JNE CHECK_SCISSORS
    CMP BL, 0
    JE IS_WIN
    JMP IS_LOSE

CHECK_SCISSORS:
    CMP BL, 1
    JE IS_WIN
    JMP IS_LOSE

IS_WIN:
    INC user_wins
    LEA DX, msg_win
    JMP PRINT_RESULT
IS_LOSE:
    INC cpu_wins
    LEA DX, msg_lose
    JMP PRINT_RESULT
IS_DRAW:
    INC draws
    LEA DX, msg_draw

PRINT_RESULT:
    MOV AH, 09h
    INT 21h

    INC round_counter
    CALL UPDATE_LCD
    
    JMP GAME_LOOP

END_GAME:
    LEA DX, msg_game_over
    MOV AH, 09h
    INT 21h
    
    MOV AL, user_wins
    CMP AL, cpu_wins
    JA  SHOW_U_WIN
    JB  SHOW_C_WIN
    JMP SHOW_TIE

SHOW_U_WIN:
    LEA SI, DOTS_U_WINS
    CALL WRITE_DOT_MATRIX
    JMP EXIT_PRG
    
SHOW_C_WIN:
    LEA SI, DOTS_C_WINS
    CALL WRITE_DOT_MATRIX
    JMP EXIT_PRG
    
SHOW_TIE:
    LEA SI, DOTS_TIE
    CALL WRITE_DOT_MATRIX

EXIT_PRG:
    RET

UPDATE_LCD PROC
    MOV DX, 2040h

    MOV AL, 'W'
    OUT DX, AL
    INC DX
    MOV AL, ':'
    OUT DX, AL
    INC DX
    MOV AL, user_wins
    ADD AL, '0'
    OUT DX, AL
    INC DX
    
    MOV AL, ' '
    OUT DX, AL
    INC DX
    MOV AL, 'D'
    OUT DX, AL
    INC DX
    MOV AL, ':'
    OUT DX, AL
    INC DX
    MOV AL, draws
    ADD AL, '0'
    OUT DX, AL
    INC DX
    
    MOV AL, ' '
    OUT DX, AL
    INC DX
    MOV AL, 'L'
    OUT DX, AL
    INC DX
    MOV AL, ':'
    OUT DX, AL
    INC DX
    MOV AL, cpu_wins
    ADD AL, '0'
    OUT DX, AL
    INC DX
    
    MOV AL, ' '
    OUT DX, AL
    INC DX
    MOV AL, 'R'
    OUT DX, AL
    INC DX
    MOV AL, ':'
    OUT DX, AL
    INC DX
    
    MOV AL, round_counter
    MOV AH, 0
    MOV BL, 10
    DIV BL
    
    PUSH AX
    ADD AL, '0'
    OUT DX, AL
    INC DX
    POP AX
    
    MOV AL, AH
    ADD AL, '0'
    OUT DX, AL
    
    RET
UPDATE_LCD ENDP

WRITE_DOT_MATRIX PROC
    MOV DX, 2000h
    MOV CX, 40
    
WRITE_LOOP:
    MOV AL, [SI]
    OUT DX, AL
    INC SI
    INC DX
    LOOP WRITE_LOOP
    RET
WRITE_DOT_MATRIX ENDP

CLEAR_DEVICES PROC
    MOV DX, 2030h
    MOV CX, 8
    MOV AL, 0
CLR_7SEG:
    OUT DX, AL
    INC DX
    LOOP CLR_7SEG
    
    MOV DX, 2000h
    MOV CX, 40
CLR_DOTS:
    OUT DX, AL
    INC DX
    LOOP CLR_DOTS
    
    MOV DX, 2040h
    MOV CX, 32
    MOV AL, ' '
CLR_LCD:
    OUT DX, AL
    INC DX
    LOOP CLR_LCD
    
    RET
CLEAR_DEVICES ENDP

END




