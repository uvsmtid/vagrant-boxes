
CentOS 5.5 x86_64 "Minimal Install"

## Description ##

CentOS 5.5 was installed using [CentOS-5.5-x86_64-netinstall.iso][1]
with SHA256 hash:
```
298a219be14eb75157f173de25542510eec0682b6f33e67e84a2756ef7fa83ba
```

The URL for YUM repository:
  * _Web site name_: `archive.kernel.org`
  * _CentOS directory_: `centos-vault/5.5/os/x86_64`
In order to run graphical installation, select `Cirrus` for Video
configuration of VM (`virt-manager`).

The size of the disk image `virtual_size: 138` in `metadata.json` indicates
128 GiB converted to GB and rounded up to 1GB.

Single 128 GiB disk storage is partitioned into:
  * The 1st partition partition is 1027 MiB (1..131) ext3 mounted as `/boot`.
  * The 2nd partition is a single LVM physical volume (132..16709) for
    `centos` volume group split into:
    * `centos-root` volume is 100 GiB ext3 mounted as `/`;
    * `centos-swap` volume is 1024 MiB for swap space;
    * unallocated space with 25+ GiB.

CentOS 5.5 does not have "Minimal Install" to select. Instead, all package
groups were deselected to keep installation to the bare minimum.

**NOTE**: NFS-based [synced folders][3] are not configured.
Either use `rsync` or disable them:
  * `rsync`
    ```
    config.vm.synced_folder '.', '/vagrant', type: 'rsync'
    ```
  * disable
    ```
    config.vm.synced_folder '.', '/vagrant', disabled: true
    ```

## Vagrant customization ##

* Create `vagrant` user with password `vagrant`, `uid = 1000`, `gid = 1000`.
* Set up [insecure SSH keys][2] for `vagrant` user.
* Set up  password-less `sudo` for `vagrant` user by adding line
  to `/etc/sudoers`:
  ```
  vagrant ALL=(ALL) NOPASSWD:ALL
  ```
* Disable `requiretty` for `sudo` command by adding line
  to `/etc/sudoers`:
  ```
  Defaults !requiretty
  ```
* Set `root` user's password to `vagrant`.
* Change `HOSTNAME` in `/etc/sysconfig/network` to `vagrant`.
* Disable `UseDNS` in SSH server (`/etc/ssh/sshd_config`).
* Install `rsync` package (with dependencies).

## Change log ##

* v1.0.0:
  The first (initial) release.

# footer #

Link to this file: https://gitlab.com/uvsmtid/vagrant-boxes/blob/master/centos-5.5-minimal/readme.md

[1]: http://archive.kernel.org/centos-vault/5.5/isos/x86_64/CentOS-5.5-x86_64-netinstall.iso
[2]: https://github.com/mitchellh/vagrant/tree/master/keys
[3]: http://docs.vagrantup.com/v2/synced-folders/

