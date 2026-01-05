.MODEL SMALL
.STACK 100H

.DATA
    ballX DW 40        ; Ball X position (column)
    ballY DW 12        ; Ball Y position (row)
    ballDirX DW 1      ; Ball X direction (1 = right, -1 = left)
    ballDirY DW 1      ; Ball Y direction (1 = down, -1 = up)
    paddleY DW 12      ; Player paddle Y position
    enemyPaddleY DW 12 ; Enemy paddle Y position
    score DW 0         ; Player score
    key DB ?           ; Key input placeholder

.CODE
MAIN PROC
    ; Initialize the program
    MOV AX, @DATA
    MOV DS, AX

    ; Set video mode to 80x25 text mode
    MOV AH, 00H
    MOV AL, 03H
    INT 10H

    ; Game loop
GameLoop:
    CALL DrawGame
    CALL GetInput
    CALL UpdateGame
    JMP GameLoop

DrawGame PROC
    ; Clear screen
    MOV AH, 06H
    XOR AL, AL
    XOR CX, CX
    MOV DX, 184FH
    INT 10H

    ; Draw paddles
    CALL DrawPaddle
    CALL DrawEnemyPaddle

    ; Draw ball
    CALL DrawBall
    RET
DrawGame ENDP

DrawPaddle PROC
    MOV CX, paddleY
    MOV DX, 5        ; Paddle column
    MOV AH, 02H
    INT 10H
    MOV AL, '|'      ; Paddle character
    INT 10H
    RET
DrawPaddle ENDP

DrawEnemyPaddle PROC
    MOV CX, enemyPaddleY
    MOV DX, 75       ; Enemy paddle column
    MOV AH, 02H
    INT 10H
    MOV AL, '|'      ; Paddle character
    INT 10H
    RET
DrawEnemyPaddle ENDP

DrawBall PROC
    MOV CX, ballY
    MOV DX, ballX
    MOV AH, 02H
    INT 10H
    MOV AL, 'O'      ; Ball character
    INT 10H
    RET
DrawBall ENDP

GetInput PROC
    MOV AH, 01H      ; Check for keypress
    INT 16H
    JZ NoInput       ; If no key, skip input handling

    MOV AH, 00H      ; Get keypress
    INT 16H
    MOV key, AL

    ; Handle paddle movement
    CMP key, 'W'     ; Move paddle up
    JE PaddleUp
    CMP key, 'S'     ; Move paddle down
    JE PaddleDown
    JMP NoInput

PaddleUp:
    DEC paddleY
    CMP paddleY, 1   ; Prevent moving out of bounds
    JGE NoInput
    MOV paddleY, 1
    JMP NoInput

PaddleDown:
    INC paddleY
    CMP paddleY, 24  ; Prevent moving out of bounds
    JLE NoInput
    MOV paddleY, 24
    JMP NoInput

NoInput:
    RET
GetInput ENDP

UpdateGame PROC
    ; Update ball X position
    MOV AX, ballDirX  ; Load ballDirX into AX
    ADD ballX, AX     ; Add AX to ballX

    ; Update ball Y position
    MOV AX, ballDirY  ; Load ballDirY into AX
    ADD ballY, AX     ; Add AX to ballY

    ; Ball collision with top/bottom
    CMP ballY, 1
    JGE SkipYCollision
    NEG ballDirY       ; Reverse Y direction
SkipYCollision:
    CMP ballY, 24
    JLE SkipYCollision2
    NEG ballDirY       ; Reverse Y direction
SkipYCollision2:

    ; Ball collision with paddles
    ; Check collision with left paddle
    CMP ballX, 6       ; Check if ball is near the left paddle
    JNE SkipPaddleCollision

    MOV AX, paddleY    ; Load paddleY into AX
    CMP ballY, AX      ; Compare ballY with paddleY
    JE ReverseXDirection

SkipPaddleCollision:
    ; Check collision with right paddle
    CMP ballX, 74      ; Check if ball is near the right paddle
    JNE SkipEnemyCollision

    MOV AX, enemyPaddleY ; Load enemyPaddleY into AX
    CMP ballY, AX        ; Compare ballY with enemyPaddleY
    JE ReverseXDirection

SkipEnemyCollision:
    RET

ReverseXDirection:
    NEG ballDirX       ; Reverse X direction
    RET
UpdateGame ENDP



MAIN ENDP
END MAIN
