#!/bin/bash


set -x

JUPYTER_PROGRAM_ARGS="$JUPYTER_PROGRAM_ARGS $NOTEBOOK_ARGS"

if [ x"$JUPYTER_MASTER_FILES" != x"" ]; then
    if [ x"$JUPYTER_WORKSPACE_NAME" != x"" ]; then
        JUPYTER_WORKSPACE_PATH=/opt/app-root/src/$JUPYTER_WORKSPACE_NAME
        setup-volume.sh $JUPYTER_MASTER_FILES $JUPYTER_WORKSPACE_PATH
    fi
fi

JUPYTER_ENABLE_LAB=`echo "$JUPYTER_ENABLE_LAB" | tr '[A-Z]' '[a-z]'`

if [[ "$JUPYTER_ENABLE_LAB" =~ ^(true|yes|y|1)$ ]]; then
    JUPYTER_PROGRAM_ARGS="$JUPYTER_PROGRAM_ARGS --NotebookApp.default_url=/lab"
else
    if [ x"$JUPYTER_WORKSPACE_NAME" != x"" ]; then
        JUPYTER_PROGRAM_ARGS="$JUPYTER_PROGRAM_ARGS --NotebookApp.default_url=/tree/$JUPYTER_WORKSPACE_NAME"
    fi
fi

if [[ "$JUPYTER_PROGRAM_ARGS $@" != *"--ip="* ]]; then
    JUPYTER_PROGRAM_ARGS="--ip=0.0.0.0 $JUPYTER_PROGRAM_ARGS"
fi

export JUPYTER_PRELOAD_REPOS=https://github.com/willb/openshift-ml-workflows-workshop.git

if [ -n "${JUPYTER_PRELOAD_REPOS}" ]; then
    for repo in `echo ${JUPYTER_PRELOAD_REPOS} | tr ',' ' '`; do
        echo "Checking if repository $repo exists locally"
        REPO_DIR=$(basename ${repo})
        if [ -d "${REPO_DIR}" ]; then
            pushd ${REPO_DIR}
            GIT_SSL_NO_VERIFY=true git pull --ff-only
            popd
        else
            GIT_SSL_NO_VERIFY=true git clone ${repo} ${REPO_DIR}
        fi
        
        if [[ x"$JUPYTER_PRELOAD_BRANCH" != "x" ]]; then
            export JUPYTER_PRELOAD_BRANCH=rhte2019
        fi

        pushd ${REPO_DIR}
        git checkout ${JUPYTER_PRELOAD_BRANCH}
        
        if [[ x"$JUPYTER_PRELOAD_CONTEXT" != "x" ]]; then
            export JUPYTER_PRELOAD_CONTEXT=source
        fi
        
        if [ -d ${JUPYTER_PRELOAD_CONTEXT}]; then
            git filter-branch --subdirectory-filter ${JUPYTER_PRELOAD_CONTEXT}
        fi
        
        popd
    done
fi

set -eo pipefail

if [[ "$NOTEBOOK_ARGS $@" != *"--ip="* ]]; then
  NOTEBOOK_ARGS="--ip=0.0.0.0 $NOTEBOOK_ARGS"
fi

JUPYTER_PROGRAM_ARGS="$JUPYTER_PROGRAM_ARGS --config=/home/nbuser/.jupyter/jupyter_notebook_config.py"

if [ ! -z "$JUPYTER_ENABLE_LAB" ]; then
    JUPYTER_PROGRAM="jupyter labhub"
else
    JUPYTER_PROGRAM="jupyterhub-singleuser"
fi

exec /usr/local/bin/start.sh $JUPYTER_PROGRAM $JUPYTER_PROGRAM_ARGS "$@"
