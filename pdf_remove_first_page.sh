#!/bin/bash
#echo $1
# 首先传进来一个参数
filein=$1
#使用pdftk移除第一页；
pdftk "$1" cat 2-end output /tmp/pdftk_tmp.pdf
#使用pdftk获取目录信息；
pdftk "$1" dump_data output /tmp/pdftk_tmp.info

#使用python脚本更新目录；
echo '#!/usr/bin/python
output = open("/tmp/pdftk_res.info", "w")

with open("/tmp/pdftk_tmp.info", "r") as f: 
    for line in f:
        if line.startswith("BookmarkPageNumber"):
            output.write("BookmarkPageNumber: "+ str(int(line.split()[1])-1) + "\n")
        else:
            output.write(line)
' > /tmp/pdftk_update_info.py && chmod +x /tmp/pdftk_update_info.py && /tmp/pdftk_update_info.py

gedit /tmp/pdftk_res.info

#合并目录到新生成的文件；
pdftk /tmp/pdftk_tmp.pdf update_info /tmp/pdftk_res.info output "$1"

#删除临时文件
rm /tmp/pdftk_*
