#!/bin/bash

rm -f .ycm_extra_conf.py
function HELP {
echo -e "Usage: ${0##*/} \t[-h] [-I INCLUDE_DIR] [-D DEFINITION]\n\
\t\t\t\t[-E EXCLUDE_DIR] PROJECT_ROOT\n"
echo -e "Generate config file for YouCompleteMe\n"
echo -e "Positional arguments:"
echo -e "\tPROJECT_ROOT\tThe root directory of the project\n"
echo -e "Optional arguments:"
echo -e "\t-h\t\tshow this help message and exit"
echo -e "\t-I\t\tadd include directory recursively"
echo -e "\t-E\t\tadd exclude directory. Include directories won't be added if\n\
\t\t\tin this directory"
echo -e "\t-D\t\tadd definition flag"
echo -e "\t-f\t\tforce to generate the config file"
exit 1
}
function contain_prefix() {
local n=$#
local value=${!n}
for ((i=1;i < $#;i++)) {
	RET=$(echo ${value} | grep -b -o ${!i} | \
		awk 'BEGIN {FS=":"}{print $1}')
	if [ ! -z $RET ] && [ $RET -eq 0 ]; then
		echo "y"
		return 0
	fi
}
echo "n"
return 1
}

NUMARGS=$#
if [ $NUMARGS -eq 0 ]; then
	HELP
fi

INCLUDE_DIRS=()
EXCLUDE_DIRS=()
BASE_DIRS=()
SYSTEM_INCLUDE_DIRS=()
DEFINITIONS=()
FORCE=0

OPTIND=1
while getopts :I:E:D:h:f opt; do
	case "$opt" in
		h)
			HELP
			;;
		f)
			FORCE=1
			;;
		I)
			echo "Add include directory '$OPTARG'"
			BASE_DIRS+=($(readlink -f $OPTARG))
			;;
		E)
			echo "Add exclude directory '$OPTARG'"
			EXCLUDE_DIRS+=($(readlink -f $OPTARG))
			;;
		D)
			echo "Add definition '$OPTARG'"
			DEFINITIONS+=($OPTARG)
			;;
		\?)
			HELP
			;;
	esac
done
shift $((OPTIND-1))

if [ -z "$1" ]; then
	HELP
fi

TARGET_DIR=$1

if [ -f "$TARGET_DIR/.ycm_extra_conf.py" ];then
	echo "The YCM config file already exists"
	if [ $FORCE -eq 1 ];then
		echo "Overwrite the YCM config file"
	else
		exit -1
	fi
fi

BASE_DIRS+=($(readlink -f $TARGET_DIR))

OUTPUT=$(echo | cpp -Wp,-v 2>&1)
OUTPUT=${OUTPUT##*#include <...> search starts here:}
OUTPUT=${OUTPUT%End of search list.*}

SYSTEM_INCLUDE_DIRS=($(echo "$OUTPUT" | tr " " "\n" | sort | uniq))

for dir in ${BASE_DIRS[@]}
do
	INCLUDE_DIRS+=($dir)
	HEADERS=$(find $dir -iname "*.h" -o -iname "*.hpp")
	for header in $HEADERS
	do
		PREFIX=${header%/*.*}
		SUFFIX=${PREFIX#$dir}
		while [ ! -z $SUFFIX ]
		do
			INCLUDE_DIRS+=($dir$SUFFIX)
			SUFFIX=${SUFFIX%/*}
		done
	done
done
INCLUDE_DIRS=($(echo "${INCLUDE_DIRS[@]}" | tr " " "\n" | sort | uniq))

SED_STR=""
for definition in ${DEFINITIONS[@]}
do
	SED_STR="$SED_STR\n    '-D$definition',"
done
for dir in ${INCLUDE_DIRS[@]}
do
	if [ $(contain_prefix "${EXCLUDE_DIRS[@]}" $dir) == "n" ];then
		SED_STR="$SED_STR\n    '-I',\n    '${dir//\//\\\/}',"
	fi
done
for dir in ${SYSTEM_INCLUDE_DIRS[@]}
do
	SED_STR="$SED_STR\n    '-isystem',\n    '${dir//\//\\\/}',"
done

cat "$(dirname $0)/ycm_extra_conf.py.template" | sed "s/#ADD FLAGS HERE:/$SED_STR/g" \
	> "$TARGET_DIR/.ycm_extra_conf.py"
