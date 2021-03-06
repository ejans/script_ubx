#!/bin/bash

export UBX_ROOT=$HOME/microblx/microblx
export UBX_MODULES=$HOME/microblx/install/lib/ubx
export CMAKE_PREFIX_PATH=$HOME/microblx/install/share/ubx/cmake

SOURCE_PATH=$HOME/microblx/
INSTALL_PATH=$HOME/microblx/install/

pkgs=(std_triggers std_random kdl_types)

####
## Start Install Script
################################################################

##
# Functions
###
set_colors()
{
  red='[0;31m';    lred='[1;31m'
  green='[0;32m';  lgreen='[1;32m'
  yellow='[0;33m'; lyellow='[1;33m'
  blue='[0;34m';   lblue='[1;34m'
  purple='[0;35m'; lpurple='[1;35m'
  cyan='[0;36m';   lcyan='[1;36m'
  grey='[0;37m';   lgrey='[1;37m'
  white='[0;38m';  lwhite='[1;38m'
  std='[m'
}

# Hardcoded so far, It should be a pkg as another one
install_microblx()
{
  echo "${lred}Installing Microblx framework${std}"
  mkdir -p $SOURCE_PATH
  mkdir -p $INSTALL_PATH
  cd $SOURCE_PATH
  git clone git://github.com/haianos/microblx.git
  cd microblx
  git checkout dev
  source $UBX_ROOT/env.sh
  make
  cd $SOURCE_PATH
}

install_pkg()
{
  CURR_PWD=`pwd`
  
  if test -d "$1"; then
    cd $1
    git fetch
  else
    git clone $2/$1 $1
  fi

  cd $1

  if ! test x"$3" = x; then
    if git branch | grep $3; then
      git checkout $3
      git pull
    else
      git checkout $3
    fi
  fi
#   git submodule init && git submodule update

   #make
#    source env.sh
#     make
#     cd ..
  mkdir build && cd build
  cmake "-DCMAKE_INSTALL_PREFIX=${INSTALL_PATH}" ..
  make
  make install
  cd $CURR_PWD
}

##
# Calls
#####
set_colors
install_microblx
# for ((index=0; index<${#pkgs[@]} ; index++ ))
# do
#       echo ${pkgs[$index]}
# done
for ((index=0; index<${#pkgs[@]} ; index++ ))
do
      echo "${lred}Installing ${pkgs[$index]} pkg${std}"
      install_pkg "microblx_${pkgs[index]}" git://github.com/haianos
done
