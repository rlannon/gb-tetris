IF !DEF(GLOBAL_VARIABLES_S)
DEF GLOBAL_VARIABLES_S EQU 1

SECTION "Variables", WRAM0
    wFrameCounter: db
    wShouldSwapColors: db
    wFrameLimit: db
    wTile: db
    wTetrominoNumber: db

SECTION "High RAM Variables", HRAM
    hCurrentKeys: db    ; Represents the most recent key state - use when looking at controls
    hNewKeys: db        ; Represents the incoming key state - use when updating controls

ENDC
