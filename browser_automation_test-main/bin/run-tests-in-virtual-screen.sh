#!/bin/bash

# No need for the overhead of Pabot if no parallelisation is required
if [ $ROBOT_THREADS -eq 1 ]
then
    xvfb-run \
        --server-args="-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH} -ac " \
        robot \
        --outputDir /opt/robotframework/reports \
        ${ROBOT_OPTIONS} \
        /opt/robotframework/tests/${ROBOT_FILES}
else
    xvfb-run \
        --server-args="-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH} -ac " \
        pabot \
        --verbose \
        --artifacts png,webm,gif,log \
        --processes $ROBOT_THREADS \
        --ordering /opt/robotframework/tests/.pabotsuitenames \
        --outputDir /opt/robotframework/reports \
        ${ROBOT_OPTIONS} \
        /opt/robotframework/tests/${ROBOT_FILES}
fi
exitcode=$?
# Record website current version for Jenkins or JIRA
xmllint --xpath 'string(//kw[@name="Log Website Version"]/kw[@name="Log"]/msg)' /opt/robotframework/reports/output.xml | tr -d " " > /opt/robotframework/reports/webversion
# Auto upload Log on JIRA issue
[ "${ROBOT_JIRATITLE}" ] && ( sleep 5 ; bash /opt/robotframework/tests/Scripts/create_issue.sh /opt/robotframework/reports ${ROBOT_JIRATITLE} )
# Return robot exit code
exit ${exitcode:-1}
