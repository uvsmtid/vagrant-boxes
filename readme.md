This repo contains files with configuration and documentation for Vagrant
[base boxes][1].

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

*   Shut down virtual machine and copy its storage image as `box.img`
    under (example) [box directory][4].

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

*   Run [package_box.sh][7] from the root of the repo.

*   Upload generated `tar` file to a server with publicly accessible URL.

*   Publish description at [atlas.hashicorp.com][8].

*   Update (example) [change log][3].

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

