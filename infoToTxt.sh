#!/bin/sh
title=""

while IFS= read -r line
do
    if [ ! -z $(echo $line|grep -o 'BookmarkTitle:') ]; then
        title=$(echo $line|sed "s/BookmarkTitle: //")
    fi

    if [ ! -z $(echo $line|grep -o 'BookmarkLevel:') ]; then
	level=$(echo $line|sed "s/BookmarkLevel: //")
    fi

    if [ ! -z $(echo $line|grep -o 'BookmarkPageNumber:') ]; then
        pageNum=$(echo $line|sed "s/BookmarkPageNumber: //")

	if [ $level == 1 ]; then
            echo -e $title $pageNum
	elif [ $level == 2 ]; then
            echo -e "\t"$title $pageNum
        elif [ $level == 3 ]; then
            echo -e "\t\t"$title $pageNum
        elif [ $level == 4 ]; then
            echo -e "\t\t\t"$title $pageNum
        elif [ $level == 5 ]; then
            echo -e "\t\t\t\t"$title $pageNum
	fi
    fi
done < $1

