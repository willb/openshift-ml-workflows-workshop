#!/bin/bash

export PATH=$CONDA_DIR/bin:$PATH

if [[ "x$JUPYTER_NOTEBOOK_PASSWORD" != "x" ]]; then
    HASH=$(python -c "from notebook.auth import passwd; print(passwd('$JUPYTER_NOTEBOOK_PASSWORD'))")
    echo "c.NotebookApp.password = u'$HASH'" >> /home/$NB_USER/.jupyter/jupyter_notebook_config.py
fi

if [[ -n "$JUPYTER_NOTEBOOK_X_INCLUDE" ]]; then
    curl -O $JUPYTER_NOTEBOOK_X_INCLUDE
fi

if [[ "$JUPYTERLAB" == true ]]; then
	echo "jupyter lab...."
    exec jupyter lab
else
	echo "jupyter notebook...."
	exec jupyter notebook
fi
