This repo contains files with configuration and documentation for Vagrant
these [base boxes][1]: https://atlas.hashicorp.com/uvsmtid

## Example `Vagrantfile` ##

```ruby
# Example `Vagrantfile`
VAGRANTFILE_API_VERSION = '2'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define 'auto_host_a' do |auto_host_a|
    auto_host_a.vm.box = 'uvsmtid/centos-7.0-minimal'
    auto_host_a.vm.synced_folder '.', '/vagrant', type: 'rsync'
  end
end
```

## Build new version ##

*   Follow (example) [readme][2] to reinstall fresh OS.

*   Shut down virtual machine and make a clone using `virt-manager`.

    This will shrink size of the image (without compression).

*   Copy its storage image as `box.img` under (example) [box directory][4]:

    ```
    sudo cp /var/lib/libvirt/images/centos-7.1-1503-gnome.qcow2 centos-7.1-1503-gnome/box.img
    sudo chown username centos-7.1-1503-gnome/box.img
    ```

*   Make sure (example) [metadata.json][5] reflects correct image size
    in `virtual_size`.

*   Update (example) [package_file_name][6].

    File named `package_file_name` is supposed to provide name for the package
    without any suffixes later added by `tar` and `gzip`. The box version
    number (suffix) is still part of the name, for example:

    ```
    centos-7.1-1503-gnome-1.0.0-box
    ```

    Trim leading and trailing whitespaces.

*   Run [package_box.sh][7] from the root of the repo with the box
    directory name as single argument:

    ```
    scripts/package_box.sh centos-7.1-1503-gnome
    ```

*   Upload generated `tar` file to a server with publicly accessible URL.

*   Publish description at [atlas.hashicorp.com][8].

*   Test box using (example) `Vagrantfile` [file][9].

*   Update (example) [change log][3].

# Using unpublished Vagrant box #

In this section another (unpublished) box is used as an example -
`windows-server-2012-R2-gui`. It cannot be downloaded from public sources,
but it can be reproduced based on [its description][11].

As soon as the box file (archive) is generated, it can be added to Vagrant:

```
vagrant box add --name windows-server-2012-R2-gui windows-server-2012-R2-gui-1.0.0-box.tar.gz
```

NOTE:
Specifically this box requires its own more customized
[`Vagrantfile`][10] to run (because it is Windows). The simples way
is to run Vagrant directly in the [`windows-server-2012-R2-gui`][12] directory
of this Git repository's local clone using the mentioned
`Vagrantfile` directly. The steps to make Vagrant work on Linux host
with Windows guest may also be non-trivial - see the [descriptoin][11].

# footer #

Link to this file: https://gitlab.com/uvsmtid/vagrant-boxes/blob/master/readme.md

[1]: http://docs.vagrantup.com/v2/boxes/base.html
[2]: centos-7.1-1503-gnome/readme.md
[3]: centos-7.1-1503-gnome/readme.md#change-log
[4]: centos-7.1-1503-gnome
[5]: centos-7.1-1503-gnome/metadata.json
[6]: centos-7.1-1503-gnome/package_file_name
[7]: scripts/package_box.sh
[8]: https://atlas.hashicorp.com/boxes/new
[9]: #example-vagrantfile
[10]: /windows-server-2012-R2-gui/Vagrantfile
[11]: /windows-server-2012-R2-gui/readme.md
[12]: /windows-server-2012-R2-gui

