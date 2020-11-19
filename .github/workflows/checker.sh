#!/bin/bash
set -euxo pipefail
file=$1
flag=0
date=$(date +"%Y")
case $file in
    *.java) 
        copyright="[*] *Copyright *[(][c][)](.*)*$date"
        while read line; do 
            if [ ${#$line} -gt 88 ]; then 
                echo "line longer than 88 characters"; 
                exit 1; 
            fi
            if [[ $flag -eq 0 && $line =~ ${copyright} ]]; then 
                flag=1; 
            fi
        done < "$file"
        if [ $flag -eq 0 ]; then 
            echo "Add copyright and update year"; 
            exit 1; 
        fi
        ;;
    pom.xml)
        echo "this is a pom $file"
        ;;
    build.graddle)
        echo "this is a graddle $file"
        ;;
    *.html)
        copyright="[*] *Copyright *[(][c][)](.*)*$date"
        while read line; do
            if [[ $flag -eq 0 && $line =~ ${copyright} ]]; then 
                flag=1; 
            fi
        done < "$file"
        if [ $flag -eq 0 ]; then 
            echo "Add copyright and update year"; 
            exit 1; 
        fi
        ;;
    *.adoc)
        echo "this is the adoc $file"
        ;;
    *)
        echo "its something else $file"
        ;;
esac





copyright="[*] *Copyright *[(][c][)](.*)*$date"
while read line; do 
    if [ ${#$line} -gt 88 ]; then echo "line longer than 88 characters"; exit 1; fi
    if [[ $flag -eq 0 && $line =~ ${copyright} ]]; then flag=1; fi
done < "$file"
if [ $flag -eq 0 ]; then echo "Add copyright and update year"; exit 1; fi
