# The poor man's RHEL mirror

In this repository I have collected some small scripts to set up a local mirror server for Red Hat Repositories. I called it 'poor man's mirror' because it is only capable of providing basic functionallity and could not compete with Red Hat's [Satellite](https://www.redhat.com/en/technologies/management/satellite) server.

You will find a short description in each script and comments on how to use it. The following sections give you a short overview, too.

***Notice:*** The branches `rhel7` and `rhel8` in this repository contain the current stable version for the respective ditribution major version. To use this project just clone or checkout the branch that matches your distribution. New features and bugfixes will be pushed to both branches in case they are compatible with the respective RHEL version.

To make it easier to find the correkt release version the version numbering was changed. Release versions 7.x.x are releases for RHEL 7 and versions 8.x.x are releases for RHEL 8.

***Request:*** If you find any errors in the scripts please be so kind and file a short report using the issue function here on GitHub. Since English is not my first language, there might be some mistakes in this text. If you find some please report them, too.

## Requirements

To use the poor man's mirror you need at least:

 * A RHEL server with a valid subscription
 * A webserver of your choice serving the mirrored repos to other hosts in your LAN
 * The packages 'reposync' and 'createrepo' installed
 * All other packages needed should be installed via yum dependency resolution

## CONFIG.SAMPLE

An example for the main configuration file. Copy this file or move it to be named CONFIG before edit and adjusting it to your needs. It contains the variables used by the other scripts to configure the mirror server. Here you specify which repos you would like to mirror and where to save the data.

## do_reposync.sh

This is the most important script to create a local Red Hat mirror. It is used to synchronize a RHEL-Repository to a directory on a host in your LAN to build a local mirror server. The server where this script should be used on needs to have a valid subscription for the repository which should be synchronized.

## create_yum_repo.sh

This script creates a YUM-Repository on your host, which could be used to distribute RPM-Packages to other hosts. You could use it to create repos for your own packages or to set up repos for your different stages where you provide the original Red Hat RPMs for each stage.

## rsync_repo.sh

This script is for the use case where you want to provide separated stage repositories in a staging environment with multiple stages like T-, E-, I-, Q- and P-Stage.

You could use `reposync` to sync one or more RHEL repos to each stage repo on your local mirror. But this would cost you a large amount of your bandwith and local disk space. With `rsync_repo.sh` you have to sync the Red Hat repo(s) only once and `rsync` them to the stage repos. The script uses hardlinks to spare your disk space.

## refresh__yum_repo.sh

When you have added some new RPM packages to your repository, you have to refresh the metadata DB to be able to install them on connected hosts. This could be done by this script.

**Notice:** Using this script on a mirrored RHEL repo the updateinfo.xml.gz file will be removed and the errata information will be lost. I use this script only on my own YUM repos.

## Wrapper-Scripts

In my use case I have four different stages (E, I, Q and P). I use the following wrapper scripts to update them.

 * update_rhel-e-stage.sh
 * update_rhel-i-stage.sh
 * update_rhel-q-stage.sh
 * update_rhel-p-stage.sh

Each stage is upated with packages from the stage before, e.g. `update_rhel-e-stage.sh` calls `rsync_repo.sh` to `rsync` the packages from the local mirror to the e-stage-repo, `update_rhel-i-stage.sh` does the same but uses the packages from the e-stage-repo to `rsync` them to the i-stage-repo and so on.

In addition I wrote the wrapper `update_multiple_stages.sh` to call multiple wrappers to update my stage repos.

## update_mirror_packages_and_erratas.sh

If you would like to provide Red Hat Errata Information to systems not connected to the internet, you could use this script. You specify the repos on your local  mirror where the errata information should be included. The script runs reposync, update your stage repos and implements the errata information. With that you are ready to go, to install Red Hat Advisory on your hosts.

# Log files

All scripts log their STDOUT to `/var/log/<SCRIPTNAME>.log`. STDERR is not redirected because I run the scripts via cron and would like to get notifed by email if something was written to STDOUT.

# Links and sources

 * [How to create a local mirror of the latest update for Red Hat Enterprise Linux 5, 6, 7 without using Satellite server?](https://access.redhat.com/solutions/23016)
 * [How to use "createrepo" or "reposync" to create a local repository for updates](https://access.redhat.com/solutions/9892)
 * [How to update security Erratas on system which is not connected to internet ?](https://access.redhat.com/solutions/55654)
