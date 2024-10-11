     processor 6502
     org  $7ffe

     word $8000

     .word coldstart
     .word warmstart
     .byte $C3,$C2,$CD,$38,$30

coldstart
     sei
     stx $d016
     jsr $fda3
     jsr $fd50
     jsr $fd15
     jsr $ff5b
     cli
warmstart

SCORE_1  equ $C000
SCORE_2  equ $C001
SCORE_3  equ $C002
SCORE_4  equ $C003
SCORE_5  equ $C004
SCORE_6  equ $C005

FURTHEST equ $C006
HELD     equ $C007
DEBOUNCE equ $C008

CAN_LAMP equ $C010

ZOMBIE_X equ $C011
ZOMBIE_Y equ $C012

LAST_X   equ $C013
LAST_Y   equ $C014

CHASE_X  equ $C015
CHASE_Y  equ $C016

ZOMBIE_X2 equ $C017
ZOMBIE_Y2 equ $C018

LAMP_ON   equ $C019

GHOST_BUFFER equ $C01A

FOOB equ $00FB
FOOC equ $00FC

FOOD equ $00FD
FOOE equ $00FE

JOY_INPUT equ $DC01

SPRITE_0_POINTER equ $07F8
SPRITE_0_DATA    equ $3000

SPRITE_1_POINTER equ $07F9
SPRITE_1_DATA    equ $3040

SPRITE_2_POINTER equ $07FA
SPRITE_2_DATA    equ $3080

SPRITE_3_POINTER equ $07FB
SPRITE_3_DATA    equ $30C0

SPRITE_4_POINTER equ $07FC
SPRITE_4_DATA    equ $3100


        lda #0
        sta SCORE_1
        sta SCORE_2
        sta SCORE_3
        sta SCORE_4
        sta SCORE_5
        sta SCORE_6
        
        sta CAN_LAMP
        
        lda #255
        sta FURTHEST

	lda #$FF
	sta $D40E
	sta $D40F
	lda #$80
	sta $D412

	lda #$00
        sta FOOB
        lda #$04
        sta FOOC
        
        lda #$00
        sta FOOD
        lda #$D8
        sta FOOE
        
        ldy #68
        ldx #$00
        
        lda #0
        sta $D021
        
        ldy #0
	sty $D020
        
        
	lda #192
        sta SPRITE_0_POINTER

        lda #193
        sta SPRITE_2_POINTER
        
	lda #194
        sta SPRITE_3_POINTER

        lda #195
        sta SPRITE_1_POINTER
        
        lda #196
        sta SPRITE_4_POINTER
       
        lda #%00011111
        sta $D015

	lda #4
	sta $D027
        
        ldx #0
        ldy #0

LoadPlayerSprite
	lda Player,x
        sta SPRITE_0_DATA,x
        inx
        cpx #$3F
        bne LoadPlayerSprite

	ldx #0
        ldy #0

LoadPumpkinSprite
	lda Ghost,x
        sta SPRITE_3_DATA,x
        inx
        cpx #$3F
        bne LoadPumpkinSprite
        
        ldx #0
        ldy #0

LoadGhostSprite
	lda Zombie,x
        sta SPRITE_1_DATA,x
        inx
        cpx #$3F
        bne LoadGhostSprite

	ldx #0
        ldy #0
        
LoadZombie2Sprite
	lda Zombie,x
        sta SPRITE_4_DATA,x
        inx
        cpx #$3F
        bne LoadZombie2Sprite
        
        ldx #0
        ldy #0
        
LoadZombieSprite
	lda Pumpkin,x
        sta SPRITE_2_DATA,x
        inx
        cpx #$3F
        bne LoadZombieSprite
        
        ldx #0
        ldy #0


        ldy #28
	ldx #$00
DrawDivide1
        lda FOOB
        adc #40
        sta FOOB
        lda FOOC
        adc #0
        sta FOOC
        lda #66
        sta ($00FB),y
        
        lda FOOD
        adc #40
        sta FOOD
        lda FOOE
        adc #0
        sta FOOE
        lda #1
        iny
        sta ($00FD),y
        dey
        inx
        cpx #25
        bne DrawDivide1
