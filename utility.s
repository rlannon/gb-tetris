IF !DEF(UTILITY_S)
DEF UTILITY_S EQU 1

SECTION "Utilities", ROM0


; Copies data from one location to another
; Arguments:
;   - bc - the number of bytes to copy
;   - de - the source address base
;   - hl - the target address base
CopyData:
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or a, c
    jp nz, CopyData
.done:
    ret


; Waits for the next VBLANK
WaitVBlank:
    ld a, [rLY]
    cp VBLANK_START
    jr c, WaitVBlank
    ret


; Waits until NOT VBLANK
WaitNotVBlank:
    ld a, [rLY]
    cp VBLANK_START
    jr nc, WaitNotVBlank
    ret


; A macro to turn off the LCD
MACRO LCD_DISABLE
    ld a, 0
    ld [rLCDC], a
ENDM

; A macro to turn the LCD on
MACRO LCD_ENABLE
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON
    ld [rLCDC], a
ENDM


ENDC
