IF !DEF(TETROMINO_S)
DEF TETROMINO_S EQU 1

SECTION "Tetromino", ROM0

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


; Adjusts the coordinates based on the tetromino pattern and index
;
; Arguments:
;   - b - the Y offset (twos complement)
;   - c - the X offset (twos complement)
;   - d - the base Y coordinate
;   - e - the base X coordinate
;
; Final coordinates are returned in DE
;
AdjustCoordinates:
    ld a, d
    add b
    ld d, a

    ld a, e
    add c
    ld e, a

    ret


; Copies the current (next) tetromino into the old
CopyTetromino:
    push hl
    push bc
    push de

    ld d, TETROMINO_STRUCTURE_SIZE
    ld hl, wPreviousTetromino
    ld bc, wNextTetromino
    call memcpy

    pop de
    pop bc
    pop hl

    ret


; Copies tetromino tile data into memory
;
; Arguments:
;   - b - the tetromino type (0-6)
;   - c - the tile pattern to use
;   - d - the Y coordinate of the center tile
;   - e - the X coordinate of the center tile
;
CreateTetromino:
    ; First, store the current tetromino in the old
    call CopyTetromino

    ; First, calculate the Y coordinate address
    ; Then, calculate the X coordinate address
    ; Do this four times - once for each tile in the teromino

    ; First, preserve our tile value
    ld a, c
    ld [wNextTetromino + 0], a

    ; We need the address of the relevant matrix in order to get
    ; the tetromino's coordinate positions    

    ; To do this, first multiply the type offset (B) by 8 (8 bytes per type)
    ld a, b
    sla a
    sla a
    sla a

    ; Add it to the base address of the tetrominos
    ; Store the result in HL
    ld hl, TetrominoMatrix
    adc l
    jr nc, .loopSetup
    inc h

.loopSetup:
    ld l, a ; Store the addition result back in L
    ld a, 0

.loop:
    push bc
    push de
    push hl
    push af

    ; Load BC with tetromino matrix data (Y,X)
    ;
    ; First, multiply A by 2 (2 bytes per tile) to get the index into the tetromino data
    sla a   ; x2
    ; Then, get the index at that position in HL
    adc l
    ld l, a
    jr nc, .finishIndex
    inc h
.finishIndex:
    ; Store tile data in BC
    ld a, [hli]
    ld b, a
    ld a, [hl]
    ld c, a

    ; Get adjusted coordinates in DE
    call AdjustCoordinates

    ; Get the address of those coordinates in BC
    call CalculateTileAddress

    pop af
    push af
    sla a
    ld hl, wNextTetromino + 1
    adc l
    jr nc, .saveAddress
    inc h
.saveAddress:
    ld l, a
    ld a, c
    ld [hli], a
    ld a, b
    ld [hli], a

.restoreRegisters:
    pop af
    pop hl
    pop de
    pop bc

    ; Loop comparison
    inc a
    cp 4
    jp nz, .loop

.done:
    ret


; Clears the previous tetromino from memory
; NB: Only call in VBlank!
;
; Iterates through the addresses listed in the structure,
; writing zero to each of them
;
ClearPreviousTetromino:
    ld hl, wPreviousTetromino + 1
    ld d, TETROMINO_STRUCTURE_SIZE - 1

.loop:
    ld a, [hli]
    ld c, a
    ld a, [hli]
    ld b, a
    
    xor a, a
    ld [bc], a

    dec d
    jr nz, .loop

    ret


; Draws wNextTetromino to the screen
; NB: Only call in VBlank!
DrawNextTetromino:
    ld hl, wNextTetromino + 1
    ld d, TETROMINO_STRUCTURE_SIZE - 1

.loop:
    ld a, [hli]
    ld c, a
    ld a, [hli]
    ld b, a

    ld a, [wNextTetromino]
    ld [bc], a

    dec d
    jr nz, .loop

    ret


ENDC
