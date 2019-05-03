import numpy as np

import os
import cloudpickle as cp

def serialize_to(obj, default_filename):
    filename = os.getenv("S2I_PIPELINE_STAGE_SAVE_FILE", default_filename)
    cp.dump(obj, open(filename, "wb"))

def sample_corresponding(count, source, *sources, **kwargs):
    """ given one or more list-like or data-frame-like sources, sample _count_ elements
    from each such that corresponding elements are returned. """
    
    if "seed" in kwargs:
        np.random.seed(int(kwargs["seed"]))
    
    replace = False
    
    if "replace" in kwargs:
        replace = kwargs["replace"]
        
    indices = np.random.choice(source.shape[0], count, replace=replace)
    def extract(s, idxs):
        if hasattr(s, "iloc"):
            return s.iloc[idxs, :]
        else:
            return s[idxs, :]

    return [extract(s, indices) for s in [source] + list(sources)]