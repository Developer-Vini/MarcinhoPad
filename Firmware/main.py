from kmk.extensions.media_keys import MediaKeys

from board_config import get_keyboard
from keymap import get_keymap
from encoder import get_encoder
from display import get_display


def main():
    keyboard = get_keyboard()
    keyboard.keymap = get_keymap()

    keyboard.extensions.append(MediaKeys())

    encoder = get_encoder()
    keyboard.modules.append(encoder)

    display = get_display()
    keyboard.extensions.append(display)

    keyboard.go()


if __name__ == "__main__":
    main()