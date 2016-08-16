#########################################################################
# File Name: makescope.sh
# Author: tintinr
# mail: tintinr@gmail.com
# Created Time: 日  8/ 4 10:51:38 2013
#########################################################################
#!/bin/bash

make_find_name_arg()
{
    file_prefix=$1
    declare -a file_types=("${!2}")

    for each_file in ${file_types[@]}
    do
        if [ -n "$find_arg"  ]
        then
            single_find_arg="-o "
        else
            single_find_arg=""
        fi
        single_find_arg+="-name \""
        single_find_arg+=$file_prefix
        single_find_arg+=$each_file
        single_find_arg+="\" "
        find_arg+=$single_find_arg
    done

}

make_find_arg()
{
    # 文件类型，如*.c
    local FILETYPES=("c" "cc" "cpp" "h" 
    "mk" 'sh' 
    "java" 
    "md"
    "pl"
    "hpp"
    "MD"
    "in"
    "txt"
    "s" 
    "S")
    # 文件名，如Makefile

    local FILENAMES=("Makefile" "makefile")
    make_find_name_arg "*." FILETYPES[@]
    make_find_name_arg "" FILENAMES[@]

}

build_ecsope_file()
{
    find_arg=""
    make_find_arg
    #echo "find" $src_path " " $find_arg
    find_str="find "
    find_str+=$src_path
    find_str+=" "
    find_str+=$find_arg
    eval $find_str > cscope.files

}

usage()
{
    echo "Usage: makescope src_path project_name"
    echo "==src_path: source root path"
    echo "==project_name: cscope db will be stored in ~/cscope/project_name/ dir"

}


main()
{
    current_dir=$(pwd)
    mkdir -p $project_path
    cd $project_path

    build_ecsope_file
    cscope -Rbkq -i cscope.files

    cd $current_dir

}

if [ $# -ne 2  ]
then
    usage
    return -1
fi

src_path=$1
project_path=~/.cscope/projects/$2
main
