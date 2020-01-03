
# Machine learning workflows for developers

This repository has materials from a hands-on tutorial on machine learning workflows (and using OpenShift for these).  We'll have more documentation for how to run the lab on your own time in the future, but for now you can run the notebooks and build pipelines.  

Here's how to run the interactive notebooks:

### Install the prerequisites

1. Make sure you have Python 3.7 installed, installing it if necessary
    - If you have a favorite package manager, use that
    - if not, [python.org](https://www.python.org/downloads/) has binaries for many platforms
2. Make sure you have `git` installed, installing it if necessary
    - If you have a favorite package manager, use that
    - if not, [git-scm.com](https://git-scm.com/downloads) has binaries for many platforms (you won't need a GUI)
3. Install [pipenv](https://docs.pipenv.org/en/latest/)
    - on a Mac, the easiest way is probably `brew install pipenv`
    - on a Fedora Linux machine, the easiest way is probably `dnf install pipenv`
    - on Windows, if you have Python installed already, the easiest way is probably [to use `pip`](https://docs.pipenv.org/en/latest/install/#pragmatic-installation-of-pipenv)  

### Install the notebooks and dependencies

1.  Clone this repository:  `git clone https://github.com/willb/ml-workflows-notebook/`
    - tip:  if you don't have `git` installed, you can also [download an archive of this repository](https://github.com/willb/ml-workflows-notebook/archive/master.zip)
2.  Change to this repository's directory:  `cd ml-workflows-notebook`
3.  Install the dependencies:  `pipenv install --skip-lock`
4.  Run the notebooks:  `pipenv run jupyter notebook`

# Running the lab on an OpenShift cluster:

Alternatively, to run our lab on an OpenShift cluster (including on your personal computer with minishift or `oc cluster`), run the following command:

`oc create -f https://raw.githubusercontent.com/willb/ml-workflows-for-developers/summit2019/resources.yaml`

Our slides from presenting the lab at Red Hat Summit 2019 [are online](./ml-workflows-for-developers.pdf).

Contact willb@redhat.com with any questions!
