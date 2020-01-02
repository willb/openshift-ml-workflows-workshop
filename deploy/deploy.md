# Deployment instructions

## For RHPDS

**Note**:  This workshop is _not yet available_ in the RHPDS catalog.  Stay tuned for an easier way to do things!

To run this lab in RHPDS, first provision an OpenShift 4 workshop from the RHDPS catalog.  Requesting a Let's Encrypt certificate will make your life easier.  Once the environment is up and running, you'll get an email from RHPDS with the system GUID, bastion hostname, and so on.  The rest of these steps assume you're in this directory of a checkout of this repo.

1.  Log in to the bastion host, following the instructions in the email.
1.  Add an `authorized_keys` file.  If you have a GitHub account with an ssh key, you can do it like this:
  - `mkdir -p .ssh`
  - `chmod 700 .ssh`
  - `curl https://github.com/${YOUR_GITHUB_HANDLE}.keys >> .ssh/authorized_keys` where `${YOUR_GITHUB_HANDLE}` is your GitHub username
1.  Log out from the bastion host.
1. `export RHPDS_GUID=city-1234`, where `city-1234` is your RHPDS cluster GUID;
1. `export RHPDS_USER=yourkrb-redhat.com`, where `yourkrb` is your Kerberos ID;
1. `export RHPDS_USER_COUNT=5` (or more if you're running an actual workshop)
1. `./deploy.sh`

`deploy.sh` will attempt to infer the right domain name for your RHPDS cluster based on your cluster GUID and your ssh known hosts file.  If this fails, you'll need to explicitly set the RHPDS domain name with `export RHPDS_DOMAIN=example.opentlc.com`, `export RHPDS_DOMAIN=open.redhat.com`, or something else as appropriate, depending on which domain RHPDS is using (see the email).

Allow ninety minutes or so for the workshop roles to deploy.  Once they're up, you can go through the workshop at your own pace!

## For other OpenShift 4 environments

In theory, the Ansible roles applied by `deploy.sh` should work on other OpenShift clusters, but we haven't tested and documented it yet.

## For OpenShift 3

To run an older version of the workshop on an OpenShift cluster (including on your personal computer with minishift or `oc cluster`), run the following command:

`oc create -f https://raw.githubusercontent.com/willb/openshift-ml-workflows-workshop/develop/deploy/templates/resources.yaml`