DoneDivide1
	jmp TitleScreen
        
FillCemetery
	jsr BlackOut
	ldy #0
	ldx #0
Horizontal
	lda $D41B
        cmp #50
        bcs DontMakeGrave
	lda #88
        jmp SkipNotMakeGrave
DontMakeGrave
	lda #$20
SkipNotMakeGrave
        sta ($00FB),y
        iny
        cpy #29
        bne Horizontal
Vertical
	lda FOOB
        adc #39
        sta FOOB
        lda FOOC
        adc #0
        sta FOOC
        ldy #$00
        inx
        cpx #22
        bne Horizontal

	lda #$00
        sta FOOB
        lda #$04
        sta FOOC
        
        lda #$00
        sta FOOD
        lda #$D8
        sta FOOE
        rts

ClearCemetery
	ldy #0
	ldx #0
Horizontal2
	lda #$20
        sta ($00FB),y
        iny
        cpy #29
        bne Horizontal2
Vertical2
	lda FOOB
        adc #39
        sta FOOB
        lda FOOC
        adc #0
        sta FOOC
        ldy #$00
        inx
        cpx #22
        bne Horizontal2

	lda #$00
        sta FOOB
        lda #$04
        sta FOOC
        
        lda #$00
        sta FOOD
        lda #$D8
        sta FOOE
        rts

BorePath
	ldx #0
	lda #$20
        iny
        sta ($00FB),y
        iny
        sta ($00FB),y
        dey
        dey
GoDown
        lda FOOB
        adc #40
        sta FOOB
        lda FOOC
        adc #0
        sta FOOC
        
	lda #$20
        sta ($00FB),y
        iny
        sta ($00FB),y
        dey
        
        
        cpy #0
        beq DontMove
        cpy #25
        beq DontMove
        lda $D41B
        cmp #100
        bcs DontMoveRight
        iny
        jmp DontMoveLeft
DontMoveRight
	dey
DontMoveLeft
DontMove
        inx
        cpx #22
        bne GoDown


        lda #$00
        sta FOOD
        lda #$D8
        sta FOOE
        
	ldy #0
        ldx #0
        rts
        
MakeFinishLine
	lda #255
        sta $400,y
	iny
        cpy #29
        bne MakeFinishLine
        rts
        
GameOver
	jsr LightOut
        lda #1
        sta DEBOUNCE
GameOverLoop
        lda #%00010000
        bit JOY_INPUT
        bne Debounce2
        lda DEBOUNCE
        cmp #0
        bne GameOverLoop
        lda #1
        sta DEBOUNCE
        jmp FullReset
Debounce2
	lda #0
        sta DEBOUNCE
        jmp GameOverLoop
        
TitleData
	byte "CURSED`TOMBS"
        byte 0
ButtonData
	byte "PRESS`FIRE`TO`BEGIN"
        byte 0
TitleScreen
	ldx #0
        ldy #0
DisplayLoop
	lda #1
        sta $D800,x
	lda TitleData,x
        adc #191
        sta $400,x
        sbc #191
        inx
        cmp #0
        bne DisplayLoop
        lda #$20
        sta $400+12
        ldx #0
ButtonLoop
	lda #1
        sta $D800+80,x
	lda ButtonData,x
        adc #191
        sta $400+80,x
        sbc #191
        inx
        cmp #0
        bne ButtonLoop
        lda #$20
        sta $400+80+19
TitleLoop
        lda #%00010000
        bit JOY_INPUT
        bne Debounce3
        lda DEBOUNCE
        cmp #0
        bne TitleLoop
        lda #1
        sta DEBOUNCE
        jmp FullReset
Debounce3
	lda #0
        sta DEBOUNCE
        jmp TitleLoop
        
        
        
IsXaboveY
        sty $C0FF
IsAboveLoop
	txa
        cmp $C0FF
        bcs ItIs
        beq ItsNot
