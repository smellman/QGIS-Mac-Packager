#!/bin/bash

DESC_python_shapely="Manipulation and analysis of geometric objects in the Cartesian plane."

# version of your package
VERSION_python_shapely=1.7.0

# dependencies of this recipe
DEPS_python_shapely=(python geos python_packages_pre)

# url of the package
URL_python_shapely=

# md5 of the package
MD5_python_shapely=

# default build path
BUILD_python_shapely=$BUILD_PATH/python_shapely/v${VERSION_python_shapely}

# default recipe path
RECIPE_python_shapely=$RECIPES_PATH/python_shapely

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_shapely() {
  mkdir -p $BUILD_python_shapely
  cd $BUILD_python_shapely

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_shapely() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed shapely; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_shapely() {
  try cd $BUILD_python_shapely
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib; GEOS_CONFIG=$STAGE_PATH/bin/geos-config; try $PIP_NO_BINARY shapely==${VERSION_python_shapely}

  pop_env
}

# function called after all the compile have been done
function postbuild_python_shapely() {
   if ! python_package_installed shapely; then
      error "Missing python package shapely"
   fi
}

# function to append information to config file
function add_config_info_python_shapely() {
  append_to_config_file "# python_shapely-${VERSION_python_shapely}: ${DESC_python_shapely}"
  append_to_config_file "export VERSION_python_shapely=${VERSION_python_shapely}"
}