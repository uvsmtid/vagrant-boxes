
CentOS 7.1 x86_64 "GNOME Desktop" libvirt

* Box: [uvsmtid/centos-7.1-1503-gnome][4]

## Description ##

CentOS 7.1 was installed using [CentOS-7-x86_64-DVD-1503-01.iso][1]
with SHA256 hash:
```
85bcf62462fb678adc0cec159bf8b39ab5515404bc3828c432f743a1b0b30157
```

Example URL:
```
http://mirror.nus.edu.sg/centos/7/isos/x86_64/CentOS-7-x86_64-DVD-1503-01.iso
```

The size of the disk image `virtual_size: 138` in `metadata.json` indicates
128 GiB converted to GB and rounded up to 1GB.

Single 128 GiB disk storage is partitioned into:

*   The 1st partition partition is ~ 1024 MiB ext4 mounted as `/boot`.

    *   The 2nd partition is a single LVM physical volume for `centos`
        volume group split into:

    *   `centos-root` volume is ~ 100 GiB ext4 mounted as `/`;

    *   `centos-swap` volume is ~ 1024 MiB for swap space;

*   And unallocated space (no partition) with ~ 26+ GiB.

Option to avoid installing latest updates and use release-time packages
were used.

*   Disable `kdump`.

    *   **NOTE**:

        NFS-based [synced folders][3] are not configured.
        Either use `rsync` or disable them:

*   `rsync`

    ```
    config.vm.synced_folder '.', '/vagrant', type: 'rsync'
    ```

*   disable

    ```
    config.vm.synced_folder '.', '/vagrant', disabled: true
    ```

## Vagrant customization ##

*   Create `vagrant` user with password `vagrant`, `uid = 1000`, `gid = 1000`.

*   Set up [insecure SSH keys][2] for `vagrant` user.

*   Set up  password-less `sudo` for `vagrant` user by adding line
    to `/etc/sudoers`:

    ```
    vagrant ALL=(ALL) NOPASSWD:ALL
    ```

*   Disable `requiretty` for `sudo` command by adding line
    to `/etc/sudoers`:

    ```
    Defaults !requiretty
    ```

*   Set `root` user's password to `vagrant`.

*   Change hostname `/etc/hostname` to `vagrant`.

*   Disable `UseDNS` in SSH server (`/etc/ssh/sshd_config`).

*   Install `rsync` package (with dependencies).

## Change log ##

*   v1.0.0:
    The first (initial) release.

# footer #

Link to this file: https://gitlab.com/uvsmtid/vagrant-boxes/blob/master/centos-7.1-1503-gnome/readme.md

[1]: http://mirror.nus.edu.sg/centos/7/isos/x86_64/CentOS-7-x86_64-DVD-1503-01.iso
[2]: https://github.com/mitchellh/vagrant/tree/master/keys
[3]: http://docs.vagrantup.com/v2/synced-folders/
[4]: https://atlas.hashicorp.com/uvsmtid/boxes/centos-7.1-1503-gnome

