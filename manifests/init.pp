#
# = Class: figaro::profiles::ansiblemaster
#
# == Summary
#
# Installs openshift in an BYO (bring-your-own) configuration on a list of hosts.
# The host list is generated with information from puppetdb.
#
#
# == Details
#
# We assume each host has a custom fact (by default "role"), which is queried.
# Depending on the set role the host is configured as openshift master or
# minion.
#
# We also allow multiple clusters of openshift to be installed in parallel. To
# tell different clusters apart we assume each host has a custom fact with a
# cluster name (or "identifier", if you wish). All hosts with the same fact value
# are put in a single openshift cluster.
#
#
# == Requirements
#
# You need to give the ansible user sudo rights ON THE NODE MACHINES (not on
# the master). This is the default setup of the ansible module, so please don't
# change it.
#
# You need the "nvogel-ansible" module, and puppetdbquery. Both are given as
# dependency in a local Puppetfile for use with librarian-puppet.
#
#
class openshiftinstaller (
  $playbooksrc        = 'https://github.com/openshift/openshift-ansible.git',
  $playbookversion    = 'HEAD',
  $playbookbasedir    = '/etc/ansible',

  # for collecting from puppet db
  $role_fact          = 'role',
  $master_role        = 'openshift-master',
  $minion_role        = 'openshift-minion',
  $cluster_name_fact  = 'openshift_cluster_name',
  # for determining the deployment type of openshift
  $deployment_type    = 'origin',
  $additional_repos   = [],

  # required parameter(s)
  $registry_url,
) {

  validate_re($deployment_type, '^(origin|enterprise)$',
    "openshiftinstaller - Wrong value for \$deployment_type '$deployment_type'. Must be in (origin|enterprise)")
  validate_array($additional_repos)

  # default config is "master", you have to configure nodes explicitly
  include ansible
  include ansible::playbooks
  Class['::ansible::playbooks'] -> Class['openshiftinstaller']

  $inventory_basedir = "${::ansible::playbooks::location}/inventory"

  file { $inventory_basedir:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 755,
  }

  $masters_clusters = query_facts(
    "$role_fact=\"$master_role\"",
    [ "$cluster_name_fact" ])

  $nodes_clusters = query_facts(
    "$role_fact=\"$minion_role\"",
    [ "$cluster_name_fact" ])

  $invfiles = {}

  # this is again black inline template magic. we should enable the future
  # parser for this, or write a custom function (but then we run into the
  # environment problems ...)
  $discard_me = inline_template('<%

    @masters_clusters.each { |nodename, nodefacts|
      cluster_name = nodefacts[@cluster_name_fact]
      @invfiles[cluster_name] ||= {}
      cluster = @invfiles[cluster_name]
      cluster["masters"] ||= []
      cluster["masters"] << nodename
    }

    @nodes_clusters.each { |nodename, nodefacts|
      cluster_name = nodefacts[@cluster_name_fact]
      # we only create clusters which have masters :)
      # no idea if this is actually useful, but lets just be sure.
      continue unless @invfiles.has_key? cluster_name
      # lets go on.
      cluster = @invfiles[cluster_name]
      cluster["nodes"] ||= []
      cluster["nodes"] << nodename
    }

  %>')

  # finally, let's create it ;)
  create_resources('openshiftinstaller::invfile',
                    $invfiles,
                    { "basedir" => $inventory_basedir })

}
