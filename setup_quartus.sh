#!/usr/bin/env bash

# This script should be used to setup environment variables for
# different versions of Quartus Prime Pro that are installed on the host machine
# If you have version of Quartus installed other than 24.1 or 26.1 you can add a case statement
# pointing ALTERA_ROOT to the path Quartus is installed at. Furthermore, if Quartus is not installed at $HOME
# then you should modify the path accordingly.

case "$1" in
24.1)
  ALTERA_ROOT="$HOME/intelFPGA_pro/24.1"
  ;;
26.1)
  ALTERA_ROOT="$HOME/altera_pro/26.1"
  ;;
*)
  echo "Usage: source ${BASH_SOURCE[0]} {24.1|26.1}"
  return 1
  ;;
esac

# Remove existing Quartus paths.

PATH=$(echo "$PATH" | tr ':' '\n' | grep -vE '/(intelFPGA_pro|altera_pro)/.*/quartus' | paste -sd ':')

export ALTERA_ROOT=$ALTERA_ROOT
export QUARTUS_ROOTDIR="$ALTERA_ROOT/quartus"
export QSYS_ROOTDIR="$ALTERA_ROOT/qsys/bin"

export PATH="$QUARTUS_ROOTDIR/bin:$QSYS_ROOTDIR/bin:$PATH"
export PATH="$ALTERA_ROOT/syscon/bin/:$PATH"

# Print out new environment configurations
echo "Using Quartus Prime Pro $1"
echo "QUARTUS_ROOTDIR=$QUARTUS_ROOTDIR"
echo "QSYS_ROOTDIR=$QSYS_ROOTDIR"