ItsNot
	ldx #0
        rts
ItIs
	ldx #1
        rts
        
DisplayScore
	lda #30
        adc SCORE_6
	lda #48
        adc SCORE_6
        sta $400+71
	lda #48
        adc SCORE_5
        sta $400+72
	lda #48
        adc SCORE_4
        sta $400+73
	lda #48
        adc SCORE_3
        sta $400+74
	lda #48
        adc SCORE_2
        sta $400+75
	lda #48
        adc SCORE_1
        sta $400+76
        rts

AddPoint
	ldy SCORE_1
        iny
        cpy #10
        beq Digit2
        sty SCORE_1
        jmp DoneAddingPoint
Digit2
	ldy #0
        sty SCORE_1
        ldy SCORE_2
        iny
        cpy #10
        beq Digit3
        sty SCORE_2
        jmp DoneAddingPoint
Digit3
	ldy #0
        sty SCORE_2
        ldy SCORE_3
        iny
        cpy #10
        beq Digit4
        sty SCORE_3
        jmp DoneAddingPoint
Digit4
	ldy #0
        sty SCORE_3
        ldy SCORE_4
        iny
        cpy #10
        beq Digit5
        sty SCORE_4
        jmp DoneAddingPoint
Digit5
	ldy #0
        sty SCORE_4
        ldy SCORE_5
        iny
        cpy #10
        beq Digit6
        sty SCORE_5
        jmp DoneAddingPoint
Digit6
	ldy #0
        sty SCORE_5
        ldy SCORE_6
        iny
        sty SCORE_6
DoneAddingPoint
        rts

        
BlackOut
        lda #0
        sta $D028
        sta $D029
        sta $D02A
        sta $D02B
        lda #$00
        sta FOOD
        lda #$D8
        sta FOOE
	lda #$00
        sta FOOB
        lda #$04
        sta FOOC
	ldy #0
        ldx #0
BlackOutLoop
	lda #0
	sta ($00FD),y
        iny
        cpy #29
        bne BlackOutLoop
        
        lda FOOD
        adc #39
        sta FOOD
        lda FOOE
        adc #0
        sta FOOE
	inx
        ldy #0
        cpx #25
        bne BlackOutLoop

        lda #$00
        sta FOOD
        lda #$D8
        sta FOOE
        rts
        
LightOut
        lda #5
        sta $D028
        lda #1
        sta $D029
        sta $D02B
        lda #2
        sta $D02A
        lda #$00
        sta FOOD
        lda #$D8
        sta FOOE
	lda #$00
        sta FOOB
        lda #$04
        sta FOOC
	ldy #0
        ldx #0
LightOutLoop
	lda #12
	sta ($00FD),y
        iny
        cpy #29
        bne LightOutLoop
        
        lda FOOD
        adc #39
        sta FOOD
        lda FOOE
        adc #0
        sta FOOE
	inx
        ldy #0
        cpx #25
        bne LightOutLoop
        lda #$00
        sta FOOD
        lda #$D8
        sta FOOE
        rts

FullReset
	lda #0
        sta SCORE_1
        sta SCORE_2
        sta SCORE_3
        sta SCORE_4
        sta SCORE_5
        sta SCORE_6

	lda #1
        sta $D800+71
        sta $D800+72
        sta $D800+73
        sta $D800+74
        sta $D800+75
        sta $D800+76

