# lunarg-packaging-scripts
Misc scripts used in building specific vulkan packages for LunarG.  Call scripts
with `-h` or `-?` args for usage help.

- **`.pbuilderrc`**

    A symlink to this should go in your home directory, to make the
    `cowbuild-\*` scripts work properly

- **`.aptly.conf-template`**

    This file should be copied, modified, and placed in `~/.aptly.conf`, to make
    the `aptly-\*` scripts work properly

- **`.common-lunarg.sh`**

    Common variables used by all the following scripts.

- **`build-package-from-commitid`**

    This script checks out the commit given in the `-c` argument into the branch
    specified by `-t`, merges debian packaging from the `debian-unstable`
    branch, constructs an appropriate package version string from the existing
    changelog and any release tags and other optional arguments, and uses all of
    the above to kick off a cowbuilder build of the packages in question.
    
    **_Usage:_** &nbsp; `build-package-from-commitid -c COMMIT_ID [-n] [-b BUILD_NUMBER] [-t TEMP_BRANCH] [-d DEBIAN_PACKAGING_VERSION] [-s BUILD_SUFFIX]`

    - `-c COMMIT_ID` _REQUIRED_: This is the git commit ID you want to build
      the package from. It can be in the form of a SHA hash, tag name, branch
      name, etc...
    - `-i`: Interactive. Before before any git commits, and before the version
      string is embedded into the changelog, interactively allow the user to
      modify comments or the package version string.
    - `-n`: No Build.  Perform all of the steps up until the last changelog
      commit and build, then exit, leaving the temp branch with a modified (but
      not commited) changelog.
    - `-b BUILD_NUMBER`: This allows you to specify a build number, if the
      same package commit is built multiple times.  _Default: `1`_
    - `-t TEMP_BRANCH`: This is the git branch upon which all of the checkout,
      merging, and commits done by this script will be performed.  _Default:
      `"build"`_
    - `-s BUILD_SUFFIX`: String appended to the end of the version string,
      immediately prior to BUILD_VERSION. Often useful when building the same
      package for different purposes.  e.g. could be "~ci" for a CI build,
      or "test" for a testing build.  _Default: `"~autobuild"`_
    - `d DEBIAN_PACKAGING_VERSION`: This normally won't be used, but allows you
      to specify a debian packaging version other than `1` if that's needed.
      _Default: `1`_

    The script makes the following assumptions:

    - It assumes it's invoked from inside an updated/current git clone of the
      repository which the package is built from
    - It assumes there is a "debian-unstable" branch in the git repository which
      contains the latest, working debian packaging from the last release build.
    - It assumes the repository is tagged upstream using some sort of versioning
      scheme, and that the previous release build in the repository was tagged
      in the following form:

      `<source package name>_<upstream version>-<debian version>_<build version>`
    - It assumes that the latest `debian/changelog` entry corresponds to (and
      has the same version string as) the previously mentioned release build tag.

- **`cowbuild-package-lunarg`**

    **_Usage:_** &nbsp; `cowbuild-package-lunarg [-b BUILD_VERSION] [-s BUILD_SUFFIX] [-t]`

    - `-b BUILD_VERSION` Number which will be appended to the end of the package
      version string. _Default: `"1"`_
    - `-s BUILD_SUFFIX`: String appended to the end of the version string,
      immediately prior to BUILD_VERSION. Often useful when building the same
      package for different purposes.  e.g. could be "~ci" for a CI build,
      or "~lunarg" for a release build.  _Default: `""`_
    - `-t` indicates that the script should create an annotated tag marking this
      as a release build.
    
    The script makes the following hard-coded assumptions:

    - It must be executed inside the target package source directory.
    - It expects the source to be in a git working directory, and be in a clean state.
    - The debian/changelog file must have an `UNRELEASED` entry on top, with a
      clean numeric package version string (i.e. `1.2.3-1`, not
      `1.2.3-1xenial2`), and must be checked into `HEAD` in the git repository
      (the script calls `git reset --hard` before modifying the changelog and
      building).
    - it assumes there exists an updated `$DISTRO-amd64` pbuilder chroot for
      each distro named in `.common-lunarg.sh`
    - It assumes the default pbuilder/cowbuilder chroot location: i.e.
      `/var/cache/pbuilder`
    - It depends on the `~.pbuilderrc` config file in this repository existing
      (can be a symlink) in the user's home directory.

- **`cowbuild-update-chroots`**

    Simple script to update the chroots mentioned above.  This should be run
    before the first build of the day, or any time the dependent repositories
    are updated.

- **`cowbuild-delete-build-results`**

    This script is used to periodically clean out the pbuilder results
    directories, after packages have been uploaded or stored elsewhere. Requires
    confirmation, as can be dangerous.

    *WARNING:* This script is a very blunt instrument. It simply removes all the
    files from the `results` directory, with no consideration to what's there.

- **`aptly-add-pbuilder-lunarg`**

    This script takes no arguments.  It simply looks for any `*.changes` files
    under the pbuilder directory (`/var/cache/pbuilder`), and adds them to the
    appropriate aptly base repos

- **`aptly-snapshot-lunarg`**

    **_Usage:_** &nbsp; `aptly-snapshot-lunarg <prefix>`

    This script takes a uniquely named immutable snapshot of all the appropriate
    aptly repos.  The snapshot name must be the only argument to this script,
    and must be uniquely named.

- **`aptly-publish-lunarg`**

    **_Usage:_** &nbsp; `aptly-publish-lunarg [-p <prefix>] [-s <snapshot_prefix>]`

    This script publishes either a set of LunarG snapshots, or the base LunarG
    repos, depending on the arguments it's passed.  The default `<prefix>` is
    "testing", and so the script publishes the base LunarG repositories to
    `${rootDir}/vulkan/testing` (where `${rootDir}` is defined in
    `~/.aptly.conf` by default.  The publish prefix can be overwritten with the
    `-p` option, and publishing a snapshot may be accomplished with the `-s`
    option.  Usually, these two options are used together to publish a release
    snapshot.
