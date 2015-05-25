#!/bin/sh

# This script should be run from root of the `vagrant-boxes.git` repository:
#   https://github.com/uvsmtid/vagrant-boxes
#
# For example:
#   ./scripts/package.sh centos-7.0-minimal

set -x
set -e
set -u

# Box name matches directory name.
box_name="${1}"

# File named `package_file_name` is supposed to provide name for the package
# without any suffixes added by `tar` and `gzip`.
# Trim leading and trailing whitespaces.
package_file_name="$(
    cat "${box_name}/package_file_name" | \
    head -n 1 | \
    sed 's/^[[:space:]]*//g' | sed 's/[[:space:]]*$//g'
)"

# Make sure there is not obstructing files starting with package name.
if ls "${package_file_name}"* 1> /dev/null 2> /dev/null
then
    echo "error: there are already files starting as '${package_file_name}': $(ls "${package_file_name}"*)" 1>&2
    exit 1
fi

# Vagrant expects all files in the root of the `tar` archiver (no sub-dirs).
# Archiver `tar` always works with current directory.
cd "${box_name}"

echo "Creating '${package_file_name}'..." 1>&2

# Create empty `tar` archive:
tar -cf "../${package_file_name}.tar" --files-from /dev/null

for file_name in \
    box.img \
    metadata.json \
    readme.md \
    Vagrantfile \
    package_file_name \

do
    # Append file to `tar` archive:
    tar -rf "../${package_file_name}.tar" "${file_name}"
done

# Go back to the parent dir.
cd -

# Compress archive:
gzip "${package_file_name}.tar" 

