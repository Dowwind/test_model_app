#!/bin/bash

trim() {
  local s2 s="$*"
  until s2="${s#[   ]}"; [ "$s2" = "$s" ]; do s="$s2"; done
  until s2="${s%[   ]}"; [ "$s2" = "$s" ]; do s="$s2"; done
  echo "$s"
}

echo -e "\n\033[35;1mREBASE ALL BRANCHES FROM MASTER\n"

old_IFS=$IFS
IFS=$'\n'
set checkout

git branch > branch_list
for line in $(cat branch_list)
do
    checkout=0
    if [[ $line == *"*"* ]]
    then
	checkout=1
    fi
    if [ $checkout = 0 ]
    then
	line=$(trim "$line")
	echo -e "\n\033[33;1mGoing to branch $line.\033[0m"
    	git checkout $line
    	git pull --no-commit -q origin master
    	git add .
    	git commit -q -m "Rebase branch"
    	git push origin $line
	echo -e "\033[33;1mGoing to branch master.\n\033[0m\n"
    	git checkout master
    fi
done
rm -f branch_list
echo -e "\n\n\033[35;1mREBASE DONE\033[0m"
