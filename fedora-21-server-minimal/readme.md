
## Creation steps ##

## Change log ##

* v1.2.0:
  * Resize virtual disk image from 256 GiB to 128 GiB.
  * Install `nfs-utils` package with dependencies to support
    Vagrant [synced folders][1] based on NFS.

* v1.0.2:
  Value `config.vm.box` in `Vagrantfile` was fixed to contain this box name.

* v1.0.1:
  Increase `virtual_size` in `metadata.json` file to 275 (which is 256 GiB converted to GB and rounded up to 1G).

* v1.0.0:
  The first (initial) release.

# footer #

[1]: http://docs.vagrantup.com/v2/synced-folders/
