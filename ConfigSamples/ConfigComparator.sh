#!/bin/sh

# This file is part of Smoothie (http://smoothieware.org/). The motion control part is heavily based on Grbl (https://github.com/simen/grbl) with additions from Sungeun K. Jeon (https://github.com/chamnit/grbl)
# Smoothie is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# Smoothie is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with Smoothie. If not, see <http://www.gnu.org/licenses/>.

# ----------------------------
# Functions
# ----------------------------

# ANSI color helpers
setColor () {
	echo -n "\033[$1m"
}
resetColor () {
	echo -n "\033[0m"
}

# Online help
printHelp () {

	echo	"\n" \
		"From time to time, new settings are added to Smoothie's config file. If you're\n" \
		"maintaining your own fork, you can use this script to verify that your config\n" \
		"isn't missing anything new.\n"

	setColor "1;37"
	echo	"USAGE: ./ConfigComparator.sh upstreamConfigFile yourConfigFile" \
		"\n"
	resetColor

}

# Find keywords (first token in line) that are present in the first file, but not the second.
# Lines must begin with an alpha char, so we don't accidentally register options mentioned in comments as
# though they were valid options that will be parsed by Smoothie.
checkMismatches () {

	# Extract only keywords (line must start with alpha char, so we ignore whitespace, comments, =, etc.)
	KEYWORDS=`cat "$1" |awk {'print $1'} |uniq |grep '^[[:alpha:]].*'`

	# See which keywords are in FILE1, but not FILE2.
	mismatches=0
	for i in $KEYWORDS; do

		cmd="eval grep '^$i\.*' $2"
		out=`$cmd`
		if [ -z "$out" ]; then
			echo "Keyword '$i' not found in $2."
			mismatches=$((mismatches+1))
		fi
	
	done

	echo "Found $mismatches mismatches."

}



# ----------------------------
# Program Entry
# ----------------------------

setColor "1;36"
echo "Smoothie Config Comparator by 626Pilot"
setColor "1;37"
echo "--------------------------------------"
echo ""
resetColor

FILE1="$1"
FILE2="$2"

if [ ! -e "$FILE1" ]; then
	echo "File '$FILE1' not found."
	printHelp
	exit 1
fi

if [ ! -e "$FILE2" ]; then
	echo "File '$FILE2' not found."
	printHelp
	exit 1
fi

setColor "1;32"
echo "Checking for new options:"
setColor "0;32"

checkMismatches $FILE1 $FILE2

echo ""

setColor "1;31"
echo "Checking for POTENTIALLY obsolete options. Anything that's unique to your branch can be ignored."
echo "The rest may be old options that have been removed!"
setColor "0;31"

checkMismatches $FILE2 $FILE1

resetColor

echo
echo "Please note that commented lines (beginning with #) are IGNORED! This means"
echo "that, for example, 'panel.contrast' will be found, but '#panel.contrast'"
echo "will not."
echo