ResetGame

	lda #0
        sta GHOST_BUFFER

	lda #255
        sta FURTHEST

	lda #125
        sta $D000
        sta LAST_X
        lda #230
        sta $D001
        sta LAST_Y
        
        lda #0
        
        sta CHASE_X
        sta CHASE_Y
        
        lda #50
        
        sta $D004
        sta $D005
        
        sta $D002
        sta $D003
        
        sta $D006
        sta $D007
        
        
        lda #125
        sta $D008
        sta $D009
        
      	lda #%00000001
        bit $D01E
        bne ResetGame

	lda #$00
        sta FOOB
        lda #$04
        sta FOOC
        
        lda #$00
        sta FOOD
        lda #$D8
        sta FOOE
        
        jsr ClearCemetery
        jsr FillCemetery
        
	lda #$00
        sta FOOB
        lda #$04
        sta FOOC
        
        lda #$00
        sta FOOD
        lda #$D8
        sta FOOE
        
	ldx #0
        ldy #10
        
        jsr BorePath
        
        ldy #0
        ldx #0
        jsr MakeFinishLine

	lda #192
        sta SPRITE_0_POINTER

        lda #193
        sta SPRITE_2_POINTER
        
	lda #194
        sta SPRITE_3_POINTER

        lda #195
        sta SPRITE_1_POINTER
        
        lda #196
        sta SPRITE_4_POINTER

        lda #1
        sta LAMP_ON
        jsr BlackOut

Wait1
	lda $d011
        bmi Wait1
Wait2
	lda $d012
Wait3
        cmp $d012
        beq Wait3
        clc
	lda $d011
        bpl Wait2
        
        
        jsr DisplayScore
        jsr MoveZombie
        jsr MoveZombie2
        jsr MovePumpkin

	lda #%00000001
        bit $D01F
        beq DontPushBack
        lda LAST_X
        sta CHASE_X
        sta $D000
        lda LAST_Y
        sta CHASE_Y
        sta $D001
DontPushBack


        ldy $D001
        ldx #60
        jsr IsXaboveY
        cpx #1
        bne DontWinLevel
        lda #0
        sta DEBOUNCE
        jmp ResetGame
DontWinLevel

	lda #%00000001
        bit $D01E
        beq DontGameOver2
        jmp GameOver
DontGameOver2
        

        lda #%00010000
        bit JOY_INPUT
        bne Debounce
        lda DEBOUNCE
        cmp #1
        beq DontDebounce
        lda #1
        sta DEBOUNCE
        lda LAMP_ON
        cmp #1
        beq DontSetToZero
        jsr BlackOut
        lda #1
        sta LAMP_ON
        jmp DontDebounce
DontSetToZero
	jsr LightOut
	lda #0
        sta LAMP_ON
        jmp DontDebounce
Debounce
	lda #0
        sta DEBOUNCE
DontDebounce

	lda LAMP_ON
        cmp #1
        beq DontMoveThem
        jsr MoveGhost
DontMoveThem

	lda #%000000001
        bit JOY_INPUT
        bne DontPlayerUp
        ldx $D001
        stx LAST_Y
        dex
        stx $D001
        ldy FURTHEST
        jsr IsXaboveY
        cpx #0
        bne DontPlayerDown
        ldx $D001
        stx FURTHEST
        jsr AddPoint
        jmp DontPlayerDown
DontPlayerUp
	lda #%000000010
        bit JOY_INPUT
        bne DontPlayerDown
        ldx $D001
        stx LAST_Y
        inx
        stx $D001
DontPlayerDown
	lda #%00001000
        bit JOY_INPUT
        bne DontPlayerRight
        ldx $D000
        stx LAST_X
        inx
        stx $D000
        jmp DontPlayerLeft
DontPlayerRight
	lda #%00000100
        bit JOY_INPUT
        bne DontPlayerLeft
        ldx $D000
        stx LAST_X
        cpx #15
        beq DontPlayerLeft
        dex
        stx $D000
DontPlayerLeft
	jmp Wait1

MoveZombie
	ldx ZOMBIE_X
        cpx #0
        beq DontWalkRight
        ldx $D004
        inx
        stx $D004
        jmp DoneWalkX
DontWalkRight
	ldx $D004
        dex
        stx $D004
DoneWalkX
	ldx ZOMBIE_Y
        cpx #0
        beq DontWalkDown
        ldx $D005
        inx
        stx $D005
        jmp DoneWalkY
DontWalkDown
	ldx $D005
        dex
        stx $D005
DoneWalkY
	ldx $D004
        ldy #230
        jsr IsXaboveY
        cpx #1
        bne DontBounceLeft
        ldx #0
        stx ZOMBIE_X
