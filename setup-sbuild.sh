#!/bin/bash
set -eu

# References
# https://wiki.ubuntu.com/SimpleSbuild
# https://groups.google.com/g/linux.debian.bugs.dist/c/2AstXL3gofg

sudo apt install -y sbuild debhelper ubuntu-dev-tools piuparts
sudo usermod -a -G sbuild "$USER"

mkdir -p $HOME/ubuntu/scratch
if ! grep "/home/$USER/ubuntu/scratch" /etc/schroot/sbuild/fstab; then
  echo "/home/$USER/ubuntu/scratch  /scratch          none  rw,bind  0  0" | sudo tee -a /etc/schroot/sbuild/fstab
fi

if [ ! -f ~/.sbuildrc ]; then
  cat > ~/.sbuildrc <<'EOF' 
# Name to use as override in .changes files for the Maintainer: field
# (mandatory, no default!).
$maintainer_name='Hiroaki Nakamura <hnakamur@gmail.com>';

# Default distribution to build.
$distribution = "jammy";
# Build arch-all by default.
$build_arch_all = 1;

# When to purge the build directory afterwards; possible values are "never",
# "successful", and "always".  "always" is the default. It can be helpful
# to preserve failing builds for debugging purposes.  Switch these comments
# if you want to preserve even successful builds, and then use
# "schroot -e --all-sessions" to clean them up manually.
$purge_build_directory = 'successful';
$purge_session = 'successful';
$purge_build_deps = 'successful';
# $purge_build_directory = 'never';
# $purge_session = 'never';
# $purge_build_deps = 'never';

# Directory for writing build logs to
$log_dir=$ENV{HOME}."/ubuntu/logs";

$environment_filter = [
                        '^AR$',
                        '^ARFLAGS$',
                        '^AS$',
                        '^AWK$',
                        '^CC$',
                        '^CFLAGS$',
                        '^CPP$',
                        '^CPPFLAGS$',
                        '^CXX$',
                        '^CXXFLAGS$',
                        '^DEB_BUILD_OPTIONS$',
                        '^DEB_BUILD_PROFILES$',
                        '^DEB_VENDOR$',
                        '^DPKG_ADMINDIR$',
                        '^DPKG_DATADIR$',
                        '^DPKG_GENSYMBOLS_CHECK_LEVEL$',
                        '^DPKG_ORIGINS_DIR$',
                        '^DPKG_ROOT$',
                        '^FC$',
                        '^FFLAGS$',
                        '^GCJFLAGS$',
                        '^LANG$',
                        '^LC_ADDRESS$',
                        '^LC_ALL$',
                        '^LC_COLLATE$',
                        '^LC_CTYPE$',
                        '^LC_IDENTIFICATION$',
                        '^LC_MEASUREMENT$',
                        '^LC_MESSAGES$',
                        '^LC_MONETARY$',
                        '^LC_NAME$',
                        '^LC_NUMERIC$',
                        '^LC_PAPER$',
                        '^LC_TELEPHONE$',
                        '^LC_TIME$',
                        '^LD$',
                        '^LDFLAGS$',
                        '^LD_LIBRARY_PATH$',
                        '^LEX$',
                        '^M2C$',
                        '^MAKE$',
                        '^MAKEFLAGS$',
                        '^OBJC$',
                        '^OBJCFLAGS$',
                        '^OBJCXX$',
                        '^OBJCXXFLAGS$',
                        '^PC$',
                        '^RANLIB$',
                        '^SOURCE_DATE_EPOCH$',
                        '^TERM$',
                        '^V$',
                        '^YACC$'
                      ];

# don't remove this, Perl needs it:
1;
EOF
fi

mkdir -p $HOME/ubuntu/{build,logs}

if [ ! -f ~/.mk-sbuild.rc ]; then
  cat > ~/.mk-sbuild.rc <<'EOF'
SCHROOT_CONF_SUFFIX="source-root-users=root,sbuild,admin
source-root-groups=root,sbuild,admin
preserve-environment=true"
# you will want to undo the below for stable releases, read `man mk-sbuild` for details
# during the development cycle, these pockets are not used, but will contain important
# updates after each release of Ubuntu
SKIP_UPDATES="1"
SKIP_PROPOSED="1"
# if you have e.g. apt-cacher-ng around
# DEBOOTSTRAP_PROXY=http://127.0.0.1:3142/
EOF
fi

sg sbuild

./sbuild-create-schroot.sh jammy
