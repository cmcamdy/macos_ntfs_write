#!/bin/bash
# https://blog.csdn.net/qq_41508508/article/details/106028384
# 读取nfts硬盘信息:/dev/disk4s2 on /Volumes/test (ntfs, local, nodev, nosuid, read-only, noowners)
ntfs=$(mount | grep ntfs)
# 获得数组
arr=(${ntfs//\ / }) 
len=${#arr[@]}
echo 'arr_len:'$len
unit=9
count=0
echo $ntfs
# echo ${ntfs:0:1}
# 设备地址
dev=''
# 挂载地址（和主盘同文件夹）
fileame=''
# 赋值模式
type=1

# 遍历所有输出，其中就有挂在点和文件名
while [ "$count" -lt $len ]; do  
    tmp=${arr[$count]}
	# ${tmp:0:1}:https://www.cnblogs.com/xwdreamer/p/3823463.html
    # 字符串比较：https://www.jb51.net/article/56559.htm
    if [ "${tmp:0:1}" = "/" ];then
        if [ $type = 1 ];then
            dev=$tmp
            type=2
        else  
            filepath=$tmp
            echo 'dev:'$dev
            echo 'filepath:'$filepath
            type=1
            # 提取文件名
            filename=(${filepath//\// }) 
            echo 'filename:'${filename[1]}

            # 先推出
            sudo umount $dev
            cd /Volumes
            # 在/Volumes中新建文件夹
            sudo mkdir ${filename[1]}
            # ntfs挂载
            sudo mount_ntfs -o rw,nobrowse $dev ${filename[1]}
        fi
        
    fi
    # i++
    count=$(($count + 1)) 
done
# 打开挂在点文件夹 
open /Volumes
