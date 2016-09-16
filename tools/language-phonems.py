#!/usr/bin/env python3
"""
This script produces phonems that can be used to generate words.

You will need to manually change the variables below:

"""


word_list_file_path = '/usr/share/dict/british-english'
pyphen_language = 'en_UK'





from collections import defaultdict
import operator

import pyphen



dic = pyphen.Pyphen(lang=pyphen_language)

first = defaultdict(int)
middle = defaultdict(int)
last = defaultdict(int)

words = open(word_list_file_path).read().split('\n')
# TODO: make exclusion criteria more easily configurable
words = [ w for w in words if not "'" in w ]

for word in words:

    # Yes, technically speaking they are NOT syllabes
    syllabes = dic.inserted(word.lower()).split('-')

    first[syllabes[0]] += 1
    last[syllabes[-1]] += 1
    for s in syllabes[1 : -1]:
        middle[s] += 1


def cut(dictionary, key, threshold):
    filtered = [ (k, v) for k, v in dictionary.items() if v > threshold ]
    n = [ k for k, v in filtered ]
    n.reverse()
    return '%s\n    %s\n' % (key, ','.join(n))


print(cut(first, 'ini', 50))
print(cut(middle, 'mid', 50))
print(cut(last, 'end', 50))
