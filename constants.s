; Some constants

IF !DEF(CONSTANTS_S)
DEF CONSTANTS_S EQU 1

; If rLY register >= 144 (a - 144 >= 0 -- does not overflow) then we are in vblank
DEF VBLANK_START EQU 144

; Offsets in the background tile map for the level number
DEF LEVEL_OFFSET EQU $52
DEF LEVEL_DIGITS EQU 2

; Offsets in the background for the lines
DEF LINES_OFFSET EQU $B1
DEF LINES_DIGITS EQU 3

; Offsets in the background for the score
DEF SCORE_OFFSET_BEGIN EQU $10F
DEF SCORE_DIGITS EQU 5

ENDC    ; CONSTANTS_S
