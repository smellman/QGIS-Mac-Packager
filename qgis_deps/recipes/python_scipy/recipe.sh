#!/bin/bash

DESC_python_scipy="python scipy"

# version of your package
# keep in SYNC with proj receipt
VERSION_python_scipy=1.19.1

# dependencies of this recipe
DEPS_python_scipy=(python python_packages_pre python_numpy openblas)

# url of the package
URL_python_scipy=https://github.com/scipy/scipy/archive/v${VERSION_python_scipy}.tar.gz

# md5 of the package
MD5_python_scipy=df258dde5dace1d43d152ecfbb812088

# default build path
BUILD_python_scipy=$BUILD_PATH/python_scipy/$(get_directory $URL_python_scipy)

# default recipe path
RECIPE_python_scipy=$RECIPES_PATH/python_scipy

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_scipy() {
  cd $BUILD_python_scipy

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_scipy() {
  exit 1;

  # If lib is newer than the sourcecode skip build
  if python_package_installed scipy; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_scipy() {
  try rsync -a $BUILD_python_scipy/ $BUILD_PATH/python_scipy/build-$ARCH/
  try cd $BUILD_PATH/python_scipy/build-$ARCH
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}

# function called after all the compile have been done
function postbuild_python_scipy() {
   if ! python_package_installed scipy; then
      error "Missing python package scipy"
   fi
}

# function to append information to config file
function add_config_info_python_scipy() {
  append_to_config_file "# python_scipy-${VERSION_python_scipy}: ${DESC_python_scipy}"
  append_to_config_file "export VERSION_python_scipy=${VERSION_python_scipy}"
}