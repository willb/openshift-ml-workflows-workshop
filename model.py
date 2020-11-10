import pandas as pd
import pickle

class model(object):
    def __init__(self):
        model_path = "./model.pkl"
        model = pd.read_pickle(model_path)
        print("Loaded model ", model_path)

    def predict(self, X):
        x = X[0]

        print("Evaluating input: ", x)
        prediction = model.predict(x)

        return prediction