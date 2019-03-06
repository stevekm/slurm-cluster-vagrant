SHELL:=/bin/bash

setup:
	vagrant up && \
	vagrant ssh controller -- -t 'sudo cp -f /etc/munge/munge.key /vagrant/' && \
	vagrant ssh server -- -t 'sudo cp /vagrant/munge.key /etc/munge/' && \
	vagrant ssh server -- -t 'sudo chown munge /etc/munge/munge.key' && \
	rm -f munge.key

start:
	vagrant ssh controller -- -t 'sudo /etc/init.d/munge start' && \
	vagrant ssh server -- -t 'sudo /etc/init.d/munge start' && \
	vagrant ssh controller -- -t 'sudo slurmctld -D &' && \
	vagrant ssh controller -- -t 'sudo slurmctld start' && \
	vagrant ssh server -- -t 'sudo /etc/init.d/slurmd start'

stop:
	vagrant halt --force controller
	vagrant halt --force server

remove:
	vagrant destroy controller
	vagrant destroy server
# -L /vagrant/controller.log
