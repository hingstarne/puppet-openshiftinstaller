# openshiftinstaller class for Puppet

## Summary

This class will use ansible (using the nvogel/ansible module) to install openshift v3 clusters in a network (using the official RedHat openshift installer playbook). The puppet db must run on this host, currently.


## Setup

For using this class you must have ...

* a central node which functions as ansible master
* several nodes which should be openshift masters or minions
  * the designated openshift nodes must have two facts configured:
    * one fact to indicate which role they have (OS master or minion)
    * another fact to incdicate the cluster they belong to (a simple name is all right)

## Example

Let's assume the PuppetDB is running on host `central`. The hosts `os11`, `os12`, `os01`, `os02` are designated openshift nodes, where os1x and os0x should have the same cluster.

All four openshift hosts have the facts `role` and `openshift_cluster_name` configured. `role` is either `openshift-master` or `openshift-minion`.

Given that you would call the module like this:

    # these are also by pure chance the default values ;)

    class { 'openshiftinstaller':
        query_fact          => 'role',
        master_value        => 'openshift-master',
        minion_value        => 'openshift-minion',
        cluster_name_fact   => 'openshift_cluster_name',

        # the only REQUIRED parameter so far
        registry_url        => 'some://url',
    }

It would then ...

* query all nodes and their `$query_fact` (`role` in this case) and `$cluster_name_fact` (`openshift_cluster_name` in this case) using the puppetdb
* screen the `role` fact for the given master- and minion values
* sort the remaining hosts using the `openshift_cluster_name` fact
* create an ansible inventory file under `/etc/ansible/openshift_inventories`
* clone the ansible installation playbook to `/etc/ansible/openshift_playbook`
* execute the ansible installation playbook one time for each cluster with the cluster's inventory file


## Good to know

* The module will only create clusters for which a master is found
* The module will only create the cluster ONCE. If that creation fails it is not done a second time on the next puppet run. A playbook re-run is triggered by a change (or delete) of the cluster inventory file (either manually or because it changed of added / removed hosts)
* The module will install a dynamic fact called `osi_puppetb_running`, which can be `yes` or `no`. If it is anything other than `yes` the installer will not run.
* The fact is currently checking the puppetdb on `http://localhost:8080/v3`, which is the reason that the PuppetDB must run on the same host. This will most probably be changed in the near future.

