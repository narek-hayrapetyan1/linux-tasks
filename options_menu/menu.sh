#!/bin/bash

read -p "Please enter a directory path: " dir_path

if [ -d "$dir_path" ];
then
        abs_path=$(realpath "$dir_path")
else
        echo "The path entered is not a valid directory."
        exit 1
fi

list_files(){
    read -p "Add a extension filter if needed press Enter for skip: " filter
    
    if [[ -n "$filter" && ! "$filter" =~ ^\..+ ]]; 
    then
        echo "Error: Invalid file extension format. Example: .txt or .log"
        return 1
    fi
    
    if [ -n "$filter" ]
    then
        df -h /
        echo ""
        echo "Directory listing---------------------------------------------------------------"
        echo ""
        ls -lhR "$abs_path"/*"$filter"
    else
        df -h /
        echo ""
        echo "Directory listing---------------------------------------------------------------"
        echo ""
        ls -lhR "$abs_path"
    fi
}

sort_by_size() {
    read -p "Add a extension filter if needed press Enter for skip: " filter
    
    if [[ -n "$filter" && ! "$filter" =~ ^\..+ ]]; 
    then
        echo "Error: Invalid file extension format. Example: .txt or .log"
        return 1
    fi    
    if [ -n "$filter" ]

    then
        ls -Shl "$abs_path"/*"$filter"
    else
        ls -Shl "$abs_path"
    fi
}

delete_files() {
    read -p "Enter size limit in Mb for deleting: " user_size

    if ! [[ "$user_size" =~ ^[0-9]+$ ]];
    then
    echo "Error: Size must be a positive integer."
    return 1
    fi

    read -p "Add a extension filter if needed press Enter for skip: " filter
    
    if [[ -n "$filter" && ! "$filter" =~ ^\..+ ]]; 
    then
        echo "Error: Invalid file extension format. Example: .txt or .log"
        return 1
    fi

    if [ -n "$filter" ]
    then
        for file in "$abs_path"/*$filter;
        do
            file_size=$( du -m "$file" | cut -f1 )
            if [ "$file_size" -gt "$user_size" ]
            then
                rm "$file"
            fi
        done
    else
        for file in "$abs_path"/*;
        do
            file_size=$( du -m "$file" | cut -f1 )
            if [ "$file_size" -gt "$user_size" ]
            then
                rm "$file"
            fi
        done
    fi
}

menu(){
    echo -ne "1) List Files\n2) Sort by Size\n3) Delete Files\n"

    read -p "Choose an option: " choice

    while [[ ! "$choice" =~ ^[1-3]$ ]]
    do
        read -p "Invalid Option enter again: " choice
    done

    case $choice in
        1) list_files; menu;;
        2) sort_by_size; menu;;
        3) delete_files; menu;;

    esac
    

}


menu
