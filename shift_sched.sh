#!/bin/bash

list="schedule.txt"

if [ ! -f "$list" ]; then
    touch "$list"
fi

shift_time() {
    shift=$1
    case $shift in
        morning)
            echo "6am-3pm"
            ;;
        mid)
            echo "2pm-11pm"
            ;;
        night)
            echo "10pm-7am"
            ;;
    esac
}

sort_sched() {
    time=$1
    case $time in
        morning) echo 1 ;;
        mid) echo 2 ;;
        night) echo 3 ;;
    esac
}

display_schedule() {
    team=("A1" "A2" "A3" "B1" "B2" "B3")

    for team in "${team[@]}"; do
        echo "$team"
        if grep -q " $team$" "$list"; then
            grep " $team$" "$list" | while read -r line; do
                name=$(echo "$line" | awk '{print $1}')
                shift=$(echo "$line" | awk '{print $2}')
                time=$(shift_time "$shift")
                order=$(sort_sched "$shift")
                echo "$order $name, $shift, $time"
            done | sort -k1,1n | awk '{$1=""; print "   " $0}'
        else
            echo " "
        fi
    done
}

shift_full() {
    team=$1
    shift=$2
    count=$(grep -c "$shift $team" "$list")
    if [ "$count" -ge 2 ]; then
       return 0
    else
       return 1
    fi
}

add_employee() {
    name=$(echo "$1" | awk '{print toupper(substr($1,1,1)) tolower(substr($1,2))}')
    shift=$2
    team=$3

    if shift_full "$team" "$shift"; then
        echo "Error: $shift shift in group $team is already full."
        exit 1
    else
        echo "$name $shift $team" >> "$list"
        echo "Shift created!"
        echo "Employee $name is added to group $team $shift shift."
        return 0
    fi
}

while true; do
    read -p "Enter Name: " name
    if [ "$name" == "print" ]; then
        display_schedule
        exit 0
    fi

    while true; do
        read -p "Enter Shift (morning/mid/night): " shift
        if [[ "$shift" =~ ^(morning|mid|night)$ ]]; then
            break
        else
            echo "Invalid shift. Available shifts: 'morning' 'mid' 'night'"
        fi
    done

    while true; do
        read -p "Enter Team (A1, A2, A3, B1, B2, B3): " team
        if [[ "$team" =~ ^(A1|A2|A3|B1|B2|B3)$ ]]; then
            break
        else
            echo "Invalid team. Available teams: 'A1' 'A2' 'A3' 'B1' 'B2' 'B3'"
        fi
    done

    add_employee "$name" "$shift" "$team" || continue
done
