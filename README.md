# lunarg-packaging-scripts
Misc scripts used in building specific vulkan packages for LunarG

- <b>cowbuild-package-lunarg</b>

   This script is executed inside a package source directory.  It expects the source to be held in git, and be in a clean state.  The debian/changelog file must have an "<tt>UNRELEASED</tt>" entry on top, with a clean numeric package version string (i.e. 1.2.3-1, not 1.2.3-1xenial2), and must be checked into HEAD in the git repository (i.e. the script calls <tt>git reset --hard</tt> before modifying the changelog and building).  It makes some other hardcoded assumptions:
   
   - it assumes there exist 4 updated pbuilder chroots named stretch-amd64, stretch-i386, xenial-amd64, and xenial-i386.
   - It assumes a gpg key named "brett@lunarg.com" exists to sign the packages/archive with.
   - It assumes default pbuilder/cowbuilder chroot location: i.e. /var/cache/pbuilder

- <b>cowbuild-update-chroots</b>

   Simple script to update the 4 chroots mentioned above.  This should be run before the first build of the day.

- <b>reprepro-add-lunarg</b>

   This is run in the staging repository.  It simply adds all of the files built by cowbuilder to the staging repository, and signs the Release file.
