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

; On-screen offsets for actual sprite X/Y values
DEF Y_AXIS_OFFSET EQU $10
DEF X_AXIS_OFFSET EQU $08

; Base offset for tetromino tiles
DEF TETROMINO_BASE_OFFSET EQU $25

; Number of tetromino tile patterns
DEF TETEROMINO_DESIGN_TYPES EQU $06

; Tetromino constants -- mirrors the tetromino matrix in the file
; These types are T J Z O S L I
; Tetrominos are arranged in a 5x5 grid, where 00 is the center point
; Values are 2's complement and are arranged as (Y,X) pairs
DEF NUM_TETROMINO_TYPES EQU $07
DEF TETROMINO_TYPE_T EQU $00
DEF TETROMINO_TYPE_J EQU $01
DEF TETROMINO_TYPE_Z EQU $02
DEF TETROMINO_TYPE_O EQU $03
DEF TETROMINO_TYPE_S EQU $04
DEF TETROMINO_TYPE_L EQU $05
DEF TETROMINO_TYPE_I EQU $06

ENDC    ; CONSTANTS_S
