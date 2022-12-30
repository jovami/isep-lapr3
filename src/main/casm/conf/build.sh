#!/bin/sh


DIR="iniparser"
LIB="libiniparser.a"

cd "$(dirname "$0")/${DIR}" || git submodule init || exit 1

echo "Making INIPARSER..."
make

echo "Symlinking stuff..."
ln -fsr "${LIB}" ..
ln -fsrt .. src/*.h
