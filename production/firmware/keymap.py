from kmk.keys import KC


def get_keymap():
    # sw1 -> sw2 -> sw3 -> sw4 -> sw5 -> sw6
    # a,     b,     c,    d,    e,    f
    return [
        [
            KC.A,
            KC.B,
            KC.C,

            KC.D,
            KC.E,
            KC.F,
        ]
    ]