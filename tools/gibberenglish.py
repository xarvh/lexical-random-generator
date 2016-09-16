#!/usr/bin/env python3

import phonems


def exclude(word):
    return word.endswith('ing') or word.endswith('ed') or ("'" in word) or len(word) < 2


src = open('/usr/share/dict/british-english').read().split('\n')


open('gibberenglish.lex', 'wt').write(phonems.phonems_as_string(
    pyphen_language = 'en_UK',
    max_length = 50,
    words = [ w for w in src if not exclude(w) ],
))
