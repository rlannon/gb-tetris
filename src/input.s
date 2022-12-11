IF !DEF(INPUT_S)
DEF INPUT_S EQU 1


INCLUDE "global_variables.s"


; Processes user input
ProcessInput:
    ldh a, [hNewKeys]

.handleA
    bit PADB_A, a
    jp z, .handleB

    push af
    xor a, a
    call RotateTetromino
    pop af

.handleB
    bit PADB_B, a
    jp z, .handleUp
    
    push af
    ld a, 1
    call RotateTetromino
    pop af

.handleUp:
    bit PADB_UP, a
    jp z, .handleDown
    
    ; todo: handle up

.handleDown:
    bit PADB_DOWN, a
    jp z, .handleLeft

    ; todo: handle down

.handleLeft:
    bit PADB_LEFT, a
    jp z, .handleRight

    ; todo: handle left

.handleRight:
    bit PADB_RIGHT, a
    jp z, .handleSelect

    ; todo: handle right

.handleSelect:
    bit PADB_SELECT, a
    jp z, .handleStart

    push af
    ld a, 1
    ld [wShouldSwapColors], a
    pop af

.handleStart:
    bit PADB_START, a
    jp z, .done

    ; todo: handle start

.done:
    ret


ENDC
