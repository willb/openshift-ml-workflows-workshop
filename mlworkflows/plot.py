import altair as alt
import pandas as pd

MAX_POINTS = 2500

def activate():
    if alt.renderers.active != 'notebook':
        alt.renderers.enable('notebook')
    
def plot_points(df, **kwargs):
    activate()
    plot_df = df.sample(min(len(df), MAX_POINTS))
    return alt.Chart(plot_df).encode(**kwargs).mark_point().interactive()
    
def binary_confusion_matrix(predictions, actuals, labels = None, normalize = False, width = 215, height = 215):
    activate()
    from sklearn.metrics import confusion_matrix
    
    if labels is None:
        from sklearn.utils.multiclass import unique_labels
        labels = unique_labels(predictions, actuals)
    
    assert(len(labels) == 2)
    
    cm = confusion_matrix(predictions, actuals, labels=labels)
    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
    
    def labelizer(labels):
        def labelize(tup):
            i, v = tup
            return {'predicted' : labels[int(i / 2)], 'actual' : labels[i & 1], 'value' : v}
        return labelize

    labelize = labelizer(labels)
    
    cmdf = pd.DataFrame([labelize(t) for t in enumerate(cm.ravel())])
    c = alt.Chart(cmdf).mark_rect().encode(
        x='predicted:O',
        y='actual:O',
        color='value:Q',
        tooltip=["value:Q"]
    ).properties(width=width, height=height)

    return (cmdf, c)
    