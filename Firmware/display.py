import board
import busio

from kmk.extensions.display import Display, TextEntry
from kmk.extensions.display.ssd1306 import SSD1306


def get_display():
    # OLED SSD1306 via I2C (SDA -> D4, SCL -> D5)
    i2c_bus = busio.I2C(board.D5, board.D4, frequency=400000)

    display_driver = SSD1306(
        i2c=i2c_bus,
        device_address=0x3C,
    )

    display = Display(
        display=display_driver,
        entries=[
            TextEntry(text="MarcinhoPad", x=0, y=0),
            TextEntry(text="Layer: BASE", x=0, y=16),
        ],
    )

    return display