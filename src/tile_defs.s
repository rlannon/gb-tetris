IF !DEF(TILES_S)
DEF FILES_S EQU 1

SECTION "Tile data", ROM0

Tiles:
    INCBIN "tetris.chr", 0, 2048
TilesEnd:

SECTION "Tilemap", ROM0

GameScreen:
    INCBIN "game_screen.bin", 0, 1024
GameScreenEnd:

ENDC
