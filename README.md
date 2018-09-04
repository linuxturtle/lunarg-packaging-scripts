# lunarg-packaging-scripts
Misc scripts used in building specific vulkan packages for LunarG.  Call scripts with `-h` or `-?` args for usage help.

- <b>`.pbuilderrc`</b>

    This should go in your home directory, to make the `cowbuild-\*` scripts work properly

- <b>`.aptly.conf-template`</b>

    This should be modified, and placed in `~/.aptly.conf`, to make the `aptly-\*` scripts work properly

- <b>`.common-lunarg.sh`</b>

    Common variables used by all the following scripts.

- <b>`cowbuild-package-lunarg`</b>

    This script is executed inside a package source directory.  It expects the source to be held in git, and be in a clean state.  The debian/changelog file must have an `UNRELEASED` entry on top, with a clean numeric package version string (i.e. `1.2.3-1`, not `1.2.3-1xenial2`), and must be checked into `HEAD` in the git repository (the script calls `git reset --hard` before modifying the changelog and building).  It makes some other hardcoded assumptions:

    - it assumes there exists an updated `$DISTRO-amd64` pbuilder chroot for each distro named in `.common-lunarg.sh`
    - It assumes the default pbuilder/cowbuilder chroot location: i.e. `/var/cache/pbuilder`
    - It depends on the `~.pbuilderrc` config file in this repository being present in the user's home directory

- <b>`cowbuild-update-chroots`</b>

    Simple script to update the chroots mentioned above.  This should be run before the first build of the day, or any time the dependent repositories are updated.

- <b>`aptly-add-pbuilder-lunarg`</b>

    This script looks for any `*.changes` files in the pbuilder directory (`/var/cache/pbuilder`), and adds them to the appropriate aptly repos

- <b>`aptly-snapshot-lunarg`</b>

    This script takes a uniquely named immutable snapshot of all the appropriate aptly repos.

- <b>`aptly-publish-lunarg`</b>

    This script publishes either a snapshot, or the base repo into the "rootDir" defined in `~/.aptly.conf`
