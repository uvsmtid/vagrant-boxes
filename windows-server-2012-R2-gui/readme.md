
Windows Server 2012 R2 x86_64 GUI libvirt

NOTE: It is not published Vagrant box.

This document only provides steps how the box was created.

## Description ##

The initial installation was done using
`IR3_SSS_X64FREE_EN-US_DV9.WIN_R2_2012.iso` DVD disk image
with the following `sha256sum`

```
6612b5b1f53e845aacdf96e974bb119a3d9b4dcb5b82e65804ab7e534dc7b4d5
```

The size of the disk image `virtual_size: 108` in `metadata.json` indicates
100 GiB converted to GB and rounded up to 1GB.

Single 100 GiB disk storage was fully given to Windows installer
(without any special steps for custom partitioning).

During the installation process all defaults were selected:

*   Language to install: English (United States)
*   Time and currency format: English (United States)
*   Keyboard or input method: US

The following options were available:
*   1. "Windows Server 2012 R2 Standard Evaluation (Server Core Installation)"
*   2. "Windows Server 2012 R2 Standard Evaluation (Server with GUI)"
*   3. "Windows Server 2012 R2 Datacenter Evaluation (Server Core Installation)"
*   3. "Windows Server 2012 R2 Datacenter Evaluation (Server with GUI)"
Option 2 was selected -
"Windows Server 2012 R2 Standard Evaluation (Server with GUI)".

Since no available Windows installation was present on the virtual machine,
option 2 was selected in the following list:
*   1. "Upgrade: Install Windows and keep files, settings, and applications"
*   2. "Custom: Install Windows only (advanced)" instead of

The entire "Drive 0 Unallocated Space" was used as storage for installation
(which indicated detected size of 100 GB).

## `Vagrantfile` settings ##

TODO: This section has not been updated - it is not applicable to Windows.

*   Enable `rsync` method:

    ```
    config.vm.synced_folder '.', '/vagrant', type: 'rsync'
    ```

*   Disable any syncing:

    ```
    config.vm.synced_folder '.', '/vagrant', disabled: true
    ```

## Vagrant OS customization ##

TODO: This section has not been updated - it is not applicable to Windows.

*   Create `vagrant` user with password `vagrant`, `uid = 1000`, `gid = 1000`.

*   Do not forget to make sure network interface is up on boot.

*   Set up [insecure SSH keys][2] for `vagrant` user.

    *   Private key: https://raw.githubusercontent.com/mitchellh/vagrant/004ea50bf2ae55d563fd9da23cb2d6ec6cd447e4/keys/vagrant

        Download and set permissions:

        ```
        ll /home/vagrant/.ssh/id_rsa
        -rw-------. 1 vagrant vagrant 1675 May 26 01:24 /home/vagrant/.ssh/id_rsa
        ```

    *   Public key: https://raw.githubusercontent.com/mitchellh/vagrant/004ea50bf2ae55d563fd9da23cb2d6ec6cd447e4/keys/vagrant.pub

        Download and set permissions:

        ```
        ll /home/vagrant/.ssh/id_rsa.pub
        -rw-r--r--. 1 vagrant vagrant 411 May 26 01:24 /home/vagrant/.ssh/id_rsa.pub
        ```

    *   Do not forget to add the key into `authorized_keys` (use `ssh-copy-id`).

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

---

[2]: https://github.com/mitchellh/vagrant/tree/master/keys
[3]: http://docs.vagrantup.com/v2/synced-folders/

