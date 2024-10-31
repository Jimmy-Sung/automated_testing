#!/bin/bash
params="$(echo "$*" | sed -E 's/ ?-[mgBfJ] ?[0-9A-Za-z_./]*//g')"
while getopts "m:g:B:f:i:e:J" opt
do
  case $opt in
    m) threads=$OPTARG;;
    g) memory=$OPTARG;;
    B) browser=$OPTARG;;
    f) file=$OPTARG;;
    \?) echo "Invalid option: -$OPTARG";;
  esac
done
prefix=$(date +%m%d-%H%M)
location=${prefix}"_all"
browser=${browser:-chrome}
# the name of the output folder
[ "$(echo "$*" | grep '\-i\|\-e')" ] && location="${prefix}$(echo "${params}" | sed -e 's/ *-i */_/g' | sed -e 's/ *-e */_!/g')"
# For Windows Subsystem for Linux Mount Path
[ "$(df | grep "^[A-Z]:")" ] && PWD="$(echo ${PWD} | sed 's/\/mnt\/\(.\)/\1:/g')"
# Check executed manually or not
[ "$(tty -s;echo $?)" -eq 0 ] && interactive="-it"
# Auto upload Log on JIRA issue
[ "$(echo "$*" | grep '\-J')" ] && ROBOT_JIRATITLE="-e ROBOT_JIRATITLE=[${browser}]$(echo ${location} | cut -c 11-)"
# Remember to enable shared drives in Windows docker settings
docker run --rm ${interactive} --shm-size="${memory:-1}g" -v ${PWD}/Log/$location:/opt/robotframework/reports:Z -v ${PWD}:/opt/robotframework/tests:Z \
           -e BROWSER=${browser} -e ROBOT_OPTIONS="$params" -e ROBOT_THREADS="${threads:-1}" \
           -e ROBOT_FILES="${file}" ${ROBOT_JIRATITLE} docker-robot:latest
