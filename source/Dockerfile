# (ideally) minimal pyspark/jupyter notebook

FROM centos:7

USER root

## taken/adapted from jupyter dockerfiles
# Not essential, but wise to set the lang
# Note: Users with other languages should set this in their derivative image
ENV LANGUAGE=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    PYTHONIOENCODING=UTF-8 \
    CONDA_DIR=/opt/conda \
    NB_USER=nbuser \
    NB_UID=1011 \
    NB_PYTHON_VER=3.7 \
    PATH=$CONDA_DIR/bin:$PATH \
    SPARK_HOME=/opt/spark \
    MINICONDA_VERSION=4.7.10 \
    MINICONDA_HASH=1c945f2b3335c7b2b15130b1b2dc5cf4

LABEL io.k8s.description="PySpark Jupyter Notebook." \
      io.k8s.display-name="PySpark Jupyter Notebook." \
      io.openshift.expose-services="8888:http"


RUN echo 'PS1="\u@\h:\w\\$ \[$(tput sgr0)\]"' >> /root/.bashrc \
    && chgrp root /etc/passwd \
    && chgrp -R root /opt \
    && chmod -R ug+rwx /opt \
    && useradd -m -s /bin/bash -N -u $NB_UID $NB_USER \
    && usermod -g root $NB_USER \
    && yum install -y curl wget tree bzip2 git


USER $NB_USER


# Python binary and source dependencies and Development tools

# Make the default PWD somewhere that the user can write. This is
# useful when connecting with 'oc run' and starting a 'spark-shell',
# which will likely try to create files and directories in PWD and
# error out if it cannot. 
# 
ADD fix-permissions.sh /usr/local/bin/fix-permissions.sh
ADD requirements.txt /home/requirements.txt

ENV HOME /home/$NB_USER
RUN mkdir $HOME/.jupyter \
    && cd /tmp \
    && curl -s -o Miniconda3.sh https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh \
    && echo ${MINICONDA_HASH} Miniconda3.sh | md5sum -c - \
    && bash Miniconda3.sh -b -p $CONDA_DIR \
    && rm Miniconda3.sh \
    && export PATH=$CONDA_DIR/bin:$PATH \
    && $CONDA_DIR/bin/conda config --system --append channels conda-forge  \
    && $CONDA_DIR/bin/conda config --system --set auto_update_conda false  \
    && $CONDA_DIR/bin/conda config --system --set show_channel_urls true  \
    && $CONDA_DIR/bin/conda update --all --quiet --yes  \
    && $CONDA_DIR/bin/conda install --yes --quiet jupyter jupyterhub 'notebook==6.0.0' $(while read requirement; do echo \'$requirement\'; done < /home/requirements.txt) \
    && $CONDA_DIR/bin/conda clean -tipsy \
    && $CONDA_DIR/bin/conda install --yes cloudpickle \
    && jupyter nbextension enable --py widgetsnbextension --sys-prefix \
    && fix-permissions.sh $CONDA_DIR \
    && fix-permissions.sh $HOME \
    && yum clean all -y
     

USER root

# IPython
EXPOSE 8888
WORKDIR $HOME

RUN mkdir /notebooks

ADD . /notebooks

RUN mkdir -p $HOME/.jupyter \
    && echo "c.NotebookApp.ip = '0.0.0.0'" >> $HOME/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.open_browser = False" >> $HOME/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.notebook_dir = '/notebooks'" >> $HOME/.jupyter/jupyter_notebook_config.py \
    && rm -rf /root/.npm \
    && rm -rf /root/.cache \
    && rm -rf /root/.config \
    && rm -rf /root/.local \
    && rm -rf /root/tmp \
    && fix-permissions.sh /opt \
    && fix-permissions.sh $CONDA_DIR \
    && fix-permissions.sh /notebooks \
    && fix-permissions.sh /notebooks/data \
    && fix-permissions.sh $HOME \
    && rm -f /notebooks/Dockerfile /notebooks/*.sh

ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN export PATH=$CONDA_DIR/bin:$PATH \
    && fix-permissions.sh /home/$NB_USER

ADD start.sh /usr/local/bin/start.sh
ADD start-singleuser.sh /usr/local/bin/start-singleuser.sh

WORKDIR /notebooks
CMD ["/bin/bash", "start.sh"]

USER $NB_USER