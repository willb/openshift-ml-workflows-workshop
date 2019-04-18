import pandas as pd

from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.feature_extraction.text import HashingVectorizer

class tfidfFeatureVector:
    """Convert a collection of raw documents to tfidf feature vectors"""

    def hv_count(self, corpus, n_feats):
        """
        hashes words from the _corpus_ of text
        to n_feats buckets.
        """

        hv = HashingVectorizer(norm=None, token_pattern='(?u)\\b[A-Za-z]\\w+\\b',
                           n_features=n_feats, alternate_sign=False)
        hvcounts = hv.fit_transform(corpus)  # returns a sparse numpy matrix.

        return hvcounts


    def hv_tfidf(self, hv_counts, df):
        """
        transforms a _hv_counts_ counts matrix
        into tfidf matrix with lables
        """

        tfidf_transformer = TfidfTransformer()
        tf_idf = tfidf_transformer.fit_transform(hv_counts)
        dense_tf_idf = tf_idf.toarray()
        labled_vecs = pd.concat([df.reset_index()[["index", "label"]],
                                pd.DataFrame(dense_tf_idf)], axis=1)
        labled_vecs.columns = labled_vecs.columns.astype(str)

        return labled_vecs


    def features_tfidf(self, df):
        """
        computes tf-idf feature vectors for
        data frame _df_
        """

        hash_counts = self.hv_count(df["text"], 8192)
        features = self.hv_tfidf(hash_counts, df)

        return features


    def transform(self, df):
        return self.features_tfidf(df)


    def fit(self, df, **fit_params):
        return self
