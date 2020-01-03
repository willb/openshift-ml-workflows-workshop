FROM registry.access.redhat.com/ubi8/python-36

USER root

## taken/adapted from jupyter dockerfiles
# Not essential, but wise to set the lang
# Note: Users with other languages should set this in their derivative image
ENV LANGUAGE=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    PYTHONIOENCODING=UTF-8 \
    NB_USER=nbuser \
    NB_UID=1011 \
    NB_PYTHON_VER=3.7 \
    SPARK_HOME=/opt/spark 

LABEL io.k8s.description="PySpark Jupyter Notebook." \
      io.k8s.display-name="PySpark Jupyter Notebook." \
      io.openshift.expose-services="8888:http"


RUN echo 'PS1="\u@\h:\w\\$ \[$(tput sgr0)\]"' >> /root/.bashrc \
    && chgrp root /etc/passwd \
    && chgrp -R root /opt \
    && chmod -R ug+rwx /opt \
    && useradd -m -s /bin/bash -N -u $NB_UID $NB_USER \
    && usermod -g root $NB_USER \
    && yum install -y curl wget bzip2 git


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
RUN pip3 install -r /home/requirements.txt \
    && pip3 install jupyter jupyterhub notebook \ 
    && jupyter nbextension enable --py widgetsnbextension --sys-prefix \
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
    && fix-permissions.sh /notebooks \
    && fix-permissions.sh /notebooks/data \
    && fix-permissions.sh $HOME \
    && rm -f /notebooks/Dockerfile /notebooks/*.sh

ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN fix-permissions.sh /home/$NB_USER

ADD start.sh /usr/local/bin/start.sh
ADD start-singleuser.sh /usr/local/bin/start-singleuser.sh

WORKDIR /notebooks
CMD ["/bin/bash", "start.sh"]

USER $NB_USER