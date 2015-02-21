
Fedora 21 Server x86_64 "Minimal Install"

## Description ##

Fedora 21 Server was installed using [Fedora-Server-netinst-x86_64-21.iso][1]
with SHA256 hash:
```
56af126a50c227d779a200b414f68ea7bcf58e21c8035500cd21ba164f85b9b4
```

The size of the disk image `virtual_size: 138` in `metadata.json` indicates
128 GiB converted to GB and rounded up to 1GB.

Single 128 GiB disk storage is partitioned into:
  * The 1st partition partition is 1024 MiB ext4 mounted as `/boot`.
  * The 2nd partition is a single LVM physical volume for `fedora-server`
    volume group split into:
    * `fedora-server-root` volume is 100 GiB ext4 mounted as `/`;
    * `fedora-server-swap` volume is 1024 MiB for swap space;
    * unallocated space with 25+ GiB.

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
  ```
  VAGRANT_HOST_IP=1.1.1.1
  ssh-copy-id -i vagrant.key     vagrant@${VAGRANT_HOST_IP}
  scp            vagrant.key     vagrant@${VAGRANT_HOST_IP}:.ssh/id_rsa
  scp            vagrant.key.pub vagrant@${VAGRANT_HOST_IP}:.ssh/id_rsa.pub
  ```
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

* v1.1.1:
  * Remove NFS configuration (it does not work with zero-configured
    `nfs-utils` package) for synced folders. Only `rsync` type can
    be used.

* v1.1.0:
  * Resize virtual disk image from 256 GiB to 128 GiB and
    set `virtual_size` in `metadata.json` file to 238 GB.
  * Install `nfs-utils` package with dependencies.

* v1.0.2:
  Value `config.vm.box` in `Vagrantfile` was fixed to contain this box name.

* v1.0.1:
  Increase `virtual_size` in `metadata.json` file to 275 (which is
  256 GiB converted to GB and rounded up to 1G).

* v1.0.0:
  The first (initial) release.

# footer #

[1]: http://download.fedoraproject.org/pub/fedora/linux/releases/21/Server/x86_64/iso/Fedora-Server-netinst-x86_64-21.iso
[2]: https://github.com/mitchellh/vagrant/tree/master/keys
[3]: http://docs.vagrantup.com/v2/synced-folders/

