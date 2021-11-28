#!/bin/bash

# Install VSG via `python3 -m pip install vsg`

STYLE=style/my_style.yaml

for FILE in src/*.vhdl; do
    vsg -f $FILE -c $STYLE --fix
done