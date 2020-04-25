#!/bin/bash

SQLITE_DIR=sqlite-autoconf-3310100
SQLITE_URL=https://www.sqlite.org/2020/${SQLITE_DIR}.tar.gz

INSTALL_DIR=${HOME}/usr
SRC_DIR=${INSTALL_DIR}/src

echo "### prefix=${INSTALL_DIR} ###"
echo "### Ctrl-C to abort ###"
echo ""
sleep 2

if [ ! -d ${SRC_DIR} ]; then
  mkdir -p ${SRC_DIR}
fi

cd ${SRC_DIR}

if [ ! -f /usr/bin/gcc ]; then
  echo "### install gcc. ###"
  sudo apt install -y build-essential 
fi

echo "### download sqlite3 source package. ###"

if [ ! -f ${SQLITE_DIR}.tar.gz ]; then
  wget ${SQLITE_URL}
fi
if [ ! -d ${SQLITE_DIR} ]; then
  tar xf ${SQLITE_DIR}.tar.gz
fi

cd ${SQLITE_DIR}

if [ -f Makefile ]; then
  echo "### ERROR: Makefile found. ###"
  echo "### if you want to retry configure ###"
  echo "# make distclean"
else
  echo "### configure ###"
  ./configure --enable-fts5 --prefix=${INSTALL_DIR}
  echo "### make ###"
  make
  echo "### make done. ###"
fi

echo ""
echo "### if you want to install sqlte3 into ${INSTALL_DIR} ###"
echo "# cd ${SRC_DIR}/${SQLITE_DIR}"
echo "# make install"
echo ""
echo "### if you want to copy sqlite3.c ###"
echo "# cp ${SRC_DIR}/${SQLITE_DIR}/sqlite3.c DIR/"
echo ""
