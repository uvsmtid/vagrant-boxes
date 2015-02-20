
Fedora 21 Server x86_64 "Minimal Install"

## Description ##

Fedora 21 Server was installed using [netinstall x86_64 ISO image][1] with
SHA256 hash `56af126a50c227d779a200b414f68ea7bcf58e21c8035500cd21ba164f85b9b4`.

Single 128 GiB disk storage is partitioned into:
* The 1st partition partition is 1024 MiB ext4 mounted as `/boot`.
* The 2nd partition is a single LVM physical volume for `fedora-server`
  volume group split into:
  * `fedora-server-root` volume is 100 GiB ext4 mounted as `/`;
  * `fedora-server-swap` volume is 1024 MiB ext4 volume for swap space;
  * unallocated space with 25+ GiB.

## Vagrant customization ##

* Create `vagrant` user with password `vagrant`.
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
* Install `nfs-utils` package (with dependencies) to avoid
  these commands to fail:
  ```
  /etc/init.d/rpcbind restart; /etc/init.d/nfs restart
  ```

## Change log ##

* v1.2.0:
  * Resize virtual disk image from 256 GiB to 128 GiB.
  * Install `nfs-utils` package with dependencies to support
    Vagrant [synced folders][3] based on NFS.

* v1.0.2:
  Value `config.vm.box` in `Vagrantfile` was fixed to contain this box name.

* v1.0.1:
  Increase `virtual_size` in `metadata.json` file to 275 (which is 256 GiB converted to GB and rounded up to 1G).

* v1.0.0:
  The first (initial) release.

# footer #

[1]: http://download.fedoraproject.org/pub/fedora/linux/releases/21/Server/x86_64/iso/Fedora-Server-netinst-x86_64-21.iso
[2]: https://github.com/mitchellh/vagrant/tree/master/keys
[3]: http://docs.vagrantup.com/v2/synced-folders/

