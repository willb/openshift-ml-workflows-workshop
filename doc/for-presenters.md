# For presenters

This workshop is designed to show application developers how to incorporate machine learning workflows into their everyday engineering discipline.  Our goal is for developers who are excited about machine learning to learn three important things in the context of a real application, namely detecting spam messages:

- how to use machine learning to solve a real problem, from visualization to a deployable model that can run as an application component;
- how to evaluate and validate predictive models, and some metrics that are more useful than raw accuracy;
- how OpenShift enables every stage of machine learning discovery and production, including trying different approaches to solve a problem.

## Background and workshop flow

First, follow the instructions in [deploy.md](../deploy/deploy.md), installing the OpenShift template in a project for each workshop user (or just for yourself if you're trying it out locally).  A more streamlined experience is coming soon!

The main structure of the workshop is given by [the notebooks](../source), but the slide presentation complements the notebooks.  If you're presenting slides, start with the first two sections:  "What is machine learning" and "Machine learning workflows and OpenShift."  At the end of the second section, refer attendees to the URL for their OpenShift console.

The OpenShift template makes it possible to add one of several applications to your project.  The first one each attendee will want to add is a "Jupyter Notebook," which will create a Jupyter notebook service.  They should then visit the exposed route for each notebook.  The password for the notebook service is `developer` unless they changed it at deployment.  

If you haven't used Jupyter notebooks before, please refer to [the user documentation at Project Jupyter](https://jupyter-notebook.readthedocs.io/en/stable/notebook.html#notebook-user-interface) to get comfortable with explaining details of how things work to users.  Some things to keep in mind, though, are:

- Jupyter notebooks are a literate programming environment combining _cells_ containing narration and cells containing code.  When a user executes a code cell, the output of running the code (whether a value, a table of records, a graph, or an error) is appended to the code cell.
- Shift+Enter always executes the current cell and advances to the next one.  **This is really all of the Jupyter interface anyone absolutely needs to know.**
- Cells only run if you execute them, you can run a cell more than once, you can edit a cell and run it again (or not).  This can be confusing!  Don't assume that you can reproduce the output in a notebook you've seen 
- If you get really stuck, head up to the `Kernel` menu and select `Restart and clear output` to start fresh.

The notebooks are numbered in order (and, for the most part, need to be run in order); here's how you'll go through the workshop:

- `00-generator.ipynb` is the generator we use for our synthetic data -- "legitimate" messages are based on the novels of Jane Austen, while "spam" messages are based on reviews of food products from a retail website.  _This notebook can be safely skipped in a shorter workshop; we have pregenerated a training dataset in the `data` folder._
- `01-vectors-and-visualization.ipynb` shows how to turn English-language text into vectors of numbers and visualize these vectors to see whether we can identify any structure in the data.  This is an important first step of exploratory analysis.  We recommend walking through this notebook cell-by-cell with the students and explaining what's happening -- there's a lot of narration in the notebook, but let us know if anything could be clearer!
- `02-evaluating-models.ipynb` shows how to evaluate whether or not a _binary classifier_ (that is, a model that takes an input and puts it in to one of two classes -- in this case "spam" or "legitimate") is effective.  It discusses some of the pitfalls with model training, in particular, it covers the problems with using raw accuracy and explains what some better metrics are and when one might want to use them.  We recommend walking through this notebook cell-by-cell with the students and explaining what's happening.

The next part of the workshop allows students to decide how they'll want to solve the problem.  We offer two different approaches to _feature engineering_, or extracting valuable signals from raw data in a way that a ML algorithm can exploit, and two different approaches to training predictive models with these features.  This means that as long as each student runs one of the feature engineering notebooks (starting with `03-`) and one of the model training notebooks (starting with `04-`), they'll have a complete approach to going from raw data to a prediction.  We recommend allowing students time to work through these notebooks at their own pace -- between five and ten minutes for each of the feature engineering notebook and the model training notebook is plenty of time to work through even both alternatives and/or tune some of the parameters in each approach.

Here are the notebooks for this part of the workshop:

- `03-feature-engineering-summaries.ipynb` shows how to extract features based on some summary statistics about the text;
- `03-feature-engineering-tfidf.ipynb` shows how to use term frequency-inverse document frequency and hashing to generate features capturing words appearing in each document;
- `04-model-logistic-regression.ipynb` shows how to train a logistic regression model to distinguish between legitimate and spam documents; and
- `04-model-random-forest.ipynb` shows how to train an ensemble of decision trees to distinguish between legitimate and spam documents.

Ask attendees how their model performed.  What kinds of metrics are they seeing on their test data?  What changes to the approach did they try?  Did anything improve their performance or make it noticeably worse?

If you're running the workshop in a longer session, now might be a great time to take a short break.  In any case, you'll want to pick up with the third section of the slide deck, called "Machine learning, apps, and OpenShift."  This part of the deck introduces _intelligent applications_ and talks about the teams who build them, discusses the advantages of Kubernetes and OpenShift for machine learning and intelligent applications, focusing in particular on

- scalability through scale-up or scale-out with containerized microservices,
- reproducibility through immutable images,
- developer and data scientist workflow through CI/CD and source builds, and
- solving the problem of _data drift_ through monitoring and observability.

Data drift is the phenomenon in which a predictive model loses effectiveness because the distribution of the data it is evaluating in the real world has materially diverged from the data it was trained on.  (For a real-world example, think back to the early days of automated spam filtering and the cat-and-mouse game that email scammers played with email providers -- messages for pharmaceuticals might escape detection one week, while messages for gambling or dubious mortgages might escape detection the next.)

It's time to return to OpenShift and see how we can use it to make machine learning systems better.  Here are the notebooks you'll use:

- `05-data-drift.ipynb` explains the problem of data drift and shows a common technique used by real-world spammers to escape detection, and
- `06-pipelines.ipynb` shows how we can define _machine learning pipelines_ consisting of preprocessing, feature extraction, and model training stages and then reuse these to retrain a model or try different learning approaches.

The next step is to show students how to put entire pipelines into production with source-to-image.  Source-to-image is an extremely powerful tool to make machine learning discovery reproducible, and it's also an excellent way for data scientists to communicate their work to application developers.

From the OpenShift console, select "Add to project" and then "Select from project," then choose "scikit-learn pipelines."  This will offer students a chance to chain two notebooks together in a workflow (one of the feature engineering notebooks and one of the model training notebooks) and build a REST service that serves this workflow.  _Note that creating many source builds can be extremely taxing on shared infrastructure -- if you're running many users on a single OpenShift cluster you may want to demonstrate this step instead of making it interactive._  

Next up, we'll want to use the model service to make predictions, and for that, we'll go back to Jupyter.

- `07-services.ipynb` presents a small client library for interacting with our pipeline service; it shows how to make predictions over REST and demonstrates how Prometheus metrics can help to identify data drift.

If you're comfortable installing Prometheus to scrape metrics, you can visualize the performance of your model service over time.

There's one notebook left, and it's more or less "extra credit":

- `99-baseline.ipynb` shows the classic Naive Bayes spam classification technique, which formed the basis for the first successful automatic spam classifiers.  Your attendees are unlikely to tune the other approaches so that they outperform Naive Bayes, but they may have fun trying!

The final section of the slides briefly introduces some other topics of interest:  a call to action to get involved with some key open source communities (the Open Data Hub, radanalytics.io, and Kubeflow), how OpenShift facilitates GPU and CPU acceleration of linear algebra, and the promise of function-as-a-service for machine learning systems.  