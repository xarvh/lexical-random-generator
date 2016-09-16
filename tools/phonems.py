
from collections import defaultdict
import operator
import pyphen


def load(pyphen_language, words):

    dic = pyphen.Pyphen(lang=pyphen_language)

    first = defaultdict(int)
    middle = defaultdict(int)
    last = defaultdict(int)

    for word in words:

        phonem = dic.inserted(word.lower()).split('-')

        first[phonem[0]] += 1
        last[phonem[-1]] += 1
        for s in phonem[1 : -1]:
            middle[s] += 1

    return (first, middle, last)


def dict_to_sorted_list(dictionary):
    sorted_kvs = sorted(dictionary.items(), key=operator.itemgetter(1))
    sorted_kvs.reverse()
    return [ k for k, v in sorted_kvs ]


def stringify(key, phonems):
    return '%s\n    %s\n' % (key, ','.join(phonems))


def phonems_as_string(pyphen_language, words, max_length=200):

    f, m, l = load(pyphen_language, words)
    phonems = [('ini', f), ('mid', m), ('end', l)]

    return '\n'.join(stringify(key, dict_to_sorted_list(phons)[:max_length]) for key, phons in phonems)
