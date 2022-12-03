IF !DEF(JOYPAD_S)
DEF JOYPAD_S EQU 1


SECTION "Joypad Handler", ROM0
JoypadHandler:
    ld a, P1F_GET_BTN
    ldh [rP1], a
    ldh a, [rP1] ; Perform a few reads to help inputs stabilize
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1] ; The final read contains the state we will use
    or $f0
    ld b, a     ; Action button states will be contained in B

    ld a, P1F_GET_DPAD
    ldh [rP1], a
    call .knownRet
    ldh a, [rP1] ; Perform a few reads to help inputs stabilize
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1] ; The final read contains the state we will use
    or $f0  ; Set high nibble to 0xF, leave low nibble with DPAD

    swap a
    xor b
    ld b, a     ; Store state in B

    ; Disable button reads
    ld a, P1F_GET_NONE
    ldh [rP1], a

    ; Get current and new inputs
    ldh a, [hCurrentKeys]
    xor b
    and b
    ldh [hNewKeys], a
    ld a, b
    ldh [hCurrentKeys], a
.knownRet
    ret


ENDC
