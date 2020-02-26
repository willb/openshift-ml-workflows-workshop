#!/bin/bash

export RHPDS_USER_COUNT=${RHPDS_USER_COUNT:-75}

if [ x$RHPDS_GUID == 'x' ]; then
    echo "You need to set RHPDS_GUID"
    exit 1
fi

if [ x$RHPDS_USER == 'x' ]; then
    echo "You need to set RHPDS_USER, e.g., to yourkrb-redhat.com"
    exit 1
fi

export BASTION=$(cat ~/.ssh/known_hosts | grep $RHPDS_GUID | cut -f1 -d\\  | cut -f1 -d,)

if [ x$BASTION == 'x' ]; then
    echo "Warning:  I couldn't find your RHPDS bastion host in your ssh history"
    export RHPDS_DOMAIN=${RHPDS_DOMAIN:-open.redhat.com}
else
    export RHPDS_DOMAIN=${RHPDS_DOMAIN:-$(echo $BASTION | cut -f3- -d.)}
fi

echo "RHPDS_DOMAIN is set to $RHPDS_DOMAIN -- this may explain some"
echo "errors if RHPDS has changed to use a different domain"

echo

echo "RHPDS_USER_COUNT is set to $RHPDS_USER_COUNT -- is this what you want?"

echo "(press control-C now or hold your peace!)"

if [[ ! -d agnosticd/ansible ]]; then
    echo "You need an agnosticd checkout in the current working directory."
    echo "Either change to a directory that has one before running this script,"
    echo "or clone one yourself like this:"
    echo "   git clone https://github.com/redhat-cop/agnosticd -b rhte-2019"
    exit 1
fi

sleep 5

pushd agnosticd/ansible

ansible-playbook -i bastion.${RHPDS_GUID}.${RHPDS_DOMAIN}, -u ${RHPDS_USER} configs/ocp-workloads/ocp-workload.yml -e"rgw_endpoint_url=https://s3.foo.com:8000" -e"ansible_user=${RHPDS_USER}" -e"ocp_username=opentlc-mgr" -e"ocp_workload=ocp4-workload-rhte-analytics_data_ocp_infra" -e"silent=True" -e"guid=$RHPDS_GUID" -e"ACTION=create" -e"num_users=${RHPDS_USER_COUNT}" && ansible-playbook -i bastion.${RHPDS_GUID}.${RHPDS_DOMAIN}, -u ${RHPDS_USER} configs/ocp-workloads/ocp-workload.yml -e"rgw_endpoint_url=https://s3.foo.com:8000"  -e"ansible_user=${RHPDS_USER}" -e"ocp_username=opentlc-mgr" -e"ocp_workload=ocp4-workload-rhte-analytics_data_ocp_workshop_s2020" -e"silent=True" -e"guid=$RHPDS_GUID" -e"ACTION=create" -e"num_users=${RHPDS_USER_COUNT}" && ansible-playbook -i bastion.${RHPDS_GUID}.${RHPDS_DOMAIN}, -u ${RHPDS_USER} configs/ocp-workloads/ocp-workload.yml -e"rgw_endpoint_url=https://s3.foo.com:8000" -e"ansible_user=${RHPDS_USER}" -e"ocp_username=opentlc-mgr" -e"ocp_workload=ocp4-workload-ml-workflows-workshop" -e"silent=True" -e"guid=$RHPDS_GUID" -e"ACTION=create" -e"num_users=${RHPDS_USER_COUNT}"

popd