Next word text prediction
========================================================
author: Andrew Crisp
date: 20161001
autosize: true

# Mission

Predicting textual input is a surprisingly difficult tastk to accomplish with any degree of accuracy.  George Carlin once said that "By and large, language is a tool for concealing the truth."

Unintentional concealment error includes: 
- Misspelling
- Grammar mistakes

By providing a likely intended next word, we can at least mitigate the unintentional errors.  Intentional error is beyond the scope of a simplistic computer algorithm.

The pre-processing algorithm
========================================================

Being a simplistic algorithm, the workflow can be described in a linear fashion.

1. Load in the data sources.
2. Split each source to individual entries and further to individual sentences.
3. For each level of ngram (1-4) break the sentences into ngram representations.
4. Count each occurence.
5. Save the resulting tables for later lookup.

The lookup algorithm
========================================================

Given a search term, perform the following steps.

1. Sanitize the input for mismatch characters, unicode, whitespace, numbers, and punctuation.
2. Break the input into words.
3. Check the size of input term.  If larger than three words, take a substring of the last three words.
4. Beginning with the ngram table of (length of input + 1), search for the input term.
5. For each row in the search results, calculate the percentage of frequency compared to the other rows.
6. While the input term permits, remove the first word and repeat steps 4 and 5.
7. Return the highest percentage result.

The application
========================================================

The shiny application at <https://crispa.shinyapps.io/TextPrediction/> takes the preprocessed data files and presents a bare frontend to the lookup algorithm.  Of note, the preprocessed data files have been shrunk significantly to fit within space constraints imposed by shinyapps.io.  The limits I worked within were 100Mb for disk files and 1Gb for used RAM.

Specifically, the quadgrams have been truncated so that only 29% of the original corpus remains searchable.  Interestingly, that only removed terms that have a frequency of 2 or less in the corpus.  The tri, bi, and unigrams were similarly shrunk.  But, their sizes were nearly inconsequential when compared to the quadgrams.


```r
quadgramFrequency <- readRDS('quadgramModel.rds')
summary(quadgramFrequency$Freq)
```

```
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
   3.000    3.000    4.000    7.627    6.000 7707.000 
```

```r
print(object.size(quadgramFrequency), units="Mb")
```

```
341.8 Mb
```

Improvements
========================================================

While a lot of work has been done, there are areas for improvement.

- The corpus originates entirely from a few days near Mother's Day.  Hence, Mother's Day is abnormally represented.  An option would be to collect data spread over a full year to distrubute holiday references realistically.
- Names are not handled.  While it is its own topic, capturing proper nouns and coding them with a tag could allow some flexibility to handle names in the input search term.
- Numbers and dates are similiarly not handled.
- Performance is lacking.  Even though the size of the data files has been severly cut, lookups still take multiple seconds when checking against the quadgrams.  Database searching could improve on this.
- Size is still large, relatively speaking.  A database that has been normalized should be able to shrink disk storage needed by a huge margin.
