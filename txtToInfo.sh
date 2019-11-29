#!/bin/sh
bookMarksInput="info.txt"
bookInfoInput='bookmarks.txt'

while IFS= read -r line
do
    echo "$line"

    if [ ! -z $(echo $line|grep -o 'NumberOfPages') ]; then
        break
    fi
done < "$bookInfoInput"

while IFS= read -r line
do
    if [ ! -z "$line" ]; then
        mark=`echo "$line"|sed 's/\([ 0-9]*\)$//g'`
        pageNum=`echo $line|grep -o '\([0-9]*\)$'`
        level=1

        if [ ! -z $(echo "$mark"|grep -P '^\t') ]; then
            level=2
        fi

        if [ ! -z $(echo "$mark"|grep -P '^\t\t') ]; then
            level=3
        fi

        echo "BookmarkBegin
BookmarkTitle: $mark
BookmarkLevel: $level
BookmarkPageNumber: $pageNum"
    fi
done < "$bookMarksInput"

skipped=false
while IFS= read -r line
do
    if [ $skipped = false ]; then
        if [ "$line" = "PageMediaBegin" ]; then
            skipped=true
            echo $line
        fi
    else
        echo $line
    fi
done < "$bookInfoInput"
