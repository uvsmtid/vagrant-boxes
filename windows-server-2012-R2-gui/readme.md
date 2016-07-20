
Windows Server 2012 R2 x86_64 GUI libvirt

NOTE: It is not published Vagrant box.

This document only provides steps how the box was created.

## Prerequisites ##

TODO: The steps provided in this section didn't succeed.

This VM uses its own custumized `Vagrantfile` which depends on
packaging of `winrm` together with Vagrant (and specific virtual hardware).

Instead of using default OS package repository, the installed
Vagrant package was from official Vagrant web site:

```
wget --no-check-certificate http://releases.hashicorp.com/vagrant/1.8.5/vagrant_1.8.5_x86_64.rpm
```

This package is said to be for CentOS. However, it also worked on Fedora 24:

```
dnf install vagrant_1.8.5_x86_64.rpm
```

Because this package cannot find `vagrant-libvirt` plugin,
it has to be installed (but this command failed):

```
vagrant plugin install libvirt
```

It failed due to proxied environment and SSL certificates.

Instad of proper plugin installation, `vagrant-libvirt` was copied
as a hack under required `vagrant` directory:

```
cp -rp /usr/share/vagrant/gems/gems/vagrant-libvirt-0.0.32/lib/vagrant-libvirt /opt/vagrant/embedded/gems/gems/vagrant-1.8.5/test/unit/plugins/providers/
```

This also didn't work.
TODO: Fix running Windows box on linux with `vagrant-libvirt`.

## Description ##

The initial installation was done using
`IR3_SSS_X64FREE_EN-US_DV9.WIN_R2_2012.iso` DVD disk image
with the following `sha256sum`

```
6612b5b1f53e845aacdf96e974bb119a3d9b4dcb5b82e65804ab7e534dc7b4d5
```

TODO: Update the box to use `VirtIO` storage instead of `IDE`.
This likely requires recreation of virtual machine with pre-boot settings
to specify storage type, then reinstallation of Windows from scratch
possibly providing necessary drivers in the process.

TODO: The same steps for `VirtIO` device has to be done for network.

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

As soon as installation was completed, in response to prompt for
administrator password `Vagrant2012!` was used (to pass through
password complexity requirements).

TODO: Update box and change password to trivial `vagrant`.

The following steps were completed in accordance with
[official requirements][1] listed by Vagrant for Windows.

*   Turn off UAC

    *   "Start".
    *   Search for "UAC".
    *   Select "Change User Account Control settings".
    *   "User Account Control Settings" dialogue will be opened.

    Pull the slider to "Never notify".

    In addition to this, UAC has to be disabled through registry.
    Run `regedit` and set the `EnableLUA` registry key under the following
    directory to `0x00000000`:

    ```
    HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system
    ```

    This can be done automatically by executing this command:

    ```
    reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system /v EnableLUA /d 0 /t REG_DWORD /f /reg:64
    ```

*   Disable complex passwords

    *   "Start".
    *   Open "Administrative Tools".
    *   Select "Local Security Policy".
    *   Select "Security Settings" / "Account Policies" / "Password Policy".
    *   Open "Password must meet complexity requirements".
    *   Select "Disabled".

    In addition to this, in the same list:
    *   Open "Maximum password age".
    *   Set "0" ("Password will never expire").

*   Disable "Shutdown Tracker"

    *   "Start".
    *   Search "gpedit.msc" and run it.
    *   Select "Local Computer Policy" / "Administrative Templates" / "System".
    *   Open "Display Shutdown Event Tracker".
    *   Select "Disabled".

    This can also be checked in registry.
    Run `regedit` and check that the `ShutdownReasonOn` registry key under
    the following directory is set to `0x00000000`:

    ```
    HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Reliability
    ```

*   Disable "Server Manager" starting at login (for non-Core)

    Apparently, "for non-Core" means GUI installation version selected above
    (our case).

    *   "Start".
    *   Open "Server Manager".
    *   Select "Manage" on the top bar.
    *   Select "Server Manager Properties" from the drop down menu.
    *   Select "Do not start Server Manager automatically at logon".

    There is also a way to set/check it via registry -
    see [this article][4].

*   Base WinRM Configuration

    Set the WinRM service to auto-start and allow unencrypted basic auth -
    start `cmd` and run the following commands:

    ```
    winrm quickconfig -q
    winrm set winrm/config/winrs @{MaxMemoryPerShellMB="512"}
    winrm set winrm/config @{MaxTimeoutms="1800000"}
    winrm set winrm/config/service @{AllowUnencrypted="true"}
    winrm set winrm/config/service/auth @{Basic="true"}
    sc config WinRM start=auto
    ```

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

[1]: https://www.vagrantup.com/docs/boxes/base.html#windows-boxes
[2]: https://github.com/mitchellh/vagrant/tree/master/keys
[3]: http://docs.vagrantup.com/v2/synced-folders/
[4]: https://blogs.technet.microsoft.com/rmilne/2014/05/30/how-to-hide-server-manager-at-logon/

