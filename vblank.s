IF !DEF(VBLANK_INTERRUPT_S)
DEF VBLANK_INTERRUPT_S EQU 1

INCLUDE "init.s"
INCLUDE "utility.s"
INCLUDE "interrupt_utility.s"


; NB: Space in the actual interrupt vector is limited,
; so we are delegating the execution to a separate subroutine
SECTION "VBlank Interrupt", ROM0[$0040]
VBlankInterrupt:
    INTERRUPT_INIT
    jp VBlankHandler
    

; This is the actual interrupt handler
SECTION "VBlank Hander", ROM0
VBlankHandler:
    ; Check to see if we can update the frame counter yet
    ld a, [wFrameLimit]
    ld b, a
    ld a, [wFrameCounter]
    cp a, b
    jp nz, .colorSwap

    xor a, a
    ld [wFrameCounter], a

.colorSwap:
    ld a, [wShouldSwapColors]
    cp 1
    jr z, .doSwap
    jr .done
.doSwap:    
    ldh a, [rBGP]
    cpl
    ldh [rBGP], a

    xor a, a
    ld [wShouldSwapColors], a

.showTetromino:
    ld a, [wTetrominoNumber]
    ld b, a
    ld c, $00
    ld d, $08
    ld e, $08
    call CreateTetromino

    ld a, [wTetrominoNumber]
    inc a
    ld [wTetrominoNumber], a

    ld b, a
    ld c, $27
    ld d, $08
    ld e, $08
    call CreateTetromino

    ld a, [wTetrominoNumber]
    cp $13
    jr nz, .tetrominoDone

    xor a, a

.tetrominoDone:
    ld [wTetrominoNumber], a

; Clean up and return
.done:
    INTERRUPT_CLEAN
    reti


ENDC
