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

if ! command -v fantasticon_flutter >/dev/null
then
    echo  -e "\nPlease install fantasticon_flutter (see README.md)\n"
    exit 1
fi

fantasticon_flutter --from=icons --class-name=YaruIcons --out-font=lib/icon_font/ui_icons.ttf --out-flutter=lib/widgets/icons.dart --package=yaru_icons --naming-strategy=snake
