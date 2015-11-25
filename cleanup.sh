#!/bin/bash
find -name \*|grep -E '*\.(dbg|bak|ppu|o|compiled)'|xargs rm 
find -name \* -type d|grep -E '/lib'|grep -v '/lib/'|xargs rmdir
rm -f MPS/mps
