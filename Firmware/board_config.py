import board

from kmk.kmk_keyboard import KMKKeyboard
from kmk.scanners import DiodeOrientation


def get_keyboard():
    keyboard = KMKKeyboard()

    # COLUNA 0 -> D0
    # COLUNA 1 -> D1
    # COLUNA 2 -> D2
    keyboard.col_pins = (
        board.D0,
        board.D1,
        board.D2,
    )

    # LINHA 0 -> D3
    # LINHA 1 -> D6
    keyboard.row_pins = (
        board.D3,
        board.D6,
    )

    keyboard.diode_orientation = DiodeOrientation.COL2ROW

    return keyboard