DontBounceLeft
	ldx #10
        ldy $D004
        jsr IsXaboveY
        cpx #1
        bne DontBounceRight
        ldx #1
        stx ZOMBIE_X
DontBounceRight
	ldx $D005
        ldy #230
        jsr IsXaboveY
        cpx #1
        bne DontBounceUp
        ldx #0
        stx ZOMBIE_Y
DontBounceUp
	ldx #45
        ldy $D005
        jsr IsXaboveY
        cpx #1
        bne DontBounceDown
        ldx #1
        stx ZOMBIE_Y
DontBounceDown
	rts


MoveZombie2
	ldx ZOMBIE_X2
        cpx #0
        beq DontWalkRight2
        ldx $D008
        inx
        stx $D008
        jmp DoneWalkX2
DontWalkRight2
	ldx $D008
        dex
        stx $D008
DoneWalkX2
	ldx ZOMBIE_Y2
        cpx #0
        beq DontWalkDown2
        ldx $D009
        inx
        stx $D009
        jmp DoneWalkY2
DontWalkDown2
	ldx $D009
        dex
        stx $D009
DoneWalkY2
	ldx $D008
        ldy #230
        jsr IsXaboveY
        cpx #1
        bne DontBounceLeft2
        ldx #0
        stx ZOMBIE_X2
DontBounceLeft2
	ldx #10
        ldy $D008
        jsr IsXaboveY
        cpx #1
        bne DontBounceRight2
        ldx #1
        stx ZOMBIE_X2
DontBounceRight2
	ldx $D009
        ldy #230
        jsr IsXaboveY
        cpx #1
        bne DontBounceUp2
        ldx #0
        stx ZOMBIE_Y2
DontBounceUp2
	ldx #45
        ldy $D009
        jsr IsXaboveY
        cpx #1
        bne DontBounceDown2
        ldx #1
        stx ZOMBIE_Y2
DontBounceDown2
	rts

MoveGhost
	ldx GHOST_BUFFER
        inx
        cpx #1
        beq Continue
        stx GHOST_BUFFER
        rts
Continue
        lda #0
        sta GHOST_BUFFER
        
	ldx $D000
        ldy $D002
        jsr IsXaboveY
        cpx #0
        beq DontMoveForward
        ldx $D002
        inx
        stx $D002
        jmp DontEitherX
DontMoveForward
	ldx $D002
        dex
        stx $D002
DontEitherX
	ldx $D001
        ldy $D003
        jsr IsXaboveY
        cpx #0
        beq DontMoveGDown
        ldx $D003
        inx
        stx $D003
        jmp DontEitherY
DontMoveGDown
	ldx $D003
        dex
        stx $D003
DontEitherY
        rts

MovePumpkin
	ldx CHASE_X
        ldy $D006
        cpy CHASE_X
        beq DontEitherXP
        jsr IsXaboveY
        cpx #0
        beq DontMoveForwardP
        ldx $D006
        inx
        stx $D006
        jmp DontEitherXP
DontMoveForwardP
	ldx $D006
        dex
        stx $D006
DontEitherXP
	ldx CHASE_Y
        ldy $D007
        cpy CHASE_Y
        beq DontEitherYP
        jsr IsXaboveY
        cpx #0
        beq DontMoveGDownP
        ldx $D007
        inx
        stx $D007
        jmp DontEitherYP
DontMoveGDownP
	ldx $D007
        dex
        stx $D007
DontEitherYP
        rts

