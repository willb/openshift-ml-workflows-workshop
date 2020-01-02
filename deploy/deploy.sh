#!/bin/bash

export RHPDS_DOMAIN=${RHPDS_DOMAIN:-open.redhat.com}
export RHPDS_USER_COUNT=${RHPDS_USER_COUNT:-75}

echo "RHPDS_DOMAIN is set to $RHPDS_DOMAIN -- this may explain some"
echo "errors if RHPDS has changed to use a different domain"

echo

echo "RHPDS_USER_COUNT is set to $RHPDS_USER_COUNT -- is this what you want?"

echo "(press control-C now or hold your peace!)"

sleep 5

if [ x$RHPDS_GUID == 'x' ]; then
    echo "You need to set RHPDS_GUID"
    exit 1
fi

if [ x$RHPDS_USER == 'x' ]; then
    echo "You need to set RHPDS_USER, e.g., to yourkrb-redhat.com"
    exit 1
fi

ansible-playbook -i bastion.${RHPDS_GUID}.${RHPDS_DOMAIN}, -u ${RHPDS_USER} configs/ocp-workloads/ocp-workload.yml -e"rgw_endpoint_url=https://s3.foo.com:8000" -e"ansible_user=${RHPDS_USER}" -e"ocp_username=opentlc-mgr" -e"ocp_workload=ocp4-workload-rhte-analytics_data_ocp_infra" -e"silent=True" -e"guid=$RHPDS_GUID" -e"ACTION=create" -e"num_users=${RHPDS_USER_COUNT}" && ansible-playbook -i bastion.${RHPDS_GUID}.${RHPDS_DOMAIN}, -u ${RHPDS_USER} configs/ocp-workloads/ocp-workload.yml -e"rgw_endpoint_url=https://s3.foo.com:8000"  -e"ansible_user=${RHPDS_USER}" -e"ocp_username=opentlc-mgr" -e"ocp_workload=ocp4-workload-rhte-analytics_data_ocp_workshop_s2020" -e"silent=True" -e"guid=$RHPDS_GUID" -e"ACTION=create" -e"num_users=${RHPDS_USER_COUNT}" && ansible-playbook -i bastion.${RHPDS_GUID}.${RHPDS_DOMAIN}, -u ${RHPDS_USER} configs/ocp-workloads/ocp-workload.yml -e"rgw_endpoint_url=https://s3.foo.com:8000" -e"ansible_user=${RHPDS_USER}" -e"ocp_username=opentlc-mgr" -e"ocp_workload=ocp4-workload-ml-workflows-workshop" -e"silent=True" -e"guid=$RHPDS_GUID" -e"ACTION=create" -e"num_users=${RHPDS_USER_COUNT}"