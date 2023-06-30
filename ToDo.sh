#!/bin/bash

if [ ! -f ./tasks.txt ]
then
    touch tasks.txt
fi

arg1=$1
arg_count=$#
shift
content=""

while [ ! -z "$1" ]
do  
    content="$content $1"
    shift
done

content=$(echo $content | xargs)

case $arg1 in
    add)
        if [ $arg_count -lt 2 ]
        then
            echo "[Error] This command needs an argument" >&2
            exit 1
        fi

        if [[ "${content,,}" == *"(very important)" ]]
        then
            echo "H $content" >> tasks.txt
            task_priority="H"
        elif [[ "${content,,}" == *"(important)" ]]
        then
            echo "M $content" >> tasks.txt
            task_priority="M"
        else
            echo "L $content" >> tasks.txt
            task_priority="L"
        fi
        task_number=$(wc -l tasks.txt | cut -d " " -f1)
        echo "Added task $task_number with priority $task_priority" 
        ;;
    done)
        if [ $arg_count -lt 2 ]
        then
            echo "[Error] This command needs an argument" >&2
            exit 1
        fi
        echo -n "Completed task $content: "
        awk 'NR=='$content' { print substr($0,3) ; exit }' tasks.txt
        awk 'NR!='$content' { print }' tasks.txt > tmp_tasks.txt
        cat tmp_tasks.txt > tasks.txt
        rm tmp_tasks.txt
        ;;
    list)
        if [ ! -s ./tasks.txt ]
        then
            echo "No tasks found..."
            exit 0
        fi
        awk '{printf NR;
        if($1 == "H") printf " ***** ";
        else if ($1 == "M") printf " ***   ";
        else printf " *     ";
        print substr($0,3)
        }' ./tasks.txt  
        ;;
    *)
        echo "[Error] Invalid command" >&2
        exit 1
esac
