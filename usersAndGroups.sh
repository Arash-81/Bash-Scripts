#!/bin/bash


if [[ "$1" == "--remove" ]]; then
    for i in {1..50}
    do
        userdel "user$i"
        rm -rf /home/user$i
        
    done

    groupdel group1
    groupdel group2

    rm -f pass_report.txt
    rm -f group_report.txt 
    rm -rf dir1 dir2
    exit 0;
fi

# Part I

# create dir1 and file1.txt
mkdir -p dir1
touch dir1/file1.txt

# give group write access to file1.txt
chmod g+w dir1/file1.txt

# create group1 and add 25 new users to it
groupadd group1
for i in {1..25}; do
  username="user$i"
  useradd -m -g group1 -s /bin/bash $username
done

# give group1 read access to file1.txt
chgrp group1 dir1/file1.txt
chmod g+r dir1/file1.txt

# Part II

# create dir2 and file2.sh
mkdir -p dir2
touch dir2/file2.sh

# give group read and write access to file2.sh
chmod g+rw dir2/file2.sh

# create group2 and add 25 new users to it
groupadd group2
for i in {1..25}; do
  username="user$((i+25))"
  useradd -m -g group2 -s /bin/bash $username
done

# give group2 execute access to file2.sh
chgrp group2 dir2/file2.sh
chmod g+x dir2/file2.sh

# Part III

# read information about the 50 users created and save it to pass_report.txt
grep -E '^user[1-5][0-9]:' /etc/passwd | while read line; do
  username=$(echo "$line" | cut -d: -f1)
  uid=$(echo "$line" | cut -d: -f3)
  shell=$(echo "$line" | cut -d: -f7)
  homedir=$(echo "$line" | cut -d: -f6)
  echo "User $username with UID $uid uses $shell shell and stores files in $homedir directory." >> pass_report.txt
done

# Part IV

# read information about group1 and group2 and save it to group_report.txt
grep -E '^(group1|group2):' /etc/group | while read line; do
  groupname=$(echo "$line" | cut -d: -f1)
  gid=$(echo "$line" | cut -d: -f3)
  users=$(echo "$line" | cut -d: -f4 | tr ',' ' ')
  echo "Group -> $groupname" >> group_report.txt
  echo "GID -> $gid" >> group_report.txt
  echo "Group List -> $users" >> group_report.txt
done