Player
	byte #%00000000,#%00000000,#%00000000
	byte #%00000000,#%00000000,#%00000000
	byte #%00000000,#%00000000,#%00000000
	byte #%00000000,#%00000000,#%00000000
	byte #%00000000,#%00000000,#%00000000
	byte #%00000000,#%00000000,#%00000000
	byte #%00000000,#%00000000,#%00000000
	byte #%00000000,#%00111100,#%00000000
	byte #%00000000,#%01111110,#%00000000
	byte #%00000000,#%01011010,#%00000000
	byte #%00000000,#%01111110,#%00000000
	byte #%00000000,#%01100110,#%00000000
	byte #%00000000,#%00111100,#%00000000
	byte #%00000000,#%00000000,#%00000000
	byte #%00000000,#%00000000,#%00000000
	byte #%00000000,#%00000000,#%00000000
	byte #%00000000,#%00000000,#%00000000
	byte #%00000000,#%00000000,#%00000000
	byte #%00000000,#%00000000,#%00000000
	byte #%00000000,#%00000000,#%00000000
	byte #%00000000,#%00000000,#%00000000
 
Zombie
	byte #%00000000,#%11110000,#%00000000
	byte #%00000000,#%01111110,#%00000000
	byte #%00000000,#%11111111,#%00000000
	byte #%00000000,#%11111111,#%00000000
	byte #%01111000,#%11001001,#%00011110
	byte #%11111110,#%11101101,#%01111111
	byte #%11111111,#%11111111,#%11111111
	byte #%10010111,#%11100011,#%11101001
	byte #%10010000,#%11011101,#%00001001
	byte #%00010000,#%11111111,#%00001000
	byte #%00010000,#%11111111,#%00001000
	byte #%00000000,#%11111111,#%00000000
	byte #%00000000,#%01010101,#%00000000
	byte #%00000000,#%01010101,#%00000000
	byte #%00000000,#%01010101,#%00000000
	byte #%00000000,#%01000101,#%00000000
	byte #%00000000,#%01000101,#%00000000
	byte #%00000000,#%01000100,#%00000000
	byte #%00000000,#%00000100,#%00000000
	byte #%00000000,#%00000100,#%00000000
	byte #%00000000,#%00000000,#%00000000

Ghost
	byte #%00000000,#%00000000,#%00000000
	byte #%00000000,#%01010100,#%00000000
	byte #%00000000,#%00111100,#%00000000
	byte #%00000000,#%01111110,#%00000000
	byte #%00000000,#%01011010,#%00000000
	byte #%00000000,#%01111110,#%00000000
	byte #%00000000,#%01100110,#%00000000
	byte #%00000000,#%00111100,#%00000000
	byte #%00000000,#%00000000,#%00000000
	byte #%00000001,#%01111110,#%10000000
	byte #%00000011,#%00111100,#%11000000
	byte #%00000110,#%00111100,#%01100000
	byte #%00001100,#%00111100,#%00110000
	byte #%00001000,#%00111100,#%00010000
	byte #%00000000,#%00000000,#%00000000
	byte #%00000000,#%00111100,#%00000000
	byte #%00000000,#%00100100,#%00000000
	byte #%00000000,#%00100100,#%00000000
	byte #%00000000,#%00100100,#%00000000
	byte #%00000000,#%00100100,#%00000000
	byte #%00000000,#%11100111,#%00000000

Pumpkin
	byte #%00001000,#%00000000,#%00010000
	byte #%00010000,#%00000000,#%00001000
	byte #%00011111,#%11000011,#%11111000
	byte #%00001111,#%11111111,#%11110000
	byte #%00000000,#%00111100,#%00000000
	byte #%00000000,#%00111100,#%00000000
	byte #%00001110,#%00011000,#%01110000
	byte #%00011111,#%11000011,#%11111000
	byte #%00111111,#%11111111,#%11111100
	byte #%00111000,#%11111111,#%00011100
	byte #%00111000,#%01111110,#%00011100
	byte #%00110000,#%00000000,#%00001100
	byte #%00111000,#%01111110,#%00011100
	byte #%00111000,#%11100111,#%00011100
	byte #%00110000,#%11100111,#%00001100
	byte #%00000000,#%11100111,#%00000000
	byte #%00000000,#%11000011,#%00000000
	byte #%00000000,#%11000011,#%00000000
	byte #%00000000,#%11100111,#%00000000
	byte #%00000000,#%11100111,#%00000000
	byte #%00000000,#%10100101,#%00000000

	org $9fff
        byte 0
