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

# footer #

Link to this file: https://gitlab.com/uvsmtid/vagrant-boxes/blob/master/readme.md

[1]: http://docs.vagrantup.com/v2/boxes/base.html