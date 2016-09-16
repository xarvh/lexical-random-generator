#!/usr/bin/env python3

import phonems



src = open('/usr/share/dict/british-english').read().split('\n')



def exclude1(word):
    return (
        word.endswith('ing') or
        word.endswith('ed') or
        ("'" in word) or
        len(word) < 2 or
        False
    )

src = [ w for w in src if not exclude1(w) ]



# O(n^2), too lazy to make it smarter
def exclude2(word):
    return (
        (word + 's') in src or
        (word + 'es') in src or
        False
    )

src = [ w for w in src if not exclude2(w) ]



open('gibberenglish.lex', 'wt').write(phonems.phonems_as_string(
    pyphen_language = 'en_UK',
    max_length = 50,
    words = src,
))
