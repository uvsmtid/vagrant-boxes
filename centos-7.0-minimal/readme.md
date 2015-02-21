
CentOS 7.0 x86_64 "Minimal Install"

* Box: [uvsmtid/centos-7.0-minimal][4]

## Description ##

CentOS 7.0 was installed using [CentOS-7.0-1406-x86_64-NetInstall.iso][1]
with SHA256 hash:
```
df6dfdd25ebf443ca3375188d0b4b7f92f4153dc910b17bccc886bd54a7b7c86
```

Example URL for YUM downloads:
```
http://mirror.nus.edu.sg/centos/7.0.1406/os/x86_64
```

The size of the disk image `virtual_size: 138` in `metadata.json` indicates
128 GiB converted to GB and rounded up to 1GB.

Single 128 GiB disk storage is partitioned into:
  * The 1st partition partition is ~ 1024 MB ext4 mounted as `/boot`.
  * The 2nd partition is a single LVM physical volume for `centos`
    volume group split into:
    * `centos-root` volume is ~ 100 GB ext4 mounted as `/`;
    * `centos-swap` volume is ~ 1024 MB for swap space;
  * And unallocated space (no partition) with ~ 21+ GB.

Option to avoid installing latest updates and use release-time packages
were used.

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
* Change hostname `/etc/hostname` to `vagrant`.
* Disable `UseDNS` in SSH server (`/etc/ssh/sshd_config`).
* Install `rsync` package (with dependencies).

## Change log ##

* v1.0.0:
  The first (initial) release.

# footer #

Link to this file: https://gitlab.com/uvsmtid/vagrant-boxes/blob/master/centos-7.0-minimal/readme.md

[1]: http://mirror.nus.edu.sg/centos/7.0.1406/isos/x86_64/CentOS-7.0-1406-x86_64-NetInstall.iso
[2]: https://github.com/mitchellh/vagrant/tree/master/keys
[3]: http://docs.vagrantup.com/v2/synced-folders/
[4]: https://atlas.hashicorp.com/uvsmtid/boxes/centos-7.0-minimal

