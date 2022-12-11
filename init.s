IF !DEF(INIT_S)
DEF INIT_S EQU 1

INCLUDE "utility.s"
INCLUDE "global_variables.s"

SECTION "Init", ROM0

; Main initialization routine
GlobalInit:
    di
    call WaitVBlank

    LCD_DISABLE
    
    call LoadTiles
    call InitOAM
    call InitDisplayRegisters

    ; Initialize global variables
    xor a, a
    ld [wFrameCounter], a
    ld [wShouldSwapColors], a
    ld [wTile], a
    ld [wTetrominoNumber], a
    ldh [hCurrentKeys], a
    ldh [hNewKeys], a

    ld hl, wPreviousTetromino
    call ClearTetrominoData

    ld hl, wNextTetromino
    call ClearTetrominoData

    ld a, 15
    ld [wFrameLimit], a

    ; Set up interrupts
    call InitInterrupts
    
    ; Re-enable the LCD
    LCD_ENABLE

    ret


; Loads all tile data into VRAM
; Takes no arguments, clobbers registers
LoadTiles:
    ; Copy the tiles
    ld hl, _VRAM9000
    ld de, Tiles
    ld bc, TilesEnd - Tiles
    call CopyData

    ld hl, _SCRN0
    ld de, GameScreen
    ld bc, GameScreenEnd - GameScreen
    call CopyData
    
    ret

; Set up our interrupts
; Takes no arguments
InitInterrupts:
    ld a, IEF_VBLANK
    ldh [rIE], a

    xor a, a
    ld [rIF], a

    ei
    ret


; Initializes object attribute memory
; Takes no arguments, clobbers registers
InitOAM:
.clearOAM:
    xor a, a
    ld b, 160
    ld hl, _OAMRAM
.loop:
    ld [hli], a
    dec b
    jp nz, .loop
    
    ret


; Initializes the display registers
; Takes no arguments
InitDisplayRegisters:
    ld a, %11100100
    ld [rBGP], a
    ld [rOBP0], a
    ret


ENDC
