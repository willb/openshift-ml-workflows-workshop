import altair as alt
import pandas as pd
import numpy as np



MAX_POINTS = 2500

def activate():
    if alt.renderers.active != 'notebook':
        alt.renderers.enable('notebook')
    
def plot_points(df, **kwargs):
    activate()
    plot_df = df.sample(min(len(df), MAX_POINTS))
    return alt.Chart(plot_df).encode(**kwargs).mark_point().interactive()


def plot_pca(df, input_column, **kwargs):
    import sklearn.decomposition
    DIMENSIONS = 2
    
    activate()
    samples = MAX_POINTS
    
    if "func" in kwargs:
        func = kwargs["func"]
        del kwargs["func"]
    else:
        func = lambda x: x
    
    a = np.array([func(v) for v in df[input_column].values])
    
    pca_a = sklearn.decomposition.PCA(DIMENSIONS).fit_transform(a)
    pca_data = pd.concat([df.reset_index(), pd.DataFrame(pca_a, columns=["x", "y"])], axis=1)

    return plot_points(pca_data, **kwargs) 
    
def plot_tsne(df, input_column, **kwargs):
    import sklearn.manifold
    
    activate()
    samples = MAX_POINTS
    
    if "tsne_sample" in kwargs:
        samples = kwargs["tsne_sample"]
        del kwargs["tsne_sample"]
    
    sdf = df.sample(samples)
    
    if "func" in kwargs:
        func = kwargs["func"]
        del kwargs["func"]
    else:
        func = lambda x: x
    
    a = np.array([func(v) for v in sdf[input_column].values])
    
    tsne = sklearn.manifold.TSNE()
    tsne_a = tsne.fit_transform(a)
    tsne_plot_data = pd.concat([sdf.reset_index(), pd.DataFrame(tsne_a, columns=["x", "y"])], axis=1)

    return plot_points(tsne_plot_data, **kwargs)    
    
def binary_confusion_matrix(actuals, predictions, labels = None, width = 215, height = 215):
    activate()
    from sklearn.metrics import confusion_matrix
    
    if labels is None:
        from sklearn.utils.multiclass import unique_labels
        labels = unique_labels(predictions, actuals)
    
    assert(len(labels) == 2)
    
    ccm = confusion_matrix(actuals, predictions, labels=labels)
    ncm = ccm.astype('float') / ccm.sum(axis=1)[:, np.newaxis]
    
    def labelizer(labels):
        def labelize(tup):
            i, v = tup
            return {'predicted' : labels[int(i / 2)], 'actual' : labels[i & 1], 'raw_count' : v[0], 'value' : v[1]}
        return labelize

    labelize = labelizer(labels)
    
    cmdf = pd.DataFrame([labelize(t) for t in enumerate(zip(ccm.ravel(), ncm.ravel()))])
    c = alt.Chart(cmdf).mark_rect().encode(
        x='predicted:O',
        y='actual:O',
        color='value:Q',
        tooltip=["raw_count:Q"]
    ).properties(width=width, height=height)

    return (cmdf, c)
    