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

if ! command -v fantasticon_flutter >/dev/null
then
    echo  -e "\nPlease install fantasticon_flutter (see README.md)\n"
    exit 1
fi

fantasticon_flutter --from=icons --class-name=YaruIcons --out-font=assets/ui_icons.ttf --out-flutter=lib/src/yaru_icons.dart --package=yaru_icons --naming-strategy=snake

# Build icon library overview

ICON_LIST_DOC_FILE='./doc/icon_list.md'

cat >$ICON_LIST_DOC_FILE <<EOL
<!-- GENERATED FILE - DO NOT MODIFY BY HAND -->

# Yaru_icons library overview

Icon preview | Icon name | Usage
------------ | --------- | -----
EOL

cd icons
ICONS_PATH_LIST=( $(find . -name "*.svg" | sort  | sed 's/.\///') )
cd ..

for i in ${ICONS_PATH_LIST[@]}
do
    ICON_PATH="../icons/${i}"
    ICON_NAME=$(echo "$i" | sed 's/\/_.svg//' | sed 's/-/_/g' | sed 's/\//_/g' | sed 's/.svg//')
    
    echo $"![${ICON_NAME}](${ICON_PATH}) | ${ICON_NAME//_/ } | \`YaruIcons.${ICON_NAME}\`" >> $ICON_LIST_DOC_FILE
done
