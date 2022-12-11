IF !DEF(GLOBAL_VARIABLES_S)
DEF GLOBAL_VARIABLES_S EQU 1

SECTION "Variables", WRAM0
    wFrameCounter: db
    wShouldSwapColors: db
    wFrameLimit: db
    wTile: db
    wTetrominoNumber: db
        
    ; Represents information about the tetromino's position on screen
    ; Stores the pattern followed by the addresses of each tetromino block
    ; NB: Addresses are saved in memory in little-endian form (LOW, HIGH)
    DEF TETROMINO_STRUCTURE_SIZE EQU 9
    wPreviousTetromino: ds TETROMINO_STRUCTURE_SIZE
    wNextTetromino: ds TETROMINO_STRUCTURE_SIZE

SECTION "High RAM Variables", HRAM
    hCurrentKeys: db    ; Represents the most recent key state - use when looking at controls
    hNewKeys: db        ; Represents the incoming key state - use when updating controls

ENDC
