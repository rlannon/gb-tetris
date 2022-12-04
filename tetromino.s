IF !DEF(TETROMINO_S)
DEF TETROMINO_S EQU 1

SECTION "Tetromino", ROM0

; Copies tetromino tile data into memory
;
; Arguments:
;   - b - the tetromino type (as offset)
;   - c - the tile pattern to use
;   - d - the Y coordinate of the center tile
;   - e - the X coordinate of the center tile
;   - hl - the address (in OAM) of the beginning of the 16-byte block for the 4 sprites
;
; todo: refactor this to write to the background, rather than using sprites...
;
CreateTetromino:
    ; First, calculate the X coordinate and store it in OAM
    ; Then, calculate the Y coordinate and store it in OAM
    ; Then, store the pattern in OAM
    ; Finally, store any attributes...
    ; Do this four times

    ; First thing's first -- we need the address of the relevant matrix to
    ; get the tetromino's coordinate positions
    
    ; todo: somehow preserve c so that we can store the tile...

    ; To do this, first multiply the type offset (B) by 8 (8 bytes per type)
    ld a, b
    sla a
    sla a
    sla a

    ; Add it to the base address of the tetrominos
    ld bc, TetrominoMatrix    
    ccf
    adc c
    jr nc, .loopSetup
    inc b

.loopSetup:
    ld a, 0

.loop:
    push af
    push bc

    ; Now, multiply our counter by 2 to get the coordinate pair's offset in the matrix
    sla a

    ; Add this to the matrix's base address
    ccf
    add c
    jr nc, .fetchCoordinates
    inc b

.fetchCoordinates:
    ; Now, get the actual coordinate difference (Y, X)
    ; We will need some extra registers for this
    push de
    
    ; Save updated Y coordinate in D  
    ld a, [bc]
    add d
    ld d, a

    ; Save updated X coordinate in E
    inc bc
    ld a, [bc]
    add e
    ld e, a
    dec bc

    ; Save coordinates in OAM
    push hl

    ld a, d
    ld [hli], a
    ld a, e
    ld [hli], a
    ld a, [Tiles + TETROMINO_BASE_OFFSET]
    ld [hli], a
    ld a, %11100100
    ld [hl], a

    pop hl

    ; Restore our original X/Y coordinates
    pop de

    ; Pop regs we saved at the top of the loop
    pop bc
    pop af

    ; Loop comparison
    cp 4
    jp nz, .loop

.done:
    ret


ENDC
