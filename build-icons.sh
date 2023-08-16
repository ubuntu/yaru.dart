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

if ! command -v icon_font_generator >/dev/null
then
    echo  -e "\nPlease install icon_font_generator (see README.md)\n"
    exit 1
fi

dart pub global run icon_font_generator:generator
