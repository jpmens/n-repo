#!/bin/sh

set -e

NODE_RUNNER_HOME=/etc/ansible
ANSIBLE_DIST=/etc/ansible/ansible-dist	# Full path to dir containing Ansible code

function bailout() {
	echo "node-runner: $*" >&2
	exit 2
}

git=/usr/bin/git


if [ -d "$NODE_RUNNER_HOME" ]; then
	source $NODE_RUNNER_HOME/node-runner.cf
else
	echo "$0: \$NODE_RUNNER_HOME is not a directory." >&2
	exit 1
fi

if [ -d "$ANSIBLE_DIST" ]; then
	
	cd $ANSIBLE_DIST
	source hacking/env-setup  > /dev/null
else
	echo "$0: \$ANSIBLE_DIST is not a directory." >&2
	exit 1
fi

[ -x $git ] || bailout "Can't find $git or is not executable"

cd $NODE_RUNNER_HOME
$git pull --quiet

# Re-read our config, as it may have changed after pull

source $NODE_RUNNER_HOME/node-runner.cf

# todo: maybe check md5sum of node-runner.sh before and after pull to
# decide if we want to re-exec node-runner.sh :) 


# Run the playbook

ansible-playbook ${playbook}
