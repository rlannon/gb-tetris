IF !DEF(INTERRUPT_UTILITY_S)
DEF INTERRUPT_UTILITY_S EQU 1

MACRO INTERRUPT_INIT
    push af
    push bc
    push de
    push hl
ENDM


MACRO INTERRUPT_CLEAN
    pop hl
    pop de
    pop bc
    pop af
ENDM


ENDC
