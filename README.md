Lexicon-based random name generator
-----------------------------------

See it running [here](https://xarvh.github.io/lexical-random-generator/)

```
import LexicalRandom


lexiconString =
    """
# this is a comment

streetType
    # definitions can be separed by comma or newline, it's the same
    street,road,avenue,drive,
    parade,square,plaza

namePrefix
    Georg,Smiths,Johns

nameSuffix
    chester,ington,ton,roy

surname
    {namePrefix}son
    {namePrefix}{nameSuffix}

address
    {surname} {streetType}
"""


streetNamesLexicon =
    LexicalRandom.fromString lexiconString
        |> Random.map LexicalRandom.capitalize


streetNamesRandomGenerator : Random.Generator String
streetNamesRandomGenerator =
    LexicalRandom.generator (\key -> "[missing key`" ++ key ++ "`]") streetNamesLexicon "address"
```
