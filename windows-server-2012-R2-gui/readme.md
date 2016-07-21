
Windows Server 2012 R2 x86_64 GUI libvirt

NOTE: It is not published Vagrant box.

This document only provides steps
how the box was created and how it can be used.

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

TODO:
Should hostname be fixed to `vagrant` manually or Vagrant
may take care of hosname itself automatically?

## Operation ##

After creation of the box and before using it,
some (prerequisites)[#prerequisites] has to be installed.

It was noticed that somehow (possibly due to using the official Vagrant
package with more than one provider pre-installed) `libvirt` is may not be
recognized as default provider (as usually on Linux).
So, some commands require explicit `--provider libvirt` option
(but, inconveniently, not all uniformally can take it and fail instead):

```
vagrant up --provider libvirt
vagrant destroy
```

In addition to this, if host uses proxied Internet, `winrm` communication
fails due to obvious bug (because `winrm` should not use `http_proxy` and
`https_proxy` environment variables for non-HTTP(S) communication) -
see [details here][5].

Disable environments selectively for just `vagrant` commands:

```
(unset http_proxy https_proxy ; vagrant up --provider libvirt)
(unset http_proxy https_proxy ; vagrant destroy)
```

## Prerequisites ##

The steps below differentiate:

*   **Standard** Vagrant package provided in Fedora 24 repositories.

*   **Official** Vagrant package provided at: https://www.vagrantup.com/downloads.html

### `winrm` ###

This VM uses its own custumized `Vagrantfile` which depends on
specific virtual hardware settings to match pre-installed Windows drivers.

Because VM runs Windows, it requires `winrm` packaged together with Vagrant.
Standard Fedora 24 Vagrant RPM does not include `winrm` and there is
no known way to install it in addition - for example, it is possible
to install `winrm` using the following command, but the Fedora 24 Vagrant
still does not see the installation.

It is possible to make this command succeed either for regular user
or for `root` - the gem `winrm` will be installed:

```
# Adding non-https URL is only required in proxied environment:
gem sources --remove  https://rubygems.org/
gem sources --add      http://rubygems.org/

gem install -r winrm
```

However, Vagrant will stil not be able to find `winrm` package:

```
vagrant up
/usr/share/vagrant/plugins/communicators/winrm/shell.rb:9:in `require': cannot load such file -- winrm (LoadError)
...
```

The only known tested solution is to use official Vagrant package.
This package is said to be for CentOS. However, it also worked on Fedora 24:

```
wget --no-check-certificate http://releases.hashicorp.com/vagrant/1.8.5/vagrant_1.8.5_x86_64.rpm
dnf install vagrant_1.8.5_x86_64.rpm
```

Now, this package cannot find `vagrant-libvirt` plugin (installed from
standard Fedora 24 repository).

### `vagrant-libvirt` ###

Normally, it can be easliy installed from standard Fedora 24 repository.
However, when official Vagrant package is used (to provide `winrm` dependency),
there is no known way to make it see `vagrant-libvirt`.

Instead, install `vagrant-libvirt` through `vagrant` command itself.
In order to succeed, it requires pre-installed `libvirt-devel` package.
In addition to that, if the access to Internet is proxied and it has
issues with https, there is no known way to tell `vagrant` to use
non-https URL like it is possible with `gem` command - therefore,
use (temporarily) direct Internet access.

```
unset http_proxy https_proxy
sudo dnf install libvirt-devel
vagrant plugin install libvirt
```

## Change log ##

*   v1.0.0:
    The first (initial) release.

---

[1]: https://www.vagrantup.com/docs/boxes/base.html#windows-boxes
[2]: https://github.com/mitchellh/vagrant/tree/master/keys
[3]: http://docs.vagrantup.com/v2/synced-folders/
[4]: https://blogs.technet.microsoft.com/rmilne/2014/05/30/how-to-hide-server-manager-at-logon/
[5]: https://github.com/WinRb/WinRM/issues/208#issuecomment-234143484

