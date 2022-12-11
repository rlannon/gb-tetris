IF !DEF(TILES_S)
DEF TILES_S EQU 1


SECTION "Tile Utilities", ROM0


; Calculates a tile address (in VRAM/on screen)
; Preserves af, hl
;
; Arguments:
;   - d - the Y coordinate
;   - e - the X coordinate
;
; Result returned in bc
;
CalculateTileAddress:
    push af
    push hl

    ld bc, _SCRN0

.calculateY:
    ld hl, 0
    ld l, d

    ; Multiply Y by 32
    scf
    ccf
    sla l   ; x2
    rl h
    sla l   ; x4
    rl h
    sla l   ; x8
    rl h
    sla l   ; x16
    rl h
    sla l   ; x32
    rl h

    ; Now, add HL to BC
    ld a, l
    adc c
    jr nc, .addHighByteY
    inc h
.addHighByteY:
    ld c, a
    ld a, h
    add b
    ld b, a

.calculateX:
    ld a, c
    adc e
    jr nc, .saveAddress
    inc b

.saveAddress:
    ld c, a

.done:
    pop hl
    pop af
    ret


ENDC
