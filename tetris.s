; The main file for our program

INCLUDE "hardware.inc"

INCLUDE "constants.s"

INCLUDE "vblank.s"
INCLUDE "joypad.s"

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
    jr .done
.done:
    halt
    jp Main


SECTION "Tile data", ROM0

Tiles:
    INCBIN "tetris.chr", 0, 2048
TilesEnd:

SECTION "Tilemap", ROM0

Tilemap:
    INCBIN "tilemap.bin", 0, 1024
TilemapEnd:
