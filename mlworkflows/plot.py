import altair as alt

MAX_POINTS = 2500

def plot_points(df, **kwargs):
    alt.renderers.enable('notebook')
    plot_df = df.sample(min(len(df), MAX_POINTS))
    return alt.Chart(plot_df).encode(**kwargs).mark_point().interactive()