import re
import numpy as np
import pandas as pd
from sklearn.feature_extraction.stop_words import ENGLISH_STOP_WORDS


def strip_punct(doc):
    """
    takes in a document _doc_ and
    returns a tuple of the punctuation-free
    _doc_ and the count of punctuation in _doc_
    """

    return re.subn(r"""[!.><:;',@#~{}\[\]\-_+=£$%^&()?]""", "", doc,
                   count=0, flags=0)


def caps(word):
    return not word.islower()


def isstopword(word):
    return word in ENGLISH_STOP_WORDS


def standard_summary(row):
    """
    takes in an entry _row_ from the data and
    computes each of the summaries then returns
    the summaries in a tuple, along with the unique
    'level_0' id
    """

    doc = row["text"]

    no_punct = strip_punct(doc)

    words = no_punct[0].split()

    number_words = len(words)

    word_length = [len(x) for x in words]

    mean_wl = sum(word_length)/number_words

    max_wl = max(word_length)
    min_wl = min(word_length)

    pc_90_wl = np.percentile(word_length, 90)
    pc_10_wl = np.percentile(word_length, 10)

    upper = sum([caps(x) for x in words])
    stop_words = sum([isstopword(x) for x in words])

    return [no_punct[1], number_words, mean_wl, max_wl, min_wl, pc_10_wl,
            pc_90_wl, upper, stop_words]


def features_simple(df):
    """
    computes feature vectors for text in data frame _df_
    and returns it in a data frame
    """

    features = df.apply(standard_summary, axis=1).apply(pd.Series)
    features.columns = ["num_punct", "num_words", "av_wl",
                        "max_wl", "min_wl", "10_quantile",
                        "90_quantile", "upper_case", "stop_words"]
    labled_vecs = pd.concat([df[["index", "label"]], features], axis=1)
    labled_vecs.columns = labled_vecs.columns.astype(str)

    return labled_vecs
