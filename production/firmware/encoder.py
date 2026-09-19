import board

from kmk.keys import KC
from kmk.modules.encoder import EncoderHandler


def get_encoder():
    # A -> PORTA A -> D8
    # B -> PORTA B -> D9
    # C -> GND

    # S1 -> GND
    # S2 -> LINHA2 -> D7

    encoder_handler = EncoderHandler()

    encoder_handler.pins = (
        (
            board.D8,
            board.D9,
            board.D7,
            False,  # não inverter
        )
    )

    # vol -
    # vol +
    # press mute
    encoder_handler.map = [
        (
            (
                KC.VOLD,
                KC.VOLU,
                KC.MUTE,
            ),
        ),
    ]

    return encoder_handler