#!/bin/bash
#
# Legal Stuff:
#
# This file is free software; you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the Free Software
# Foundation; version 3.
#
# This file is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
# details.
#
# You should have received a copy of the GNU Lesser General Public License along with
# this program; if not, see <https://www.gnu.org/licenses/lgpl-3.0.txt>

## Flutter Yaru icons build script
##
## usage: ./build-icons.sh

# Build icon font

if ! command -v yaru_icon_font_generator >/dev/null
then
    echo
    read -p "yaru_icon_font_generator is required, do you want to install it right now? (y/n)" -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        dart pub global activate -sgit https://github.com/Jupi007/icon_font_generator.git --git-ref yaru
    fi
fi

yaru_icon_font_generator
