#!/bin/bash
cd __srcdir
git pull

mkdir -p __blddir

cd __blddir
ifdef(`__windows__', cmake --build . -- /maxcpucount:7, time cmake --build . -- -j7)
