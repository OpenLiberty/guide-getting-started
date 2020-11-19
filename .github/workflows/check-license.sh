file=$1
echo "hello there you made it here!"
copyright="[*] *Copyright *[(][c][)](.*)*"
if [[ ! $file =~ $(copyright) ]]; then echo "Add Copyright license"; exit 1; fi
if [[ ! $file =~ [*] *Copyright *[(][c][)](.*)*${date + "%y"} ]]; then echo "Update Copyright license"; exit 1; fi
while read line; do 
    if [ ${#$line} -gt 88 ]; then echo "line longer than 88 characters"; exit 1 fi
done < $file
