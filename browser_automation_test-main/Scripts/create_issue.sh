#!/bin/bash
TOKEN="bGFzemxvY2h1bmdAaXRyaS5vcmcudHc6M0lxcnlBajE4OTFtY255cGlkSGY2RDYw"

[ -e "$1/log.html" -a -e "$1/output.xml" ] || (echo "Log file not found" ; exit 1)
PASS=$(cat $1/output.xml | xmllint --xpath 'string(//total/stat[2]/@pass)' -)
TOTAL=$(cat $1/output.xml | xmllint --xpath 'string(//total/stat[2]/@fail)+string(//total/stat[2]/@pass)' -)
ELAPSED=$(TZ=UTC date -d@$(($( date -d"$(cat $1/output.xml | xmllint --xpath 'string(//robot/suite/status[last()]/@endtime)' -)" +%s) \
        - $(date -d"$(cat $1/output.xml | xmllint --xpath 'string(//robot/suite/status[last()]/@starttime)' -)" +%s))) +'%H小時%M分%S秒')
FAIL=$(cat $1/output.xml | xmllint --xpath '//stat[@fail="1" and @pass="0"]' - 2>/dev/null | tr -d "\n" | sed 's/<[^>]*>/ /g' | sed -E 's/\s+/\\n/g')
VER=$(cat $1/webversion)

#If count(FILES) <= 10;Uploading sequence is queuing (reverse)
if [ "${FAIL}" ];then
    IMAGES=($(cat $1/output.xml | xmllint --xpath '//test/status[@status="FAIL"]/../descendant::kw[@name="Capture Page Screenshot"][last()]/msg/text()' - \
              | grep -oP '(?<=src\=")[0-9-]*selenium-screenshot-[0-9]*.png' | sort -r))
    [ "$(echo ${IMAGES[@]} | awk -F " " '{print NF}')" -le 20 ] && FILES=("${IMAGES[@]/#/ -F file=@$1/}")
fi

ISSUEID=`curl -sX POST \
  --url 'https://citcpm.atlassian.net/rest/api/3/issue' \
  --header 'Authorization: Basic '${TOKEN} \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data '{
    "fields": {
        "project":
        {
            "key": "BAT"
        },
        "parent":
        {
            "key": "BAT-114"
        },
        "summary": "'$(date +%m%d)' '$2'測試報告",
        "description": {
          "type": "doc",
          "version": 1,
          "content": [
            {
              "type": "paragraph",
              "content": [
                {
                  "type": "text",
                  "text": "'${VER}'\n共成功執行 '${PASS}'/'${TOTAL}' 個測試案例\n總花費時間 '${ELAPSED}'\n下列執行失敗:'${FAIL}'"
                }
              ]
            }
          ]
        },
        "issuetype": {
            "name": "Sub-task"
        },
        "assignee": {
            "name": "'$3'"
        }
    },
    "transition": {
        "id": "21"
    }
}' | jq -r '.key'`

RESULT=`curl -sX POST \
  --url 'https://citcpm.atlassian.net/rest/api/3/issue/'${ISSUEID}'/attachments' \
  --header 'Authorization: Basic '${TOKEN} \
  --header 'Accept: application/json' \
  --header 'X-Atlassian-Token: no-check' \
  ${FILES[@]} -F 'file=@'$1/log.html | jq -c '.[]?'`

[ "${RESULT}" ] && echo -e "\nIssue Created Successfully" || echo -e "\nIssue Created Unsuccessfully"
