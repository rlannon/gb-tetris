; The main file for our program

INCLUDE "hardware.inc"

INCLUDE "constants.s"
INCLUDE "tile_defs.s"

INCLUDE "vblank.s"
INCLUDE "joypad.s"

INCLUDE "tetromino.s"

SECTION "Header", ROM0[$100]

    jp EntryPoint

    ds $150 - @, 0

EntryPoint:
    ; Wait a bit before clearing the Nintendo logo and initializing
    ld b, 0
.wait:
    call WaitVBlank
    call WaitNotVBlank
    inc b
    ld a, b
    cp $B4
    jr c, .wait

.init:
    call GlobalInit

Main:
    call WaitNotVBlank
    call JoypadHandler

    ; Update frame counter
    ld a, [wFrameCounter]
    inc a
    ld [wFrameCounter], a

    ; Handle input
    ldh a, [hNewKeys]
    bit PADB_A, a
    jp nz, .setColorSwap
    jp .done
.setColorSwap:
    ld a, 1
    ld [wShouldSwapColors], a

    ld hl, _OAMRAM
    ld b, 0
    ld c, $27
    ld d, $30
    ld e, $30
    call CreateTetromino
.done:
    halt
    jp Main


; A matrix containing tetromino tile positions
SECTION "Tetromino Map", ROM0

TetrominoMatrix:
    INCBIN "tetrominos.bin", 0, $A0
TetrominoMatrixEnd:
